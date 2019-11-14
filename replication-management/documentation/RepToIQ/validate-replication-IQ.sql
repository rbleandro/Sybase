select count(*) from cp_svp_parcel
go
select count(*) from  tttl_ma_barcode
go
select count(*) from  tttl_ma_shipment
go
select count(*) from  tttl_ma_eput3
go
47140863
47180206
go

select * from svp_cp..svp_parcel where reference_num='000186977701' and service_type='D' and shipper_num='42033752' and first_scan_date='20190724 00:00:00:000'
go

select count(*) from  
go

select top 10 * from DBA.tttl_ma_barcode 
where 1=1
and reference_num='000018169101 ' and service_type='D' and shipper_num='43809851' and manlink=15349025
go
select top 10 * from cpscan..tttl_ma_eput3 
where 1=1
and shipment_id=1 and manlink=2399207
go
select * from cpscan..tttl_ma_document  where shipper_num='-4240928' 
GO
select top 10 * from cpscan..tttl_ma_shipment where manlink=-12437263