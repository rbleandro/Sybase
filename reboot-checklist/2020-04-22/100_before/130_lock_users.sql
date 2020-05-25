use dba
go
if object_id('dba.dbo.lockedlogins') is not null
	drop table dbo.lockedlogins
go

use master
go
--0.  save the currently locked logins. We'll need to lock them again after the upgrade
select name 
into dba..lockedlogins 
from master..syslogins 
where status & 2 = 2
go --28 record(s) affected on 2019-05-16 16:01:41

--1.  locks all accounts to prevent changes to any databases
exec sp_locklogin NULL, "lock", sa_role
go