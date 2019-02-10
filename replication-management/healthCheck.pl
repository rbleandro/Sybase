#!/usr/bin/perl 

###################################################################################
#Script:   This script runs a replication health check through rs_ticket          #
#                                                                                 #
#Author:   Amer Khan                                                              #
#Revision:                                                                        #
#Date           Name            Description                                       #
#---------------------------------------------------------------------------------#
#Jul 17,2017	Amer Khan       Originally created                                #
#                                                                                 #
###################################################################################

##This function is needed to removing leading and trailing spaces...
sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

## Determining primary and replicate database server.
$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P -Shqvsybrep3 -b <<EOF 2>&1
connect rssd
go
select distinct dsname from rs_dbreps r, rs_databases d where r.dbid = d.dbid
go
exit
EOF
`;

if ($sqlError =~ /CPDB2/){ $PDS = "CPDB2"; $RDS = "CPDB1"; }else{ $PDS = "CPDB1"; $RDS = "CPDB2"; }

print "Primary Database Server is $PDS and Replicate Database Server is $RDS \n";

my @chars = ("A".."Z", "a".."z",0..9);
my $string;
$string .= $chars[rand @chars] for 1..10;

print "\nSending rs_ticket now, with unique string = $string \n\n";
print "Checking Replication Health of...\n";

if ($ARGV[0] eq "all"){
$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P -S$PDS -b <<EOF 2>&1
use master
go
select name from master..sysdatabases where name not in ('master','sybmgmtdb','model','sybsecurity','sybsystemdb','sybsystemprocs','lm_stage') and name not like 'temp%' order by name
go
exit
EOF
`;
}else{
$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P -Shqvsybrep3 -b <<EOF 2>&1
connect rssd
go
set nocount on
go
select distinct dbname from rs_databases where dbname not like 'hqvsyb%' and dbname not like '%_iq_%'
go
exit
EOF
`;
}

#print "$sqlError\n";
@row_array = split(/\n/,$sqlError);
my $cntr = 0; #Counter is needed to try for a set number of times to look for ticket sent

foreach $dbname (@row_array){
  next if $dbname =~ /Gateway/;
  next if $dbname =~ /affected/;
  next if $dbname =~ /^$/;
  $dbname = trim($dbname); # Remove spaces

  print "$dbname...";

  $sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P -S$PDS -b <<EOF 2>&1
use $dbname
go
rs_ticket \"$string\"
go
exit
EOF
`;

  #print "Source DB: $sqlError \n";
  $cntr = 0;
  while ($sqlError !~ /$string/){
   $cntr++;
   if ($cntr > 60){
    print "\n***NOT Good for $dbname \n"; 
    
    $currDT = localtime();
    $mailError = `/usr/sbin/sendmail -t -i <<EOF
To: CANPARDatabaseAdministratorsStaffList\@canpar.com
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
   sleep(1);
   $sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P -S$RDS -b <<EOF 2>&1
use $dbname
go
select h1 from rs_ticket_history where h1 = \"$string\"
go
exit
EOF
`;
  # print "Replicate DB: $sqlError \n";
  }#eof while

  if ($sqlError =~ /$string/){ print "GOOD \n"; }

}#eof foreach loop

################################################
## Following is to check IQ connection health  #
################################################

$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P -Shqvsybrep3 -b <<EOF 2>&1
connect rssd
go
set nocount on
go
select distinct dbname from rs_databases where dbname like '%_iq_%'
go
exit
EOF
`;


#print "$sqlError\n";
@iq_row_array = split(/\n/,$sqlError);
my $cntr = 0; #Counter is needed to try for a set number of times to look for ticket sent

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
print "\n***NOT Good for $dbname \n"; 

$currDT = localtime();
$mailError = `/usr/sbin/sendmail -t -i <<EOF
To: CANPARDatabaseAdministratorsStaffList\@canpar.com
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
select h1 from rs_ticket_history where h1 = \"$string\"
go
exit
EOF
`;
# print "Replicate DB Messages: $sqlError \n";
sleep(1);
}#eof while

if ($sqlError =~ /$string/){ print "GOOD \n"; $sqlError ="";}

}#eof IQ foreach loop
