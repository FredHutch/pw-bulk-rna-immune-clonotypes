#!/bin/bash

set -e

run-trust4 \
    -u ${R1} \
    -f ${ref} \
    -o TRUST4 \
    -t ${task.cpus}
