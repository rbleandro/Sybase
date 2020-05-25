/*
1. First of all identify whether cpu is going high because of some other process or dataserver process. To check this you can use prstat Unix command. If it is due to other process ask Unix SA to check but if it is due to dataserver process need to dig further into ASE server.
Below is the Unix command to check cpu utilization on Unix :
prstat -a

2. After that, login to ASE server and check what is the CPU utilization inside ASE server. To check that fire sp_monitor on interval of say 30 seconds, 4-5 times and see how is the pattern.
Note: sp_monitor output has seconds column in first row which tells about interval between two sp_monitor run and all the CPU_busy, io_busy, idle percentage is percentage time of this.
You can not directly co-relate cpu utilization shown by prstat command and sp_monitor output. For example – suppose seconds is showing 100 and cpu_busy is showing 15% that means out of 100 seconds cpu was busy for 15 seconds.

3. If sp_monitor or sp_sysmon shows that CPU utilization is high then need to identify the root cause. High CPU utilization can happen due to various reason like increase in load on server, high logical io by some spid, high spinlock ratio etc.
4. To get cpu usages by each connection, you can use below command. Which will list out CPU utilization by all connections in descending order of CPU time.
5. To analyse pressure on CPU, you can check how many processes are in running or runnable state. If these processes counts are consistently higher than online engine, that means there are load on cpu.
6. Sometimes because of high spinlock ratio also cpu utilization goes high. If consistently spinlock ratio is high then need to fine tune cache or number of engines.
7. Sometimes it is seen that sp_monitor or sp_sysmon shows low cpu utilization, whereas when checked at OS level it is high and dataserver is consuming most of the cpu. In that case probably need to carefully tune “runnable process search count”.
When cpu is not actively working on some task, it goes into loop to check for any completed I/O, if it finds then I/O busy counter is increased if not then idel counter. After completed I/O check, it checks is there any new command to process or not. This time is count as idel time. So looping into checking for new commnad is although idel from dataserver prospective but it is not idel from OS prospective.

By default runnable process search count is 2000. That means if cpu is idel it will loop 2000 times to check for any new command or completed I/O before yielding cpu to OS. So in that case reducing runnable process search count may help.
*/


exec sp_monitor connection, cpu
go

--engine load distribution
select * into #t1 from cmonThread
waitfor delay "00:01:00"
select * into #t2 from master..monThread
select a.ThreadID, a.ThreadPoolName,
(b.TaskRuns - a.TaskRuns) as TaskRuns, 
convert (numeric(6,2),(100.0 * (b.BusyTicks - a.BusyTicks))/(b.TotalTicks - a.TotalTicks)) as "Pct busy",
(b.UserTime - a.UserTime) as UserTime,
(b.SystemTime - a.SystemTime) as SystemTime
from #t1 a, #t2 b
where a.InstanceID = b.InstanceID
and a.ThreadID = b.ThreadID
and a.ThreadPoolName not in ("syb_system_pool","syb_blocking_pool")
go
--top 20 heaviest queries
Select top 20 a.SPID, p.Login,case when p.ClientApplName is null then isnull(p.Application,sp.ipaddr) else p.ClientApplName end as Appication,p.DBName, p.Command, a.CPUTime, a.PhysicalReads, a.LogicalReads
From master..monProcessActivity a, master..monProcess p, master..monProcessStatement s,master.dbo.sysprocesses sp
Where a.SPID = p.SPID and a.KPID = p.KPID and a.SPID = s.SPID and a.KPID = s.KPID and p.SPID=sp.spid and p.KPID=sp.kpid
Order by a.CPUTime desc
go
--CPU load by application/host 
Select count(a.SPID) as '#Sessions',p.Login,case when p.ClientApplName is null then isnull(p.Application,sp.ipaddr) else p.ClientApplName end as Application
,p.DBName--, p.Command
, sum(a.CPUTime) as CumulativeCPU, sum(a.PhysicalReads) as CumulativePhyReads, sum(a.LogicalReads) as CumulativeLogReads
From master..monProcessActivity a, master..monProcess p, master..monProcessStatement s,master.dbo.sysprocesses sp
Where a.SPID = p.SPID and a.KPID = p.KPID and a.SPID = s.SPID and a.KPID = s.KPID and p.SPID=sp.spid and p.KPID=sp.kpid
group by p.Login,case when p.ClientApplName is null then isnull(p.Application,sp.ipaddr) else p.ClientApplName end,p.DBName--, p.Command
order by sum(a.CPUTime) desc
go

