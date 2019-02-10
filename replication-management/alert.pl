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

$server = $ARGV[0];

	`/usr/sbin/sendmail -t -i <<EOF
To: CANPARDatabaseAdministratorsStaffList\@canpar.com
Subject: hqvsybrep2 -- Alert -- \`date\`

$ARGV[0]
$ARGV[1]
$ARGV[2]
$ARGV[3]
$ARGV[4]
$ARGV[5]
$ARGV[6]
$ARGV[7]
$ARGV[8]
$ARGV[9]


EOF
`;
