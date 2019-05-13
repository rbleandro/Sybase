/* 
dbcc log (dbid, objid, pageno, rowno, nrecs, type, printopt)
dbid     - database ID
objid    - can be < 0, zero, or > 0. Meaning of this
           option depends on the values of 'pageno'
           and/or 'rowno'. For example, if objid >0 and
           'pageno' and 'rowno' = 0, all records for
           that object are displayed.
pageno   - page number (or 0)
rowno    - row number (or 0)
nrecs    - number of records and log scan direction
type     - the type of log record to display
printopt - denotes display options
           0 - display header and data
           1 - display header only.
 */
declare @dbid int
select @dbid=db_id('cmf_data_lm')
dbcc log(@dbid)

select * from master..syslogshold

--to free up the transaction log in a non-production environment

select db_name(dbid),* from master..syslogshold --check the syslogshold internal view to see what is holding the log
go
use cmf_data_lm
go
dbcc settrunc(ltm,ignore) -- clear every flag locking log entries (in case you have replication, high availability or other log dependent feature active)
go
checkpoint cmf_data_lm --flushes the log entries to disk
go
dump tran cmf_data_lm with truncate_only --if the checkpoint command does not free up the log, truncate the transaction log with this command 
go

select db_name(dbid),* from master..syslogshold --check the syslogshold internal view to see what is still holding the log
go
exec sp_config_rep_agent cmf_data_lm,disable --if you performed a dump/load operation to create the database and the origin database was being replicated, disable the replication agent after the load
go


DBCC DBREPAIR(cpscan, fixlogfreespace, scanlogchain , 1) -- use this to recalculate log free space. This can be useful when you're trying to use the "alter database log off" command.
go