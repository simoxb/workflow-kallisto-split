process check_strandedness{

	label 'check_strandedness'
	
    input:
     tuple val(sample_name), path(reads)
     path(annotation)
     path(reference_cdna)
   
    output: 
        env strandedness, emit: kallisto
        
    shell:
    '''    
    check_strandedness -g !{annotation} -r1 !{reads[0]} -r2 !{reads[1]} --transcripts !{reference_cdna} > result.txt
    result=$( tail -n 1 result.txt )
    if [[ $result == *"likely unstranded"* ]]; then
        strandedness="--genomebam"
    elif [[ $result == *"likely RF/fr-firststrand"* ]]; then
        strandedness="--fr-stranded --genomebam"
    elif [[ $result == *"likely FR/fr-secondstrand"* ]]; then
        strandedness="--rf-stranded --genomebam"
    else
        strandedness="error"
        echo "strandness cannot be determined" >> error_strandness.txt
    fi 
    '''   
}
