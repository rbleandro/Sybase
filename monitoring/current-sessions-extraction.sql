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
go
create or replace procedure sp_getRunningProcesses
as
begin
    set nocount on
    
    DECLARE @OrderBy_Criteria VARCHAR(128)
    --set @OrderBy_Criteria = 'Logical Reads'
    SET @OrderBy_Criteria = 'cpu'
    --SET @OrderBy_Criteria = 'cps'
    --set @OrderBy_Criteria = 'execution_count'
    --set @OrderBy_Criteria = 'duration'
    --set @OrderBy_Criteria = 'Physical Reads'
    
    insert into tempdb1.dbo.dba_mon_processes
    SELECT
        spid,
        'exec sp_showplan('+cast(spid as varchar(50))+')' 'ShowPlan'
        ,CASE cmd 
            WHEN 'NETWORK HANDLER' 
            THEN NULL 
            ELSE DB_NAME(dbid) 
        END 'DB',
        'kill ' + cast(spid as varchar(50)) 'KillCmd',
        --fid ,
        execution_time,
        status,
        SUSER_NAME(suid) 'username',
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
        cpu,
        physical_io,
        blocked 'BlkPID',
        cmd,
        --tran_name 'Transaction',
        time_blocked 'BlkTime',
        network_pktsz 'NetPackSize',
        --block_xloid 'Lock Owner Id',
        ipaddr 'IPAddr',
        loggedindatetime 'LastLogin' ,
        getdate() as 'snapTime'
    
    --into tempdb1.dbo.dba_mon_processes	
    FROM
        master.dbo.sysprocesses 
    where 1=1
    
    --and hostname = host_name()
    --and hostname = 'HQVDSTAGE1'
    and DB_NAME(dbid) not in ('master','sybmgmtdb')
    and DB_NAME(dbid) not like 'tempdb%'
    and status not in ('background')
    and cmd not in ('HK WASH','HK GC','HK CHORES','NETWORK HANDLER')
    and status <> 'recv sleep'
    and spid <> @@spid and spid > 15
    --and cmd = 'LOAD DATABASE'
    --and spid=3841
    ORDER BY CASE @OrderBy_Criteria
                        WHEN 'Physical Reads' THEN physical_io
                        WHEN 'cpu' THEN cpu
                        WHEN 'Duration' THEN execution_time
                        WHEN 'Blocks' THEN time_blocked
                    END desc
end                    
go		
exec sp_getRunningProcesses
go
--select top 10 * from master.dbo.sysprocesses where spid>14	and status <> 'recv sleep'	 and DB_NAME(dbid)  in ('master','sybmgmtdb')
--go
select spid,ShowPlan,DB,KillCmd,execution_time,status,username,host,program,memusage,cpu*100000/1000 as CPU,physical_io,BlkPID,cmd,BlkTime,NetPackSize,IPAddr,LastLogin,snapTime 
 from tempdb1.dbo.dba_mon_processes where snapTime >= '6/12/2018 6:15:01 AM' 
and cmd not in ('AWAITING COMMAND') 
--and spid not in (4745,839,3315)
order by snapTime desc--,execution_time desc
go
select spid,ShowPlan,DB,KillCmd,execution_time,status,username,host,program,memusage,cpu*100000/1000 as CPU,physical_io,BlkPID,cmd,BlkTime,NetPackSize,IPAddr,LastLogin,snapTime 
 from tempdb1.dbo.dba_mon_processes where snapTime >= '6/12/2018 6:00:02 AM' and snapTime < '6/12/2018 6:00:03 AM' 
--and spid not in (select spid from tempdb1.dbo.dba_mon_processes where snapTime >= '6/12/2018 6:15:01 AM' and snapTime < '6/12/2018 6:15:02 AM') 
and cmd not in ('AWAITING COMMAND') 
and spid not in (1507)
order by execution_time desc
go
select spid,ShowPlan,DB,KillCmd,execution_time,status,username,host,program,memusage,cpu*(select convert(int,value2) from master.dbo.syscurconfigs where config=176)/1000 as CPU,physical_io,BlkPID,cmd,BlkTime,NetPackSize,IPAddr,LastLogin,snapTime 
from tempdb1.dbo.dba_mon_processes where snapTime >= '6/12/2018 3:00:00 AM' and snapTime < '6/12/2018 3:15:03 AM' 
and spid not in (select spid from tempdb1.dbo.dba_mon_processes where snapTime >= '6/12/2018 2:40:00 AM' and snapTime < '6/12/2018 3:00:00 AM') 
and cmd not in ('AWAITING COMMAND') 
--and spid not in (1507)
order by LastLogin 
go
select spid,ShowPlan,DB,KillCmd,execution_time,status,username,host,program,memusage,cpu*(select convert(int,value2) from master.dbo.syscurconfigs where config=176)/1000 as CPU,physical_io,BlkPID,cmd,BlkTime,NetPackSize,IPAddr,LastLogin,snapTime 
from tempdb1.dbo.dba_mon_processes where snapTime >= '6/14/2018 3:00:00 AM' and snapTime < '6/14/2018 3:10:03 AM' 
and spid not in (select spid from tempdb1.dbo.dba_mon_processes where snapTime >= '6/14/2018 2:56:00 AM' and snapTime < '6/14/2018 3:00:00 AM') 
--and cmd not in ('AWAITING COMMAND') 
--and spid not in (1507)
order by LastLogin 
go
select spid,ShowPlan,DB,KillCmd,execution_time,status,username,host,program,memusage,cpu*(select convert(int,value2) from master.dbo.syscurconfigs where config=176)/1000 as CPU,physical_io,BlkPID,cmd,BlkTime,NetPackSize,IPAddr,LastLogin,snapTime 
 from tempdb1.dbo.dba_mon_processes where snapTime >= '6/12/2018 6:00:02 AM' and snapTime < '6/12/2018 6:00:03 AM' 
and spid not in (select spid from tempdb1.dbo.dba_mon_processes where snapTime >= '6/12/2018 6:15:01 AM' /*and snapTime < '6/12/2018 6:15:02 AM'*/) 
and cmd not in ('AWAITING COMMAND') 
and spid not in (1507)
order by execution_time desc
go

select spid,ShowPlan,DB,KillCmd,execution_time,status,username,host,program,memusage,cpu*(select convert(int,value2) from master.dbo.syscurconfigs where config=176)/1000 as CPU,physical_io,BlkPID,cmd,BlkTime,NetPackSize,IPAddr,LastLogin,snapTime 
 from tempdb1.dbo.dba_mon_processes where host in ('CPDB2','AUTOMAN03') and username in ('rhload','sybase','sa') and program in ('isql','gentor.exe') order by snapTime
go

select spid,ShowPlan,DB,KillCmd,execution_time,status,username,host,program,memusage,cpu*(select convert(int,value2) from master.dbo.syscurconfigs where config=176)/1000 as CPU,physical_io,BlkPID,cmd,BlkTime,NetPackSize,IPAddr,LastLogin,snapTime 
from tempdb1.dbo.dba_mon_processes
where 1=1
and snapTime >= '6/14/2018 5:54:00 AM' --and snapTime < '6/14/2018 5:54:03 AM' 
and program = 'CMF_INHERITANCE.exe'
order by snapTime
go
select snapTime,count(spid)
from tempdb1.dbo.dba_mon_processes
where 1=1
and snapTime >= '6/14/2018 3:00:00 AM' --and snapTime < '6/14/2018 5:54:03 AM' 
and program = 'CMF_INHERITANCE.exe'
group by snapTime
order by snapTime
go
select snapTime,program,count(spid) SessionCount,sum(cpu*(select convert(int,value2) from master.dbo.syscurconfigs where config=176)/1000) cpuTotal,min(LastLogin) LoginTime
from tempdb1.dbo.dba_mon_processes
where 1=1
and snapTime >= '6/14/2018 3:00:00 AM' --and snapTime < '6/14/2018 5:54:03 AM' 
--and program = 'CMF_INHERITANCE.exe'
group by snapTime,program
order by snapTime,program
go
select s.SPID, s.CpuTime, t.LineNumber, t.SQLText
from master..monProcessStatement s, master..monProcessSQLText t
where s.SPID = t.SPID
order by s.CpuTime DESC
go

select spid,ShowPlan,DB,KillCmd,execution_time,status,username,host,program,memusage,cpu*(select convert(int,value2) from master.dbo.syscurconfigs where config=176)/1000 as CPU,physical_io,BlkPID,cmd,BlkTime,NetPackSize,IPAddr,LastLogin,snapTime 
from tempdb1.dbo.dba_mon_processes
where 1=1
--and spid = 2868 
--and username ='rhload' 
and host='CPDB2' and program='isql' and snapTime >= '6/14/2018 3:00:00 AM'
order by snapTime
go

use svp_cp
go

select top 30 * from svp_proc_source_failure_log order by inserted_on desc
go

select top 30 * from svp_proc_source_failure_log order by start_time desc
go

select top 50 * from svp_status_run 
where convert(time,start_date) >= '02:00:00' and convert(time,start_date) <= '07:00:00'
order by inserted_on desc
go

select top 30 * from svp_proc_parcelwork_log order by start_time desc
go