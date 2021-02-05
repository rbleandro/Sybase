#!/usr/bin/perl -w

####################################################################################################################################################################
#Script:   This script monitors sybase server errorlog for critical and fatal     
#          errors. It is designed to run every minute and scan the errorlog and   
#          send messages when errors are found. It also monitors whether the      
#          $server server and Backup server is up                                 
#                                                                                 
#Author:   		Amer Khan                                                              
#Revision:                                                                        
#Date           Name            Description                                       
#---------------------------------------------------------------------------------
#01/07/04       Amer Khan       Originally created                                
#                                                                                 
#02/23/06      	Ahsan Ahmed     Modified for email to DBA's and documentation
#July 26 2019	Rafael Leandro	Installed missing Perl modules. Removed redundant emails. Reviewed search keywords.
####################################################################################################################################################################

use Date::Calc qw(Today_and_Now Delta_YMDHMS Add_Delta_YMDHMS Delta_DHMS Date_to_Text);

#Usage Restrictions
if ($#ARGV != 0){
   print "Usage: monitor_errorlog.pl $server \n";
   die "Script Executed With Wrong Number Of Arguments\n";
}

#Saving argument
$server = $ARGV[0];

open(ERRORLOG,"</opt/sybase/REP-15_5/install/$server.log") or die "Can't open the file /opt/sybase/REP-15_5/install/$server.log: $!\n\n";

#Setting Time range to scan
$currDate=((localtime())[5]+1900)."/".sprintf('%02d',((localtime())[4]+1))."/".sprintf('%02d',((localtime())[3]));
$currYear=sprintf('%02d',((localtime())[5]+1900));
$currMonth=sprintf('%02d',((localtime())[4]+1));
$currDay=sprintf('%02d',((localtime())[3]));
$currHour=sprintf('%02d',((localtime())[2]));
$currMin =sprintf('%02d',((localtime())[1]-1)); #Subtract one to check the past minute
$currSec =sprintf('%02d',((localtime())[0]-1));

use Date::Calc qw(Today_and_Now Delta_YMDHMS Add_Delta_YMDHMS Delta_DHMS Date_to_Text);

my $today = [Today_and_Now()];
my @target = split(/,/,`cat /opt/sybase/cron_scripts/lastErrorStamp`); #[2019,7,26,0,0,0];
my $target = [@target];

my $delta = Normalize_Delta_YMDHMS($today,$target);
  
print "$delta->[3]\n";

$echoOut=`echo "$currYear,$currMonth,$currDay,$currHour,0,0" > /opt/sybase/cron_scripts/lastErrorStamp`;

print "Echo error: $echoOut \n";

#what if the minute is 00, the result would be -1 instead of 59, correcting that
if($currMin == "-1"){
   $currMin = "59";
}

print "Errorlog Checked: $currDate\ $currHour\:$currMin\:$currSec \n";
#CANPARDatabaseAdministratorsStaffList
my $mail="CANPARDatabaseAdministratorsStaffList";

#Scanning the errorlog...
$getNextLine = 0;
$tooManyErrors = 0;
while (<ERRORLOG>){
   if($getNextLine == 1){
      $tooManyErrors += 1;
      $secondLine = $_;
      print "$firstLine$secondLine\n";
      if(($tooManyErrors < 5 ) && ($firstLine !~ /Deadlock/ || $firstLine !~ /IGNORE/i || $firstLine !~ /WARN/i || $firstLine !~ /Ambiguous/ || $secondLine !~ /IGNORE/i || $secondLine !~ /WARN/i) && ($firstLine !~ /WARNING #5185/ && $secondLine !~ /WARNING #5185/) && ($firstLine !~ /WARNING #24068/ && $secondLine !~ /WARNING #24068/) && ($firstLine !~ /Message: 1708/ && $secondLine !~ /Message: 1708/)){
      `/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com,CANPARDBASybaseMobileAlerts\@canpar.com
Subject: $server SRS Error Alert

Errors Found In $server Errorlog!!!
$firstLine$secondLine
EOF
`;
print "*********\nMail Sent To the DBA team\n*********\n";
      }else{
         if($tooManyErrors == 5){
         `/usr/sbin/sendmail -t -i <<EOF
To: $mail\@canpar.com,CANPARDBASybaseMobileAlerts\@canpar.com
Subject: $server SRS Error Alert

Errors Found In $server Errorlog!!!
!!!!!!!!!!!!Too Many Errors Logged At $currDate\--$currHour\:$currMin!!!!!!!!!!!!!!!!!
EOF
`;
print "*********\nMail Sent To DBAs\n*********\n";
         }
      }
      $getNextLine = 0;
      next;
   }
   if(/$currDate/){
      if (/$currHour\:$currMin\:/){
         #if((/ERROR/ || /SQM_ADD_SEGMENT/ || /cease/ || /Loss detected/ || /sleeping/i || /critically/i || /failed/i || /degradation/i || /deadlock/i || /stack trace/i || /fatal/i || /WARNING/i))
		 if((/SQM_ADD_SEGMENT/ || /cease/ || /Loss detected/ || /sleeping/i || /critically/i || /degradation/i || /deadlock/i || /stack trace/i || /WARNING/i || /skipped/i))
		 {
			$firstLine = $_;
            $getNextLine = 1;
         }
      }
   }
}

close ERRORLOG;

######  Following is needed to fix seconds, minutes, hours
sub Normalize_Delta_YMDHMS
  {
      my($date1,$date2) = @_;
      my(@delta);

      @delta = Delta_YMDHMS(@$date1,@$date2);
      while ($delta[1] < 0 or
             $delta[2] < 0 or
             $delta[3] < 0 or
             $delta[4] < 0 or
             $delta[5] < 0)
      {
          if ($delta[1] < 0) { $delta[0]--; $delta[1] += 12; }
          if ($delta[2] < 0)
          {
              $delta[1]--;
              @delta[2..5] = (0,0,0,0);
              @delta[2..5] = Delta_DHMS(Add_Delta_YMDHMS(@$date1,@delta),@$date2);
          }
          if ($delta[3] < 0) { $delta[2]--; $delta[3] += 24; }
          if ($delta[4] < 0) { $delta[3]--; $delta[4] += 60; }
          if ($delta[5] < 0) { $delta[4]--; $delta[5] += 60; }
      }
      return \@delta;
}

