# 
DBNAME='WGS'
DBPATH='SeqDB'
#TARGET="L7_"
# Create AAseqs files from existing alignment
#for i in $(ls ../alignment | grep -v WGS | sed "s/region_//" | sed "s/_outer_aln.fasta// " );do echo $i; cat ../alignment/region_"$i"_outer_aln.fasta | awk '{if ("$1" !~ ">") {gsub("-","",$0)}; print $0}' | sed "s/WGS|//" | sed "s/|/_"$i" /" | tr "|" " " > "$i".fasta;done

# Create WGS BLAST DB for searching and extraction
#makeblastdb -dbtype nucl -parse_seqids -in "$DBNAME".fasta -out "$DBNAME"

# Search for ortholog sequences
tblastn -num_threads 10 -query "$DBPATH"/"$1".fasta -outfmt 6 -db "$DBPATH"/"$DBNAME" > "$1"_"$DBNAME".tblastn_tab

# select tblastn output besthit then extract nucleotide sequence and translate to AA sequence with emboss transeq  
#sort -k12,12gr E_"$DBNAME".tblastn_tab | sort -u -k2,2  | awk '{print "blastdbcmd -db "$DBPATH"/"$DBNAME" -entry "$2" -range "$9  "-""$1"0 + 30 }' | bash | awk '{if ("$1" ~ ">") {print "#" $0 "#"} else {print $0} }' | tr -d "\n" | tr "#" "\n" | awk '{if ("$1" ~ ">") {gsub(":"," ", $0); print "$1""_E "$3,$4,$5,$6} else {print $0} }' > E_"$DBNAME"_nucl.fasta
#sort -k12,4gr "$1"_"$DBNAME".tblastn_tab | sort -u -k2,2  | awk -v SS=1 '{SS = ($9 - ( ( $7 -1 ) * 3))  ;print "blastdbcmd -db '"$DBPATH"'/'"$DBNAME"' -entry "$2" -range "SS "-"$10 + 30 }' | bash | awk '{if ($1 ~ ">") {print "#" $0 "#"} else {print $0} }' | tr -d "\n" | tr "#" "\n" | awk -v LineNum=0 '{if ($1 ~ ">") {LineNum+=1;gsub(":"," ", $0); print ">L"LineNum" "substr($1,2)" "$3,$4,$5,$6} else {print $0} }' > "$1"_"$DBNAME"_nucl.fasta

#RBD and nstp
#sort -k12,4gr -u -k2,2 "$1"_"$DBNAME".tblastn_tab \
#      | awk -v SS=1 '{SS = ($9 - ( ( $7 -1 ) * 3))  ;print "blastdbcmd -db '"$DBPATH"'/'"$DBNAME"' -entry "$2" -range "SS "-"$10  }' | bash \
#      | awk '{if ($1 ~ ">") {print "#" $0 "#"} else {print $0} }' | tr -d "\n" | tr "#:" "\n " > "$1"_"$DBNAME"_nucl.fasta

# ORF1ab add 1 base
#sort -k12,4gr -u -k2,2 "$1"_"$DBNAME".tblastn_tab \
#      | awk -v SS=1 '{SS = ($9 - ( ( $7 -1 ) * 3))  ;print "blastdbcmd -db '"$DBPATH"'/'"$DBNAME"' -entry "$2" -range "SS "-"$10 + 8135  }' | bash \
#      | awk '{if ($1 ~ ">") {print "#" $0 "#"} else {print $0} }' | tr -d "\n" | tr "#:" "\n " > "$1"_"$DBNAME"_nucl.fasta

#Normal ORF
#sort -k12,4gr -u -k2,2 "$1"_"$DBNAME".tblastn_tab \
awk '{print $0 "\t" substr($2,2) }' "$1"_"$DBNAME".tblastn_tab | awk '{ gsub("_","\t",$13) ;print $0}' | sort -h -k12,12gr -k4,4gr | sort -u -h -k13,13g  \
	| tr " " "\t" |  awk -v SS=1 '{SS = ($9 - ( ( $7 - 1 ) * 3))  ;print "blastdbcmd -db '"$DBPATH"'/'"$DBNAME"' -entry "$2" -range "SS "-"$10 + 30 }' | bash \
	| awk '{if ($1 ~ ">") {print "#" $0 "#"} else {print $0} }' | tr -d "\n" | tr "#:" "\n " > "$1"_"$DBNAME"_nucl.fasta


#translate nucl Seq to AA Seq
transeq "$1"_"$DBNAME"_nucl.fasta -out "$1"_"$DBNAME"_AA.fasta

#trim exceeded part from stop codon
#cat "$1"_"$DBNAME"_AA.fasta | bash FastaOneliner.bash | awk -F '*' '{print $1}'  > "$1"_"$DBNAME"_AA_trm.fasta
#Normal ORF
cat "$1"_"$DBNAME"_AA.fasta | bash FastaOneliner.bash | tr "*" "\t" \
    |  awk -v ORF="" '{if ($1 ~ ">") {print $0; ORF=""} \
    else { for (i = 1; i <= NF; i++) { if ( length($i) > length(ORF)) { ORF = $i} } print ORF } }' \
    | sed "s/[^>M ]\{,\}M/M/" > "$1"_"$DBNAME"_AA_trm.fasta

#RBD and nstp
#cat "$1"_"$DBNAME"_AA.fasta | bash FastaOneliner.bash > "$1"_"$DBNAME"_AA_trm.fasta

awk '{if ($1 ~ ">") {gsub(">","",$0); print } }' "$1"_"$DBNAME"_AA.fasta > "$1"_"$DBNAME"_FullName.namelist
#do alignment with mafft
#mafft --globalpair --maxiterate 1000 "$1"_"$DBNAME"_AA_trm.fasta  2> mafftstderr | bash FastaOneliner.bash > "$1"_"$DBNAME"_AA.mafft
#mafft --globalpair --maxiterate 1000 "$1"_"$DBNAME"_AA.fasta  2> mafftstderr | bash FastaOneliner.bash > "$1"_"$DBNAME"_AA.mafft
mafft --globalpair --maxiterate 1000 "$1"_"$DBNAME"_AA_trm.fasta  2> mafftstderr \
| bash FastaOneliner.bash > "$1"_"$DBNAME"_AA.mafft

#convert alignment to phylip format
#seqret -sequence E_"$DBNAME"_AA.mafft -outseq E_"$DBNAME"_AA.phy
seqret -osformat phylip -sequence "$1"_"$DBNAME"_AA.mafft -outseq "$1"_"$DBNAME"_AA.phy

#calculate distance
#distmat -protmethod 2 E_"$DBNAME"_AA_trimmed.mafft -outfile E_"$DBNAME"_AA_trimmed.dmt
rm "$1"_"$DBNAME"_AA.dist
bash -c 'echo -e "./"$1"\nF\n"$2"\nY\n" | phylip protdist' _ "$1"_"$DBNAME"_AA.phy "$1"_"$DBNAME"_AA.dist
#transform distance matrix from phylip protdist output to tsv
cat "$1"_"$DBNAME"_AA.dist | awk '{if ($1 ~ /[A-Za-z]/) {print "#"$0} else {print $0}  }' | tr -d '\n' | tr '#' '\n' | awk 'NF > 2' | awk '{print $1}' > "$1".namelist
echo -en "NAME\t" > "$1"_"$DBNAME"_AA_dist.tsv ;cat "$1".namelist | tr "\n" "\t" >> "$1"_"$DBNAME"_AA_dist.tsv; echo >> "$1"_"$DBNAME"_AA_dist.tsv
cat "$1"_"$DBNAME"_AA.dist | awk '{if ($1 ~ /[A-Za-z]/) {print "#"$0} else {print $0}  }' | tr -d '\n' | tr '#' '\n' | awk  'NF > 2' | sed "s/ \{1,\}/ /g" | tr " " "\t" >> "$1"_"$DBNAME"_AA_dist.tsv

#convert Distance matrix to simmilarity matrix
 cat  "$1"_"$DBNAME"_AA_dist.tsv | awk '{ for (i = 1; i <= NF; i++) { if (NR > 1 && i > 1) { $i = 100.0 - ( $i * 100.0 ) } } print }' |  tr " " "\t" > "$1"_"$DBNAME"_AA_sim.tsv
