#!/bin/bash

set -e

run-trust4 \
    -1 inputs/READS_1.fastq.gz \
    -f ${ref} \
    -o TRUST4 \
    -t ${task.cpus}

cp TRUST4_report.tsv "${sample}.tsv"