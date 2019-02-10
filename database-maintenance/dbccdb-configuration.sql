use master
go
exec sp_plan_dbccdb -- run this to get the values for setting up dbccdb. You will need to use these values later in the commands below
go

use master
go
if exists (select * from master.dbo.sysdatabases
where name = "dbccdb")
begin
print "+++ Dropping the dbccdb database"
drop database dbccdb
end
go

--use master
--go
--disk init
--name = "dbccdb_dat",
--physname = "/remote/disks/masters/",
--size = "4096"
--go
--disk init
--name = "dbccdb_log",
--physname = "/remote/disks/masters/",
--size = "1024"
--go

use master
go
create database dbccdb on dev30 = 73544 log on log4 = 23 --create the database in case it is not created already
go
alter database dbccdb on dev30=7000
go

use dbccdb
go
sp_addsegment scanseg, dbccdb, dev30 -- adding segment for the scan workspace
go
sp_addsegment textseg, dbccdb, dev30 -- adding segment for the text workspace
go

isql -Usa -i/opt/sap/ASE-16_0/scripts/installdbccdb -- run this shell script to install dbcc database

use dbccdb
go
sp_dbcc_createws dbccdb, scanseg, scan_lmscan, scan, "28543M" -- use the value returned from sp_plan_dbccdb
go
sp_dbcc_createws dbccdb, textseg, text_lmscan, text, "7136M" -- use the value returned from sp_plan_dbccdb
go

sp_dbcc_updateconfig canada_post, "max worker processes", "2" --run this to change dbcc configurations for a given db
go
sp_configure "number of worker processes", 20 --run this to enable dbcc commands to run in parallel according to the output of sp_plan_dbccdb
go
sp_configure "max parallel degree" -- check this to properly config the parameter 'number of worker processes'. The general formula is: [max parallel degree] X [the number of concurrent connections wanting to run queries in parallel] X [1.5]
go

/******************************** Use this session below in case you need to set up a named cache for dbcc commands
--exec sp_cacheconfig dbcc_cache, "7136M"
--go
--exec sp_bindcache dbcc_db
--go

exec sp_cacheconfig
go
exec sp_helpcache
go
use master
go
exec sp_helpconfig 'memory' --check the memory configurations
go
***************************************/ 
-- run command below to check the space used by dbccdb database
select db_name(d.dbid) as db_name
,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) as data_size_MB
,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then convert(bigint,size) - curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end)/1048576.*@@maxpagesize) as data_used_MB
--ceiling(100 * (1 - 1.0 * sum(case when u.segmap != 4 and vdevno >= 0 then curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end) / sum(case when u.segmap != 4 then u.size end))) as data_used_pct,
,ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) as log_size_MB
,ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end) - lct_admin("logsegment_freepages",d.dbid)/1048576.*@@maxpagesize) as log_used_MB
--ceiling(100 * (1 - 1.0 * lct_admin("logsegment_freepages",d.dbid) / sum(case when u.segmap in (4, 7) and vdevno >= 0 then u.size end))) as log_used_pct 
,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) - ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then convert(bigint,size) - curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end)/1048576.*@@maxpagesize) as UnusedDataSpace_MB
,ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) - ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end) - lct_admin("logsegment_freepages",d.dbid)/1048576.*@@maxpagesize) as UnusedLogSpace_MB
,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) + ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) as TotalDatabaseSpace_MB
--,d.dbid,u.*
from master..sysdatabases d, master..sysusages u
where u.dbid = d.dbid  and d.status != 256
--and u.dbid=(select dbid from master..sysdatabases where dbid=db_id()) and u.segmap % (select segment from syssegments where name ='image_seg') = 0
and u.dbid=db_id('dbccdb')
group by d.dbid
--order by TotalDatabaseSpace_MB desc
go

