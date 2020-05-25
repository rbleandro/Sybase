--0.  save the currently locked logins. We'll need to lock them again after the upgrade
select name into dba..lockedlogins from master..syslogins where status & 2 = 2
go --28 record(s) affected on 2019-05-16 16:01:41
--1.  locks all accounts to prevent changes to any databases 
exec sp_locklogin NULL, "lock", sa_role
go
--1.1 disable cron jobs (take note of any jobs that run during the downtime)
--1.2 disable datastage jobs (take note of any jobs that run during the downtime)
--2.  synchonize databases to standby (run command below at the production server)
/opt/sap/cron_scripts/dump_databases.pl > /opt/sap/cron_scripts/cron_logs/dump_databases.log 2>&1
go
--3.  stop ASE and SYB_BACKUP
--3.1 disable REP Server monitor jobs
--4.  run the upgrade process (first phase only)
--5.  start ASE and SYB_BACKUP and let it recover all databases (when the query below returns nothing).
select * from master..sysdatabases where status & 64 = 64
go
--6.  run the updatease utility: 
/opt/sap/ASE-16_0/bin/updatease -D/opt/sap -SCPDB2
--7.  once the utility is done and all databases are recovered, unlock the logins
exec sp_locklogin NULL, "unlock"           
go

--8.  restore the state of the previously locked logins
declare spidcurs cursor for
select name from dba..lockedlogins 
go
Declare @dbname varchar(50),@str varchar(1000)
open spidcurs
fetch next from spidcurs into @dbname
While @@fetch_status = 0
Begin
set @str = 'exec sp_locklogin '+@dbname+',"lock"'
exec(@str)
--select @str

fetch next from spidcurs into @dbname
End
Deallocate spidcurs
go

--8.1  check the number of logins locked (compare with the backup taken previously)
select * from master..syslogins where status & 2 = 2
go

--8.1 enable cron jobs 
--8.2 enable datastage jobs 
--8.3  run any jobs saved previously (see steps 1.*)

