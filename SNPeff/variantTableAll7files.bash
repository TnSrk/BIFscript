head -n $1 variant_position.list | tail -n 1 | tr "\n" "\t" ; 
head -n $1 variant_position.list | tail -n 1 | awk '{print "grep ID24118-RSV_S21_L001_R_001.filtered.normalized.snpeffed.vcf   variant_ALL_list.out | grep "$2"\t | grep \t" $1  }'  | bash | awk '{print $1 }' | tr  -d "\n"; echo -n "	"; 
head -n $1 variant_position.list | tail -n 1 | awk '{print "grep ID24119-LRV_S22_L001_R_001.filtered.normalized.snpeffed.vcf   variant_ALL_list.out | grep "$2"\t | grep \t" $1  }'  | bash | awk '{print $1 }' | tr -d "\n" ; echo -n "	"; 
head -n $1 variant_position.list | tail -n 1 | awk '{print "grep ID24122-LSU_S23_L001_R_001.filtered.normalized.snpeffed.vcf   variant_ALL_list.out | grep "$2"\t | grep \t" $1  }'  | bash | awk '{print $1 }' | tr -d "\n" ; echo -n "	"; 
head -n $1 variant_position.list | tail -n 1 | awk '{print "grep ID24123-LRV-1_S24_L001_R_001.filtered.normalized.snpeffed.vcf variant_ALL_list.out | grep "$2"\t | grep \t" $1  }'  | bash | awk '{print $1 }' | tr -d "\n" ; echo -n "	";
head -n $1 variant_position.list | tail -n 1 | awk '{print "grep ID24123-LRV-2_S25_L001_R_001.filtered.normalized.snpeffed.vcf variant_ALL_list.out | grep "$2"\t | grep \t" $1  }'  | bash | awk '{print $1 }' | tr -d "\n" ; echo -n "	";
head -n $1 variant_position.list | tail -n 1 | awk '{print "grep ID24127-LRU-1_S26_L001_R_001.filtered.normalized.snpeffed.vcf variant_ALL_list.out | grep "$2"\t | grep \t" $1  }'  | bash | awk '{print $1 }' | tr -d "\n" ; echo -n "	";
head -n $1 variant_position.list | tail -n 1 | awk '{print "grep ID24127-LRU-2_S27_L001_R_001.filtered.normalized.snpeffed.vcf variant_ALL_list.out | grep "$2"\t | grep \t" $1  }'  | bash | awk '{print $1 }' | tr -d "\n" ; echo -n "	";
echo;
