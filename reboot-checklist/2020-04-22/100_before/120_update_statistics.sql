declare spidcurs cursor for
select name from master..sysdatabases where status2 & 16 != 16 order by name --excluding offline databases
go
Declare @dbname varchar(50),
@str varchar(1000),@str1 varchar(1000)

open spidcurs
fetch next from spidcurs into @dbname
While @@fetch_status = 0
Begin

--Select @str0 = @str+convert(nvarchar(30),@dbname)+@str1
set @str = 'UPDATE STATISTICS '+@dbname+'..sysindexes'
set @str1 = 'UPDATE STATISTICS '+@dbname+'..syspartitions'

--print @str
--print @str1

exec(@str)
exec(@str1)

set @str=''
set @str1=''

fetch next from spidcurs into @dbname
End
Deallocate spidcurs
go


/*********** CHECKPOINT ALL DATABASES AFTER RUNNING THE ABOVE ************/