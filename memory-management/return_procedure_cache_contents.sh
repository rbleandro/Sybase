$SYBASE/OCS/bin/isql -Usa -Pxxxx << EOT | grep "pbname
Total # of bytes used" | awk '!(NR%2){print p" "$0}{p=$0}' | awk '{ print $1" "$9" bytes"; }' | sed "s/pbname=//g" | sed "s/'//g" | sort -k2 -n 
dbcc traceon(3604)
go
dbcc procbuf
go
EOT