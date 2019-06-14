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