create replication definition CPDB1_iq_lm_cparf06i_rep
with primary at CPDB1.cmf_data_lm
with primary table named dbo.'cparf06i'
with replicate table named DBA.lm_cparf06i
(
	customer          char(8),
	invoice_date      datetime,
	original_amt      money,
	outstanding_amt   money,
	highseq           integer,
	full_payment_date datetime,
	POA_batch         char(3),
	invoice_number    char(15)
)	
primary key (customer,invoice_date,POA_batch,invoice_number)
go
