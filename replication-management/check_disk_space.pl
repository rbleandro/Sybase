#!/usr/bin/perl -w
######################################################################################
#Description: 	This script will query source database for the original column
#		datatype. It is then switched to HANA datatype and passed back to 
#		calling script, which scan_ddl.pl
#
#Author:	Amer Khan
#Modified:	Jun 26 2017 - Created
######################################################################################
# Logging into RepAgent
  $sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -Ps9b2s3 -s\\| -w1000 -e <<EOF 2>&1
admin disk_space
go    
exit   
EOF
`;
# print "$sqlError \n";
#Check if any errors or we can proceed with the next table...
if ($sqlError =~ /syntax|error|not/i){
  print "$sqlError \n";
  print "\n\nError occurred in above, can not proceed: ";
  die "Stopping due to error\n";
}
# Split each row first
  @row_array = split(/\n/,$sqlError);
  my $cntr = 0; #Counter is needed to skip header, dashes.
  foreach $columns (@row_array){
     $cntr++;
     next if $cntr < 4;
#     print "Cntr: $cntr...Original $columns \n";
     last if length($columns) == 0; #First empty line means, we have processed all columns
#    print "Count: $cntr...$columns: length :".length($columns)." \n";
     #Now create the array for each row
     @columns_array = split(/\|/,$columns);
    #Remove surrounding spaces
    $columns_array[2] =~ s/\s+$//; $columns_array[4] =~ s/\s+$//; $columns_array[5] =~ s/\s+$//; $columns_array[6] =~ s/\s+$//;
#    print "Partition: $columns_array[2]...Total Space: $columns_array[4]...Use Space: $columns_array[5]\n";
    if ($columns_array[5] > 1000){
       $currDT = localtime();
       print "Stable Queue seems too high, please check \n";
       print "Partition: $columns_array[2]...Total Space: $columns_array[4]...Use Space: $columns_array[5]\n";
       $mailError = `/usr/sbin/sendmail -t -i <<EOF
To: CANPARDatabaseAdministratorsStaffList\@canpar.com
Subject: High Stable Queue Size Alert
Time Alert Sent: $currDT\n
--===============================================================\n
Partition: $columns_array[2]...Total Space: $columns_array[4]...Use Space: $columns_array[5]\n
--===============================================================\n
EOF
`;
print "\nMail result: $mailError \n";
    }#eof sqt is too high
   
  }#eof forach columns

