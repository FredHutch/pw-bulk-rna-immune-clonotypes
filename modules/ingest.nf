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


    emit:
    reads_ch

}