use sybsystemprocs 
go 

if object_id("sp_upsall") is not null 
begin 
drop proc sp_upsall 
end
go 


create procedure sp_upsall 
as 
declare @length int, @usedb smallint, @usename varchar(30), @lockcount int, @user_dbname varchar(30) 
declare db_cur cursor for select name from master..sysdatabases where dbid not in (1, 3) order by dbid 
for read only 
set nocount on 

open db_cur 
fetch db_cur into @user_dbname 
while @@sqlstatus = 0 
begin 
/* ** ** Get the id of the current database. ** */ 
select @usedb = db_id(@user_dbname) 
select @usename = rtrim(@user_dbname) 
select @lockcount = count(dbid) from master.dbo.syslocks where master.dbo.syslocks.dbid = @usedb 

if (@lockcount != 0) 
begin 
/* ** ** show all the process info for the default database. ** */ 
print "--------------------------------------------------------------------" 
print " Processes in the %1! database",@usename 
print"---------------------------------------------------------" 
select spid = convert(char(4), master.dbo.sysprocesses.spid), fid = convert(char(4), master.dbo.sysprocesses.fid)
, table_name = convert(char(16), object_name(master.dbo.syslocks.id,@usedb)), page = convert(char(10),page)
, program=convert(char(8),program_name), trans= convert(char(12),tran_name), blk=convert(char(3),blocked),
blk_time = convert(char(6), master.dbo.sysprocesses.time_blocked), line = convert(char(5), master.dbo.sysprocesses.linenum) 
from master.dbo.syslocks, master.dbo.spt_values, master.dbo.syslogins, master.dbo.sysprocesses 
where master.dbo.syslocks.type = master.dbo.spt_values.number and master.dbo.sysprocesses.suid = master.dbo.syslogins.suid 
and master.dbo.spt_values.type = "L" and master.dbo.syslocks.spid = master.dbo.sysprocesses.spid 
-- and master.dbo.sysprocesses.spid = -- master.dbo.sysprocesses.fid 
and master.dbo.syslocks.dbid = @usedb 

union 

select spid=convert(char(4),spid), fid=convert(char(4),fid), table_name="--Locked--", page="--Locked--"
, program=convert(char(8), program_name), trans=convert(char(12), tran_name), blk=convert(char(3), blocked)
, blktime=convert(char(6), time_blocked), line = convert(char(5), linenum) 
from master.dbo.sysprocesses where blocked>0 
order by spid, table_name, program, page 
end 
fetch db_cur into @user_dbname 
end 
close db_cur 
deallocate cursor db_cur 
go

