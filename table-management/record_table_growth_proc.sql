 use cpscan
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use lmscan
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use cmf_data
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use cmf_data_lm
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use canship_webdb
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use rev_hist
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use rev_hist_lm
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use canada_post
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use svp_lm
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use svp_cp
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use canshipws
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use cdpvkm
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use collectpickup
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use collectpickup_lm
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use dqm_data_lm
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use sort_data
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use liberty_db
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use eput_db
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use evkm_data
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use linehaul_data
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use lm_stage
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use pms_data
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use rate_update
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use shippingws
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use termexp
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use uss
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use mpr_data
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO
 use mpr_data_lm
GO
create or replace procedure record_table_growth
as
insert into tbl_growth (table_name,row_count,pages,mbs,Allocated_MB,Used_MB,SnapTime,SnapId)
select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
,convert(decimal(19,2),reserved_pages(db_id(),o.id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Allocated MB"
,convert(decimal(19,2),used_pages(db_id(),id)/(1024.0 / (@@maxpagesize/1024.0) )) as "Used MB"
,getdate() as SnapTime
,(select isnull(max(SnapId),0)+1 from tbl_growth) as SnapId
from sysobjects o
where type = "U"
order by "Used MB" desc
GO