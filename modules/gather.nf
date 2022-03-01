// Process paired-end data
process paired {
    container "${params.container__trust4}"
    label "mem_medium"
    publishDir "${params.output_folder}/${sample}", mode: "copy", overwrite: true

    input:
    tuple val(sample), path(fastq_1), path(fastq_2)
    path ref

    output:
    path "*"

    script:
    template "paired.sh"
}

// Concatenate a set of TSV files
process concat {
    container "${params.container__pandas}"
    label "io_limited"
    publishDir "${params.output_folder}/", mode: "copy", overwrite: true

    input:
    path "*"

    output:
    path "TRUST4_report.csv"

    script:
    template "concat.py"
}   

workflow gather {

    take:
    tsv_ch

    main:

    concat(
        tsv_ch.toSortedList()
    )

}