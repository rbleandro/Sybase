--exec sp_listsuspect_page 
--go
declare spidcurs cursor for
select name from master..sysdatabases where status2 !=-32768
go
Declare @dbname varchar(50),
@str varchar(1000),@str1 varchar(1000),@str0 varchar(1000)

set @str = 'exec master..sp_setsuspect_granularity '
set @str1 = ',"page" '

open spidcurs
fetch next from spidcurs into @dbname
While @@fetch_status = 0
Begin

Select @str0 = @str+convert(nvarchar(30),@dbname)+@str1
exec(@str0)
print @str0
set @str0=''

fetch next from spidcurs into @dbname
End
Deallocate spidcurs
go
