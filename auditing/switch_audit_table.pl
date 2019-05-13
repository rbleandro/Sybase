#!/usr/bin/perl -w

###################################################################################
#Script:   This script moves audited data into user table for report and switches #
#                                                                                 #
#										  #
#Author:   Amer Khan                                                              #
#Revision:                                                                        #
#Date		Name		Description                                       #
#---------------------------------------------------------------------------------#
#Jul 17,2016	Amer Khan	Originally created                                #
#                                                                                 #
###################################################################################
#Usage Restrictions
open (PROD, "</opt/sap/cron_scripts/passwords/check_prod");
while (<PROD>){
@prodline = split(/\t/, $_);
$prodline[1] =~ s/\n//g;
}
if ($prodline[1] eq "0" ){
print "standby server \n";
        die "This is a stand by server\n"
        }
        use Sys::Hostname;
        $prodserver = hostname();

        if ($prodserver eq 'CPDB2'){ $stbyserver = 'CPDB1'; } else { $stbyserver = 'CPDB2'; }

        print "Prod: $prodserver....Stby: $stbyserver \n";


#Count the number of rows in sysaudits_01 before paging
my $sqlError = "";

$sqlError = `. /opt/sap/SYBASE.sh
isql -Usa -P\`/opt/sap/cron_scripts/getpass.pl sa\` -S$prodserver -b -n<<EOF 2>&1
set nocount on
go
use sybsecurity
go
execute audit_thresh
go
exit
EOF
`;

print "$sqlError\n";

   if ($sqlError =~ /Msg/){
`/usr/sbin/sendmail -t -i <<EOF
To: CANPARDatabaseAdministratorsStaffList\@canpar.com
Subject: Error: switch_audit_table

$sqlError
EOF
`;
   }#end of if messages received

