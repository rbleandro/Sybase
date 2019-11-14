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
,'use '+d.name+char(10)+'GO'+char(10)+'dbcc traceon(3604)'+char(10)+'GO'+char(10)+'dbcc dbrepair('+d.name+',''fixlogfreespace'',''scanlogchain'',1)'+char(10)+'GO'+char(10)+'dbcc traceoff(3604)'+char(10)+'GO'+char(10)
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

/* 
--old version
select db_name(d.dbid) as db_name
,ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/512 end)) as log_size_MB
,lct_admin("logsegment_freepages",d.dbid)/512 as log_free_MB
,convert(decimal(6,2), (100 * ((lct_admin("logsegment_freepages",d.dbid)/512.) / sum((case when u.segmap in (4, 7) and vdevno >= 0 then u.size end)/512.)))) as log_free_pct 
--,case (select count(*) from master..sysusages u1, master..sysdevices d1 where u.dbid=u1.dbid and d1.vdevno = u1.vdevno and d1.status & 2 = 2 and u1.segmap = 7 and db_name(u1.dbid) not like 'tempdb%' and u1.dbid between 4 and 31512) when 0 then 'No' else 'Yes' end as MixExt
from master..sysdatabases d, master..sysusages u
where u.dbid = d.dbid  and d.status != 256
--and d.name not like 'tempdb%'
and d.name not in ('sybsystemdb','sybsystemprocs','sybmgmtdb','master','model')
and d.name not in ('canshipws')
--excluding databases with mixed segments since they do not report the right usage
--and d.name not in (select db_name(u.dbid) from master..sysusages u, master..sysdevices d where d.vdevno = u.vdevno and d.status & 2 = 2 and segmap = 7 and db_name(u.dbid) not like 'tempdb%' and u.dbid between 4 and 31512)
group by d.dbid
--excluding databases with wrong metadata about the log free space due to internal bug
--having lct_admin("logsegment_freepages",d.dbid) < sum((case when u.segmap in (4, 7) and vdevno >= 0 then u.size end))
--rollback
order by convert(decimal(6,2), (100 * ((lct_admin("logsegment_freepages",d.dbid)/512.) / sum((case when u.segmap in (4, 7) and vdevno >= 0 then u.size end)/512.)))) 
go 
*/

exec rev_hist..sp_helpsegment_custom 'logsegment'
go

exec sp_helpdb rev_hist