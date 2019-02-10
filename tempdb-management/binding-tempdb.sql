sp_tempdb "bind","lg","sa","GR","default"--one login can be bound to a group, which can be bound to a tempdb

sp_tempdb "bind","lg","sa","DB","tempdb1"-- a login can also be bound directly to a tempdb

sp_tempdb 'unbind','lg','sa' --unbinding a login 

exec sp_tempdb 'show' --shows the bindings of database groups and logins
go
exec sp_tempdb 'who',tempdb7 --shows the connections using the specified tempdb
go