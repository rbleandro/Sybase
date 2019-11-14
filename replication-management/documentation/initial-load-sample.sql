--truncate table DBA.tttl_ma_barcode
go

--insert into DBA.tttl_ma_barcode IGNORE CONSTRAINT UNIQUE 0 location 'CPDB1.cpscan' packetsize 7168
--{ 
--select 
--service_type, reference_num, shipper_num, manlink, shipment_id, pieceno, weight, cube, cube_length, cube_width, cube_height, COD_amount, cust_reference, cost_centre, order_number, inserted_on, updated_on
--from tttl_ma_barcode noholdlock
--}
--commit

go
--alter table DBA.tttl_ma_barcode drop inserted_on
--go
--alter table DBA.tttl_ma_barcode add inserted_on datetime NULL
go


select top 10 * from tttl_ma_barcode where manlink=2399207 and shipment_id= 1
go
select top 10 * from cpscan..tttl_ma_barcode 
where shipper_num='42409282' and manifest_num='R111111' and manifest_date='2011-11-11 00:00:00.000' and filedatetime='2011-11-14 04:09:00.000' and manlink=7270201
go

select top 10 * from DBA.tttl_ma_barcode where manlink=12437263 and shipment_id= 1
go

-- 60431443 1h 2m 4s
--120198750
 
