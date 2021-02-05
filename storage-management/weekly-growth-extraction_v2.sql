declare @d1l datetime,@d1h datetime,@d2l datetime, @d2h datetime
set @d1l='2/3/2021 5:00:00.000 PM'
set @d1h=dateadd(hh,1,@d1l)
set @d2l=dateadd(dd,1,@d1l)
set @d2h=dateadd(hh,1,@d2l)

declare @daytosubtract tinyint
set @daytosubtract = 0

--truncate table tempdb7.dbo.tbl_space

select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'scan_compliance' as dbname
from scan_compliance..tbl_growth g1 inner join  scan_compliance..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--and g1.SnapId=g2.SnapId+1
--and g1.SnapId = (select max(SnapId)-@daytosubtract from scan_compliance..tbl_growth where table_name=g1.table_name)
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'lmscan' as dbname
from lmscan..tbl_growth g1 inner join  lmscan..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'cpscan' as dbname
from cpscan..tbl_growth  g1 inner join cpscan..tbl_growth  g2 on  g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'svp_cp' as dbname
from svp_cp..tbl_growth  g1 inner join svp_cp..tbl_growth  g2 on  g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'svp_lm' as dbname
from svp_lm..tbl_growth  g1 inner join svp_lm..tbl_growth  g2 on  g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'cmf_data' as dbname
from cmf_data..tbl_growth  g1 inner join cmf_data..tbl_growth  g2 on  g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'cmf_data_lm' as dbname
from cmf_data_lm..tbl_growth  g1 inner join cmf_data_lm..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'canship_webdb' as dbname
from canship_webdb..tbl_growth  g1 inner join canship_webdb..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'canshipws' as dbname
from canshipws..tbl_growth  g1 inner join canshipws..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'cdpvkm' as dbname
from cdpvkm..tbl_growth  g1 inner join cdpvkm..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'collectpickup' as dbname
from collectpickup..tbl_growth  g1 inner join collectpickup..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'collectpickup_lm' as dbname
from collectpickup_lm..tbl_growth  g1 inner join collectpickup_lm..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'dqm_data_lm' as dbname
from dqm_data_lm..tbl_growth  g1 inner join dqm_data_lm..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'eput_db' as dbname
from eput_db..tbl_growth  g1 inner join eput_db..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'evkm_data' as dbname
from evkm_data..tbl_growth  g1 inner join evkm_data..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'liberty_db' as dbname
from liberty_db..tbl_growth  g1 inner join liberty_db..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'linehaul_data' as dbname
from linehaul_data..tbl_growth  g1 inner join linehaul_data..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'lm_stage' as dbname
from lm_stage..tbl_growth  g1 inner join lm_stage..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'rate_update' as dbname
from rate_update..tbl_growth  g1 inner join rate_update..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'shippingws' as dbname
from shippingws..tbl_growth  g1 inner join shippingws..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'sort_data' as dbname
from sort_data..tbl_growth  g1 inner join sort_data..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0
--order by RowCountGrowth desc

union
select g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.Used_MB - g1.Used_MB) as GrowthInMbs,g1.SnapTime,g2.SnapTime,'uss' as dbname
from uss..tbl_growth  g1 inner join uss..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
and (g2.Used_MB - g1.Used_MB) > 0

order by GrowthInMbs desc
go

declare @d1l datetime,@d1h datetime,@d2l datetime, @d2h datetime
set @d1l='8/13/2018 5:00:00.000 PM'
set @d1h=dateadd(hh,1,@d1l)
set @d2l=dateadd(dd,1,@d1l)
set @d2h=dateadd(hh,1,@d2l)

select top 10 g1.table_name,(g2.row_count - g1.row_count) as RowCountGrowth,(g2.kbs - g1.kbs) as GrowthInMbs,'cmf_data_lm' as dbname
from cmf_data_lm..tbl_growth  g1 inner join cmf_data_lm..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapTime between @d1l and @d1h
and g2.SnapTime between @d2l and @d2h
order by RowCountGrowth desc
go

alter table cmf_data_lm..tbl_growth modify table_name varchar(100)
go