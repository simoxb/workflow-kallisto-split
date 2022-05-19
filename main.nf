nextflow.enable.dsl=2



Channel.fromFilePairs(params.reads)
	.set{raw_input_ch}



include {fastp} from "./modules/fastp"
include {kallisto_index; kallisto_map} from "./modules/kallisto"
include {cufflinks} from "./modules/cufflinks"
include {check_strandedness} from "./modules/check_strandedness"
include {fastqsplit} from "./modules/splitFastq"
include {samtools; samtools_merge} from "./modules/samtools"




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
       	 	 | view()        	 	 
       		 | set{ read_pairs_ch }
       		 
       		 

		kallisto_map(read_pairs_ch, check_strandedness.out.kallisto.first(), kallisto_index.out, params.gtf)
		samtools(kallisto_map.out.bam)
		samtools_merge(samtools.out)
		
		cufflinks(check_strandedness.out.cufflinks, samtools_merge.out, params.gtf)

}

workflow{
	rnaseq(raw_input_ch)	
}

