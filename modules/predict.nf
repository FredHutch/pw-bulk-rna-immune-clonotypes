// Process paired-end data
process paired {
    container "${params.container__trust4}"
    label "mem_medium"
    publishDir "${params.output_folder}/${sample}", mode: "copy", overwrite: true, pattern: "TRUST4*"

    input:
    tuple val(sample), path("inputs/READS_?.fastq.gz")
    path ref

    output:
    path "TRUST4*", emit: all
    path "${sample}.tsv", emit: tsv

    script:
    template "paired.sh"
}

// Process single-end data
process single {
    container "${params.container__trust4}"
    label "mem_medium"
    publishDir "${params.output_folder}/${sample}", mode: "copy", overwrite: true, pattern: "TRUST4*"

    input:
    tuple val(sample), path("inputs/READS_?.fastq.gz")
    path ref

    output:
    path "TRUST4*", emit: all
    path "${sample}.tsv", emit: tsv

    script:
    template "single.sh"
}   

def validate_input_params(){

    if ( params.output_folder == false ){
        log.info"""
ERROR:
Must specify folder for output files with --output_folder
        """
        exit 1
    }

    if ( params.ref == false && params.ref_fasta == false ){
        raise_ref_param_error()
    }
    if ( params.ref && params.ref_fasta ){
        raise_ref_param_error()
    }

}

def raise_ref_param_error(){
    log.info"""
ERROR:
User must specify one (and only one) of the following parameters:
--ref
--ref_fasta

See README.md for more details.
"""
    exit 1

}

workflow predict {

    take:
    reads_ch

    main:

    validate_input_params()

    if ( params.ref ){
        ref = file("$projectDir/assets/TRUST4/ref/${params.ref}_bcrtcr.fa")
    } else {
        ref = file(params.ref_fasta)
    }

    if ( params.paired_reads || params.paired_manifest ){
        paired(reads_ch, ref)
        tsv = paired.out.tsv
    } else {
        single(reads_ch, ref)
        tsv = single.out.tsv
    }

    emit:
    tsv = tsv

}