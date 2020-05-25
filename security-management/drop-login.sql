--first get the objects owned by the login. Run this on each database
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner robbie_toyota' when 'P' then 'alter procedure '+ name + ' modify owner robbie_toyota' end as Command 
from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
go 

--run this to modify ownership
alter table cmfrates modify owner robbie_toyota
alter table cmfshipr modify owner robbie_toyota
alter table disp_cust modify owner robbie_toyota
alter table disp_route modify owner robbie_toyota
alter table disp_term modify owner robbie_toyota
alter table disp_user_regn modify owner robbie_toyota
alter table disp_users modify owner robbie_toyota
alter table tot_hs modify owner robbie_toyota
go


--GET USER AND ITS MAPPINGS INSIDE ALL DATABASES. DROP THE USER INSIDE EACH DATABASE
declare dbcurs cursor for
select name from master..sysdatabases where status2 !=-32768 --and name not like 'tempdb%' and name not in ('sybsecurity','dba')
go
Declare @dbname varchar(50), @login varchar(100),@str0 text
set @str0=""
set @login ='tech_user'
open dbcurs
fetch next from dbcurs into @dbname
While @@fetch_status = 0
Begin

set @str0 = @str0 + "select '"+@dbname+"' as db,u.name,'exec "+@dbname+"..sp_dropuser '+u.name
from "+@dbname+"..sysusers u 
LEFT JOIN master..syslogins l ON u.suid = l.suid 
LEFT JOIN "+@dbname+"..sysusers g ON u.gid = g.uid 
LEFT JOIN "+@dbname+"..sysalternates a ON u.suid = a.altsuid 
LEFT JOIN master..syslogins o ON a.suid = o.suid 
WHERE 1=1 AND u.suid != -2 AND u.uid != u.gid 
and (u.name = '"+@login+"' or l.name = '"+@login+"' or o.name = '"+@login+"')
union
"
fetch next from dbcurs into @dbname
End
set @str0 = @str0 + "select 'master',name,'sp_dropuser "+@login+"' from master..sysusers where 1=2"

exec dba.dbo.settxt @str0
go
Deallocate dbcurs
go

--finnaly drop the login
USE master
GO
DROP LOGIN dryden_zarate  --WITH OVERRIDE
GO

select * from syslogins where name in ('dryden_zarate','jesse_robinson','dbo','sa','DBA')
go
