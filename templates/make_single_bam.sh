#!/bin/bash

set -e

java -Xmx8G -jar /usr/local/share/picard-2.26.10-0/picard.jar FastqToSam \
    FASTQ=${R1} \
    OUTPUT=${specimen}.bam \
    READ_GROUP_NAME=${specimen} \
    SAMPLE_NAME=${specimen} \
    LIBRARY_NAME=${specimen} \
