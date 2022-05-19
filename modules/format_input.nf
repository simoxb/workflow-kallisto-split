process format_input{
	
	input:
	tuple val(sample_id), path(reads1), path(reads2)
	
	output:
	tuple val(sample_id), path("*fastp*{1,2}*.fq"), emit: trimmed
	
	script:
	"""
	cp ${reads1} ${reads1.baseName}.fq
	cp ${reads2} ${reads2.baseName}.fq
	"""

}
