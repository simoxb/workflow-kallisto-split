process fastp{		
	
	label 'fastp'
	
	input: 
	tuple val(id), path(reads)
	
	output: 
	tuple val(id), path("${id}*fastp*{1,2}.f*q"), emit: trimmed
		
	script:
	"""
	fastp -i ${reads[0]} -I ${reads[1]} -o ${id}_fastp.1.fastq -O ${id}_fastp.2.fastq --detect_adapter_for_pe --json ${reads[0].baseName}_fastp.json --html ${reads[0].baseName}_fastp.html --thread ${params.threads}
	"""
}

