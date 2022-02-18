#!/bin/bash

set -e

run-trust4 \
    -1 ${R1} \
    -2 ${R2} \
    -f ${ref} \
    -o TRUST4 \
    -t ${task.cpus}
