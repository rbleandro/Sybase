--list all non-proxy tables
select 'grant all on ' + name + ' to ava_aqui' from sysobjects where type = 'U' and sysstat2 & 1024 <> 1024 
go
