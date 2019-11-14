use master
go
exec dbo.rp_kill_db_processes 'Hub_db'
go
exec sp_dboption Hub_db, single, true
go
use Hub_db checkpoint 
go
sp_renamedb Hub_db, hub_db
go
use master exec sp_dboption hub_db, single, false 
go
use hub_db checkpoint
go
select * from master..sysdatabases where status & 1024 = 1024
go
