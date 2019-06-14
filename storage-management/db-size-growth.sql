declare @daytosubtract tinyint
set @daytosubtract = 2

select  sum(d1.data_used_MB - d2.data_used_MB) as TotalGrowth 
,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime,d1.db_name
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
--and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name in ('cpscan','lmscan')
group by  d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime,d1.db_name --362.849
go
declare @daytosubtract tinyint
set @daytosubtract = 4

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='cmf_data_lm'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='cmf_data'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='cpscan'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='lmscan'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='mpr_data'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='mpr_data_lm'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='rev_hist'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='rev_hist_lm'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='svp_cp'
--order by d1.db_name,d1.SnapId desc
union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='svp_lm'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='pms_data'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='uss'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='shippingws'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='lm_stage'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='linehaul_data'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='sort_data'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='liberty_db'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='evkm_data'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='eput_db'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='dqm_data_lm'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='collectpickup'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='collectpickup_lm'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='cdpvkm'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='canshipws'
--order by d1.db_name,d1.SnapId desc

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='canship_webdb'

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='canada_post'

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='scan_compliance'

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='rate_update'

union

select top 1 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='termexp'
--order by d1.db_name,d1.SnapId desc
go


select top 1000 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
,d1.data_used_MB,d2.data_used_MB
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where 1=1
and d1.SnapId=d2.SnapId+1
and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='cpscan'
order by d1.db_name,d1.SnapId desc
go
select top 1000 d1.db_name,d1.data_used_MB - d2.data_used_MB as 'growth(MB)' ,d1.SnapId,d2.SnapId,d1.SnapTime,d2.SnapTime
,d1.data_used_MB,d2.data_used_MB
from dba..db_space d1 inner join dba..db_space d2 on d1.db_name=d2.db_name
where 1=1
and d1.SnapId=d2.SnapId+1
--and d1.SnapId = (select max(SnapId)-@daytosubtract from dba..db_space where db_name=d1.db_name)
and d1.db_name='lmscan'
order by d1.db_name,d1.SnapId desc
go
