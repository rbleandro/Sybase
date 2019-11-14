create replication definition CPDB2_iq_lm_revhstr_rep
with primary at CPDB1.rev_hist_lm
with primary table named dbo.'revhstr'
with replicate table named DBA.lm_revhstr
(
	linkage      	 integer ,
	shipment_id  	 smallint ,
	DV_charges   	 smallmoney ,
	DV_amt       	 smallmoney ,
	COD_charges  	 smallmoney ,
	COD_amt      	 smallmoney ,
	PUT_charges  	 smallmoney ,
	XC_charges   	 smallmoney ,
	EA_charges   	 smallmoney ,
	EA_level     	 tinyint ,
	PD_type      	 char(1) ,
	PD_charges   	 smallmoney ,
	DG_charges   	 smallmoney ,
	COS_charges  	 smallmoney ,
	RURAL_charges	 smallmoney
)	
primary key (linkage, shipment_id )
go

--truncate table DBA.lm_revhstr
go

insert into DBA.lm_revhstr /*IGNORE CONSTRAINT UNIQUE 0*/ location 'CPDB1.rev_hist_lm' packetsize 7168
{ 
select 
linkage, shipment_id, DV_charges, DV_amt, COD_charges, COD_amt, PUT_charges, XC_charges, EA_charges, EA_level, PD_type, PD_charges, DG_charges, COS_charges, RURAL_charges
from revhstr noholdlock
}
commit
go

select top 10 * from lm_revhstr where linkage=0 and shipment_id= 1
go
select top 10 * from rev_hist_lm..revhstr where linkage=--shipper_num='42409282' and manifest_num='R111111' and manifest_date='2011-11-11 00:00:00.000' and filedatetime='2011-11-14 04:09:00.000' and manlink=7270201
go

