#!/usr/bin/perl -w

#Script:   	Script to monitor memory utilization in the server. If there is memory pressure, a restart of replication server might be necessary to release the
#			inactive portion.
#
#Author:   	Rafael Leandro
#Date           Name            Description
#Aug 08 2019    Rafael Leandro  Originally created


use Sys::Hostname;
use strict;
use warnings;
use Getopt::Long qw(GetOptions);

my $mail = 'CANPARDatabaseAdministratorsStaffList';
my $tmem=2000;
my $skipcheckprod=0;

GetOptions(
    'skipcheckprod|s=s' => \$skipcheckprod,
	'to|r=s' => \$mail,
	'threshold|t=i' => \$tmem
) or die "Usage: $0 --skipcheckprod|s 0 --to|r rleandro --threshold|t 100000\n";

my $freemem=`free -m | grep "Mem:" | grep -v grep | awk '{print \$7}'`;

#print $freemem;

if ($freemem < 500){
`/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com
Subject: SRS Memory utilization Alert

Memory on hqvsybrep3 is under pressure. Consider restarting the replication server if you get repeated alerts about failed rs_tickets and/or detect hanged sessions (with unchanged 'awaiting commands' status) at the replicate databases on the secondary servers.

To issue a rs_ticket manually, run the script healthCheck.pl located at /opt/sybase/cron_scripts.

Script name: $0. Current threshold: $tmem.
EOF
`;
}