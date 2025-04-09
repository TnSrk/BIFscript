cat | bash FastaOneliner.bash | tr "*" "\t" \
   |  awk -v ORF="" '{if ($1 ~ ">") {print $0; ORF=""} \
    else { for (i = 1; i <= NF; i++) { if ( length($i) > length(ORF)) { ORF = $i} } print ORF } }' \
   | sed "s/[^>M ]\{,\}M/M/" 
