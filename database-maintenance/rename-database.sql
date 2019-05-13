use master
go
exec dbo.rp_kill_db_processes 'rev_hist_old'
go
exec sp_dboption rev_hist_old, single, true
go
use rev_hist_old checkpoint 
go
sp_renamedb rev_hist_old, rev_hist_cubew
go
use master exec sp_dboption rev_hist_cubew, single, false 
go
use rev_hist_cubew checkpoint
go
select * from master..sysdatabases where status & 1024 = 1024
go
