process cufflinks{
	
	label 'cufflinks'
	
	input:
	env STRANDNESS
	tuple val(id), path(bam)
	path(gtf)
	
	output:
	
	
	shell:
	'''
	if [[ $STRANDNESS == "firststrand" ]]; then
        	cufflinks -G !{gtf} !{bam} --library-type fr-firststrand --num-threads !{params.threads}
   	elif [ $STRANDNESS == "secondstrand" ]]; then
        	cufflinks -G !{gtf} !{bam} --library-type fr-secondstrand --num-threads !{params.threads}
    	elif [[ $STRANDNESS == "unstranded" ]]; then
        	cufflinks -G !{gtf} !{bam} --library-type fr-unstranded --num-threads !{params.threads}
	else  
		echo $STRANDNESS > error_strandness.txt
		echo "strandness cannot be determined" >> error_strandness.txt
    	fi
	'''
}
