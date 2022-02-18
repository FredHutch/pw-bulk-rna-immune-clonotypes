// Construct an unaligned BAM file from a pair of FASTQ files
process make_paired_bam {
    container "${params.container__picard}"
    label "io_limited"

    input:
    tuple val(specimen), path(R1), path(R2)

    output:
    tuple val(specimen), path("${specimen}.bam")

    script:
    template "make_paired_bam.sh"
}

// Construct an unaligned BAM file from a single FASTQ file
process make_single_bam {
    container "${params.container__picard}"
    label "io_limited"

    input:
    tuple val(specimen), path(R1)

    output:
    tuple val(specimen), path("${specimen}.bam")

    script:
    template "make_single_bam.sh"
}


def validate_input_params(){
    param_count = 0

    if (params.paired_reads){param_count += 1}
    if (params.paired_manifest){param_count += 1}
    if (params.single_reads){param_count += 1}
    if (params.single_manifest){param_count += 1}

    if (param_count != 1){
        log.info"""
        User must specify one (and only one) of the following parameters:
        --paired_reads
        --paired_manifest
        --single_reads
        --single_manifest

        See README.md for more details.
        """
        exit 1
    }
}

workflow ingest {

    // Input data must be defined with one of the following params
    // paired_reads
    // paired_manifest
    // single_reads
    // single_manifest
    validate_input_params()

    // If the input is specified from paired reads
    if ( params.paired_reads ){
        Channel
            .fromFilePairs(params.paired_reads)
            .map { it -> [it[0], it[1][0], it[1][1]]}
            .set { reads_ch }
    }

    // If the input is specified from paired reads in a manifest file
    if ( params.paired_manifest ){
        Channel
            .from(file(params.paired_manifest))
            .splitCsv(header: true)
            .map {
                r -> [
                    r["specimen"], 
                    file(r["R1"]),
                    file(r["R2"])
                ]
            }
            .set { reads_ch }
    }

    // If the input is specified from single reads
    if ( params.single_reads ){
        Channel
            .fromPath(params.single_reads)
            .map { it -> [ it.name.replaceAll(".fastq.gz", ""), it ]}
            .set { reads_ch }
    }

    // If the input is specified from single reads in a manifest file
    if ( params.single_manifest ){
        Channel
            .from(file(params.single_manifest))
            .splitCsv(header: true)
            .map {
                r -> [
                    r["specimen"], 
                    file(r["R1"])
                ]
            }
            .set { reads_ch }
    }

    if ( params.paired_manifest || params.paired_reads ){
        make_paired_bam(reads_ch)
        out_ch = make_paired_bam.out
    } else {
        make_single_bam(reads_ch)
        out_ch = make_single_bam.out
    }

    emit:
    out_ch

}