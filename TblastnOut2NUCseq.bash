DBPATH=$1
DBNAME=$2
cat | awk '{print "blastdbcmd -db '"$DBPATH"'/'"$DBNAME"' -entry "$2" -range "$9"-"$10 + 30}' | bash 
