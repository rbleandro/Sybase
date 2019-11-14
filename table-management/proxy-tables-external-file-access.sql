use master
go
exec sp_configure 'enable file access',1
go
use dba
go
if exists (select * from sysobjects where name='check_prod') exec ('drop table check_prod')
go
create proxy_table check_prod
external file
at '/opt/sap/cron_scripts/passwords/check_prod'
go

select * from  dba.dbo.check_prod where record like '%1'
go
