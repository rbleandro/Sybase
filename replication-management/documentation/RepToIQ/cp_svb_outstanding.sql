create replication definition CPDB1_iq_cp_svb_outstanding_rep
with primary at CPDB1.rev_hist
with primary table named dbo.svb_outstanding
with replicate table named DBA.svb_outstanding
(
	period                 	 char(6) ,
	fiscal_week            	 char(7) ,
	company                	 char(1) ,
	"status"                 char(30) quoted,
	manifest_num           	 char(7) ,
	manifest_null          	 char(1) ,
	reason_code            	 char(90) ,
	customer_name          	 varchar(50) ,
	service_type           	 char(1) ,
	shipper_num            	 char(8) ,
	reference_num          	 char(13) ,
	pic_date_time          	 datetime ,
	pic_employee_num       	 char(6) ,
	del_time_date          	 datetime ,
	del_employee_num       	 char(6) ,
	del_status             	 char(3) ,
	del_status_desc        	 varchar(40) ,
	terminal_num           	 char(3) ,
	terminal_name          	 varchar(20) ,
	del_name               	 varchar(12) ,
	del_address_name       	 varchar(100) ,
	del_address            	 varchar(100) ,
	del_city               	 varchar(100) ,
	del_postal_code        	 varchar(6) ,
	del_province           	 char(2) ,
	billed_weight          	 decimal,
	weight_source          	 char(30) ,
	cw_weight_unit         	 varchar(1) ,
	shipping_system_cd     	 char(2) ,
	shipping_system        	 char(50) ,
	inserted_on_cons       	 datetime ,
	alt_shipper_num        	 char(8) ,
	alt_reference_num      	 char(13) ,
	billing_weight_unit    	 char(1) ,
	cw_weight              	 decimal,
	first_scan_date_time   	 datetime ,
	first_scan_employee_num  char(6) ,
	lxl_count              	 decimal,
	inserted_on            	 datetime  
)	
primary key (service_type, shipper_num, reference_num)
go

