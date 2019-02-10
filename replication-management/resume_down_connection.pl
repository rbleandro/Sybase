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
resume connection to CPIQ2.cmf_data_iq_conn5 skip transaction
go
exit
EOF
`;

print "$error\n";

