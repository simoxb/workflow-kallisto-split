process check_strandedness{

	label 'check_strandedness'
	
    input:
     tuple val(sample_name), path(reads)
     path(annotation)
     path(reference_cdna)
   
    output: 
        env STRANDNESS

    shell:
    '''    
    check_strandedness -g !{annotation} -r1 !{reads[0]} -r2 !{reads[1]} --transcripts !{reference_cdna} > result.txt
    result=$( tail -n 1 result.txt )
    if [[ $result == *"likely unstranded"* ]]; then
          STRANDNESS="unstranded"
    elif [[ $result == *"likely RF/fr-firststrand"* ]]; then
          STRANDNESS="firststrand"
    elif [[ $result == *"likely FR/fr-secondstrand"* ]]; then
          STRANDNESS="secondstrand"
    else
        STRANDNESS="error"
    fi
    '''
    
  
}
