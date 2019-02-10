CREATE OR REPLACE PROCEDURE dbo.sp_getRunningProcesses
as
begin
    set nocount on
    
    DECLARE @OrderBy_Criteria VARCHAR(128),@clockrate int
    set @clockrate  = (select convert(int,cc.value2) from master.dbo.syscurconfigs cc inner join master.dbo.sysconfigures sc on cc.config=sc.config where sc.name='sql server clock tick length')
    --set @OrderBy_Criteria = 'b' --blocked
    --SET @OrderBy_Criteria = 'cpu'
    SET @OrderBy_Criteria = 'spid'
    --set @OrderBy_Criteria = 'd' --duration
    --set @OrderBy_Criteria = 'pr' - physical reads 

    delete from dba.dbo.dba_mon_processes where snapTime < dateadd(dd,-7,getdate())
        
    insert into dba.dbo.dba_mon_processes
    SELECT
	sp.spid
	,sp.cmd 
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
	sp.time_blocked 'tblk',
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
	,(select count(*) from master..systransactions s where s.spid=sp.blocked) as '#btran'
	,getdate() as snapTime
    FROM
        master.dbo.sysprocesses sp
        left join master.dbo.sysprocesses sp1 on sp.blocked = sp1.spid
    where 1=1
    and DB_NAME(sp.dbid) not in  ('tempdb3')
    and sp.status not in ('background')
    and sp.cmd not in ('HK WASH','HK GC','HK CHORES','NETWORK HANDLER','MEMORY TUNE','DEADLOCK TUNE','SHUTDOWN HANDLER','KPP HANDLER','ASTC HANDLER','CHECKPOINT SLEEP','PORT MANAGER','AUDIT PROCESS','CHKPOINT WRKR','LICENSE HEARTBEAT','JOB SCHEDULER')
    and sp.status <> 'recv sleep'
    and sp.spid <> @@spid 
    and sp.blocked not in (select distinct spid from master..syslocks where spid not in (select spid from master..sysprocesses))
    
    ORDER BY CASE @OrderBy_Criteria
        WHEN 'pr'   THEN sp.physical_io
        WHEN 'cpu'  THEN sp.cpu
        WHEN 'd'    THEN sp.execution_time
        WHEN 'b'    THEN sp.time_blocked
        WHEN 'spid' THEN sp.spid
    END asc
                   
end
GO

select  * from dba.dbo.dba_mon_processes
go
select top 10 * from cmf_data_lm..points_no_ranges
go