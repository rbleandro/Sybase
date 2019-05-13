use master
go

select 	distinct Config_Name = name,
			Config_Value = convert(char(32), space(11-char_length(
			isnull(a.value2, convert(char(32), a.value)))) +
			isnull(a.value2, convert(char(32), a.value))),
			Run_Value = convert(char(11), space(11-char_length(
			isnull(b.value2, convert(char(32), b.value)))) +
			isnull(b.value2, convert(char(32), b.value))),
			Unit =  b.unit

from master.dbo.sysconfigures a, master.dbo.syscurconfigs b
where
a.config = b.config
and a.parent != 19
and a.config != 19
go

sp_monitorconfig "procedure cache"
go

dbcc deleteplan('svp_cp', 'svp_report_customer', 'all')
go
dbcc traceon(3604)
go
dbcc proc_cache(free_unused)
go
dbcc proc_cache(flush_elc)
go
dbcc purgesqlcache
go
dbcc traceoff(3604)
go
exec sp_configure    "procedure cache size", 3840000
go



select
case ObjectType
when 'stored procedure'
then 'dbcc proc_cacherm(P,' + DBName + ',' + ObjectName + ')'
when 'trigger procedure'
then 'dbcc proc_cacherm(T,' + DBName + ',' + ObjectName + ')'
when 'view'
then 'dbcc proc_cacherm(V,' + DBName + ',' + ObjectName + ')'
when 'default value spec'
then 'dbcc proc_cacherm(D,' + DBName + ',' + ObjectName + ')'
when 'rule'
then 'dbcc proc_cacherm(R,' + DBName + ',' + ObjectName + ')'
end, *
from master..monCachedProcedures
go
