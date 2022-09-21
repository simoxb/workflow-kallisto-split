process merge_quant {
    label 'python'
    publishDir params.outdir
    
    input:
    file out_bam
    
    output:
    path("merged_quant.tsv"), emit: gathered_quant
    
    script:
    """
    python ${params.baseDir}/bin/merge_quant.py 
    """
}
