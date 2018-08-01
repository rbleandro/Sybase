use master
go
exec sp_monitor "statement"
go
exec sp_monitor "connection"
go
exec sp_monitor
go
exec sp_monitor "procedure"
go
exec sp_opt_querystats 'select * from pubs2.dbo.authors', 'showplan,statio,option_show, plancost'
go

   