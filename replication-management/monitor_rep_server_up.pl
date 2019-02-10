#!/usr/bin/perl

###################################################################################
#Script:   CPSYBREP2 Server Heart Beat Monitor                                    #
#                                                                                 #
#Author:   Ahsan ahmed                                                            #
#Revision:                                                                        #
#Date           Name            Description                                       #
#                               Modified sendmail to send server up & down        #
#                                                                                 #
###################################################################################

#Setting Time range to scan
$currDate=((localtime())[5]+1900)."/".sprintf('%02d',((localtime())[4]+1))."/".sprintf('%02d',((localtime())[3]));
$currHour=sprintf('%02d',((localtime())[2]));
$currMin =sprintf('%02d',((localtime())[1])); #Subtract one to check the past minute

#Check if the server is still up
$isServerUp =`ps -ef|grep sybase|grep repserver|grep hqvsybrep3|grep -v sh|grep -v grep`;
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
   print "Attempting to restart the server...\n";
   $ASIQINITSRVCNT = `cat /tmp/repsrvcnt`;  # ASA INITial SRV CNT
   if ($ASIQINITSRVCNT == 2 ){
      print "!!!Not notifying any one, but Replication Server Is STILL Down!!!\n";
   }else{
      print "Sending mail for server down\n";
      $ASIQINITSRVCNT = $ASIQINITSRVCNT + 1;
      `echo $ASIQINITSRVCNT > /tmp/repsrvcnt`;
      print "\n\n***!!!REP Server Is Down...!!!***\n\n";
      `/usr/sbin/sendmail -t -i <<EOF
To: CANPARDatabaseAdministratorsStaffList\@canpar.com,CANPARDBASybaseMobileAlerts\@canpar.com
Subject: REP SERVER ON sybrep3 IS DOWN!!!

\*\*\*\!\!\!Server Is Down\!\!\!\*\*\*

Dated: $currDate\--$currHour\:$currMin
EOF
`;

   }
}
