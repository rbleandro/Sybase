if object_id('#multdb_dbs') is not null
drop table #multdb_dbs
go
create or replace procedure return_unbound_tempdb
as
declare @grptdb_stat int, @isSDC		int
create table #multdb_dbs(dbname varchar(255),instancename varchar(255) null,groupname varchar(255))

select @isSDC = case 
when @@clustermode = "shared disk cluster" then 1
else 0
end

if (@isSDC = 1)
select @grptdb_stat = number
from master.dbo.spt_values
where   type = "D3" and name = "local user temp db"
else
select @grptdb_stat = number 
from master.dbo.spt_values
where   type = "D3" and name = "user created temp db"

if @isSDC = 0 and 
exists (select * 
     from master..sysattributes
     where class = 16
     AND attribute = 0
     AND object_type = 'GR'
     AND object_cinfo = "default")
begin
insert into #multdb_dbs(dbname, groupname)
  values ("tempdb", "default")
end

insert into #multdb_dbs(dbname, instancename, groupname)
select a.object_cinfo, instance_name(a.object_info2), b.object_cinfo
from master..sysattributes a, master..sysattributes b
where a.class = 16 
AND b.class = 16
AND a.object_type = 'D ' 
AND b.object_type = 'GR'
AND a.object = b.int_value

select name,'#','Unbound'
from master..sysdatabases
where status3 & @grptdb_stat != 0 AND name NOT IN
(select dbname from  #multdb_dbs)

go

