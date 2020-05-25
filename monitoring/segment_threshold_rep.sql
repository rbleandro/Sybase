use dba
go
if object_id('threshold_control') is not null
    drop table dba.dbo.threshold_control
go
create table dba.dbo.threshold_control (dbname varchar(100),segname varchar(50) null,space_threshold_MB int null)
go
truncate table dba.dbo.threshold_control
go

CREATE OR REPLACE PROCEDURE dbo.populate_threshold_control
as

Declare @dbname varchar(50),
@str varchar(1000),@str1 varchar(1000)

truncate table dba.dbo.threshold_control

declare spidcurs cursor for
select name from master..sysdatabases 
where status2 & 16 != 16 
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs')
order by name --excluding offline databases

open spidcurs
fetch next from spidcurs into @dbname
While @@fetch_status = 0
Begin

set @str = '
insert into dba.dbo.threshold_control(dbname,segname,space_threshold_MB)
select	'''+@dbname+''',s.name,t.free_space/512
from '+@dbname+'..syssegments s left join '+@dbname+'..systhresholds t on s.segment = t.segment
and s.name not in (''ps_bi_lo_dc_pr_pt_ss_dp_seg'',''parcel_seg'',''system'') 
and t.status != 1'


exec(@str)

set @str=''

fetch next from spidcurs into @dbname
End
close spidcurs
Deallocate spidcurs

delete from dba.dbo.threshold_control where segname in ('system','ps_bi_lo_dc_pr_pt_ss_dp_seg','parcel_seg')
delete from dba.dbo.threshold_control where segname='default' and dbname like 'tempdb%'
update dba.dbo.threshold_control set space_threshold_MB=0 where space_threshold_MB is null

truncate table dba.dbo.db_space_rep

insert into dba.dbo.db_space_rep
select db_name(d.dbid) as db_name
,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) as dataSize
,ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/512 end)) as logSize
,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) + isnull(ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)),0) as TotalDatabaseSpace
from master..sysdatabases d, master..sysusages u
where u.dbid = d.dbid  and d.status != 256
group by d.dbid
order by d.name
GO


exec dba.dbo.populate_threshold_control
go

select * from dba.dbo.threshold_control
go

select d.name as dbname,isnull(t.segname,'') as segname,isnull(t.space_threshold_MB,-99) as space_threshold_MB,'No segment threshold defined. Please solve ASAP.' as SitRep
,s.TotalDatabaseSpace,s.dataSize,s.logSize
from master..sysdatabases d
left join dba.dbo.threshold_control t on d.name = t.dbname 
inner join dba.dbo.db_space_rep s on s.db_name=d.name
where 1=1
and d.name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs')
and t.space_threshold_MB is null
and s.TotalDatabaseSpace > 1000
go

select t1.dbname,t1.segname--, space_threshold_MB
,'consider creating a new threshold for ' + cast((case when (case t1.segname when 'logsegment' then s.logSize*0.25 else s.dataSize*0.25 end) > 5000 then 5000 else (case t1.segname when 'logsegment' then s.logSize*0.25 else s.dataSize*0.25 end) end) as varchar(50)) as SitRep
,s.TotalDatabaseSpace,s.dataSize,s.logSize
,'exec '+t1.dbname+'..sp_addthreshold '+t1.dbname+', "'+t1.segname+'", '+ cast((case when (case t1.segname when 'logsegment' then s.logSize*0.25 else s.dataSize*0.25 end) > 5000 then 5000 else (case t1.segname when 'logsegment' then s.logSize*0.25 else s.dataSize*0.25 end) end)*512 as varchar(50)) +', sp_thresholdNOaction'
from dba.dbo.threshold_control t1
inner join dba.dbo.db_space_rep s on s.db_name=t1.dbname
where 1=1
and not exists
    (
        select t2.segname 
        from dba.dbo.threshold_control t2 
        inner join dba.dbo.db_space_rep s1 on s1.db_name=t2.dbname 
        where t1.dbname = t2.dbname and t1.segname=t2.segname 
        group by t2.segname
        having max(t2.space_threshold_MB) >= (case when (case t2.segname when 'logsegment' then s1.logSize*0.25 else s1.dataSize*0.25 end) > 5000 then 5000 else (case t2.segname when 'logsegment' then s1.logSize*0.25 else s1.dataSize*0.25 end) end)
    )
and s.TotalDatabaseSpace > 1000
group by dbname,segname
,'consider creating a new threshold for ' + case t1.segname when 'logsegment' then cast(s.logSize*0.25 as varchar(50)) else cast(s.dataSize*0.25 as varchar(50)) end 
,s.TotalDatabaseSpace,s.dataSize,s.logSize
go

select	segment_name=s.name,
    free_pages_GB=t.free_space/512,
    last_chance=t.status,
    threshold_procedure=t.proc_name
from syssegments s, systhresholds t
where s.segment = t.segment
--and s.name = @segname
and t.status != 1
go
