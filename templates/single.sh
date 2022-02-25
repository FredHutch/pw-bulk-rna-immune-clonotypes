#!/bin/bash

set -e

run-trust4 \
    -u ${fastq_1} \
    -f ${ref} \
    -o TRUST4 \
    -t ${task.cpus}
