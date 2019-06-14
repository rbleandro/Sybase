
exec sp_tempdb "who",tempdb10 --kill all sessions returned by this 
go
exec sp_tempdb "remove",tempdb10,default
go

drop database tempdb10
go