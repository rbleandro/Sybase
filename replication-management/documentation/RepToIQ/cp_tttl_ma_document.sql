drop replication definition iq_tttl_ma_document_rep

create replication definition iq_tttl_ma_document_rep
with primary at CPDB1.cpscan
with primary table named dbo.'tttl_ma_document'
with replicate table named DBA.tttl_ma_document
(
shipper_num  	char(8) ,
	manifest_num char(7) ,
	manifest_date smalldatetime ,
	filedatetime  smalldatetime ,
	manlink      	integer ,
	weight_unit  	char(1) ,
	EDMP_flag    	integer ,
	filenum      	integer ,
	filename     	varchar(50)  
)	
primary key ( shipper_num, manifest_num, manifest_date, filedatetime, manlink)
go


