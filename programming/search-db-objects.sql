declare spidcurs cursor for
select name from master..sysdatabases where status2 !=-32768 and name not like 'tempdb%' and name not in ('sybsecurity','dba')
go
Declare @dbname varchar(50),@str0 varchar(4000),@object varchar(1000)
set @object='process_db_record'
set @str0=""
open spidcurs
fetch next from spidcurs into @dbname
While @@fetch_status = 0
Begin

set @str0 = @str0 + "select '"+@dbname+"',* from "+@dbname+"..sysobjects where 1=1 and name like '%"+@object+"%' 
union
"

--select @str0
--set @str0=''

fetch next from spidcurs into @dbname
End
set @str0 = @str0 + "select 'master',* from master..sysobjects where 1=2"
--select @str0
exec(@str0)
go
Deallocate spidcurs
go

