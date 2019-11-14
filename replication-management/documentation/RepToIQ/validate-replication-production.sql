use svp_cp
go

select * from svp_cp..svp_parcel where reference_num='000186977701' and service_type='D' and shipper_num='42033752' and first_scan_date='20190724 00:00:00:000'
go
select * from cpscan..svp_parcel where reference_num='000186977701' and service_type='D' and shipper_num='42033752' and first_scan_date='20190724 00:00:00:000'
go

INSERT INTO svp_cp.dbo.svp_parcel(reference_num, service_type, shipper_num, first_scan_date, pickup_shipper_num, document_id, document_date, linkage, shipment_id, term_from_scan, interline_from_scan, term_from_postal, interline_from_postal, province_from, term_to_scan, interline_to_scan, province_to, sort_terminal, origin_postal, destin_postal_scan, first_scan_time, first_scan_status, first_scan_flag, del_scan_time, del_scan_status, del_scan_flag, actual_days, std_days, made_service, evaluation_date_sp, correctly_manifested, split_at_delivery, evaluation_date_rh, destin_postal_man, inserted_on_cons, updated_on_cons, del_attempt_time, del_attempt_status, INO_terminal, INO_date, INO_standard_days, INO_actual_days, INO_scan_time, PD_type, del_term_first_scan, del_term_first_scan_date, del_term_first_scan_datetime, del_term_standard_days, del_term_actual_days, scan_at_delivery_term, source_of_failure, del_scan_comments, calc_service_flag, expected_arr_date, expected_del_date_flag, expected_del_date, del_route, service_code_source, service_code, controllable, reason, source_of_failure_sales, terminal_at_fault, customer_additional_days) 
	VALUES('000186977701', 'D', '42033752', '20190724 00:00:00:000', '', '', '2019-7-26 16:32:15', 0, 0, '', '', '', '', '', '', '', '', '', '', '', '2019-7-26 16:32:15', '', '', '2019-7-26 16:32:15', '', '', 0, 0, '', '2019-7-26 16:32:15', '', '', '2019-7-26 16:32:15', '', '2019-7-26 16:32:15', '2019-7-26 16:32:15', '2019-7-26 16:32:15', '', '', '2019-7-26 16:32:15', 0, 0, '2019-7-26 16:32:15', '', '', '2019-7-26 16:32:15', '2019-7-26 16:32:15', 0, 0, '', '', '', '', '2019-7-26 16:32:15', '', '2019-7-26 16:32:15', '', '', '', '', '', '', '', 0)
GO
delete from svp_cp..svp_parcel where reference_num='000186977701' and service_type='D' and shipper_num='42033752' and first_scan_date='20190724 00:00:00:000'
go

select * from svp_cp..svp_parcel
exec sp_spaceused svp_parcel
go

use cpscan
go

exec cpscan..sp_spaceused tttl_ma_barcode
go
exec cpscan..sp_spaceused tttl_ma_shipment
go
exec cpscan..sp_spaceused tttl_ma_eput3
go

select top 10 * from cpscan..tttl_ma_eput3 
where 1=1
and reference_num='000018169101 ' and service_type='D' and shipper_num='43809851' and manlink=15349025
and inserted_on is not null
order by inserted_on
go
update cpscan..tttl_ma_barcode set cost_centre='' where 1=1
and reference_num='000018169101 ' and service_type='D' and shipper_num='43809851' and manlink=15349025
go

select top 10 * from cpscan..tttl_ma_eput3 
where 1=1
and shipment_id=1 and manlink=2399207
go
update cpscan..tttl_ma_eput3 set spec_inst=''
where 1=1
and shipment_id=1 and manlink=2399207
go

select top 10 * from cpscan..tttl_ma_document
where 1=1
and shipment_id=1 and manlink=2399207
go

select * from cpscan..tttl_ma_document  where shipper_num='-4240928' 
GO

INSERT INTO cpscan..tttl_ma_document (shipper_num,manifest_num,manifest_date,filedatetime,manlink,weight_unit,EDMP_flag,filenum,filename) 
VALUES('-42409282','R111111','2011-11-11 00:00:00.0','2011-11-14 04:09:00.0',7270201,'L',0,6854662,'MAR111111.MA1')
GO
delete top 1 from cpscan..tttl_ma_document  where shipper_num='-4240928' 
go

select top 10 * from cpscan..tttl_ma_shipment where manlink=-12437263
go

INSERT INTO cpscan..tttl_ma_shipment (manlink,shipment_id,pieces,weight,spec_inst,cust_reference,cost_centre,order_number,service_code,total_charges,DV_charges,DV_amount,PUT_charges,XC_charges,HST,GST,QST,zone,cons_account,cons_name,cons_address1,cons_address2,cons_address3,cons_city,cons_prov,cons_postal,cons_attention,xc_pieces,min_weight_flag,NSR_flag,estimated_del_date,EA_charges,consignee_email,sa_resi_flag,sa_resi_charge,enh_service,pd_flag,pd_charge,cos_flag,cos_charge,dg_flag,dg_charge,rural_charge,country
,dhl_extract,inserted_on_cons,updated_on_cons) 
VALUES(-12437263,-1,1,1.8,'                                        ',' ',' ',' ',1,16.9600,0,0,0,0,2.4500,0,0,15,'SERRURES','SERRURES BAIE DES CHALEURS','10 RUE BOUCHER',' ',' ','CAMPBELLTON','NB','E3N2P1','JEAN FRANCOIS',0,0,0,'2015-09-02 00:00:00.0',0,' ','N',0,' ',' ',0,'N',0,'N',0,0,'  ',' ','2015-08-28 14:15:14.51','2015-08-28 14:15:14.51')
GO

delete top 1 from cpscan..tttl_ma_shipment where manlink=-12437263
go