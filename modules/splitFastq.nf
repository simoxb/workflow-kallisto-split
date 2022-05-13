process fastqsplit{
    
    input: 
    tuple val(name), path(fastq)

    output:
    tuple val(name), path("*${fastq.baseName}*1*.f*q"), path("*${fastq.baseName}*2*.f*q")

    script:
    """ 
    ${params.baseDir}/bin/splitFastq -i ${fastq[0]} -n ${params.split} -o ${fastq[0].getBaseName()} 
    ${params.baseDir}/bin/splitFastq -i ${fastq[1]} -n ${params.split} -o ${fastq[1].getBaseName()} 
    """
}

