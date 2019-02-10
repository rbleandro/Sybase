select "Host","Program","User","#Sessions"
union
SELECT
	case 
	    CASE clienthostname 
            WHEN '' 
            THEN hostname 
            WHEN NULL 
            THEN hostname 
            ELSE clienthostname 
	    END
	WHEN NULL then 
	    case ipaddr 
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
	    else CASE clienthostname 
            WHEN '' 
            THEN hostname 
            WHEN NULL 
            THEN hostname 
            ELSE clienthostname 
	    END
	end 'host',

	CASE clientapplname 
		WHEN '' 
		THEN program_name 
		WHEN NULL 
		THEN program_name 
		ELSE clientapplname 
	END 'program',
	SUSER_NAME(suid),
	convert(varchar(50),count(spid)) as 'NumSessions'
FROM master.dbo.sysprocesses sp
where 1=1
and DB_NAME(dbid) not in  ('tempdb3')
and status not in ('background')
and cmd not in ('HK WASH','HK GC','HK CHORES','NETWORK HANDLER','MEMORY TUNE','DEADLOCK TUNE','SHUTDOWN HANDLER','KPP HANDLER','ASTC HANDLER','CHECKPOINT SLEEP','PORT MANAGER','AUDIT PROCESS','CHKPOINT WRKR','LICENSE HEARTBEAT','JOB SCHEDULER')
and status <> 'recv sleep'
and spid <> @@spid 
and blocked not in (select distinct spid from master..syslocks where spid not in (select spid from master..sysprocesses))
group by CASE clientapplname 
		WHEN '' 
		THEN program_name 
		WHEN NULL 
		THEN program_name 
		ELSE clientapplname 
	END, SUSER_NAME(suid)
	,case 
	    CASE clienthostname 
            WHEN '' 
            THEN hostname 
            WHEN NULL 
            THEN hostname 
            ELSE clienthostname 
	    END
	WHEN NULL then 
	    case ipaddr 
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
	    else CASE clienthostname 
            WHEN '' 
            THEN hostname 
            WHEN NULL 
            THEN hostname 
            ELSE clienthostname 
	    END
	end 
go				
