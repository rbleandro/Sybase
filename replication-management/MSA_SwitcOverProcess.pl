#!/usr/bin/perl -w

my $PRI = 'CPDB2';
my $SEC = 'CPDB1';

print "\nWhat is your current Primary Server? (default: $PRI)...Hit Enter for default or enter new server name now: ";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ $PRI = $user_input; }

print "Current Primary Server: $PRI\n";

print "\nWhat is your current Secondary Server? (default: $SEC)...Hit Enter for default or enter new server name now: ";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ $SEC = $user_input; }

print "Current Secondary Server: $SEC\n";

print "\n******> Switching Current Primary $PRI to New Primary $SEC... <****** \n";

print "\nIs this correct? Hit Enter for default or enter no now: ";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ die "Stopping at request \n"; }


open (INFILE,"<./databases.list") || print "cannot open: $!\n";
while (<INFILE>){  
  $_ =~ s/\n//;
  my $database = $_;
  print "==========================>>>>>>>>>>>>>>>>> Initiating SwitchOver for $database\n";

my $sqlError="";
print "Checking if data is in sync...\n\n";
print "Checking Current Primary Server ...\n";
$sqlError=`. /opt/sybase/SYBASE.sh
isql -Usa -P -w300 -e  <<EOF 2>&1
admin who,sqm,$PRI,$database
go
EOF
`;
#print "$sqlError \n*\n*\n*\n";

my @syncCheck = split('\n',$sqlError);

#print "$syncCheck[6] \n";
print "Outbound Block Check....\n";
$syncCheck[6] =~ s/^\s+//g;
$syncCheck[6] =~ s/\s+/ /g;
$syncCheck[6] =~ s/\s/|/g;
#print "$syncCheck[6] \n";

my @outCheck = split ('\|',$syncCheck[6]);
print "First Block is: $outCheck[1] \n";
print "Last  Block is: $outCheck[2] \n"; 

#print "\n $syncCheck[8] \n";
print "Inbound Block Check....\n";
$syncCheck[8] =~ s/^\s+//g;
$syncCheck[8] =~ s/\s+/ /g;
$syncCheck[8] =~ s/\s/|/g;
#print "$syncCheck[8] \n";

my @inCheck = split ('\|',$syncCheck[8]);
print "First Block is: $inCheck[1] \n";
print "Last  Block is: $inCheck[2] \n";

print "\nReview Segment Blocks...Should I proceed...?(Hit Enter to proceed, n to stop):";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ die "Stopping at request \n";}

############===========================================


print "Checking Current Secondary Server ...\n";
$sqlError=`. /opt/sybase/SYBASE.sh
isql -Usa -P -w300 -e  <<EOF 2>&1
admin who,sqm,$SEC,$database
go
EOF
`;
#print "$sqlError \n*\n*\n*\n";

@syncCheck = split('\n',$sqlError);

#print "$syncCheck[6] \n";
print "Outbound Block Check....\n";
$syncCheck[6] =~ s/^\s+//g;
$syncCheck[6] =~ s/\s+/ /g;
$syncCheck[6] =~ s/\s/|/g;
#print "$syncCheck[6] \n";

@outCheck = split ('\|',$syncCheck[6]);
print "First Block is: $outCheck[1] \n";
print "Last  Block is: $outCheck[2] \n";

#print "\n $syncCheck[8] \n";
print "Inbound Block Check....\n";
$syncCheck[8] =~ s/^\s+//g;
$syncCheck[8] =~ s/\s+/ /g;
$syncCheck[8] =~ s/\s/|/g;
#print "$syncCheck[8] \n";

@inCheck = split ('\|',$syncCheck[8]);
print "First Block is: $inCheck[1] \n";
print "Last  Block is: $inCheck[2] \n";

print "\nReview Segment Blocks...Should I proceed...?(Hit Enter to proceed, n to stop):";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ die "Stopping at request \n";}

# Following next is for testing only!!
#next;
##################################################################

############===========================================

print "\n Dropping subscription for $database from current PRI...\n\n"; 
$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -P -w300 -e <<EOF 2>&1
drop subscription $database\_dbsub
for database replication definition $database\_dbrep
with primary at $PRI.$database
with replicate at $SEC.$database
without purge
go
EOF
`;
print "\n\n$sqlError\n\n";


#Check if subscription has been dropped...
#Sometime it could delayed, due to other activities in the SRS
while(1==1){
  $sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -P -w300 -e <<EOF 2>&1
check database subscription $database\_dbsub,$SEC,$database
go
exit
EOF
`;
#print "$sqlError \n";

  #Check if any errors or we can proceed with the next step...
  if ($sqlError =~ /doesn\'t exist/i){
    print "\n\n$database\_dbsub has been successfully dropped, proceeding ...\n\n";
    sleep(1);
    last;
  }
}

#Following next is for testing only!!
next;
##################################################################

#--3. Stop replication agent on PRImary db

$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -P -S$PRI -w300 -e <<EOF 2>&1
use $database
go
sp_stop_rep_agent $database
go
waitfor delay '00:00:03'
go
-- Running twice to make sure it has stopped
sp_stop_rep_agent $database
go
EOF
`;
print "\n\n$sqlError\n\n";

print "\nReview Replication Agent Status in Current Primary...Should I proceed...?(Hit Enter to proceed, n to stop):";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ die "Stopping at request \n";}

## Stopping or attempting to stop RepAgent in Secondary, just in case if it is running...
#
$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -P -S$SEC -w300 -e <<EOF 2>&1
use $database
go
sp_stop_rep_agent $database
go
waitfor delay '00:00:03'
go
-- Running twice to make sure it has stopped
sp_stop_rep_agent $database
go
EOF
`;
print "\n\n$sqlError\n\n";

print "\nReview Replication Agent Status in Current Secondary...Should I proceed...?(Hit Enter to proceed, n to stop):";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ die "Stopping at request \n";}

#--4. Remove truncation marker from PRIM

$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -P -S$PRI -w300 -e <<EOF 2>&1
use $database
go
dbcc settrunc(ltm,ignore)
go
EOF
`;
print "\n\n$sqlError\n\n";

print "\nReview Removing Sec Truncation Marker in Current Primary...Should I proceed...?(Hit Enter to proceed, n to stop):";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ die "Stopping at request \n";}

#--5. Remove and then Set Secondary Truncation Point for SECO 

$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -P -S$SEC -w300 -e <<EOF 2>&1
use $database
go
dbcc settrunc(ltm,ignore)
go
dbcc settrunc(ltm,valid)
go
EOF
`;
print "\n\n$sqlError\n\n";

print "\nReview Removing/Setting Sec Truncation Marker in Current SECondary...Should I proceed...?(Hit Enter to proceed, n to stop):";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ die "Stopping at request \n";}

#--7. Reset zeroltm for SECO in SRS

$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -P -w300 -e <<EOF 2>&1
connect to rssd
go
rs_zeroltm $SEC,$database
go
EOF
`;
print "\n\n$sqlError\n\n";

print "\nReview Reset zeroltm for SECO in SRS...Should I proceed...?(Hit Enter to proceed, n to stop):";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ die "Stopping at request \n";}

#--8. Start replication agent on SECO

$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -P -S$SEC -w300 -e <<EOF 2>&1
use $database
go
sp_start_rep_agent $database
go
exit
EOF
`;
print "\n\n$sqlError\n\n";

print "\nReview Start replication agent in Current SECondary...Should I proceed...?(Hit Enter to proceed, n to stop):";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ die "Stopping at request \n";}

#--9. create the db rep def for the new primary

$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -P -w300 -e <<EOF 2>&1
create database replication definition $database\_dbrep
with primary at $SEC.$database
replicate DDL
replicate system procedures
go
exit
EOF
`;
print "\n\n$sqlError\n\n";

print "\nReview create the db rep def for the new primary in SRS...Should I proceed...?(Hit Enter to proceed, n to stop):";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ die "Stopping at request \n";}


#--10. create the subscription for db repdef for the new PDB, without materialization, since all DML/DDL is locked

$sqlError = `. /opt/sybase/SYBASE.sh
isql -Usa -P -w300 -e <<EOF 2>&1
create subscription $database\_dbsub
for database replication definition $database\_dbrep
with primary at $SEC.$database
with replicate at $PRI.$database
without materialization
subscribe to truncate table
go
exit
EOF
`;
print "\n\n$sqlError\n\n";

print "\nReview create the subscription for the new primary in SRS...Should I proceed...?(Hit Enter to proceed, n to stop):";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ die "Stopping at request \n";}



print "\n\n !! $database has been setup for replication successfully !! \n\n";
}#eof while loop

