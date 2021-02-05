#!/usr/bin/perl

#Script:        This script runs a replication health check through rs_ticket
#Jul 17,2017	  Amer Khan       Originally created
#Jul 26 2019	  Rafael Leandro
#               1.Obfuscated password for security reasons.
#								2.Changed the script to only check the database that have actual subscriptions created for them (this avoids unnecessary checks and mail alerts).
#								3.Included check for the DR site.
#Aug 8 2019		  Rafael Leandro
#               1.Added sqm block validation. Sometimes the ticket takes a bit to be replicated. The alert will now only fire if the SQM is actually not moving. This validation was not added for IQ.
#								2.Added error handling for isql connections
#May 27 2020    Rafael Leandro
#               1.Parameters will now be flags instead of positional
#               2.Added cleanup for table rs_ticket_history

use Sys::Hostname;
use strict;
use warnings;
use Getopt::Long qw(GetOptions);

my $mail = 'CANPARDatabaseAdministratorsStaffList';
my $finTime = localtime();
my $option = "all";

GetOptions(
  'to|r=s' => \$mail,
  'option|o=s' => \$option
) or die "Usage: $0 --to|r rleandro --option|o all\n";

##This function is needed to removing leading and trailing spaces...
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

## Determining primary and replicate database server.
my $sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -Shqvsybrep3 -b <<EOF 2>&1
connect rssd
go
delete from rs_ticket_history where dsi_t < dateadd(day,-7,getdate())
go
select distinct dsname from rs_dbreps r, rs_databases d where r.dbid = d.dbid
go
exit
EOF
`;

if ($sqlError =~ /Msg/ || $sqlError =~ /Possible Issue Found/){
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: Errors occured when running healthCheck.pl script
$sqlError
EOF
`;
die;
}
my $PDS = ""; my $RDS = ""; 

if ($sqlError =~ /CPDB2/){ $PDS = "CPDB2"; $RDS = "CPDB1"; }else{ $PDS = "CPDB1"; $RDS = "CPDB2"; }
my $RDR = "CPDB4";

print "Primary Database Server is $PDS and Replicate Database Server is $RDS \n";

my @chars = ("A".."Z", "a".."z",0..9);
my $string;
$string .= $chars[rand @chars] for 1..10;

print "\nSending rs_ticket now, with unique string = $string \n\n";
print "Checking Replication Health of $PDS...\n";

if ($option eq "all"){
$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -S$PDS -b <<EOF 2>&1
use master
go
select name from master..sysdatabases where name not in ('master','sybmgmtdb','model','sybsecurity','sybsystemdb','sybsystemprocs','mpr_data_lm','mpr_data') and name not like 'temp%' order by name
go
exit
EOF
`;

}else{
$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -Shqvsybrep3 -b <<EOF 2>&1
connect rssd
go
set nocount on
go
select distinct dbname from rs_databases d inner join rs_subscriptions s on d.dbid=s.dbid where d.dbname not like 'hqvsyb%' and d.dbname not like '%_iq_%' and dsname='CPDB2' and materializing=0 order by dbname
go
exit
EOF
`;
}

if ($sqlError =~ /Msg/ || $sqlError =~ /Possible Issue Found/){
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: Errors occured when running healthCheck.pl script
$sqlError
EOF
`;
die;
}

my @row_array; my $dbname; my $sqmcheck1; my $sqmcheck2; my $currDT; my $mailError; my @iq_row_array; my $dbname_row; my @dbname_array;

@row_array = split(/\n/,$sqlError);
my $cntr = 0; #Counter is needed to try for a set number of times to look for ticket sent

foreach $dbname (@row_array){
next if $dbname =~ /Gateway/;
next if $dbname =~ /affected/;
next if $dbname =~ /^$/;
$dbname = trim($dbname); # Remove spaces

print "$dbname...";

$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -S$PDS -b <<EOF 2>&1
use $dbname
go
rs_ticket \"$string\"
go
exit
EOF
`;

if ($sqlError =~ /Msg/ || $sqlError =~ /Possible Issue Found/){
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: Errors occured when running healthCheck.pl script
$sqlError
EOF
`;
die;
}
  
#Checking the rs_ticket on the standby server
$cntr = 0;
$sqmcheck1=`perl /opt/sybase/cron_scripts/return_sqm_block.pl $RDS $dbname`;
while ($sqlError !~ /$string/){
 $cntr++;
 if ($cntr > 60){
  $sqmcheck2=`perl /opt/sybase/cron_scripts/return_sqm_block.pl $RDS $dbname`;

if ($sqmcheck2 == $sqmcheck1){
print "***NOT Good for Standby - $dbname. First sqm check:$sqmcheck1. Second sqm check: $sqmcheck2 \n";

$currDT = localtime();

$mailError = `/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: SRS Health Check Alert
Time Alert Sent: $currDT\n
--===============================================================\n
Replication May Be Down For $dbname on standby server.
rs_ticket check failed to reach the replicate db within 60 seconds
This might be a temporary high usage, wait a little more and
then check, if you keep getting the alerts.
--===============================================================\n
EOF
`;
print "\nMail result: $mailError \n";

last;
}}
   
sleep(1);

$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -S$RDS -b <<EOF 2>&1
use $dbname
go
delete from rs_ticket_history where dsi_t < dateadd(day,-7,getdate())
go
select h1 from rs_ticket_history where h1 = \"$string\"
go
exit
EOF
`;

if ($sqlError =~ /Msg/ || $sqlError =~ /Possible Issue Found/){
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: Errors occured when running healthCheck.pl script
$sqlError
EOF
`;
die;
}
}#eof while

if ($sqlError =~ /$string/){ print "Standby OK\n"; }

}#eof foreach loop

#print "Checking Replication Health of $RDR...\n";
#if ($option eq "all"){
#$sqlError = `. /opt/sybase/SYBASE.sh
#isql -Usa -w200 -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -S$PDS -b <<EOF 2>&1
#use master
#go
#select name from master..sysdatabases where name not in ('master','sybmgmtdb','model','sybsecurity','sybsystemdb','sybsystemprocs','mpr_data','mpr_data_lm') and name not like 'temp%' order by name
#go
#exit
#EOF
#`;
#
#}else{
#$sqlError = `. /opt/sybase/SYBASE.sh
#isql -Usa -w200 -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -Shqvsybrep3 -b <<EOF 2>&1
#connect rssd
#go
#set nocount on
#go
#select distinct dbname from rs_databases d inner join rs_subscriptions s on d.dbid=s.dbid where d.dbname not like 'hqvsyb%' and d.dbname not like '%_iq_%' and dsname='CPDB4' and materializing=0 order by dbname
#go
#exit
#EOF
#`;
#}
#
#if ($sqlError =~ /Msg/ || $sqlError =~ /Possible Issue Found/){
#`/usr/sbin/sendmail -t -i <<EOF
#To: $mail\@canpar.com
#Subject: Errors occured when running healthCheck.pl script
#$sqlError
#EOF
#`;
#die;
#}
#
#@row_array = split(/\n/,$sqlError);
#$cntr = 0; #Counter is needed to try for a set number of times to look for ticket sent
#
#foreach $dbname (@row_array){
#  next if $dbname =~ /Gateway/;
#  next if $dbname =~ /affected/;
#  next if $dbname =~ /^$/;
#  $dbname = trim($dbname); # Remove spaces
#
#  print "$dbname...";
#  #Checking the rs_ticket on the DR server
#  $cntr = 0;
#  $sqmcheck1=`perl /opt/sybase/cron_scripts/return_sqm_block.pl $RDR $dbname`;
#  
#  while ($sqlError !~ /$string/){
#   $cntr++;
#   if ($cntr > 60){
#	$sqmcheck2=`perl /opt/sybase/cron_scripts/return_sqm_block.pl $RDR $dbname`;
#	
#	if ($sqmcheck2 == $sqmcheck1){
#    print "***NOT Good for DR - $dbname. First sqm check:$sqmcheck1. Second sqm check: $sqmcheck2 \n";
#
#    $currDT = localtime();
#    $mailError = `/usr/sbin/sendmail -t -i <<EOF
#To: $mail\@canpar.com
#Subject: SRS Health Check Alert
#Time Alert Sent: $currDT\n
#--===============================================================\n
#Replication May Be Down For $dbname on DR server.
#rs_ticket check failed to reach the replicate db within 60 seconds
#This might be a temporary high usage, wait a little more and
#then check, if you keep getting the alerts.
#--===============================================================\n
#EOF
#`;
#print "\nMail result: $mailError \n";
#
#    last;
#   }}
#   sleep(1);
#   $sqlError = `. /opt/sybase/SYBASE.sh
#isql -Usa -w200 -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -S$RDR -b <<EOF 2>&1
#use $dbname
#go
#delete from rs_ticket_history where dsi_t < dateadd(day,-7,getdate())
#go
#select h1 from rs_ticket_history where h1 = \"$string\"
#go
#exit
#EOF
#`;
#
#if ($sqlError =~ /Msg/ || $sqlError =~ /Possible Issue Found/){
#`/usr/sbin/sendmail -t -i <<EOF
#To: $mail\@canpar.com
#Subject: Errors occured when running healthCheck.pl script
#$sqlError
#EOF
#`;
#die;
#}
# 
#}#eof while
#
#  if ($sqlError =~ /$string/){ print "DR OK \n"; }
#}#eof foreach loop


################################################
## Following is to check IQ connection health  #
################################################

$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -Shqvsybrep3 -b <<EOF 2>&1
connect rssd
go
set nocount on
go
select distinct dbname from rs_databases where dbname like '%_iq_%'
go
exit
EOF
`;

if ($sqlError =~ /Msg/ || $sqlError =~ /Possible Issue Found/){
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: Errors occured when running healthCheck.pl script
$sqlError
EOF
`;
die;
}

#print "$sqlError\n";
@iq_row_array = split(/\n/,$sqlError);
$cntr = 0; #Counter is needed to try for a set number of times to look for ticket sent

foreach $dbname_row (@iq_row_array){
next if $dbname_row =~ /Gateway/;
next if $dbname_row =~ /affected/;
next if $dbname_row =~ /^$/;
$dbname_row = trim($dbname_row); # Remove spaces

@dbname_array = split(/_iq_conn/,$dbname_row);
$dbname = $dbname_array[0]."_rep".$dbname_array[1];

print "$dbname_row...";

#print "Source DB: $sqlError \n";
$cntr = 0;
while ($sqlError !~ /$string/){
$cntr++;
if ($cntr > 60){
print "\n***NOT Good for IQ - $dbname \n";

$currDT = localtime();
$mailError = `/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: SRS Health Check Alert
Time Alert Sent: $currDT\n
--===============================================================\n
Replication May Be Down For $dbname
rs_ticket check failed to reach the replicate db within 60 seconds
This might be a temporary high usage, wait a little more and
then check, if you keep getting the alerts.
--===============================================================\n
EOF
`;
print "\nMail result: $mailError \n";

last;
}
#print "$dbname";

$sqlError = `. /opt/sybase/SYBASE.sh
isql -U$dbname -w200 -Psybase -SCPIQ -b <<EOF 2>&1
delete from rs_ticket_history where dsi_t < dateadd(day,-7,getdate())
commit
go
select h1 from rs_ticket_history where h1 = \"$string\"
commit
go
exit
EOF
`;

if ($sqlError =~ /Msg/ || $sqlError =~ /Possible Issue Found/){
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: Errors occured when running healthCheck.pl script
$sqlError
EOF
`;
die;
}

sleep(1);
}#eof while

if ($sqlError =~ /$string/){ print "OK\n"; $sqlError ="";}

}#eof IQ foreach loop
