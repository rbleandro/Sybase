
drop table tempdb7..tbl_space
go
if object_id('tempdb7..tbl_space') is null
begin
exec ('select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,''canada_post'' as dbname,g1.SnapTime as SnapTimeCurr,g2.SnapTime as SnapTimePrev
into tempdb7..tbl_space
from canada_post..tbl_growth g1 inner join  canada_post..tbl_growth g2 on g1.table_name = g2.table_name
where 1=2')
end
go
declare @daytosubtract tinyint
set @daytosubtract = 0

truncate table tempdb7..tbl_space

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'canada_post' as dbname,g1.SnapTime,g2.SnapTime
from canada_post..tbl_growth g1 inner join  canada_post..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from canada_post..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'canship_webdb' as dbname,g1.SnapTime,g2.SnapTime
from canship_webdb..tbl_growth g1 inner join  canship_webdb..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from canship_webdb..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'canshipws' as dbname,g1.SnapTime,g2.SnapTime
from canshipws..tbl_growth g1 inner join  canshipws..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from canshipws..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'cdpvkm' as dbname,g1.SnapTime,g2.SnapTime
from cdpvkm..tbl_growth g1 inner join  cdpvkm..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from cdpvkm..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'cmf_data' as dbname,g1.SnapTime,g2.SnapTime
from cmf_data..tbl_growth g1 inner join  cmf_data..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from cmf_data..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'cmf_data_lm' as dbname,g1.SnapTime,g2.SnapTime
from cmf_data_lm..tbl_growth g1 inner join  cmf_data_lm..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from cmf_data_lm..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'collectpickup' as dbname,g1.SnapTime,g2.SnapTime
from collectpickup..tbl_growth g1 inner join  collectpickup..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from collectpickup..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'collectpickup_lm' as dbname,g1.SnapTime,g2.SnapTime
from collectpickup_lm..tbl_growth g1 inner join  collectpickup_lm..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from collectpickup_lm..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'cpscan' as dbname,g1.SnapTime,g2.SnapTime
from cpscan..tbl_growth g1 inner join  cpscan..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from cpscan..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'dqm_data_lm' as dbname,g1.SnapTime,g2.SnapTime
from dqm_data_lm..tbl_growth g1 inner join  dqm_data_lm..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from dqm_data_lm..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'eput_db' as dbname,g1.SnapTime,g2.SnapTime
from eput_db..tbl_growth g1 inner join  eput_db..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from eput_db..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'evkm_data' as dbname,g1.SnapTime,g2.SnapTime
from evkm_data..tbl_growth g1 inner join  evkm_data..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from evkm_data..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'liberty_db' as dbname,g1.SnapTime,g2.SnapTime
from liberty_db..tbl_growth g1 inner join  liberty_db..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from liberty_db..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'linehaul_data' as dbname,g1.SnapTime,g2.SnapTime
from linehaul_data..tbl_growth g1 inner join  linehaul_data..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from linehaul_data..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'lm_stage' as dbname,g1.SnapTime,g2.SnapTime
from lm_stage..tbl_growth g1 inner join  lm_stage..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from lm_stage..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'lmscan' as dbname,g1.SnapTime,g2.SnapTime
from lmscan..tbl_growth g1 inner join  lmscan..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from lmscan..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'mpr_data' as dbname,g1.SnapTime,g2.SnapTime
from mpr_data..tbl_growth g1 inner join  mpr_data..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from mpr_data..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'mpr_data_lm' as dbname,g1.SnapTime,g2.SnapTime
from mpr_data_lm..tbl_growth g1 inner join  mpr_data_lm..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from mpr_data_lm..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'pms_data' as dbname,g1.SnapTime,g2.SnapTime
from pms_data..tbl_growth g1 inner join  pms_data..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from pms_data..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'rate_update' as dbname,g1.SnapTime,g2.SnapTime
from rate_update..tbl_growth g1 inner join  rate_update..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from rate_update..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'rev_hist' as dbname,g1.SnapTime,g2.SnapTime
from rev_hist..tbl_growth g1 inner join  rev_hist..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from rev_hist..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'rev_hist_lm' as dbname,g1.SnapTime,g2.SnapTime
from rev_hist_lm..tbl_growth g1 inner join  rev_hist_lm..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from rev_hist_lm..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'scan_compliance' as dbname,g1.SnapTime,g2.SnapTime
from scan_compliance..tbl_growth g1 inner join  scan_compliance..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from scan_compliance..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'shippingws' as dbname,g1.SnapTime,g2.SnapTime
from shippingws..tbl_growth g1 inner join  shippingws..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from shippingws..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'sort_data' as dbname,g1.SnapTime,g2.SnapTime
from sort_data..tbl_growth g1 inner join  sort_data..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from sort_data..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'svp_cp' as dbname,g1.SnapTime,g2.SnapTime
from svp_cp..tbl_growth g1 inner join  svp_cp..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from svp_cp..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'svp_lm' as dbname,g1.SnapTime,g2.SnapTime
from svp_lm..tbl_growth g1 inner join  svp_lm..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from svp_lm..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'termexp' as dbname,g1.SnapTime,g2.SnapTime
from termexp..tbl_growth g1 inner join  termexp..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from termexp..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'uss' as dbname,g1.SnapTime,g2.SnapTime
from uss..tbl_growth g1 inner join  uss..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from uss..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

select *
,'select count(*) from '+dbname+'..'+table_name+' where updated_on < dateadd(yy,-3,getdate())
union
select count(*) from '+dbname+'..'+table_name+' where inserted_on_cons >= convert(datetime,convert(date,getdate()))
go' 
from tempdb7..tbl_space 
order by GrowthInMB desc
go



declare spidcurs cursor for
select name from master..sysdatabases where dbid>3 and name not like 'tempdb%' and name not like 'syb%' order by name
go
Declare @dbname varchar(50),@str text,@str1 text--,@str0 varchar(1000)
set @str = ''
open spidcurs
fetch next from spidcurs into @dbname
While @@fetch_status = 0
Begin

set @str = @str + 'insert into tempdb7..tbl_space
select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'''+@dbname+''' as dbname,g1.SnapTime,g2.SnapTime--,''select count(*) from '+@dbname+'..''+g1.table_name
from '+@dbname+'..tbl_growth g1 inner join  '+@dbname+'..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-@daytosubtract from '+@dbname+'..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc

union

'

fetch next from spidcurs into @dbname
End
Deallocate spidcurs

select @str
go

select top 10 g1.table_name,(g1.row_count - g2.row_count) as RowCountGrowth,(g1.Used_MB - g2.Used_MB)/1000 as GrowthInMB,'lmscan' as dbname,g1.SnapTime,g2.SnapTime,g1.Used_MB,g2.Used_MB
from lmscan..tbl_growth g1 inner join  lmscan..tbl_growth g2 on g1.table_name = g2.table_name
where 1=1
and g1.SnapId = (select max(SnapId)-3 from lmscan..tbl_growth)
and g1.SnapId=g2.SnapId+1
order by GrowthInMB desc
go

select count(*) from cpscan..tttl_dr_delivery_record where updated_on_cons < dateadd(yy,-3,getdate())
union all 
select count(*) from lmscan..tttl_dr_delivery_record where updated_on_cons < dateadd(yy,-3,getdate())
union all
select count(*) from cpscan..tttl_dr_delivery_record where inserted_on_cons >= convert(datetime,convert(date,getdate()))
union all 
select count(*) from lmscan..tttl_dr_delivery_record where inserted_on_cons >= convert(datetime,convert(date,getdate()))
go

select count(*) from cpscan..PictureDataCapture where updated_on_cons < dateadd(yy,-3,getdate()) 
union all
select count(*) from cpscan..PictureDataCapture where updated_on_cons >= convert(datetime,convert(date,getdate())) 
union all
select count(*) from lmscan..PictureDataCapture where updated_on_cons < dateadd(yy,-3,getdate()) 
union all
select count(*) from lmscan..PictureDataCapture where updated_on_cons >= convert(datetime,convert(date,getdate())) 
go
select count(*) from cpscan..COSDataCapture where updated_on_cons < dateadd(yy,-3,getdate()) 
union all
select count(*) from cpscan..COSDataCapture where updated_on_cons >= convert(datetime,convert(date,getdate())) 
union all
select count(*) from lmscan..COSDataCapture where updated_on_cons < dateadd(yy,-3,getdate()) 
union all
select count(*) from lmscan..COSDataCapture where updated_on_cons >= convert(datetime,convert(date,getdate())) 
go
select count(*) from lmscan..tttl_ev_event_rawbc where inserted_on < dateadd(yy,-3,getdate()) 
union all
select count(*) from lmscan..tttl_ev_event_rawbc where inserted_on >= convert(datetime,convert(date,getdate())) 
go
select count(*) from cmf_data_lm..pr_manifest_audit_barcodes_fees where updated_on < dateadd(yy,-3,getdate()) 
union all
select count(*) from cmf_data_lm..pr_manifest_audit_barcodes_fees where inserted_on_cons >= convert(datetime,convert(date,getdate())) 
go

exec lmscan..sp_estspace @table_name ='tttl_dr_delivery_record', @no_of_rows =1,@textbin_len=244292 --0.31
go
exec lmscan..sp_estspace @table_name ='tttl_ev_event', @no_of_rows =1 --0.07
go
select top 1 * from lmscan..tttl_dr_delivery_record
GO