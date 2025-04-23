awk '{if ($2 == '$1' && $0 ~ "	'$2'	") print $2"-"$13"-"$14"-"$15}' variant_ALL_list.out | head -n 1
