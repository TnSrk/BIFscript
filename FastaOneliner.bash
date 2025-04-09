cat | awk '{if ($1 ~ ">") {print "#" $0 "#"} else {print $0} }' | tr -d "\n" | tr "#" "\n" | grep -v "^$"
