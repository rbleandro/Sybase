use master
go

--extracts information on server logins
select crdate,name ,pwdate, case when status & 2 =2 then 'Locked' else 'Non-Locked' end as status
from syslogins
where crdate is not null
order by name
go

--extracts the user databases
select * from sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs')
and name not like 'tempdb%'

go

/********************** run the cursor below to generate the query that extracts permissions for all users for all databases  ******************/
declare spidcurs cursor for
select name from master..sysdatabases where status2 !=-32768 and name not like 'tempdb%' and name not in ('sybsecurity','dba')
go
Declare @dbname varchar(50),@str0 varchar(4000),@object varchar(1000)
set @object='tempdb1'
set @str0=""
open spidcurs
fetch next from spidcurs into @dbname
While @@fetch_status = 0
Begin

set @str0 = @str0 + "select '"+@dbname+"' as db,name,'CPDB1' as serv from "+@dbname+"..sysusers where 1=1 
union
"

--select @str0
--set @str0=''

fetch next from spidcurs into @dbname
End
set @str0 = @str0 + "select 'master',name,'CPDB1' as serv from master..sysusers where 1=2"
select @str0
--exec(@str0)
go
Deallocate spidcurs
go
/************************************************************************************************************************************************/


/********************** run the cursor below to generate the query that extracts permissions for all users for all databases  ******************/
declare spidcurs cursor for
select name from master..sysdatabases where status2 !=-32768 and name not like 'tempdb%' and name not in ('sybsecurity','dba')
go
Declare @dbname varchar(50),@str0 text
set @str0=""
open spidcurs
fetch next from spidcurs into @dbname
While @@fetch_status = 0
Begin

set @str0 = @str0 + "select distinct u.name as username, case suid when -2 then 'YES' else 'NO' end as is_group,'"+@dbname+"' as db,o.name as object_name,v.name as permission from "+@dbname+"..sysprotects p, master.dbo.spt_values v, "+@dbname+"..sysusers u , "+@dbname+"..sysobjects o where p.uid=u.uid and p.action=v.number and p.protecttype=1 and v.type = 'T' and u.name!= 'dbo' and p.id = o.id
union
"

fetch next from spidcurs into @dbname
End
set @str0 = @str0 + "select '' as username, case suid when -2 then 'YES' else 'NO' end as is_group,'master' as db,'','' as serv from master..sysusers where 1=2 
order by 1,2"
select @str0
--exec(@str0)
go
Deallocate spidcurs
go
/************************************************************************************************************************************************/
