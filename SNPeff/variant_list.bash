grep EFF $1 \
| awk -F '	' '$2 ~ /[0-9]+/' \
| tr ',' '\t' | awk -F "	" '{print $2 "\t" $11 "\t" $8 "\t" $1}' \
| sed 's/:/\t/1' | sed 's/:/\t/1' | sed 's/;/\t/g2' | sed "s/ $//g"  \
| awk -F "	" 'NF > 5' \
| sed 's/|/\t/g' |  awk  -F "	"  '{ if ($3 > 0) {print $2/$3 "\t" $0} else {print $2"#####" "\t" $0 } }' \
| sort -s -t "	" -n -k2,2 -k10,10 -k19,19 \
| awk -F "	" -v pos=0 '{if ($2 != pos) {print "+++++++++++++++++++"; pos=$2}; print $0 "\t" $2 "\t" $10 "\t" $19 }' \
| awk -F "	" '$1 > 0.0 || substr($1,1,1) == "+"' \

