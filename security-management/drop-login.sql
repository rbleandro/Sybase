--first get the objects owned by the login. Run this on each database
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner robbie_toyota' when 'P' then 'alter procedure '+ name + ' modify owner robbie_toyota' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
go 

--run this to modify ownership
alter table cmfrates modify owner robbie_toyota
alter table cmfshipr modify owner robbie_toyota
alter table disp_cust modify owner robbie_toyota
alter table disp_route modify owner robbie_toyota
alter table disp_term modify owner robbie_toyota
alter table disp_user_regn modify owner robbie_toyota
alter table disp_users modify owner robbie_toyota
alter table tot_hs modify owner robbie_toyota
go
--after that, drop all aliases that point to the login on the database
sp_dropalias N'jesse_robinson', N'dbo' 
GO

--finnaly drop the login
USE master
GO
DROP LOGIN dryden_zarate  --WITH OVERRIDE
GO

select * from syslogins where name in ('dryden_zarate','jesse_robinson','dbo','sa','DBA')
go

/*

use cmf_data_lm
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use collectpickup
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use collectpickup_lm
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use cpscan
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use dqm_data_lm
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use eput_db
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use evkm_data
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use liberty_db
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use linehaul_data
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use lm_stage
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use lmscan
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use master
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use model
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use mpr_data
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use mpr_data_lm
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use pms_data
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use rate_update
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use rev_hist
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use rev_hist_lm
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use shippingws
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use sort_data
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use svp_cp
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use svp_lm
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use sybmgmtdb
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use sybsecurity
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use sybsystemdb
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use sybsystemprocs
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use tempdb
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use tempdb1
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use tempdb2
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use tempdb3
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use tempdb4
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use tempdb5
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use tempdb6
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use tempdb7
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use tempdb8
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use tempdb9
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use termexp
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO
use uss
GO
select uid, loginame, name,type,db_name() as DBNAME,case type when 'U' then 'alter table '+ name + ' modify owner dbo' when 'P' then 'alter table '+ name + ' modify owner dbo' end as Command from sysobjects where loginame != NULL and uid =1 and loginame = "dryden_zarate" and type not in ('D')
GO

*/