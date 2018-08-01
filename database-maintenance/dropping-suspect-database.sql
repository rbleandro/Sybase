exec sp_configure "allow updates", 1
go

use master
go

update sysdatabases
set status = 320
where 1=1 --status & 256 = 256
and name = 'canshipws'
go

exec sp_configure "allow updates", 0
go

commit transaction
go

dbcc dbrepair('canshipws',dropdb)
