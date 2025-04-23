#gatk LeftAlignAndTrimVariants --split-multi-allelics -R $1 -V $2 -O $3
#bash gatk4_VCF_normalliz.sh NC_063383.fasta ID24123-LRV-2_S25_L001_R_001_asmb_NC_063383.sorted.vcf ID24123-LRV-2_S25_L001_R_001_asmb_NC_063383.filtered.vcf
gatk LeftAlignAndTrimVariants --split-multi-allelics -R NC_063383.fasta -V $1.filtered.vcf -O $1.filtered.normalized.vcf
