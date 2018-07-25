# bowtie2 is run using the `notice_target` and `run_bowtie2` functions.
#
# `notice_target` is invoked as follows,
#
#     notice_target [-t name ] replicon1.fna replicon2.fna ...
#
# E.g.,
#
#     notice_target .../DC3000/NC_4*.fna
#
# The default output name for the target is `default`. This can be
# overriden with the `-t` option. E.g.,
#
#     notice_target -t dc3000 .../DC3000/NC_4*.fna
#
# The `bowtie2` program is run using `run_bowtie2`, which is invoked as
# follows,
#
#     run_bowtie2 [-t target] [-o label ] sequences1.fq.gz sequences2.fq.gz ... \ 
#        [-- other bowtie2 args ]
#
# E.g., to align a seq of reads to the `default` target,
#
#     run_bowtie2 sequences.fastq.gz
#
# The default tag used for the output files is `output`. The can be
# changed using the `-o` argument. For example, to compare reads from
# two conditions against the same genome,
#
#      run_bowtie2 -o condition1 sequences1.fastq.gz
#      run_bowtie2 -o condition2 sequences2.fastq.gz
#
# The target can be specified with the `-t` arguement. For instance,
# to align the same set of reads against multiple genomes,
#
#     notice_target -t genome1 genome1.fna
#     notice_target -t genome2 genome2.fna
#     run_bowtie2 -t genome1 -o genome1 sequences.fastq.gz
#     run_bowtie2 -t genome2 -o genome2 sequences.fastq.gz

# Below are some handy flags for `bowtie2`. Use these by adding `--
# $BOWTIE2_FLAGS` to the end of each `run_bowtie2` invocation. E.g.,
#
#     run_bowtie2 sequences.fastq.gz -- $BOWTIE2_FLAGS
#
# Be sure to read the Bowtie2 documentation for a list of all option.

BOWTIE2_FLAGS=""

# Which alignment method. Read
# <http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml#end-to-end-alignment-versus-local-alignment>
# for details.
BOWTIE2_FLAGS+=" --end-to-end" # perform full-length alignment of each read
# BOWTIE2_FLAGS+=" --local" # allow clipping when aligning each read

# Reporting options. The differences are subtle. Read
# <http://bowtie-bio.sourceforge.net/bowtie2/manual.shtml#reporting>
# for details.
BOWTIE2_FLAGS+=" " # (default) find and output the (heuristically)
		   # best alignment. This is almost certainly the one
		   # that you want to use.
# BOWTIE2_FLAGS+=" -k1" # find and output exactly 1 (of possibly many)
# 		      # match.
# BOWTIE2_FLAGS+=" -k5" # find and output exactly 5 (of possibly many)
# 		      # matches
# BOWTIE2_FLAGS+=" --all" # output all matches. VERY SLOW!

