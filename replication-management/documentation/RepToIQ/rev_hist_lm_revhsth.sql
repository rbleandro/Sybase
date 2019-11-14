create replication definition CPDB2_iq_lm_revhsth_rep
with primary at CPDB1.rev_hist_lm
with primary table named dbo.'revhsth'
with replicate table named DBA.lm_revhsth
(
	shipper_num        	 char(8) ,
	pickup_rec_num     	 char(10) ,
	pickup_rec_date    	 smalldatetime ,
	data_entry_date    	 smalldatetime ,
	billto_type        	 char(1) ,
	bt422              	 char(5) ,
	units              	 char(1) ,
	assoc_code         	 char(4) ,
	origin_pc          	 char(6) ,
	ZW_discount        	 char(8) ,
	ZW_alpha           	 char(1) ,
	RBF_paper          	 char(9) ,
	RBF_file           	 char(9) ,
	filenum            	 char(8) ,
	release_as         	 char(1) ,
	invoice            	 char(15) ,
	invoice_date       	 smalldatetime ,
	linkage            	 integer ,
	com_disc_date      	 datetime ,
	user_id            	 varchar(15) ,
	fuel_surcharge_code	 char(2)  ,
	inserted_on        	 datetime ,
	updated_on         	 datetime  
)	
primary key (linkage )
go

--truncate table DBA.lm_revhsth
go

insert into DBA.lm_revhsth /*IGNORE CONSTRAINT UNIQUE 0*/ location 'CPDB1.rev_hist_lm' packetsize 7168
{ 
select 
shipper_num, pickup_rec_num, pickup_rec_date, data_entry_date, billto_type, bt422, units, assoc_code, origin_pc, ZW_discount, ZW_alpha, RBF_paper, RBF_file, filenum, release_as, invoice, invoice_date, linkage, com_disc_date, user_id, fuel_surcharge_code, inserted_on, updated_on
from revhsth noholdlock
}
commit

go

select top 10 * from lm_revhsth where linkage=2014523803 --and shipment_id= 1
go
select top 10 * from rev_hist_lm..revhsth where linkage=--shipper_num='42409282' and manifest_num='R111111' and manifest_date='2011-11-11 00:00:00.000' and filedatetime='2011-11-14 04:09:00.000' and manlink=7270201
go
