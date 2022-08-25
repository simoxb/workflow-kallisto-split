process merge_quant {
    label 'python'

    input:
    file out_bam
    
    output:
    path("merged_quant.tsv"), emit: gathered_quant
    
    script:
    """
    python ${params.baseDir}/bin/merge_quant.py 
    """
}
