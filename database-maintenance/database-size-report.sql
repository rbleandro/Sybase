/* version 1.0
select db_name(d.dbid) as db_name
,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) as data_size_MB
,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then convert(bigint,size) - curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end)/1048576.*@@maxpagesize) as data_used_MB
--ceiling(100 * (1 - 1.0 * sum(case when u.segmap != 4 and vdevno >= 0 then curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end) / sum(case when u.segmap != 4 then u.size end))) as data_used_pct,
,ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) as log_size_MB
,ceiling(lct_admin("logsegment_freepages",d.dbid)/1048576.*@@maxpagesize - sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) as log_used_MB
--,lct_admin("logsegment_freepages",d.dbid)/1048576.*@@maxpagesize
--ceiling(100 * (1 - 1.0 * lct_admin("logsegment_freepages",d.dbid) / sum(case when u.segmap in (4, 7) and vdevno >= 0 then u.size end))) as log_used_pct 
,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) - ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then convert(bigint,size) - curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end)/1048576.*@@maxpagesize) as UnusedDataSpace_MB
,ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) - ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end) - lct_admin("logsegment_freepages",d.dbid)/1048576.*@@maxpagesize) as UnusedLogSpace_MB
,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) + ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) as TotalDatabaseSpace_MB

from master..sysdatabases d, master..sysusages u
where u.dbid = d.dbid  and d.status != 256
and d.name='cpscan'
group by d.dbid
--order by TotalDatabaseSpace_MB desc
go */

select db_name(d.dbid) as db_name
,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) as dataSize
,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then convert(bigint,size) - curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end)/1048576.*@@maxpagesize) as dataUsed
,ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/512 end)) as logSize
,sum(case when u.segmap = 4 and vdevno >= 0 then u.size/512 end) - ABS(lct_admin("logsegment_freepages",d.dbid)/512) as logUsed
,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) - ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then convert(bigint,size) - curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end)/1048576.*@@maxpagesize) as UnusedDataSpace_MB
,lct_admin("logsegment_freepages",d.dbid)/512 as FreeLogSpace
,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) + ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) as TotalDatabaseSpace

from master..sysdatabases d, master..sysusages u
where u.dbid = d.dbid  and d.status != 256
and d.name <> 'tempdb3'
group by d.dbid
--order by TotalDatabaseSpace_MB desc
go