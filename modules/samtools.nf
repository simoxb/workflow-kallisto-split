process samtools {
    label 'samtools'
    
    
    input:
    tuple val(sample_name), path(bam_file)
    
    output:
    path("${bam_file}.sorted.bam")
    
    script:
    """
    samtools view -b ${bam_file} | samtools sort -o ${bam_file}.sorted.bam -T tmp  
    """
    
}

process samtools_merge {
    label 'samtools'
    publishDir params.outdir

    input:
    path(bam_files)
    
    output:
    tuple val("alignement_gathered.bam"), path("alignement_gathered.bam")
    
    script:
    """
    samtools merge alignement_gathered.bam ${bam_files}
    """
}
