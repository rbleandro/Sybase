select "Procedure Cache Hit Ratio"=convert(bigint,(convert(bigint,Requests)-convert(bigint,Loads))*100)/Requests
from master..monProcedureCache
go

select * into #moncache_prev 
from master..monDataCache
waitfor delay "00:10:00"
select * into #moncache_cur
from master..monDataCache
select p.CacheName, 
"Hit Ratio"=((c.LogicalReads-p.LogicalReads) - (c.PhysicalReads - p.PhysicalReads))*100 / (c.LogicalReads - p.LogicalReads) 
from #moncache_prev p, #moncache_cur c 
where p.CacheName = c.CacheName
go
