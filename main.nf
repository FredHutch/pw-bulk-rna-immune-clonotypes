// Using DSL-2
nextflow.enable.dsl=2

// Import modules
include { ingest } from './modules/ingest'
include { predict } from './modules/predict'

// Main workflow
workflow {

    // Get reads from --[paired/single]_manifest or --reads
    ingest()

    // Predict clonotypes from the imported reads
    predict(ingest.out)

}