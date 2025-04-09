DBPATH=$1
DBNAME=$2
cat | awk '{print "blastdbcmd -db '"$DBPATH"'/'"$DBNAME"' -entry "$2" -range "$9"-"$10 + 30}' | bash \
	| awk -v NAME="" '{if ($1 != name) {NAME=$1} else {$1==NAME+"_B"} ;if ($1 ~ ">") {print "#" $0 "#"} else {print $0} }' | tr -d "\n" | tr "#:" "\n " 
