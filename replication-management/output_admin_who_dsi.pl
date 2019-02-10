#!/usr/bin/perl 

###################################################################################
#Script:                                                          #
#                                                                                 #
#Author:                                                          #
#Revision:                                                                        #
#Date           Name            Description                                       #
#---------------------------------------------------------------------------------#
#Jun 26,2006	Amer Khan       Originally created                                #
#                                                                                 #
###################################################################################

$error = `. /opt/sybase/SYBASE.sh
isql -Usa -w1400 -P -Shqvsybrep3 -o/opt/sybase/cron_scripts/cron_logs/output_admin_who_dsi.log <<EOF 2>&1
admin who, dsi
go
exit
EOF
`;

print "$error\n";

