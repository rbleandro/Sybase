select * from master..sysdatabases
go

exec tempdb..sp_addthreshold tempdb, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb..sp_addthreshold tempdb, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb..sp_addthreshold tempdb, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb1..sp_addthreshold tempdb1, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb1..sp_addthreshold tempdb1, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb1..sp_addthreshold tempdb1, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb2..sp_addthreshold tempdb2, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb2..sp_addthreshold tempdb2, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb2..sp_addthreshold tempdb2, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb3..sp_addthreshold tempdb3, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb3..sp_addthreshold tempdb3, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb3..sp_addthreshold tempdb3, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb4..sp_addthreshold tempdb4, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb4..sp_addthreshold tempdb4, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb4..sp_addthreshold tempdb4, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb5..sp_addthreshold tempdb5, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb5..sp_addthreshold tempdb5, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb5..sp_addthreshold tempdb5, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb6..sp_addthreshold tempdb6, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb6..sp_addthreshold tempdb6, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb6..sp_addthreshold tempdb6, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb_mpr..sp_addthreshold tempdb_mpr, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb_mpr..sp_addthreshold tempdb_mpr, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb_mpr..sp_addthreshold tempdb_mpr, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb7..sp_addthreshold tempdb7, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb7..sp_addthreshold tempdb7, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb7..sp_addthreshold tempdb7, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb8..sp_addthreshold tempdb8, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb8..sp_addthreshold tempdb8, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb8..sp_addthreshold tempdb8, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb9..sp_addthreshold tempdb9, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb9..sp_addthreshold tempdb9, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
go
exec tempdb1..sp_addthreshold tempdb1, "logsegment", 256000, sp_thresholdactiontempdb --removes the tempdb from the default group if this threshold is crossed
go
exec tempdb2..sp_addthreshold tempdb2, "logsegment", 256000, sp_thresholdactiontempdb --removes the tempdb from the default group if this threshold is crossed
go
exec tempdb3..sp_addthreshold tempdb3, "logsegment", 256000, sp_thresholdactiontempdb --removes the tempdb from the default group if this threshold is crossed
go
exec tempdb4..sp_addthreshold tempdb4, "logsegment", 256000, sp_thresholdactiontempdb --removes the tempdb from the default group if this threshold is crossed
go
exec tempdb5..sp_addthreshold tempdb5, "logsegment", 256000, sp_thresholdactiontempdb --removes the tempdb from the default group if this threshold is crossed
go
exec tempdb6..sp_addthreshold tempdb6, "logsegment", 256000, sp_thresholdactiontempdb --removes the tempdb from the default group if this threshold is crossed
go
exec tempdb7..sp_addthreshold tempdb7, "logsegment", 256000, sp_thresholdactiontempdb --removes the tempdb from the default group if this threshold is crossed
go
exec tempdb8..sp_addthreshold tempdb8, "logsegment", 256000, sp_thresholdactiontempdb --removes the tempdb from the default group if this threshold is crossed
go
exec tempdb9..sp_addthreshold tempdb9, "logsegment", 256000, sp_thresholdactiontempdb --removes the tempdb from the default group if this threshold is crossed
go



exec tempdb..sp_helpthreshold
go
exec tempdb1..sp_helpthreshold
go
exec tempdb2..sp_helpthreshold
go
exec tempdb3..sp_helpthreshold
go
exec tempdb4..sp_helpthreshold
go
exec tempdb5..sp_helpthreshold
go
exec tempdb6..sp_helpthreshold
go
exec tempdb7..sp_helpthreshold
go
exec tempdb8..sp_helpthreshold
go
exec tempdb9..sp_helpthreshold
go


select round(lct_admin("logsegment_freepages",db_id('tempdb3'))/512.,2),getdate()
go

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
and d.name like 'tempdb%'
group by d.dbid
--order by TotalDatabaseSpace_MB desc
go