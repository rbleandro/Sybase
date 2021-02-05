#!/usr/bin/perl

#Script:   This script takes a backup of the system tables on CPDB1, CPDB2 and CPDB4 for recovery purposes
#
#Author:   Rafael Leandro
#Date           Name            Description
#Aug 15 2019	Rafael Leandro	Originally created

use Sys::Hostname;
use strict;
use warnings;
use Getopt::Long qw(GetOptions);
use Sys::Hostname;

my $prodserver = hostname();
my $drserver = 'CPDB4';
my $mail = 'CANPARDatabaseAdministratorsStaffList';
my $skipcheckprod=0;
my $finTime = localtime();

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

GetOptions(
    'skipcheckprod|s=s' => \$skipcheckprod,
	'to|r=s' => \$mail
) or die "Usage: $0 --skipcheckprod 0 --to rleandro\n";

if ($skipcheckprod==0){
open (PROD, "</opt/sybase/cron_scripts/passwords/check_prod") or die "Can't open < /opt/sap/cron_scripts/passwords/check_prod : $!";

my @prodline="";
while (<PROD>){
	@prodline = split(/\t/, $_);
	$prodline[1] =~ s/\n//g;
}

if ($prodline[1] eq "0" ){
	print "standby server \n";
	die "This is a stand by server\n"
}
}

my $my_pid = getppid();
my $isProcessRunning =`ps -ef|grep sybase|grep backup_cron_jobs.pl|grep -v grep|grep -v $my_pid|grep -v "vim backup_cron_jobs.pl"|grep -v "less backup_cron_jobs.pl"`;

print "Running: $isProcessRunning \n";

if ($isProcessRunning){
die "\n Can not run, previous process is still running \n";

}else{
print "No Previous process is running, continuing\n";
}

#Set starting variables
my $currTime = localtime();
my $startHour=sprintf('%02d',((localtime())[2]));
my $startMin=sprintf('%02d',((localtime())[1]));

## Determining primary server
my $sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -Shqvsybrep3 -b <<EOF 2>&1
connect rssd
go
set nocount on
go
select distinct dsname from rs_dbreps r, rs_databases d where r.dbid = d.dbid
go
exit
EOF
`;

if ($sqlError =~ /Msg/ || $sqlError =~ /Possible Issue Found/){
print "$sqlError\n";
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: Errors occured when running backup_ASE_system_tables.pl script
$sqlError
EOF
`;
die;
}

$sqlError=trim($sqlError);
$sqlError =~ s/Gateway connection to .* is created.//g;
$sqlError =~ s/\(\w+ \w+ affected\)//g;
$sqlError =~ s/\n//g;
my $PDS=trim($sqlError);

#print "$sqlError\n";

## Determining secondary servers
$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -Shqvsybrep3 -b <<EOF 2>&1
connect rssd
go
set nocount on
go
select distinct dsname from rs_repdbs r1 where dsname <> (select distinct dsname from rs_dbreps r, rs_databases d where r.dbid = d.dbid) and dsname not like '%IQ%'
go
exit
EOF
`;

if ($sqlError =~ /Msg/ || $sqlError =~ /Possible Issue Found/){
print "$sqlError\n";
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: Errors occured when running backup_ASE_system_tables.pl script
$sqlError
EOF
`;
die;
}

$sqlError=trim($sqlError);
$sqlError =~ s/Gateway connection to .* is created.//g;
$sqlError =~ s/\(\w+ \w+ affected\)//g;

my @secservers = split(/\n/,$sqlError);
my $RDS = trim($secservers[1]);
my $RDR = trim($secservers[2]);

print "Production server:$PDS, Secondary server:$RDS, Secondary server:$RDR\n";

#$sqlError = system("sqsh -Usa -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -S$PDS -i/opt/sybase/ASE_data/system_tables/extract-systables.sql");

#print "$sqlError\n";

$sqlError = `sqsh -Usa -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -S$PDS <<EOF 2>&1
select * from sysdatabases
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/production/sysdatabases.csv"
select * from sysdevices
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/production/sysdevices.csv"
select * from sysusages
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/production/sysusages.csv"
select * from sysloginroles
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/production/sysloginroles.csv"
select * from syslogins
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/production/syslogins.csv"
select * from sysconfigures
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/production/sysconfigures.csv"
select * from syscharsets
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/production/syscharsets.csv"
select * from sysservers
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/production/sysservers.csv"
select * from sysremotelogins
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/production/sysremotelogins.csv"
select * from sysresourcelimits
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/production/sysresourcelimits.csv"
select * from systimeranges
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/production/systimeranges.csv"
exit
EOF
`;

if ($sqlError =~ /error/i || $sqlError =~ /failed/i){
print "$sqlError\n";
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: Errors occured when running backup_ASE_system_tables.pl script
$sqlError
EOF
`;
die;
}

$sqlError = `sqsh -Usa -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -S$RDS <<EOF 2>&1
select * from sysdatabases
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/standby/sysdatabases.csv"
select * from sysdevices
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/standby/sysdevices.csv"
select * from sysusages
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/standby/sysusages.csv"
select * from sysloginroles
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/standby/sysloginroles.csv"
select * from syslogins
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/standby/syslogins.csv"
select * from sysconfigures
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/standby/sysconfigures.csv"
select * from syscharsets
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/standby/syscharsets.csv"
select * from sysservers
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/standby/sysservers.csv"
select * from sysremotelogins
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/standby/sysremotelogins.csv"
select * from sysresourcelimits
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/standby/sysresourcelimits.csv"
select * from systimeranges
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/standby/systimeranges.csv"
exit
EOF
`;

if ($sqlError =~ /error/i || $sqlError =~ /failed/i){
print "$sqlError\n";
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: Errors occured when running backup_ASE_system_tables.pl script
$sqlError
EOF
`;
die;
}

$sqlError = `sqsh -Usa -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -S$RDR <<EOF 2>&1
select * from sysdatabases
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/dr/sysdatabases.csv"
select * from sysdevices
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/dr/sysdevices.csv"
select * from sysusages
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/dr/sysusages.csv"
select * from sysloginroles
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/dr/sysloginroles.csv"
select * from syslogins
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/dr/syslogins.csv"
select * from sysconfigures
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/dr/sysconfigures.csv"
select * from syscharsets
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/dr/syscharsets.csv"
select * from sysservers
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/dr/sysservers.csv"
select * from sysremotelogins
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/dr/sysremotelogins.csv"
select * from sysresourcelimits
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/dr/sysresourcelimits.csv"
select * from systimeranges
go -m csv 2>/dev/null >"/opt/sybase/ASE_data/system_tables/dr/systimeranges.csv"
exit
EOF
`;

if ($sqlError =~ /error/i || $sqlError =~ /failed/i){
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: Errors occured when running backup_ASE_system_tables.pl script
$sqlError
EOF
`;
die;
}