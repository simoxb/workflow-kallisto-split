process cufflinks{
	
	label 'cufflinks'
	
	input:
	env strandedness_param
	tuple val(id), path(bam)
	path(gtf)
	
	output:
	
	
	shell:
	'''
    cufflinks -G !{gtf} !{bam} --library-type ${strandedness_param} --num-threads !{params.threads}
	'''
}
