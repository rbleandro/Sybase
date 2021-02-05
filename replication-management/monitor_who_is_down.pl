#!/usr/bin/perl

#Script:   		This script monitors if there are any distributors down
#Jun 26 2006	Amer Khan       Originally created
#Jan 01 2020	Rafael Bahia	Changed it to check if database is undergoing load or being materialized before alerting
#								Script will now send one alert per agent down

use Sys::Hostname;
use strict;
use warnings;
use Getopt::Long qw(GetOptions);

my $mail = 'CANPARDatabaseAdministratorsStaffList';
my $finTime = localtime();

GetOptions(
    'to|r=s' => \$mail
) or die "Usage: $0 --to|r rleandro \n";

my $error = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -Shqvsybrep3 -b <<EOF 2>&1 | grep "(1)"
admin who_is_down
go
exit
EOF
`;

if($error =~ /Msg/)
{
print $error . "\n";
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: ERROR - monitor_who_is_down.pl script.
$error
EOF
`;
}

# print "$error\n";

if($error =~ /Down|Suspended/i && $error =~ /DSI EXEC/){

my @results="";
@results = split(/\n/,$error);

for (my $i=0; $i <= $#results; $i++){
	my @vec = split(/\)/,$results[$i]);
	my @vec2 = split(/\./,$vec[1]);
	my $sds = $vec2[0];
	my $db = $vec2[1];
	$sds =~ s/^\s+//g;
	
	if ($sds =~ /CPDB4/) {next;} #comment this once CPDB4 comes back online
	
# print "Data source: $sds. Database $db\n";	

my $check = `. /opt/sybase/SYBASE.sh
isql -Shqvsybrep3_erssd -Uhqvsybrep3_RSSD_maint -w900 -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -b -n <<EOF 2>&1
set nocount on
go
select materializing
from rs_databases d inner join rs_subscriptions s on d.dbid=s.dbid ,
where d.dbname not like 'hqvsyb%' and d.dbname not like '%_iq_%'
and dsname='$sds'
and dbname='$db'
and materializing=0
go
exit
EOF
`;

if($check =~ /Msg/)
{
print $check . "\n";
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: ERROR - monitor_who_is_down.pl script.
$check
EOF
`;
}

$check =~ s/\t//g;
$check =~ s/.*affected.*//g;
$check =~ s/\s//g;

# print $check."\n";

if ($check != 1){

my $checkload = `. /opt/sybase/SYBASE.sh
isql -S$sds -Usa -w900 -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -b -n <<EOF 2>&1
set nocount on
go
select count(*)
from master..sysprocesses
where cmd='LOAD DATABASE'
and status<>'recv sleep'
go
exit
EOF
`;

$checkload =~ s/\t//g;
$checkload =~ s/.*affected.*//g;
$checkload =~ s/\s//g;

if ($checkload == 0){

print "$results[$i]\n";
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: hqvsybrep3 -- Who Is Down Alert -- \`date\`
Content-Type: text/html
MIME-Version: 1.0

<p>$results[$i]</p>

<p>resume connection to $sds.$db execute transaction</p>

EOF
`;
}
}
}
}