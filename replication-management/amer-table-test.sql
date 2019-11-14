select myint,'cmf_data'as db from cmf_data..amer
union
select myint,'sort_data'as db from sort_data..amer
union
select myint,'cmf_data_lm'as db from cmf_data_lm..amer_rep_tst
union
select myint,'pms_data'as db from pms_data..amer_rep_tbl
union
select myint,'rev_hist'as db from rev_hist..amer_rep_tbl
union
select myint,'evkm_data'as db from evkm_data..amer_rep_tbl
union
select myint,'liberty_db'as db from liberty_db..amer_rep_tbl
union
select myint,'rate_update'as db from rate_update..amer_rep_tbl
union
select myint,'collectpickup'as db from collectpickup..amer_rep_tbl
union
select myint,'scan_compliance'as db from scan_compliance..amer_rep_tbl
union
select myint,'collectpickup_lm'as db from collectpickup_lm..amer_rep_tbl
union
select myint,'lmscan'as db from lmscan..amer_rep_test
union
select myint,'svp_cp'as db from svp_cp..amer_table 
union
select myint,'cpscan'as db from cpscan..amer_table
union
select myint,'svp_lm'as db from svp_lm..amer_table 
union
select myint,'dqm_data_lm'as db from dqm_data_lm..amer_table
union
select myint,'rev_hist_lm'as db from rev_hist_lm..amer_table
union
select myint,'canship_webdb'as db from canship_webdb..amer_table
union
select myint,'linehaul_data'as db from linehaul_data..amer_table
union
select myint,'cdpvkm'as db from cdpvkm..amer_test
union
select myint,'eput_db'as db from eput_db..amer_tst
union
select myint,'canada_post'as db from canada_post..amertable
union
select myint,'lm_stage'as db from lm_stage..amer_table
go
declare @int int
set @int=-45798

update cmf_data..amer set myint = @int
update sort_data..amer set myint = @int
update cmf_data_lm..amer_rep_tst set myint = @int
update pms_data..amer_rep_tbl set myint = @int
update rev_hist..amer_rep_tbl set myint = @int
update canshipws..amer_rep_tbl set myint = @int
update evkm_data..amer_rep_tbl set myint = @int
update liberty_db..amer_rep_tbl set myint = @int
update rate_update..amer_rep_tbl set myint = @int
update collectpickup..amer_rep_tbl set myint = @int
update scan_compliance..amer_rep_tbl set myint = @int
update collectpickup_lm..amer_rep_tbl set myint = @int
update lmscan..amer_rep_test set myint = @int
update svp_cp..amer_table set myint = @int
update cpscan..amer_table set myint = @int
update svp_lm..amer_table set myint = @int
update lm_stage..amer_table set myint = @int
update dqm_data_lm..amer_table set myint = @int
update rev_hist_lm..amer_table set myint = @int
update canship_webdb..amer_table set myint = @int
update linehaul_data..amer_table set myint = @int
update cdpvkm..amer_test set myint = @int
update eput_db..amer_tst set myint = @int
update canada_post..amertable set myint = @int
go