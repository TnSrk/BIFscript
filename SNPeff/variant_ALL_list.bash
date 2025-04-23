grep EFF ID*_S*_L*.filtered.normalized.snpeffed.vcf   \
| awk -F '	' '$2 ~ /[0-9]+/' \
| awk -F "	" -vOFS='	' '{  gsub("MODIFIER\\|\\|\\|","MODIFIER||"$4"/"$5"|",$8)  ; print $0 }' \
| tr ',' '\t' | awk -F '	' '{print $2 "\t" $11 "\t" $8 "\t" $1}' \
| sed 's/:/\t/1' | sed 's/:/\t/1' | sed 's/EFF/\tEFF/g2'  \
| awk -F '	' 'NF > 5' \
| sed 's/|/\t/g' |  awk  -F "	"  '{ if ($3 > 0) {print $2/$3 "\t" $0} else {print $2"#####" "\t" $0 } }' \
| sort  -t "	"  -k2,2 -k10,10 -k19,19 \
| awk -F '	' -v pos=0  -v posA=0 '{if ($2 != pos || $10 != posA) {print "+++++++++++++++++++"; pos=$2; posA=$10}; print $0 "\t" $2 "\t" $10 "\t" $19 }' \
| awk -F '	' '$1 > 0.0 || substr($1,1,1) == "+"' \

