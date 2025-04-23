#snpeff ann -nodownload -formatEff -classic -noStats -noLog -quiet -no-upstream -no-downstream -c $snpeff_config sars2 -v $input
#snpeff ann -nodownload -formatEff -classic -noStats -noLog -quiet -no-upstream -no-downstream -c $1 sars2 -v $2
#snpEff ann -nodownload -formatEff -classic -noStats -noLog  -no-upstream -no-downstream -c snpEff.config dbase -v ID24123-LRV-2_S25_L001_R_001_asmb_NC_063383.filtered.vcf > ID24123-LRV-2_S25_L001_R_001_asmb_NC_063383.filtered.snpeffed.vcf
snpEff ann -nodownload -formatEff -classic -noStats -noLog  -no-upstream -no-downstream -c snpEff.config dbase -v $1.filtered.normalized.vcf > $1.filtered.normalized.snpeffed.vcf
