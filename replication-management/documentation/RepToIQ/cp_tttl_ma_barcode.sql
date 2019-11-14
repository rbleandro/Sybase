create replication definition CPDB1_iq_tttl_ma_barcode_rep
with primary at CPDB1.cpscan
with primary table named dbo.tttl_ma_barcode
with replicate table named DBA.tttl_ma_barcode
(
	service_type  	 char(1),
	reference_num 	 char(13),
	shipper_num   	 char(8),
	manlink       	 int,
	shipment_id   	 int,
	pieceno       	 tinyint,
	weight        	 decimal,
	"cube"          	 decimal quoted,
	cube_length   	 tinyint,
	cube_width    	 tinyint,
	cube_height   	 tinyint,
	COD_amount    	 smallmoney,
	cust_reference	 varchar(40),
	cost_centre   	 varchar(40),
	order_number  	 varchar(40),
	inserted_on   	 datetime ,
	updated_on    	 datetime 
)	
primary key ( reference_num, service_type, shipper_num, manlink)
go

