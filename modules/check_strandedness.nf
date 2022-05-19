process check_strandedness{

	label 'check_strandedness'
	
    input:
     tuple val(sample_name), path(reads)
     path(annotation)
     path(reference_cdna)
   
    output: 
        env strandedness_1, emit: kallisto
        env strandedness_2, emit: cufflinks
    shell:
    '''    
    check_strandedness -g !{annotation} -r1 !{reads[0]} -r2 !{reads[1]} --transcripts !{reference_cdna} > result.txt
    result=$( tail -n 1 result.txt )
    if [[ $result == *"likely unstranded"* ]]; then
        strandedness_1="--genomebam"
        strandedness_2="fr-unstranded"
    elif [[ $result == *"likely RF/fr-firststrand"* ]]; then
        strandedness_1="--fr-stranded --genomebam"
        strandedness_2="fr-firststrand"
    elif [[ $result == *"likely FR/fr-secondstrand"* ]]; then
        strandedness_1="--rf-stranded --genomebam"
        strandedness_2="fr-secondstrand"
    else
        strandedness_1="error"
        strandedness_2="error"
        echo "strandness cannot be determined" >> error_strandness.txt
    fi 
    '''
}

