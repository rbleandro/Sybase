alter database scan_compliance  log off logdev4= 23000
--dump database scan_compliance to "/home/sybase/db_backups/scan_compliance.dmp" compression=100 with shrink_log 
go

-- checking new space. COlumn total database should report X GB less than you specified in the command above
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
and db_name(d.dbid)='scan_compliance'
group by d.dbid
order by db_name desc
go

--sysusages will now report negative values for the vdeno for the fragments that were removed, showing that this database has undergone a shrink operation in the past
select (size/1048576.*@@maxpagesize),* from master..sysusages where dbid=db_id('scan_compliance')
go