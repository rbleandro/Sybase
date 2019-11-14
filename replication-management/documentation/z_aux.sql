exec sp_spaceused revhstm
go
select count(*) from lm_stage..bcxref
union
select count(*) from lm_stage..cwparcel
union
select count(*) from lm_stage..cwshipment
union
select count(*) from lm_stage..revhstf1--
union
select count(*) from cmf_data_lm.dbo.simon_inv_records
union
select count(*) from lm_stage..revhstm
union
select count(*) from lm_stage..revhstr
go
select * 
--into revhstf1_bkp_20190721 
from lm_stage..revhstf1_bkp_20190721
go
delete from  revhstf1
go
select * from cmf_data_lm.dbo.simon_inv_records
go
select * from lm_stage..revhstf1
go

select * from cmf_data_lm..invoicing_status_checks where resource = 'rv_tables' and processed_date = convert(date, getdate()) 
select * from cmf_data_lm..invoicing_status_checks where resource = 'arinvage' and processed_date = convert(date, getdate())
go

SELECT cmf_data_lm.dbo.invoicing_status_checks.processed_date, cmf_data_lm.dbo.invoicing_status_checks.resource, cmf_data_lm.dbo.invoicing_status_checks.status_check 
FROM cmf_data_lm.dbo.invoicing_status_checks WHERE data_source='inv' and resource='invoicing' and status_check='Done' and processed_date = convert(date,getdate())
go

cpscan..tttl_ma_eput3
cpscan..tttl_ma_document
cpscan..tttl_ma_shipment
cpscan..tttl_ma_barcode
go
exec cpscan..sp_spaceused tttl_ma_eput3
exec cpscan..sp_spaceused tttl_ma_document
exec cpscan..sp_spaceused tttl_ma_shipment
exec cpscan..sp_spaceused tttl_ma_barcode
exec svp_cp..sp_spaceused svp_parcel
go
lmscan..tttl_ma_barcode
go
svp_cp..svp_parcel
go

select top 1 * from tttl_ma_barcode
go
insert into ExtractionControl values ('tttl_ma_barcode_IQ',dateadd(dd,-2,getdate()),null)
go


select top 10 * from cpscan..tttl_ma_eput3 where manlink=2399207 and shipment_id= 1
go
update cpscan..tttl_ma_eput3 set spec_inst='' where manlink=2399207 and shipment_id= 1
go

select top 10 * from cpscan..tttl_ma_document 
where shipper_num='42409282' and manifest_num='R111111' and manifest_date='2011-11-11 00:00:00.000' and filedatetime='2011-11-14 04:09:00.000' and manlink=7270201
go
update cpscan..tttl_ma_document set EDMP_flag=0
where shipper_num='42409282' and manifest_num='R111111' and manifest_date='2011-11-11 00:00:00.000' and filedatetime='2011-11-14 04:09:00.000' and manlink=7270201
go

select top 10 * from cpscan..tttl_ma_shipment where manlink=12437263 and shipment_id= 1
go
update top 1 cpscan..tttl_ma_shipment set spec_inst='' where manlink=12437263 and shipment_id= 1
go


sp_setreptable 'dbo.tttl_ma_document','true', owner_on --execute this on publisher ASE
go
tttl_lo_linehaul_outbound
go
sp_setreptable 'dbo.tttl_ps_pickup_shipper',false
go
sp_setreptable 'dbo.tttl_lo_linehaul_outbound',true,owner_on
go

