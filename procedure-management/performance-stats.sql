select ObjectName ,Active,CPUTime,ExecutionCount ,ExecutionTime /1000 ExecutionTime_in_Sec,MemUsageKB,PhysicalReads,LogicalReads, CompileDate,ObjectType,PlanID--,SnapExecutionTime,SnapExecutionCount
--into dba.dbo.cwparcel_live_routines_perf_stats
from master..monCachedProcedures mp
where 1=1
and mp.DBName = 'rev_hist'
--and ObjectName='invoice_shipments_rbc'
and ObjectName in (
select distinct o.name 
from sysobjects o,
    syscomments c
where o.id=c.id
--and o.type='P'
and (c.text like "%cwparcel_live%"
or  exists(
    select 1 from syscomments c2 
        where c.id=c2.id 
        and c.colid+1=c2.colid 
        and right(c.text,100)+ substring(c2.text, 1, 100) like "%cwparcel_live%" 
    )
)
)
order by ObjectName, CPUTime desc
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