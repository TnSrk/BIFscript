#gatk HaplotypeCaller -R NC_063383.fasta -I ID24123-LRV-2_S25_L001_R_001_asmb_NC_063383.sorted.bam -O ID24123-LRV-2_S25_L001_R_001_asmb_NC_063383.sorted.vcf --minimum-mapping-quality 10 --ploidy 2 -ERC BP_RESOLUTION
#gatk HaplotypeCaller -R data/genomes/dbase.fa -I $1.sorted.bam -O $1.vcf --minimum-mapping-quality 10 --ploidy 2 -ERC BP_RESOLUTION
gatk HaplotypeCaller -R NC_063383.fasta -I $1.sorted.bam -O $1.vcf --minimum-mapping-quality 10 --ploidy 2 -ERC BP_RESOLUTION
