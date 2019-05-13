sp_tempdb "bind","lg","sa","GR","default"--one login can be bound to a group, which can be bound to a tempdb

sp_tempdb "bind","lg","sa","DB","tempdb1"-- a login can also be bound directly to a tempdb

sp_tempdb 'unbind','lg','sa' --unbinding a login 

exec sp_tempdb 'show' --shows the bindings of database groups and logins
go
exec sp_tempdb 'who',tempdb7 --shows the connections using the specified tempdb
go

-------------- CANPAR SETUP -------------

exec sp_tempdb 'show'
go
sp_tempdb "add", "tempdb1", "default"
go
sp_tempdb "add", "tempdb2", "default"
go
sp_tempdb "add", "tempdb3", "default"
go
sp_tempdb "add", "tempdb4", "default"
go
sp_tempdb "add", "tempdb6", "default"
go
sp_tempdb "add", "tempdb6", "default"
go
sp_tempdb "remove", "tempdb7", "default"
go
sp_tempdb "remove", "tempdb8", "default"
go
sp_tempdb "remove", "tempdb9", "default"
go
sp_tempdb "remove", "tempdb5", "default"
go


sp_tempdb "create","critical"
go
sp_tempdb "create","gentor"
go
sp_tempdb "create","report"
go


USE master
GO
disk init name = 'tempdb9'
	 , physname = '/opt/sap/data/tempdb9.dat'
	 , vdevno = 69
	 , size = 5242880
	 , dsync = false
GO

CREATE TEMPORARY DATABASE tempdb9 
	ON tempdb9 = 10240
GO
USE master
GO
exec sp_dboption 'tempdb9', 'trunc log on chkpt', true
GO
exec sp_dboption 'tempdb9', 'ddl in tran', true
GO
exec sp_dboption 'tempdb9', 'select into/bulkcopy/pllsort', true
GO
USE tempdb9
GO
checkpoint
GO


sp_tempdb "add", "tempdb7", "report"
go
sp_tempdb "add", "tempdb8", "report"
go
sp_tempdb "add", "tempdb9", "gentor"
go
sp_tempdb "add", "tempdb5", "critical"
go


sp_tempdb "bind", "lg", "robbie_toyota", "GR", "report"
go
sp_tempdb "bind", "lg", "crystal_reporter", "GR", "report"
go
sp_tempdb "bind", "lg", "dan_pham", "GR", "report"
go
sp_tempdb "bind", "lg", "lm_glocent_user", "GR", "critical"
go
sp_tempdb "bind", "lg", "overhead_scan_user", "GR", "gentor"
go