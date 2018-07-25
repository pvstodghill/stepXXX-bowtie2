#! /bin/bash

# ------------------------------------------------------------------------
# set up the runtime environment
# ------------------------------------------------------------------------

# exit on error
set -e

if [ "$PVSE" ] ; then
    # In order to help test portability, I eliminate all of my
    # personalizations from the PATH.
    export PATH=/usr/local/bin:/usr/bin:/bin
fi

# ------------------------------------------------------------------------
# Check the config file
# ------------------------------------------------------------------------

THIS_DIR=$(dirname $BASH_SOURCE)
CONFIG_SCRIPT=$THIS_DIR/config.bash
if [ ! -e "$CONFIG_SCRIPT" ] ; then
    echo 1>&2 Cannot find "$CONFIG_SCRIPT"
    exit 1
fi

# ------------------------------------------------------------------------
# These functions implement the computation.
# ------------------------------------------------------------------------

function perl_join
{
    c="$1" ; shift 1
    result="$1" ; shift 1
    for s in "$@" ; do
	result="$result$c$s"
    done
    echo $result
}

function notice_target
{
    NAME=default
    if [ "$1" = "-t" ] ; then
	NAME="$2" ; shift 2
    fi

    [ "$HOWTO" ] || HOWTO="./scripts/howto -f packages.yaml"
    [ "$BT2_BUILD_THREADS" ] || BT2_BUILD_THREADS=$(./scripts/howto -f packages.yaml -q -c bowtie2-build nproc)
    INPUT_SEQUENCES=$(perl_join , "$@")
    (
	export HOWTO_MOUNT_DIR=$(./scripts/find-closest-ancester-dir $THIS_DIR "$@")
	set -x
	$HOWTO bowtie2-build -q --threads ${BT2_BUILD_THREADS} ${INPUT_SEQUENCES} temp/$NAME
    )

}

function run_bowtie2 {
    TARGET_NAME=default
    OUTPUT_NAME=output
    if [ "$1" = "-t" ] ; then
	TARGET_NAME="$2" ; shift 2
    fi
    if [ "$1" = "-o" ] ; then
	OUTPUT_NAME="$2" ; shift 2
    fi

    INPUT_FILES=
    INPUT_ARG=
    while [ -n "$1" -a "$1" != "--" ] ; do
	INPUT_FILES+=" $1"
	if [ -z "$INPUT_ARG" ] ; then
	    INPUT_ARG="$1"
	else
	    INPUT_ARG="$INPUT_ARG,$1"
	fi
	shift 1
    done
    if [ "$1" = "--" ] ; then
	shift 1
    fi

    [ "$HOWTO" ] || HOWTO="./scripts/howto -f packages.yaml -v"
    [ "$BT2_ALIGN_THREADS" ] || BT2_ALIGN_THREADS=$(./scripts/howto -f packages.yaml -q -c bowtie2 nproc)

    (
	export HOWTO_MOUNT_DIR=$(./scripts/find-closest-ancester-dir $THIS_DIR $INPUT_FILES)
	set -x
	$HOWTO bowtie2 --seed 1 --threads ${BT2_ALIGN_THREADS} "$@" \
	       -x temp/$TARGET_NAME \
	       -U "$INPUT_ARG" \
	       --un-gz results/${OUTPUT_NAME}.unmatched.fastq.gz \
	    | gzip > results/${OUTPUT_NAME}.sam.gz
    )
}

# ------------------------------------------------------------------------
# create empty `results` and `temp` directories
# ------------------------------------------------------------------------

(
    set -x
    cd $THIS_DIR
    rm -rf results temp
    mkdir results temp
)

# ------------------------------------------------------------------------
# Read the config file, which performs the actual computation.
# ------------------------------------------------------------------------

. "$CONFIG_SCRIPT"

# ------------------------------------------------------------------------
# Done.
# ------------------------------------------------------------------------
