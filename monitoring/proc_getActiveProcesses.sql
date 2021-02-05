exec dba.dbo.sp_getActiveProcesses @ExcludeSystem =1, @ExcludeDormant =1, @spid = NULL,@filterHost =NULL,@filterUser =NULL,@filterProgram =NULL,@filterStatus =NULL,@filterDatabase =NULL
go
exec dba.dbo.sp_getActiveProcesses @ExcludeSystem =0, @ExcludeDormant =0,@ExcludeActive =1, @spid = NULL,@filterHost ='LMSWS1',@filterUser ='uss',@filterProgram =NULL,@filterStatus =NULL,@filterDatabase =null
go 
exec dba.dbo.sp_getActiveProcesses @ExcludeSystem =0, @ExcludeDormant =0, @spid = 801 ,@filterHost =NULL,@filterUser =NULL,@filterProgram =NULL,@filterStatus =NULL,@filterDatabase =NULL
go
exec dba.dbo.sp_getActiveProcesses @ExcludeSystem =0, @ExcludeDormant =1, @spid = null,@filterHost =NULL,@filterUser ='lm_data_loader',@filterProgram =null,@filterStatus =NULL,@filterDatabase =null
go
exec dba.dbo.sp_getActiveProcesses @ExcludeSystem =0, @ExcludeDormant =0, @spid = null,@filterHost =NULL,@filterUser =null,@filterProgram =NULL,@filterStatus =NULL,@filterDatabase ='lmscan'
go
exec dba.dbo.sp_getActiveProcesses @ExcludeSystem =0, @ExcludeDormant =0, @spid = null,@filterHost =NULL,@filterUser =null,@filterProgram ='MOBITRAX-EXPORT.exe',@filterStatus =NULL,@filterDatabase =null
go
exec dba.dbo.sp_getActiveProcesses @ExcludeSystem =0, @ExcludeDormant =1, @spid = null,@filterHost =NULL,@filterUser =null,@filterProgram ='LM_ReturnFlows_service.exe',@filterStatus =NULL,@filterDatabase =null
go

use dba
go

CREATE OR REPLACE PROCEDURE dbo.sp_getActiveProcesses (@ExcludeSystem bit=1, @ExcludeDormant bit=1,@ExcludeActive bit=0, @spid smallint = NULL,@filterHost varchar(500)=NULL,@filterUser varchar(500)=NULL
,@filterProgram varchar(500)=NULL,@filterStatus varchar(50)=NULL,@filterDatabase varchar(100)=NULL,@showWaits bit=0,@orderby varchar(100)='user')
as

declare @cmd varchar(4000)

SELECT @cmd='
DECLARE @OrderBy_Criteria VARCHAR(128),@clockrate int
set @clockrate  = (select convert(int,cc.value2) from master.dbo.syscurconfigs cc inner join master.dbo.sysconfigures sc on cc.config=sc.config where sc.name=''sql server clock tick length'')

select ''kill '' + cast(sp.spid as varchar(50)),	sp.spid	,case query_text(sp.spid) when NULL then sp.cmd else query_text(sp.spid) end as cmd
,CASE sp.cmd  WHEN ''NETWORK HANDLER'' THEN NULL ELSE DB_NAME(sp.dbid) END ''Database''
,convert(varchar(2),floor(sp.execution_time / (1000 * 60 * 60 * 24))) + ''d:'' + convert(varchar(2),floor(sp.execution_time / (1000 * 60 * 60)) % 24) + ''h:'' + convert(varchar(2),floor(sp.execution_time / (1000 * 60)) % 60) + ''m:'' + convert(varchar(2),floor(sp.execution_time / (1000)) % 60) + ''s'' as ''duration''
,sp.status,	SUSER_NAME(sp.suid) ''user'',
CASE sp.clienthostname WHEN '''' THEN sp.hostname WHEN NULL THEN sp.hostname ELSE sp.clienthostname END ''host''
,CASE sp.clientapplname  WHEN '''' THEN sp.program_name WHEN NULL THEN sp.program_name ELSE sp.clientapplname END ''program'',
sp.memusage,	sp.cpu*@clockrate/1000 as ''CPU(ms)'',	sp.physical_io,	sp.blocked ''blkpid'', db_name(tempdb_id(sp.spid)) as tempdb,	sp.time_blocked ''tblk'',	sp.loggedindatetime ''Last Login'' ,sp1.blocked as bblkpid,sp1.cmd as bcmd,sp1.status as bstatus
,CASE sp1.clientapplname  WHEN '''' THEN sp1.program_name WHEN NULL THEN sp1.program_name ELSE sp1.clientapplname END ''bprogram'',
CASE sp1.clienthostname WHEN '''' THEN sp1.hostname WHEN NULL THEN sp1.hostname ELSE sp1.clienthostname END as ''bhost''
,SUSER_NAME(sp1.suid) ''buser'',case sp1.spid when NULL then ''N/A'' else ''kill '' + cast(sp1.spid as varchar(50)) end as ''KillCmd''
,getdate() as SnapTime
FROM master.dbo.sysprocesses sp left join master.dbo.sysprocesses sp1 on sp.blocked = sp1.spid
where 1=1 and sp.spid <> @@spid'

if @ExcludeSystem=1
    set @cmd = @cmd + ' and sp.cmd not in (''HK WASH'',''HK GC'',''HK CHORES'',''NETWORK HANDLER'',''MEMORY TUNE'',''DEADLOCK TUNE'',''SHUTDOWN HANDLER'',''KPP HANDLER'',''ASTC HANDLER'',''CHECKPOINT SLEEP'',''PORT MANAGER'',''AUDIT PROCESS'',''CHKPOINT WRKR'',''LICENSE HEARTBEAT'',''JOB SCHEDULER'') and sp.status not in (''background'') ' 

if @ExcludeDormant=1
    set @cmd = @cmd + ' and sp.status <> ''recv sleep'''

if @ExcludeActive=1
    set @cmd = @cmd + ' and sp.status = ''recv sleep'''    

if @filterHost is not null
    set @cmd = @cmd + ' and sp.hostname = '''+@filterHost+''''
     
if @filterUser is not null
     set @cmd = @cmd + ' and SUSER_NAME(sp.suid) like '''+@filterUser+''''
     
if @filterProgram is not null
     set @cmd = @cmd + ' and sp.program_name like '''+@filterProgram+''''
     
if @filterStatus is not null
    set @cmd = @cmd + ' and sp.status = '''+@filterStatus+''''
    
if @spid is not null
    set @cmd = @cmd + ' and sp.spid = ' + convert(varchar(50),@spid)
    
if @filterDatabase is not null
    set @cmd = @cmd + ' and DB_NAME(sp.dbid) in  ('''+@filterDatabase+''')'

 
--and sp.blocked not in (select distinct spid from master..syslocks where spid not in (select spid from master..sysprocesses))
--and (sp.cmd like ''%dhl_shpmt%'' or query_text(sp.spid) like ''%dhl_shpmt%'')
set @cmd = @cmd + ' 
order by ' + case @orderby when 'user' then 'SUSER_NAME(sp.suid)' 
when NULL then 'sp.spid' 
when 'program' then 'CASE sp.clientapplname  WHEN '''' THEN sp.program_name WHEN NULL THEN sp.program_name ELSE sp.clientapplname END'
when 'spid' then 'sp.spid'
when 'host' then 'CASE sp.clienthostname WHEN '''' THEN sp.hostname WHEN NULL THEN sp.hostname ELSE sp.clienthostname END'
when 'cpu' then 'sp.cpu*@clockrate/1000 desc'
end


if @showWaits =1
begin
	set @cmd = @cmd + '
delete from dba.dbo.processwaits

insert into dba.dbo.processwaits
select w.*,e.Description 
from master..monProcessWaits w 
inner join master..monWaitEventInfo e on w.WaitEventID=e.WaitEventID
where SPID='+convert(varchar(50),@spid)+'

waitfor delay ''00:00:02''

select w.SPID, t.Description,w.WaitTime - t.WaitTime as DiffWaitTime, w.Waits - t.Waits as DiffWaits
from master..monProcessWaits w 
inner join master..monWaitEventInfo e on w.WaitEventID=e.WaitEventID
inner join dba.dbo.processwaits t on t.SPID=w.SPID and t.WaitEventID=w.WaitEventID
where w.SPID='+convert(varchar(50),@spid)

end

--select @cmd
exec (@cmd)
GO
