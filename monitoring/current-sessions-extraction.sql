/*

recv sleep >>>  Waiting on a network read.  Immediate Kill.
send sleep >>>  Waiting on a network send.  Immediate Kill.
alarm sleep >>>  Waiting on an alarm    Immediate Kill.
lock sleep >>>  Waiting on a lock acquisition. Immediate Kill.
sync sleep >>>  Waiting on a synchronization message from another process in the family. Immediate Kill. Other processes in the family must also be brought to state in which they can be killed.
sleeping >>> Waiting on a disk I/O, or some other resource. Probably indicates a process that is running, but doing extensive disk I/O Killed when it “wakes up,” usually immediate; a few sleeping processes do not wake up and require a server restart to clear.
runnable >>> In the queue of runnable processes. Immediate Kill.
running >>> Actively running on one of the server engines. Immediate Kill.
infected >>> Server has detected serious error condition; extremely rare. kill command not recommended. Server restart probably required to clear process.
background >>> A process, such as a threshold procedure, run by Adaptive Server rather than by a user process. Immediate; use kill with extreme care. Recommend a careful check of sysprocessesbefore killing a background process.
log >>> suspend Processes suspended by reaching the last-chance threshold on the log. Immediate Kill.

*/

DECLARE @OrderBy_Criteria VARCHAR(128),@clockrate int
set @clockrate  = (select convert(int,cc.value2) from master.dbo.syscurconfigs cc inner join master.dbo.sysconfigures sc on cc.config=sc.config where sc.name='sql server clock tick length')
--set @OrderBy_Criteria = 'b' --blocked
--SET @OrderBy_Criteria = 'cpu'
SET @OrderBy_Criteria = 'spid'
--set @OrderBy_Criteria = 'd' --duration
--set @OrderBy_Criteria = 'pr' - physical reads 

SELECT
	sp.spid
	--,pw.WaitTime,wi.Description,
	--'exec sp_showplan('+cast(sp.spid as varchar(50))+')' 'Plan'
	,case query_text(sp.spid) when NULL then sp.cmd else query_text(sp.spid) end as cmd
	,CASE sp.cmd 
		WHEN 'NETWORK HANDLER' 
		THEN NULL 
		ELSE DB_NAME(sp.dbid) 
	END 'Database',
	sp.execution_time as 'extime',
	sp.status,
	SUSER_NAME(sp.suid) 'user',
	case 
	    CASE sp.clienthostname 
            WHEN '' 
            THEN sp.hostname 
            WHEN NULL 
            THEN sp.hostname 
            ELSE sp.clienthostname 
	    END
	WHEN NULL then 
	    case sp.ipaddr 
	        when '10.4.96.82' then 'lmsdc1vaproc02' 
	        when '10.3.1.223' then 'hqvmanproc1' 
	        when '10.4.96.121' then 'lmsdc1vaproc01' 
	        when '10.3.1.37' then 'hqvdstage1' 
	        --when '10.133.32.97' then 'lmsdc1vaproc01'
	        when '10.3.1.100' then 'cprhqvprtl03'
	        when '10.3.1.107' then 'cprhqvprtlstg'
	        when '10.3.1.167' then 'hqvcsw01'
	        when '10.4.96.108' then 'lmsws1'
	        when '10.4.96.43' then 'hqvlmsecomm1'
	        when '10.4.96.103' then 'lmscrystrpt1'
	        
	    end 
	    else CASE sp.clienthostname 
            WHEN '' 
            THEN sp.hostname 
            WHEN NULL 
            THEN sp.hostname 
            ELSE sp.clienthostname 
	    END
	end 'host',

	CASE sp.clientapplname 
		WHEN '' 
		THEN sp.program_name 
		WHEN NULL 
		THEN sp.program_name 
		ELSE sp.clientapplname 
	END 'program',
	sp.memusage,
	sp.cpu*@clockrate/1000 as 'CPU(ms)',
	sp.physical_io,
	sp.blocked 'blkpid',
	--case blocked when 0 then '0' else query_text(blocked) end as BlockingQuery,
	--sp.cmd,
	--tran_name 'Transaction',
	sp.time_blocked 'tblk',
	--network_pktsz 'Network Packet Size',
	--block_xloid 'Lock Owner Id',
	--ipaddr 'IP address',
	--loggedindatetime 'Last Login' ,
	--enginenum
	--,show_plan(spid,-1, -1, -1,-1)
	
	sp1.blocked as bblkpid
	,sp1.cmd as bcmd
	,sp1.status as bstatus
	,CASE sp1.clientapplname 
		WHEN '' 
		THEN sp1.program_name 
		WHEN NULL 
		THEN sp1.program_name 
		ELSE sp1.clientapplname 
	END 'bprogram',
	CASE sp1.clienthostname 
            WHEN '' 
            THEN sp1.hostname 
            WHEN NULL 
            THEN sp1.hostname 
            ELSE sp1.clienthostname 
	    END as 'bhost'
    ,SUSER_NAME(sp1.suid) 'buser'
	,case sp1.spid when NULL then 'N/A' else 'kill ' + cast(sp1.spid as varchar(50)) end as 'KillCmd'
	,(select count(*) from master..systransactions s where s.spid=sp.blocked) as '#btran'
FROM
	master.dbo.sysprocesses sp
	left join master.dbo.sysprocesses sp1 on sp.blocked = sp1.spid
--	inner join dbo.monProcessWaits pw on sp.spid = pw.SPID
--    inner join monWaitEventInfo wi on pw.WaitEventID = wi.WaitEventID
where 1=1
--and hostname = host_name()
and DB_NAME(sp.dbid) not in  ('tempdb3')
and sp.status not in ('background')
and sp.cmd not in ('HK WASH','HK GC','HK CHORES','NETWORK HANDLER','MEMORY TUNE','DEADLOCK TUNE','SHUTDOWN HANDLER','KPP HANDLER','ASTC HANDLER','CHECKPOINT SLEEP','PORT MANAGER','AUDIT PROCESS','CHKPOINT WRKR','LICENSE HEARTBEAT','JOB SCHEDULER')
and sp.status <> 'recv sleep'
and sp.spid <> @@spid 
and sp.blocked not in (select distinct spid from master..syslocks where spid not in (select spid from master..sysprocesses))
--and hostname = '670-D-102766'
--and cmd = 'AWAITING COMMAND'
--and spid=2681
--and SUSER_NAME(suid) = 'lm_data_loader'
--and blocked <> 0
--and program_name='ICS_Data_Transfer2.exe'
ORDER BY CASE @OrderBy_Criteria
        WHEN 'pr'   THEN sp.physical_io
        WHEN 'cpu'  THEN sp.cpu
        WHEN 'd'    THEN sp.execution_time
        WHEN 'b'    THEN sp.time_blocked
        WHEN 'spid' THEN sp.spid
END desc    
go		
select db_name(dbid),* from master..syslogshold
go

--kill 2070
