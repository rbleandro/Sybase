create or replace procedure sp_dbSizeRep (@dbname varchar(100)=NULL)
as
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
and (@dbname is null or d.name=@dbname)
group by d.dbid
order by d.name
go

exec sp_dbSizeRep 'lmscan'
go