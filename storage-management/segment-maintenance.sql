use cpscan
go
--exec sp_extendsegment 'image_seg',cpscan,dev32
go
exec sp_helpthreshold
go
--exec sp_dropsegment image_seg, cpscan, dev29
go

--Log segment usage report
select db_name(d.dbid) as db_name
,d.status2 & 32768 isMixed
,sum(convert(bigint,u.size)/512.) as TotalMB
,case d.status2 & 32768 when 32768 then ((lct_admin("num_logpages", d.dbid)) + (sum(u.size)/256))/512
 else sum(convert(bigint,u.size)/512) - (lct_admin("logsegment_freepages", d.dbid) - lct_admin("reserved_for_rollbacks", d.dbid))/512
 end as UsedMB
,(lct_admin("logsegment_freepages", d.dbid) - lct_admin("reserved_for_rollbacks", d.dbid))/512  as FreeMB
,convert(decimal(16,2), (100 * (case d.status2 & 32768 when 32768 then ((lct_admin("num_logpages", d.dbid)) + (sum(u.size)/256.))/512.
 else sum(convert(bigint,u.size)/512.) - (lct_admin("logsegment_freepages", d.dbid) - lct_admin("reserved_for_rollbacks", d.dbid))/512.
 end ))/ sum(convert(bigint,u.size)/512.)) as logUsed_pct
,'use '+d.name+' dbcc traceon(3604) dbcc dbrepair('+d.name+',''fixlogfreespace'',''scanlogchain'',1) dbcc traceoff(3604)'
from master..sysdatabases d, master..sysusages u
where u.dbid = d.dbid  and d.status != 256
and u.segmap & 4 = 4
and d.name not in ('sybsystemdb','sybsystemprocs','sybmgmtdb','master','model')
and d.name not like ('tempdb%')
--excluding databases with mixed segments since they do not report the right usage
--and d.status2 & 32768 = 32768
group by d.dbid
--excluding databases with wrong metadata about the log free space due to internal bug
order by convert(decimal(16,2), (100 * (case d.status2 & 32768 when 32768 then ((lct_admin("num_logpages", d.dbid)) + (sum(u.size)/256.))/512.
 else sum(convert(bigint,u.size)/512.) - (lct_admin("logsegment_freepages", d.dbid) - lct_admin("reserved_for_rollbacks", d.dbid))/512.
 end ))/ sum(convert(bigint,u.size)/512.)) desc
go
