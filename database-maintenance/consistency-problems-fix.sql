/***** CONFIGURING *****/
use lmscan
go
exec sp_dbcc_configreport
go
sp_dbcc_updateconfig lmscan, "max worker processes", "18"
go
sp_configure "number of worker processes", 2 
go

/***** CHECKING *****/
dbcc checkstorage 
go
dbcc checkverify
go
exec sp_dbcc_runcheck cpscan --runs checkstorage,checkverify and sp_dbcc_recommendations in one command
go

/***** REPORTING *****/
use termexp exec sp_listsuspect_object
go
exec sp_dbcc_recommendations "lmscan"
go
select db_name(dbid),* from dbccdb..dbcc_operation_log
go
exec sp_dbcc_patch_finishtime lmscan, 1
go
exec sp_dbcc_faultreport "short","lmscan"
go
select * from dbccdb..dbcc_faults
go


/***** FIXING *****/
dbcc checkalloc ("lmscan",fix)-- requires database to be on single user mode
go
dbcc checktable("sales_churn")
go
--dbcc indexalloc("shipper",fix)
dbcc tablealloc("shipper",'optimized',fix)--* lmscan
go
dbcc tablealloc("empstats",'optimized',fix)--* lmscan
go
--dbcc tablealloc("driver_stats",'optimized',fix)
go
--dbcc tablealloc("tttl_ps_pickup_shipper",'optimized',fix)
go
dbcc checktable("tttl_ev_event")
go

dbcc dbrepair(rev_hist, redo_shrink) --to fix objects left inconsistent after a failed shrink op
go