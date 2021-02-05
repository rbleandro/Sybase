#!/usr/bin/perl

#Script:   CPSYBREP2 Server Heart Beat Monitor
#
#Date			Name            Description
#NoOneKnows		Ahsan ahmed     Modified sendmail to send server up & down
#April 7 2020	Rafael			Cleaned up unused code and added automatic restart logic. Improved the mail alert message.

use strict;
use warnings;

my $ASIQINITSRVCNT="";
#Setting Time range to scan
my $currDate=((localtime())[5]+1900)."/".sprintf('%02d',((localtime())[4]+1))."/".sprintf('%02d',((localtime())[3]));
my $currHour=sprintf('%02d',((localtime())[2]));
my $currMin =sprintf('%02d',((localtime())[1])); #Subtract one to check the past minute

#Check if the server is still up
my $isServerUp =`ps -ef|grep sybase|grep repserver|grep hqvsybrep3|grep -v sh|grep -v grep`;
if($isServerUp){
   #print "server is running \n";
   $ASIQINITSRVCNT = `cat /tmp/repsrvcnt`;
   if ($ASIQINITSRVCNT != 0){
   print "Sending mail for server up\n";
   `/usr/sbin/sendmail -t -i <<EOF
To: CANPARDatabaseAdministratorsStaffList\@canpar.com,CANPARDBASybaseMobileAlerts\@canpar.com
Subject: REP SERVER ON sybrep3 IS BACKUP NOW!!!

\*\*\*\!\!\!Server Is Back Up Now\!\!\!\*\*\*

Dated: $currDate\--$currHour\:$currMin
EOF
`;

}

`echo 0 > /tmp/repsrvcnt`;

}else{
#print "Attempting to restart the server...\n";
#$ASIQINITSRVCNT = `cat /tmp/repsrvcnt`;  # ASA INITial SRV CNT
#if ($ASIQINITSRVCNT == 2 ){
#   print "!!!Not notifying any one, but Replication Server Is STILL Down!!!\n";
#}
#else{
system("/opt/sybase/REP-15_5/install/RUN_hqvsybrep3 &");
my $check = `ps -ef|grep sybase|grep repserver|grep hqvsybrep3|grep -v sh|grep -v grep`;
my $msg ="";

if ($check){
$msg = "A succesfull attempt to restart the server was initiated automatically. For more information about what caused the initial shutdown check the logs below.\n";
}else{
$msg = "A unsuccesfull attempt to restart the server was made automatically. Please check ASAP. For more information about what caused the initial shutdown check the logs below.\n";
}

print "Sending mail for server down\n";
$ASIQINITSRVCNT = $ASIQINITSRVCNT + 1;
`echo $ASIQINITSRVCNT > /tmp/repsrvcnt`;
print "\n\n***!!!REP Server Is Down...!!!***\n\n";

`/usr/sbin/sendmail -t -i <<EOF
To: CANPARDatabaseAdministratorsStaffList\@canpar.com,CANPARDBASybaseMobileAlerts\@canpar.com
Subject: REP SERVER ON sybrep3 IS DOWN!!!

Replication Server Is Down!!! $msg

To check the server state: ps -ef|grep sybase|grep repserver|grep hqvsybrep3|grep -v sh|grep -v grep

Replication server log: tail -n50 /opt/sybase/REP-15_5/install/hqvsybrep3.log
RHEL log (you might have to check previously dated log files): sudo tail -n50 /var/log/messages

Dated: $currDate\--$currHour\:$currMin

Script name: $0.
EOF
`;

#}
}
