use sybsecurity
go

CREATE OR REPLACE PROCEDURE dbo.audit_thresh
as
begin
--==================
-- Let's purge data over a month old
-- Since we are bcp'ing data out and emailing it
--==================

select event into #temp from sybsecurity.dbo.event_descriptions where event in (70,18,92,27,28,41,3,10,27,64,11,28,12,16,34,40,58,19,42,71,73,74,78,84,89,104,105)

delete sybsecurity..sysaudits where eventtime < dateadd(dd,-30,getdate())
-- delete non DML audits
delete sybsecurity..sysaudits where 
event not in (select event from #temp) and dbname like 'tempdb%'

--==================

declare @audit_table_number int
/*
** Select the value of the current audit table
*/
select @audit_table_number = scc.value
from master.dbo.syscurconfigs scc, master.dbo.sysconfigures sc
where sc.config=scc.config and sc.name = 'current audit table'
/*
** Set the next audit table to be current.
** When the next audit table is specified as 0,
** the value is automatically set to the next one.
*/
exec sp_configure 'current audit table', 0, 'with truncate'
/*
** Copy the audit records from the audit table
** that became full into another table.
*/
if @audit_table_number = 1
begin
insert sybsecurity..sysaudits
select event, eventmod, spid, eventtime, sequence, suid, dbid, objid, xactid, loginname, dbname, objname, objowner, extrainfo, nodeid from sysaudits_01 
where 
event in (select event from #temp) and dbname not like 'tempdb%' and dbname not in ('sybsystemprocs')

truncate table sysaudits_01
end

if @audit_table_number = 2
begin
insert sybsecurity..sysaudits
select event, eventmod, spid, eventtime, sequence, suid, dbid, objid, xactid, loginname, dbname, objname, objowner, extrainfo, nodeid from sysaudits_02 
where 
event in (select event from #temp) and dbname not like 'tempdb%' and dbname not in ('sybsystemprocs')

truncate table sysaudits_02
end

if @audit_table_number = 3
begin
insert sybsecurity..sysaudits
select event, eventmod, spid, eventtime, sequence, suid, dbid, objid, xactid, loginname, dbname, objname, objowner, extrainfo, nodeid from sysaudits_03 
where 
event in (select event from #temp) and dbname not like 'tempdb%' and dbname not in ('sybsystemprocs')

truncate table sysaudits_03
end

if @audit_table_number = 4
begin
insert sybsecurity..sysaudits
select event, eventmod, spid, eventtime, sequence, suid, dbid, objid, xactid, loginname, dbname, objname, objowner, extrainfo, nodeid from sysaudits_04 
where 
event in (select event from #temp) and dbname not like 'tempdb%' and dbname not in ('sybsystemprocs')

truncate table sysaudits_04
end

if @audit_table_number = 5
begin
insert sybsecurity..sysaudits
select event, eventmod, spid, eventtime, sequence, suid, dbid, objid, xactid, loginname, dbname, objname, objowner, extrainfo, nodeid from sysaudits_05 
where 
event in (select event from #temp) and dbname not like 'tempdb%' and dbname not in ('sybsystemprocs')

truncate table sysaudits_05
end

if @audit_table_number = 6
begin
insert sybsecurity..sysaudits
select event, eventmod, spid, eventtime, sequence, suid, dbid, objid, xactid, loginname, dbname, objname, objowner, extrainfo, nodeid from sysaudits_06 
where 
event in (select event from #temp) and dbname not like 'tempdb%' and dbname not in ('sybsystemprocs')

truncate table sysaudits_06
end

if @audit_table_number = 7
begin
insert sybsecurity..sysaudits
select event, eventmod, spid, eventtime, sequence, suid, dbid, objid, xactid, loginname, dbname, objname, objowner, extrainfo, nodeid from sysaudits_07 
where 
event in (select event from #temp) and dbname not like 'tempdb%' and dbname not in ('sybsystemprocs')

truncate table sysaudits_07
end

if @audit_table_number = 8
begin
insert sybsecurity..sysaudits
select event, eventmod, spid, eventtime, sequence, suid, dbid, objid, xactid, loginname, dbname, objname, objowner, extrainfo, nodeid from sysaudits_08 
where 
event in (select event from #temp) and dbname not like 'tempdb%' and dbname not in ('sybsystemprocs')

truncate table sysaudits_08
end

return(0)

end
GO
