
USE master
GO

CREATE LOGIN cronmpr
	WITH PASSWORD 's9b2s3'
	DEFAULT DATABASE tempdb
	DEFAULT LANGUAGE us_english
	EXEMPT INACTIVE LOCK TRUE
go
grant role sa_role to cronmpr
go

--remember to update the path to the tempdb files
--For CPDB2 it is /home/sybase/data
--For CPDB1 and CPDB4 it is /opt/sap/data
declare @device int
select @device = max(vdevno)+1 from sysdevices

if @@servername='CPDB2'
	disk init name = 'tempdb_mpr', physname = '/home/sybase/data/tempdb_mpr.dat', vdevno = @device, size="30G", dsync = false
else
	disk init name = 'tempdb_mpr', physname = '/opt/sap/data/tempdb_mpr.dat', vdevno = @device, size="30G", dsync = false
GO

CREATE TEMPORARY DATABASE tempdb_mpr ON tempdb_mpr = 30000
GO
USE master
GO
exec sp_dboption 'tempdb_mpr', 'trunc log on chkpt', true
GO
exec sp_dboption 'tempdb_mpr', 'ddl in tran', true
GO
exec sp_dboption 'tempdb_mpr', 'select into/bulkcopy/pllsort', true
GO
USE tempdb_mpr
GO
checkpoint
GO

exec master..sp_tempdb "create","mpr"
go

exec master..sp_tempdb "add", "tempdb_mpr", "mpr"
go

exec master..sp_tempdb "bind","lg","cronmpr","DB","tempdb_mpr"-- a login can also be bound directly to a tempdb
go

exec master..sp_tempdb 'show'
go