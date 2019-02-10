--generates the command to run sp_listsuspect_object on every database. Run this after the recovery phase for a database (after load or server restart operations)
declare spidcurs cursor for
select name from master..sysdatabases where status2 !=-32768
go
Declare @dbname varchar(50),@str varchar(1000)

open spidcurs
fetch next from spidcurs into @dbname
While @@fetch_status = 0
Begin
set @str = 'use ' +@dbname+' exec sp_listsuspect_object'
--exec(@str0)
print @str

fetch next from spidcurs into @dbname
End
Deallocate spidcurs
go
