select top 10 DBName,ObjectName ,Active,CPUTime,ExecutionCount ,ExecutionTime/ExecutionCount/1000 as 'AvgExecutionTime(s)',MemUsageKB,PhysicalReads,LogicalReads, CompileDate,ObjectType,PlanID--,SnapExecutionTime,SnapExecutionCount
,CAST (mp.ExecutionCount/CASE DATEDIFF(second, mp.CompileDate, GETDATE()) WHEN 0 THEN 1. ELSE DATEDIFF(second, mp.CompileDate, GETDATE()) END AS DECIMAL(19,0)) AS [Calls/Second]
,CAST (mp.ExecutionCount/CASE DATEDIFF(minute, mp.CompileDate, GETDATE()) WHEN 0 THEN 1. ELSE DATEDIFF(minute, mp.CompileDate, GETDATE()) END AS DECIMAL(19,0)) AS [Calls/Minute]
,CAST (mp.ExecutionCount/CASE DATEDIFF(hour, mp.CompileDate, GETDATE()) WHEN 0 THEN 1. ELSE DATEDIFF(hour, mp.CompileDate, GETDATE()) END AS DECIMAL(19,0)) AS [Calls/Hour]
,CAST (mp.ExecutionCount/CASE DATEDIFF(day, mp.CompileDate, GETDATE()) WHEN 0 THEN 1. ELSE DATEDIFF(day, mp.CompileDate, GETDATE()) END AS DECIMAL(19,0)) AS [Calls/dia]
--,*
from master..monCachedProcedures mp
where 1=1
--and mp.DBName = 'cpscan'
--and ObjectName='rpt_canpar_shipments_manifested_in_last_x_days'
order by CPUTime desc
go


select top 10 * 
from master..monProcessProcedures 
go

go
select top 10 * from dbo.monProcessProcedures
go
select top 10 * from dbo.monProcedureCache
go
select top 10 * from dbo.monProcessActivity
go
select top 1000 mp.*,mw.Description 
from dbo.monProcessWaits mp, monWaitEventInfo mw 
where mp.WaitEventID = mw.WaitEventID
and mp.SPID>50
go
select top 10 * from dbo.monWaitEventInfo
go
exec sp_configure 'enable stmt cache monitoring' --self explanatory
exec sp_configure 'enable monitoring' 
exec sp_configure 'statement cache size' 
go
exec sp_configure 'enable literal' --turns auto parameterization on or off
go
sp_configure "enable metrics capture" --Query metrics allow you to measure performance for your session using the sp_metrics stored procedure. 
go
sp_configure 'max SQL text monitored' --limits the size of the SQL statement that you can see (that is, it truncates past this limit).
go