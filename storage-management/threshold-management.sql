exec scan_compliance..sp_helpthreshold -- check the existing thresholds
go
exec sp_addthreshold scan_compliance, "logsegment", 256000, sp_thresholdaction --512 MB threshold for the logsegment
go
exec sp_addthreshold scan_compliance, "default", 2560000, sp_thresholdnoaction -- 5 GB threshold for the default segment
go
exec sp_modifythreshold scan_compliance, "logsegment", 1024000, NULL, 256000 -- use this to modify a existing threshold
go
select  72872/1048576.*@@maxpagesize -- use this formula to convert number of pages to megabytes 
go

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

from master..sysdatabases d, master..sysusages u
where u.dbid = d.dbid  and d.status != 256
group by d.dbid
--order by TotalDatabaseSpace_MB desc
order by db_name
go

