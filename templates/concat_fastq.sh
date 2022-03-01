#!/bin/bash

set -euo pipefail

for f in inputs/*; do

    gzip -t \$f

done

cat inputs/* > "${sample_name}_${read_i}.fastq.gz"
