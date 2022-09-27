process fastqsplit{
    
    label 'python'    
    input: 
    tuple val(name), path(fastq)

    output:
    tuple val(name), path("*${name}*1*.f*q.gz"), path("*${name}*2*.f*q.gz")

    script:
    """ 
    ${params.baseDir}/bin/splitFastq -i ${fastq[0]} -n ${params.split} -o ${fastq[0].getBaseName()} 
    ${params.baseDir}/bin/splitFastq -i ${fastq[1]} -n ${params.split} -o ${fastq[1].getBaseName()} 
    """
}

