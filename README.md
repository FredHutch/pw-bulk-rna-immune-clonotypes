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

### Reference Genome

Reference sequences for any organism may be produced following the instructions
laid out by the [makers of TRUST4](https://github.com/liulab-dfci/TRUST4#build-custom-vjc-gene-database-files-for--f-and---ref).

For convenience, reference sequences are provided in `assets/TRUST4/ref/` for `GRCm38`, `hg19`, and `hg38`.

To select one of the pre-formatted reference sequences in that folder, the user may specify
the parameter `ref`, which will reference the file `assets/TRUST4/ref/{ref}_bcrtcr.fa`.
Alternatively, the user may specify any other reference sequence file with the param `ref_fasta`.
Either `ref` or `ref_fasta` may be used, but not both.

### Output Data

All output data will be written to the folder specified by the parameter `output_folder`
