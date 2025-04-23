awk '$5 != "<NON_REF>" ' ID24123-LRV-2_S25_L001_R_001_asmb_NC_063383.filtered.snpeffed_mod.vcf  | awk 'substr($1,1,1) != "#"' | less
