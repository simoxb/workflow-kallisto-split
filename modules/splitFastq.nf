process fastqsplit{
    
    label 'python'    
    input: 
    tuple val(name), path(fastq)

    output:
    tuple val(name), path("*${name}*1*.f*q"), path("*${name}*2*.f*q")

    shell:
    '''
    length=$(grep -Fxc "+" !{fastq[0]}) 
    z=$((${length} / !{params.split}))
    splitby=$((${z} + 1))
    !{params.baseDir}/bin/splitFastq -i !{fastq[0]} -n ${splitby} -o !{fastq[0].getBaseName()} 
    !{params.baseDir}/bin/splitFastq -i !{fastq[1]} -n ${splitby} -o !{fastq[1].getBaseName()} 
    '''
}

