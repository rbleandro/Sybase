select db_name(u.dbid),lstart,size / (power(2,20)/@@maxpagesize) as 'MB',d.name as 'device name',case when segmap = 4 then 'log' when segmap & 4 = 0 then 'data' else 'log and data' end as 'usage'
,segmap
from master..sysusages u, master..sysdevices d where d.vdevno = u.vdevno and d.status & 2 = 2 and dbid in (select distinct  u.dbid from sysusages u, sysdevices d 
where d.vdevno = u.vdevno and d.status & 2 = 2 
--and segmap = 7 and db_name(u.dbid) not like 'tempdb%' and u.dbid between 4 and 31512
and db_name(u.dbid) ='cmf_data_lm' ) order by 1
go
use master 
declare @log int
select @log=ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end))*2 from master..sysdatabases d, master..sysusages u where u.dbid = d.dbid and d.status & 32 != 32 and status2 < 0 and d.name ='canshipws_dev1' group by d.dbid
--select @log
alter database canshipws_dev1 log on log2=1000
go



exec canada_post..sp_helpdb canada_post
go
exec canada_post..sp_helpsegment_custom "logsegment"
go

select db_name(dbid),* from syslogshold
go
select db_name(masterdbid),* from systransactions
go
dump tran canada_post with truncate_only
go

use master exec rp_kill_db_processes 'canada_post'
go
alter database canada_post off dev20=5680
go

use master alter database canada_post log off logdev3=9716
go

exec canada_post..sp_dropsegment logsegment, canada_post, dev36
go
exec canada_post..sp_dropsegment "system", canada_post, logdev4
go
exec canada_post..sp_dropsegment "default", canada_post, logdev4
go

use master exec rp_kill_db_processes 'canada_post'
go
use master exec sp_dboption canada_post, single, true
go
use canada_post exec canada_post..sp_logdevice canada_post,logdev2
go
use master exec rp_kill_db_processes 'canada_post'
go
use master exec sp_dboption canada_post, single, false
go

--use canada_post
--go
--dbcc traceon(3604)
--go
--go
--dbcc dbrepair(canada_post,findstranded)
--go
--dbcc dbrepair(canada_post, remap)
--go
--dbcc dbreboot(reboot,canada_post )
--go
--DBCC DBREPAIR(canada_post, fixlogfreespace, scanlogchain )
--go
--dbcc traceoff(3604)
--go

select db_name(u.dbid),lstart,size / (power(2,20)/@@maxpagesize) as 'MB',d.name as 'device name',case when segmap = 4 then 'log' when segmap & 4 = 0 then 'data' else 'log and data' end as 'usage'
from sysusages u, sysdevices d where d.vdevno = u.vdevno and d.status & 2 = 2 and dbid in (select distinct  u.dbid from sysusages u, sysdevices d 
where d.vdevno = u.vdevno and d.status & 2 = 2 and segmap in (6,7) and db_name(u.dbid) not like 'tempdb%' and u.dbid between 4 and 31512 ) order by 1
go

