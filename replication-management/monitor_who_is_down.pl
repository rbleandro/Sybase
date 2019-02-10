#!/usr/bin/perl 

###################################################################################
#Script:   This script monitors if there are any connections, distributors        #
#          or other threads                                                       #
#                                                                                 #
#Author:   Amer Khan                                                              #
#Revision:                                                                        #
#Date           Name            Description                                       #
#---------------------------------------------------------------------------------#
#Jun 26,2006	Amer Khan       Originally created                                #
#                                                                                 #
###################################################################################

$error = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P -Shqvsybrep3 -b <<EOF 2>&1
admin who_is_down
go
exit
EOF
`;

#print "$error\n";

#Set starting variables
$Min=sprintf('%02d',((localtime())[1]));
$num_count = `cat /tmp/num_count`;

#if($error && $num_count <= 1){
if($error =~ /Down/i && $error =~ /DSI EXEC/){

#print "$error\n";

$num_count = $num_count + 1;
`echo $num_count > /tmp/num_count`;
	print "$error\n";
	`/usr/sbin/sendmail -t -i <<EOF
To: CANPARDatabaseAdministratorsStaffList\@canpar.com
Subject: hqvsybrep3 -- Who Is Down Alert -- \`date\`

$error

EOF
`;
}else{ # if error exists
  print "All clear \n";
#	if (!$error){
	`echo 0 > /tmp/num_count`;
#	}
} # eof reset num_count
