# Bulk RNAseq Immune Clonotype Analysis (PubWeb)
Analysis of T-/B-cell clonotypes from bulk RNA sequencing data

## Purpose

The goal of this workflow is to estimate the relative abundance of lymphocytes
from different clonal lineages using bulk RNAseq data. The conceptual approach
of the analysis is to reconstruct the TCR/BCR loci which were recombined in
a unique way during the formation of each lineage.

## Implementation

### Input Data

Input data must be bulk RNAseq data in gzip-compressed FASTQ format. Data may
be either single-end or paired-end.

To define the structure of the input, the user may specify either a filepath
wildcard (e.g. `path/to/reads/*_R{1,2}*.fastq.gz`) or with a manifest file.

Manifest files must be formatted as a three-column CSV with the headers
`specimen`, `R1`, and `R2`.

To distinguish between paired- and single-end data, one (and only one) of the
following parameters must be used:
 - `paired_reads`
 - `paired_manifest`
 - `single_reads`
 - `single_manifest`
 