process fastp{		
	
	label 'fastp'
	
	input: 
	tuple val(id), path(reads)
	
	output: 
	tuple val(id), path("fastp*{1,2}*.fq"), emit: trimmed
		
	script:
	"""
	fastp -i ${reads[0]} -I ${reads[1]} -o fastp_${reads[0]} -O fastp_${reads[1]} --detect_adapter_for_pe --json ${reads[0].baseName}_fastp.json --html ${reads[0].baseName}_fastp.html --thread ${params.threads}
	"""
}

