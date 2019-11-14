
CREATE OR REPLACE PROCEDURE dbo.rp_kill_recvsleep_sessions
as

Declare @spid int,@user varchar(100),@str nvarchar(128)

select top 1 @user=username 
from dba.dbo.monNumSession 
where 1=1
and NumSessions>50 
and snapTime = (select max(snapTime) from dba.dbo.monNumSession)
order by NumSessions desc

declare spidcurs cursor for
select spid from master..sysprocesses where status='recv sleep' and suser_name(suid)=@user
open spidcurs
fetch next from spidcurs into @spid
While @@fetch_status = 0
Begin

Select @str = 'Kill '+convert(nvarchar(30),@spid)
exec(@str)
--print @str

fetch next from spidcurs into @spid
End
Deallocate spidcurs
GO


select * 
from dba.dbo.monNumSession 
where 1=1
and NumSessions>50 
and snapTime = (select max(snapTime) from dba.dbo.monNumSession)
order by NumSessions desc
