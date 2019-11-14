use dba
go

CREATE OR REPLACE PROCEDURE dbo.sp_check_logholds (@spid smallint=null,@CheckPhantom bit=0, @All bit=0)
as

declare @cmd varchar(4000)

SELECT @cmd='select spid,db_name(dbid) as ''database'',starttime,datediff(mi,s.starttime,getdate()) as duration,name
from master..syslogshold s where 1=1' 

if @All=1 
begin
	exec (@cmd)
	return
end	
else
begin
    set @cmd = @cmd + ' and spid <>0'
	if @CheckPhantom=1
	begin
		set @cmd = @cmd + ' and not exists(select * from master..sysprocesses p where p.spid=s.spid)'
		exec (@cmd)
		return
	end
	else	
	if @spid is not null
		set @cmd = @cmd + ' and spid = ' + cast(@spid as varchar(6))
	
	exec (@cmd)
	return
end
GO

exec dba.dbo.sp_check_logholds @spid=null,@CheckPhantom=0,@All=0
go

