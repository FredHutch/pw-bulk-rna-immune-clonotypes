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
            .map {
                it -> [it[0], ['R1', 'R2'], it[1]]
            }
            .transpose()
            .set { reads_ch }
    }

    // If the input is specified from paired reads in a manifest file
    // then the structure of the reads in the channel will be set up
    // to match the format of the `fromFilePairs` factory:
    // [val(sample_name), [path(fastq_1), path(fastq_2)]]
    if ( params.paired_manifest ){
        Channel
            .from(file(params.paired_manifest))
            .splitCsv(header: true)
            .map {
                r -> [
                    r["sample"], 
                    ['R1', 'R2'],
                    [
                        file(r["fastq_1"]),
                        file(r["fastq_2"])
                    ]
                ]
            }
            .transpose()
            .set { reads_ch }
    }

    // If the input is specified from single reads
    if ( params.single_reads ){
        Channel
            .fromPath(params.single_reads)
            .map { it -> [ it.name.replaceAll(".fastq.gz", ""), 'R1', it ]}
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
                    'R1',
                    file(r["fastq_1"])
                ]
            }
            .set { reads_ch }
    }

    // Group by sample name and R1 vs. R2, and split up the
    // channel based on whether there are multiple files per sample
    reads_ch
        .groupTuple(by: [0, 1])
        .branch {
            multiple: it[2].size() > 1
            single: true
        }
        .set { grouped_reads_ch }

    // For the samples which have multiple files, concatenate them
    concat(
        grouped_reads_ch.multiple
    )

    // Finally, remove the "R1"/"R2" tags and group by sample
    grouped_reads_ch
        .single
        .map {
            it -> [it[0], it[2][0]]
        }
        .mix(
            concat
                .out
                .map {
                    it -> [it[0], it[2]]
                }
        )
        .groupTuple()
        .set { output_reads_ch }

    emit:
    output_reads_ch

}

// Concatenate a set of FASTQ files
process concat {
    container "${params.container__pandas}"
    label "io_limited"

    input:
    tuple val(sample_name), val(read_i), path("inputs/")

    output:
    tuple val(sample_name), val(read_i), path("${sample_name}_${read_i}.fastq.gz")

    script:
    template "concat_fastq.sh"
}  