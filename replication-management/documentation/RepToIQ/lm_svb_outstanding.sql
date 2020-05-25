create replication definition CPDB1_iq_lm_svb_outstanding_rep
with primary at CPDB1.rev_hist_lm
with primary table named dbo.svb_outstanding
with replicate table named DBA.lm_svb_outstanding
(
"status" char(30) quoted,
reason_code char(90),
comments char(255),
primary_wb char(30),
invoice_num char(8),
invoice_date date,
customer_num char(8),
customer_name char(50),
reference_num char(40),
pic_date_time datetime,
pic_employee_num char(6),
del_time_date datetime,
del_employee_num char(6),
del_status char(3),
del_status_desc varchar(40),
terminal_num char(3),
terminal_name varchar(20),
del_name varchar(12),
del_address varchar(100),
del_city varchar(100),
del_postal_code varchar(6),
del_province char(2),
average_billed_weight decimal,
weight_source char(30),
pickup_shipper_num char(8),
prefix_status char(2),
period char(6),
updated_on_cons datetime,
fiscal_week char(7),
del_address_name varchar(100),
inserted_on datetime,
additional_serv_flag char(1),
manual_entry_flag integer
)
primary key (reference_num)
go