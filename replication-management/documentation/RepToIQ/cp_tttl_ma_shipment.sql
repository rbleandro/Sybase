drop replication definition iq_tttl_ma_shipment_rep

create replication definition iq_tttl_ma_shipment_rep
with primary at CPDB1.cpscan
with primary table named dbo.'tttl_ma_shipment'
with replicate table named DBA.tttl_ma_shipment
(
manlink int     ,
shipment_id int     ,
pieces tinyint ,
weight decimal,
spec_inst char(40),
cust_reference varchar(40),
cost_centre varchar(40),
order_number varchar(40),
service_code tinyint ,
total_charges smallmoney ,
DV_charges smallmoney ,
DV_amount smallmoney ,
PUT_charges smallmoney ,
XC_charges smallmoney ,
HST smallmoney ,
GST smallmoney ,
QST smallmoney ,
"zone"   tinyint quoted,
cons_account varchar(15),
cons_name varchar(40),
cons_address1 varchar(40),
cons_address2 varchar(40),
cons_address3 varchar(40),
cons_city varchar(30),
cons_prov char(2) ,
cons_postal varchar(10),
cons_attention varchar(30),
xc_pieces tinyint ,
min_weight_flag int     ,
NSR_flag int     ,
estimated_del_date smalldatetime,
EA_charges smallmoney ,
consignee_email varchar(50),
sa_resi_flag char(1),
sa_resi_charge smallmoney,
enh_service char(1) ,
pd_flag char(1),
pd_charge smallmoney,
cos_flag char(1),
cos_charge smallmoney,
dg_flag char(1),
dg_charge smallmoney,
rural_charge smallmoney,
country char(2),
dhl_extract char(1),
inserted_on_cons datetime,
updated_on_cons datetime
)	
primary key (manlink, shipment_id )
go
