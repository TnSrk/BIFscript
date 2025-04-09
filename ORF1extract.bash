NAME=$2
DB=$1 
#../Seqs/WGS
grep $NAME BatORF1ab_Selected_1stPart_1line_AA.WGS.tblastn_tab | sort -k12,12gr -k4,4gr | head -1 | awk '{print "blastdbcmd -db '$DB' -entry '$NAME' -range "$9"-"$10}' \
	| bash > TMP_ORF1_NU.fasta
grep $NAME BatORF1ab_Selected_2ndPart_1line_AA.WGS.tblastn_tab | sort -k12,12gr -k4,4gr | head -1 | awk '{print "blastdbcmd -db '$DB' -entry '$NAME' -range "$9"-"$10}' \
	| bash >> TMP_ORF1_NU.fasta
transeq TMP_ORF1_NU.fasta -out TMP_ORF1_AA.fasta
echo ">"$2 > TMP_ORF1_AA_"$NAME".fasta
grep -v ">" TMP_ORF1_AA.fasta | bash FastaOneliner.bash >> TMP_ORF1_AA_"$NAME".fasta

