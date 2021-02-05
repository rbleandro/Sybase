declare @daytosubtract tinyint
set @daytosubtract = 0

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='scan_compliance'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='cmf_data_lm'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='cmf_data'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='cpscan'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='lmscan'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='mpr_data'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='mpr_data_lm'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='rev_hist'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='rev_hist_lm'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='svp_cp'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='svp_lm'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='pms_data'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='uss'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='shippingws'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='lm_stage'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='linehaul_data'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='liberty_db'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='evkm_data'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='eput_db'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='dqm_data_lm'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='collectpickup'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='collectpickup_lm'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='cdpvkm'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='canshipws'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='canship_webdb'

--order by d1.db_name,d1.SnapId desc
go


select top 1000 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
,d1.data_used_MB,d2.data_used_MB
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where 1=1
and d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='cpscan'
order by d1.db_name,d1.SnapId desc
go
select top 1000 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
,d1.data_used_MB,d2.data_used_MB
from tempdb7..db_space d1 inner join tempdb7..db_space d2 on d1.db_name=d2.db_name
where 1=1
and d1.SnapId=d2.SnapId+1
--and d1.SnapId = (select max(SnapId)-@daytosubtract from tempdb7..db_space where db_name=d1.db_name)
and d1.db_name='lmscan'
order by d1.db_name,d1.SnapId desc
go
declare @d1l datetime,@d1h datetime,@d2l datetime, @d2h datetime
set @d1l='10/2/2018 5:00:00 PM'
set @d1h=dateadd(hh,1,@d1l)
set @d2l=dateadd(dd,1,@d1l)
set @d2h=dateadd(hh,1,@d2l)

select  g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.kbs - g1.kbs)/1000 as GrowthInMbs,'lmscan' as dbname,g1.SnapTime,g2.SnapTime
from lmscan..tbl_growth g1 inner join  lmscan..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
order by RowCountGrowth desc
go