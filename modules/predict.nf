// Process paired-end data
process paired {
    container "${params.container__trust4}"
    label "mem_medium"
    publishDir "${params.output_folder}/${specimen}", mode: "copy", overwrite: true

    input:
    tuple val(specimen), path(R1), path(R2)
    path ref

    output:
    path "*"

    script:
    template "paired.sh"
}

// Process single-end data
process single {
    container "${params.container__trust4}"
    label "mem_medium"
    publishDir "${params.output_folder}/${specimen}", mode: "copy", overwrite: true

    input:
    tuple val(specimen), path(R1)
    path ref

    output:
    path "*"

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
    } else {
        single(reads_ch, ref)
    }

}