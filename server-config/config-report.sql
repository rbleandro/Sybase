use master
go

sp_configure "sql server clock tick length"
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
--select * from  master.dbo.sysconfigures where name ='sql server clock tick length'
--go
--select top 1 * from master.dbo.syscurconfigs where config=176
--go