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
SET @OrderBy_Criteria = 'cpu'
--set @OrderBy_Criteria = 'd' --duration
--set @OrderBy_Criteria = 'pr' - physical reads 

SELECT
	spid,
	'kill ' + cast(spid as varchar(50)) 'KillCmd',
	'exec sp_showplan('+cast(spid as varchar(50))+')' 'Plan'
	,query_text(spid) as Query
	,CASE cmd 
		WHEN 'NETWORK HANDLER' 
		THEN NULL 
		ELSE DB_NAME(dbid) 
	END 'Database',
	execution_time,
	status,
	SUSER_NAME(suid) 'user',
	CASE clienthostname 
		WHEN '' 
		THEN hostname 
		WHEN NULL 
		THEN hostname 
		ELSE clienthostname 
	END 'host',
	CASE clientapplname 
		WHEN '' 
		THEN program_name 
		WHEN NULL 
		THEN program_name 
		ELSE clientapplname 
	END 'program',
	memusage,
	cpu*@clockrate/1000 as 'CPU(ms)',
	physical_io,
	blocked 'Blocked spid',
	case blocked when 0 then '0' else query_text(blocked) end as BlockingQuery,
	cmd,
	tran_name 'Transaction',
	time_blocked 'Time Blocked',
	network_pktsz 'Network Packet Size',
	block_xloid 'Lock Owner Id',
	ipaddr 'IP address',
	loggedindatetime 'Last Login' 
	--,show_plan(spid,-1, -1, -1,-1)
FROM
	master.dbo.sysprocesses 
where 1=1
--and hostname = host_name()
--and DB_NAME(dbid) = 'svp_lm'
and status not in ('background')
and cmd not in ('HK WASH','HK GC','HK CHORES','NETWORK HANDLER')
and status <> 'recv sleep'
and spid <> @@spid 
--and cmd = 'LOAD DATABASE'
--and spid=3841
and (suid is not null and hostname is not null) --skipping internal processes
ORDER BY CASE @OrderBy_Criteria
        WHEN 'pr' THEN physical_io
        WHEN 'cpu' THEN cpu
        WHEN 'd' THEN execution_time
        WHEN 'b' THEN time_blocked
END desc
go				
--select top 10 * from master.dbo.sysprocesses where spid>14	and status <> 'recv sleep'	
--go
