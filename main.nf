nextflow.enable.dsl=2



Channel.fromFilePairs(params.reads)
	.set{raw_input_ch}



include {fastp} from "./modules/fastp"
include {kallisto_index; kallisto_map} from "./modules/kallisto"
include {cufflinks} from "./modules/cufflinks"
include {check_strandedness} from "./modules/check_strandedness"
include {fastqsplit} from "./modules/splitFastq"


workflow rnaseq{
	take: 
		fastq_input

			
	main:
		fastp(fastq_input)
		kallisto_index(params.transcriptome)
		check_strandedness(fastq_input, params.gtf, params.ref_cdna)
		
		fastqsplit(fastp.out.trimmed) \
	   		 | map { name, fastq, fastq1 -> tuple( groupKey(name, fastq.size()), fastq, fastq1 ) } \
       	 	 | transpose() \
       		 | set{ read_pairs_ch }
       		 
		
		kallisto_map(check_strandedness.out, read_pairs_ch, params.gtf, kallisto_index.out)
		/*TODO: merge bam-files
		
		cufflinks(check_strandedness.out, xxx, params.gtf)*/
}

workflow{
	rnaseq(raw_input_ch)	
}

