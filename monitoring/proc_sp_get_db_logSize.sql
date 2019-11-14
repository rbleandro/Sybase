use dba
go
create or replace procedure sp_get_db_logSize (@threshold decimal(5,2)=0)
as
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
--,'use '+d.name+char(10)+'GO'+char(10)+'dbcc traceon(3604)'+char(10)+'GO'+char(10)+'dbcc dbrepair('+d.name+',''fixlogfreespace'',''scanlogchain'',1)'+char(10)+'GO'+char(10)+'dbcc traceoff(3604)'+char(10)+'GO'+char(10)
from master..sysdatabases d, master..sysusages u
where u.dbid = d.dbid  and d.status != 256
and u.segmap & 4 = 4
and d.name not in ('sybsystemdb','sybsystemprocs','sybmgmtdb','master','model')
group by d.dbid
having convert(decimal(16,2), (100 * (case d.status2 & 32768 when 32768 then ((lct_admin("num_logpages", d.dbid)) + (sum(u.size)/256.))/512.
 else sum(convert(bigint,u.size)/512.) - (lct_admin("logsegment_freepages", d.dbid) - lct_admin("reserved_for_rollbacks", d.dbid))/512.
 end ))/ sum(convert(bigint,u.size)/512.)) > @threshold
order by convert(decimal(16,2), (100 * (case d.status2 & 32768 when 32768 then ((lct_admin("num_logpages", d.dbid)) + (sum(u.size)/256.))/512.
 else sum(convert(bigint,u.size)/512.) - (lct_admin("logsegment_freepages", d.dbid) - lct_admin("reserved_for_rollbacks", d.dbid))/512.
 end ))/ sum(convert(bigint,u.size)/512.)) desc
go

exec sp_get_db_logSize 0.5
go
