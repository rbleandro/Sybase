#!/usr/bin/perl

#Script:   This script monitors if there are any replication agents down for the primary data source
#Date           Name            Description
#May 25 2020	Rafael Bahia	Originally created

use Sys::Hostname;
use strict;
use warnings;
use Getopt::Long qw(GetOptions);

my $mail = 'CANPARDatabaseAdministratorsStaffList';
my $finTime = localtime();

GetOptions(
    'to|r=s' => \$mail
) or die "Usage: $0 --to|r rleandro \n";

my $sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -Shqvsybrep3 -b <<EOF 2>&1
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
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: Errors occured when running monitor_who_is_down.pl (get primary replication server phase)
$sqlError
EOF
`;
die;
}

$sqlError =~ s/Gateway connection.*//g;
$sqlError =~ s/.*row affected.*//g;
$sqlError =~ s/\s+//g;
$sqlError =~ s/\n//g;

#die $sqlError;

my $error = `. /opt/sybase/SYBASE.sh
isql -Usa -w200 -P\`/opt/sybase/cron_scripts/getpass.pl sa\` -Shqvsybrep3 -b <<EOF 2>&1 | grep "$sqlError"
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
Subject: ERROR - monitor_who_is_down.pl script (run admin who_is_down phase).
$error
EOF
`;
}

$error =~ s/^\s+//g;
#$error =~ s/\n//g;
#die "$sqlError\n\n$error\n";

if($error =~ /Down/ ){
	
my $htmlmail="<html>
<head>
<title>Sybase threshold missing alert</title>
<style>
table {
  border-collapse: collapse;
}
table, th, td {
  border: 1px solid black;
}
td {
  padding: 5px;
  text-align: left;
}
th {
  background-color: #99bfac;
  color: white;
  padding: 5px;
  text-align: center;
}
</style>
</head>
<body>
<p>There are replication agents down in the replication server. This can cause database log bloat if not solved asap. Run the command below to start the agent in the primary data source.<br>
<br>
Example:<br>
<br>
exec dba..sp_start_rep_agent dba<br>
go<br>
</p>
<p><b>$error</b></p></body></html>";

#my @results="";
#@results = split(/\n/,$error);
#for (my $i=0; $i <= $#results; $i++){
#	my @vec = split(/Down/,$results[$i]);
#	my @vec2 = split(/\./,$vec[1]);
#	my $sds = $vec2[0];
#	my $db = $vec2[1];

`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: hqvsybrep3 -- Replication Agent Down Alert 
Content-Type: text/html
MIME-Version: 1.0

$htmlmail

Script name: $0.

EOF
`;
}else{
print "No agents down found at this time ". $finTime."\n";	
}