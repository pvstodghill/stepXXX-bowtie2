# stepXXX-bowtie2

Module to run
[bowtie2](http://bowtie-bio.sourceforge.net/bowtie2/index.shtml), a
package that aligns sequence reads, for instance in a FASTQ format, against a
genome, for instance in FASTA format, and produced an alignment
dataset, for instance in SAM format.

> Please cite: Langmead B, Salzberg S. Fast gapped-read alignment with
> Bowtie 2. Nature Methods. 2012, 9:357-359.


To use this module, first create a configuration file from the
template.

    $ cp config-template.bash config.bash

Then update `config.bash` according to your needs.

Finally, run the module

    $ ./doit.bash

By default, this module uses the [Docker](https://www.docker.com/) image,

<https://hub.docker.com/r/pvstodghill/bowtie2/>

To use a use a native executables, uncomment the "HOWTO" assignment in
the configuration file.

By default, this modules uses all available threads. To use a
different thread count, uncomment and update the "THREADS=..."
assignment in the configuration file.
