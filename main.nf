// Using DSL-2
nextflow.enable.dsl=2

// Import modules
include { ingest } from './modules/ingest'
include { predict } from './modules/predict'
include { gather } from './modules/gather'

// Main workflow
workflow {

    // Get reads from --[paired/single]_manifest or --reads
    ingest()

    // Predict clonotypes from the imported reads
    predict(ingest.out)

    // Gather all of the outputs into a single table
    gather(predict.out)

}