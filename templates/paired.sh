#!/bin/bash

set -e

run-trust4 \
    -1 ${fastq_1} \
    -2 ${fastq_2} \
    -f ${ref} \
    -o TRUST4 \
    -t ${task.cpus}
