use lmscan
go
select owner = user_name(uid), name, type 
from sysobjects 
where 1=1
--and name in ("pickup_call",'shipper','terminal')
and user_name(uid)<>'dbo'
order by user_name(uid)
go
alter table robbie_toyota.* modify owner dbo
go
alter table robbie_toyota.pickup_call modify owner dbo
go
alter table rafael_leandro.terminal modify owner dbo
go
alter table DBA.* modify owner dbo
go
alter table rafael_leandro.* modify owner dbo
go
use cmf_data_lm
go
select owner = user_name(uid), name, type 
from sysobjects where name in ("cmfshipr",'cmfrates','disp_cust') 
go

alter table robbie_toyota.cmfshipr modify owner dbo
go
alter table DBA.cmfrates modify owner dbo
go
alter table DBA.disp_cust modify owner dbo
go
alter table DBA.* modify owner dbo 
go
