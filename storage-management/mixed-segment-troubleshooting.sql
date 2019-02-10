--select db_name(d.dbid) as db_name,status2,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) as data_size_MB,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then convert(bigint,size) - curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end)/1048576.*@@maxpagesize) as data_used_MB,ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) as log_size_MB,ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end) - lct_admin("logsegment_freepages",d.dbid)/1048576.*@@maxpagesize) as log_used_MB,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) - ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then convert(bigint,size) - curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end)/1048576.*@@maxpagesize) as UnusedDataSpace_MB,ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) - ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end) - lct_admin("logsegment_freepages",d.dbid)/1048576.*@@maxpagesize) as UnusedLogSpace_MB,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) + ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) as TotalDatabaseSpace_MB from master..sysdatabases d, master..sysusages u where u.dbid = d.dbid and d.status & 32 != 32 and status2 < 0 and d.name not like 'tempdb%' and d.dbid between 4 and 31512 group by d.dbid order by TotalDatabaseSpace_MB asc,db_name
--go
--select distinct db_name(u.dbid) from sysusages u, sysdevices d where d.vdevno = u.vdevno and d.status & 2 = 2 and segmap = 7 and db_name(u.dbid) not like 'tempdb%' and u.dbid between 4 and 31512 order by 1
go
select db_name(u.dbid),lstart,size / (power(2,20)/@@maxpagesize) as 'MB',d.name as 'device name',case when segmap = 4 then 'log' when segmap & 4 = 0 then 'data' else 'log and data' end as 'usage'
from sysusages u, sysdevices d where d.vdevno = u.vdevno and d.status & 2 = 2 and dbid in (select distinct  u.dbid from sysusages u, sysdevices d where d.vdevno = u.vdevno and d.status & 2 = 2 and segmap = 7 and db_name(u.dbid) not like 'tempdb%' and u.dbid between 4 and 31512 ) order by 1
go
exec sp_helpdb canshipws_dev1
go
use master 
declare @log int
select @log=ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end))*2 from master..sysdatabases d, master..sysusages u where u.dbid = d.dbid and d.status & 32 != 32 and status2 < 0 and d.name ='canshipws_dev1' group by d.dbid
--select @log
alter database canshipws_dev1 log on log2=1000
go

use master exec rp_kill_db_processes 'canshipws_dev1' exec sp_dboption canshipws_dev1, single, true
go
use canshipws_dev1 exec canshipws_dev1..sp_logdevice canshipws_dev1,log2
go
use master exec sp_dboption canshipws_dev1, single, false
go

--exec canshipws_dev1..sp_dropsegment logsegment,canshipws_dev1,dev33
--exec canshipws_dev1..sp_dropsegment 'default',canshipws_dev1,logdev1
--exec canshipws_dev1..sp_dropsegment system,canshipws_dev1,logdev1
--exec sp_extendsegment 'default',canshipws_dev1,dev19
--exec sp_extendsegment 'logsegment',canshipws_dev1,log2

go
/*
use master exec rp_kill_db_processes 'canshipws_dev1' exec sp_dboption canshipws_dev1, single, true
go
use canshipws_dev1
go
dbcc traceon(3604)
go
--dbcc findstranded
--go
--dbcc dbrepair(canshipws_dev1,remap)
--go
dbcc dbreboot(report, canshipws_dev1)
go
dbcc dbreboot(reboot, ussws_dev2)
go
dbcc traceoff(3604)
go
use master exec sp_dboption canshipws_dev1, single, false
go


--canshipws_dev1
--canshipws_dev2
ussws_dev2
canshipws_sandbox
dqm_data
termexp
ussws_dev1
linehaul_data
pmsbilling
lm_stage
ussws_sandbox
svp_cp
svp_lm
go
select * from sysdatabases where name = 'ussws_dev2'
go
*/