#!/usr/bin/perl -w

my $PRI = 'CPDB1';
my $SEC = 'CPDB2';

print "\nWhat is your old Primary Server? (default: $PRI)...Hit Enter for default or enter new server name now: ";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ $PRI = $user_input; }

print "Current Primary Server: $PRI\n";

print "\n******> So Dropping Subs from $PRI ... <****** \n";

print "\nIs this correct? Hit Enter for default or enter no now: ";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";}else{ die "Stopping at request \n"; }


open (INFILE,"<./tables.list") || print "cannot open: $!\n";
while (<INFILE>){  
  $_ =~ s/\n//;
  my $table = $_;
  print "\n==========================>>>>>>>>>>>>>>>>> Dropping Subscription For $table\n";

my $sqlError="";
$sqlError=`. /opt/sybase/SYBASE.sh
isql -Usa -P -w300 <<EOF 2>&1
connect to rssd
go
select dbname from rs_subscriptions s, rs_databases d
where subname = '$PRI\_iq\_$table\_sub'
and s.dbid = d.dbid
go
EOF
`;
#print "$sqlError \n";

my @syncCheck = split('\n',$sqlError);

#print "$syncCheck[3] \n";
if ($syncCheck[3] eq ''){
print "\nI did not get any connection info.\nIs subscription name correct or it does not exist anymore - $PRI\_iq\_$table\_sub ?\nHit enter to skip and go to next one or enter no to abort: ";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";next;}else{ die "Stopping at request \n"; }
}

$syncCheck[3] =~ s/^\s+//g;
$syncCheck[3] =~ s/\s+/ /g;
$syncCheck[3] =~ s/\s//g;
#print "$syncCheck[3] \n";

#Constructing drop sub command and execute it
$sqlError=`. /opt/sybase/SYBASE.sh
isql -Usa -P -w300 -e  <<EOF 2>&1
drop subscription $PRI\_iq\_$table\_sub
for $PRI\_iq\_$table\_rep
with replicate at CPIQ2.$syncCheck[3]
without purge
go
EOF
`;
#print "$sqlError \n*\n*\n*\n";

sleep(2); #wait few secs

#Running second time to make sure it has been dropped successfully

$sqlError=`. /opt/sybase/SYBASE.sh
isql -Usa -P -w300 <<EOF 2>&1
connect to rssd
go
select subname from rs_subscriptions s
where subname = '$PRI\_iq\_$table\_sub'
go
EOF
`;

#print "$sqlError \n*\n*\n*\n";

my @syncCheck = split('\n',$sqlError);

#print "$syncCheck[3] \n";
if ($syncCheck[3] eq ''){
print "Subscription Dropped - $PRI\_iq\_$table\_sub ? Proceeding to next...\n";

sleep(1);
}else{
print "*** Failure, please check log before proceeding ***\n";

print "#============================\n";
$logOutput = `tail -5 /opt/sybase/REP-15_5/install/hqvsybrep3.log`;
print $logOutput;
print "\n#===========================\n*\n*\n";

print "Hit enter to skip and go to next one or enter no to abort: ";
chomp ($user_input = <STDIN>);
if ($user_input eq ""){print "Proceeding at request\n";next;}
else{ die "Stopping at request \n"; }

}

}#eof while loop

print "\nALL DONE!!\n";
