CREATE or replace proc rp_kill_db_processes
(@dbname varchar(20))
as

Declare @dbid int,
@spid int,
@str nvarchar(128)

select @dbid = dbid from master..sysdatabases
where name = @dbname

declare spidcurs cursor for
select spid from master..sysprocesses where dbid = @dbid
open spidcurs
fetch next from spidcurs into @spid
While @@fetch_status = 0
Begin

Select @str = 'Kill '+convert(nvarchar(30),@spid)
exec(@str)
--print @str

fetch next from spidcurs into @spid
End
Deallocate spidcurs
GO

exec rp_kill_db_processes 'svp_lm'
go