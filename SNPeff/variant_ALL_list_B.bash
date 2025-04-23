grep EFF ID*_S*_L*.filtered.normalized.snpeffed.vcf   \
| awk -F '	' '$2 ~ /[0-9]+/' \
| awk -F "	" -vOFS='	' '{  gsub("MODIFIER\\|\\|\\|","MODIFIER||"$4"/"$5"|",$8)  ; print $0 }' \
| awk -F '	' -vOFS='	' '{ gsub(",","_",$8) ; print $0}' \
| awk -F '	' -vOFS='	' '{ gsub(",","\t",$10) ; print $0}' \
| awk -F '	' '{print $2 "\t" $11 "\t" $8 "\t" $1}' \
| awk -F '	' -vOFS='	' '{ gsub("\\|","_",$2) ; print $0}' \
| sed 's/:/\t/1' | sed 's/:/\t/1' | sed 's/EFF/\tEFF/'  \
| awk -F '	' 'NF > 5' \
| sed "s/|/\t/1" | sed "s/|/\t/1"| sed "s/|/\t/1"| sed "s/|/\t/1"| sed "s/|/\t/1"| sed "s/|/\t/1"| sed "s/|/\t/1"| sed "s/|/\t/1"| sed "s/|/\t/1"| sed "s/|/\t/1" \
|  awk  -F "	" '{ if ($3 > 0 && NF > 3) {print $2/$3 "\t" $0} else {print $2"#####" "\t" $0  } }' \
| awk -F '	' '{print $0 "\t" $9}' \
| sort  -t "	" -k2,2 -k8,8 -k17,17 \
| awk -F '	' -v pos=0  -v posA=0 '{if ($2 != pos || $8 != posA) {print "+++++++++++++++++++"}; pos=$2; posA=$8; print $0 }' \
| awk -F '	' '$1 > 0.0 || substr($1,1,1) == "+"' 

