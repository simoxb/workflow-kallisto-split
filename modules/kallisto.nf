process kallisto_index{

	label 'kallisto'
	
	input: 
	path(fasta_input)

	
	output:
	path("${fasta_input.baseName}.index")
	
	script:
	"""
	kallisto index -i ${fasta_input.baseName}.index ${fasta_input}
	"""
}

process kallisto_map{

	label 'kallisto'
	
	input:
	env STRANDNESS
	tuple val(pair_id), path(reads1), path(reads2)
	path(gtf)
	path(index)
	
	output:
	tuple val(pair_id), path("${reads1.baseName}.bam"), emit: bam
	
 	shell:
 	'''
 	if [[ $STRANDNESS == "firststrand" ]]; then
		kallisto quant -i !{index} -o ./ --gtf !{gtf} --fr-stranded --genomebam --threads !{params.threads} !{reads1} !{reads2}
		mv pseudoalignments.bam !{reads1.baseName}.bam
   	elif [[ $STRANDNESS == "secondstrand" ]]; then
		kallisto quant -i !{index} -o ./ --gtf !{gtf} --rf-stranded --genomebam --threads !{params.threads} !{reads1} !{reads2}
		mv pseudoalignments.bam !{reads1.baseName}.bam
    	elif [[ $STRANDNESS == "unstranded" ]]; then
		kallisto quant -i !{index} -o ./ --gtf !{gtf} --genomebam --threads !{params.threads} !{reads1} !{reads2}
		mv pseudoalignments.bam !{reads1.baseName}.bam
	else  
		echo $STRANDNESS > error_strandness.txt
		echo "strandness cannot be determined" >> error_strandness.txt
    	fi
 	'''

}
