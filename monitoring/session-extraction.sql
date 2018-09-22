--truncate table tempdb1.dbo.dba_mon_processes
go
alter table tempdb1.dbo.dba_mon_processes add constraint pk_currsessions primary key (snapTime,spid)
go
exec sp_getRunningProcesses
go
select snapTime,program,spid,ShowPlan,DB,KillCmd,execution_time,status,username,host,memusage,cpu,physical_io,BlkPID,cmd,BlkTime,NetPackSize,IPAddr,LastLogin       
from tempdb1.dbo.dba_mon_processes 
where snapTime between '2018-09-21 09:55:00' and '2018-09-21 10:15:00'
order by snapTime, program
go

select top 10 * 
from tempdb1..dba_mon_processes 
where  1=1
and program not in ('uvsh.exe','isql','uvsh')
--and execution_time=1497938
order by execution_time desc 
go
