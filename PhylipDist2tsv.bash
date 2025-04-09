INNAME=$1
OUTNAME=$2
if [ "$#" -ne 2  ]
then
       	echo "Nmu < 2 ;num= "$#
	echo "Usage bash "$0" phylip_distnace_output output_name "
else

#transform distance matrix from phylip protdist output to tsv
cat $INNAME | awk '{if ($1 ~ /[A-Za-z]/) {print "#"$0} else {print $0}  }' | tr -d '\n' | tr '#' '\n' | awk 'NF > 2' | awk '{print $1}' > "$OUTNAME".Namelist
echo -en "NAME\t" > "$OUTNAME"_dist.tsv ;cat "$OUTNAME".Namelist | tr "\n" "\t" >> "$OUTNAME"_dist.tsv; echo >> "$OUTNAME"_dist.tsv
cat $INNAME | awk '{if ($1 ~ /[A-Za-z]/) {print "#"$0} else {print $0}  }' | tr -d '\n' | tr '#' '\n' | awk  'NF > 2' | sed "s/ \{1,\}/ /g" | tr " " "\t" >> "$OUTNAME"_dist.tsv

#convert Distance matrix to simmilarity matrix
 cat  "$OUTNAME"_dist.tsv | awk '{ for (i = 1; i <= NF; i++) { if (NR > 1 && i > 1) { $i = 100.0 - ( $i * 100.0 ) } } print }' |  tr " " "\t" > "$OUTNAME"_sim.tsv

fi
