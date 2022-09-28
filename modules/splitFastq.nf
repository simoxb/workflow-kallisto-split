process fastqsplit{
  
    publishDir params.outdir
    label 'python'
    input:
    tuple val(name), path(fastq)

    output:
    tuple val(name), path("*${name}*1*.f*q"), path("*${name}*2*.f*q")

    shell:
    '''
    length=$(wc -l < !{fastq[0]})
    (echo $length) > l.txt
    length=$((length / 4))
    s=$(echo !{params.split})
    (echo $s) > s.txt
    z=$((length / s))
    (echo $z) > z.txt
    splitby=$((${z} + 1))
    (echo $splitby) > splitby.txt
    !{params.baseDir}/bin/splitFastq -i !{fastq[0]} -n ${splitby} -o !{fastq[0].getBaseName()}
    !{params.baseDir}/bin/splitFastq -i !{fastq[1]} -n ${splitby} -o !{fastq[1].getBaseName()}
    '''
}
