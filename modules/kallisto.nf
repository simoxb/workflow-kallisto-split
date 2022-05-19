process kallisto_index{

	label 'kallisto'
	
	input: 
	path(fasta_input)

	
	output:
	tuple path(fasta_input), path("${fasta_input.baseName}.index")
	
	script:
	"""
	kallisto index -i ${fasta_input.baseName}.index ${fasta_input}
	"""
}

process kallisto_map{

	label 'kallisto'
	
	input:
	tuple val(pair_id), path(reads)
	env additional_params
	tuple path(fasta), path(index)
	path(gtf)
	
	output:
	tuple val(pair_id), path("${reads[0].baseName}.bam"), emit: bam
	
 	shell:
 	'''
 	kallisto quant -i !{index} -o ./ --gtf !{gtf} ${additional_params} --threads !{params.threads} !{reads[0]} !{reads[1]}
	mv pseudoalignments.bam !{reads[0].baseName}.bam
 	'''
}
