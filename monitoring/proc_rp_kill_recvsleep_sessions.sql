CREATE OR REPLACE PROCEDURE dbo.rp_kill_recvsleep_sessions(@user varchar(100))
as

Declare @spid int,@str nvarchar(128)

if exists(
select count(*) as qty
, SUSER_NAME(sp.suid) as 'user'
,CASE sp.clientapplname  WHEN '' THEN sp.program_name WHEN NULL THEN sp.program_name ELSE sp.clientapplname END as program
,CASE sp.clienthostname WHEN '' THEN sp.hostname WHEN NULL THEN sp.hostname ELSE sp.clienthostname END as hostname
from master..sysprocesses sp
where 1=1
group by CASE sp.clienthostname WHEN '' THEN sp.hostname WHEN NULL THEN sp.hostname ELSE sp.clienthostname END
,CASE sp.clientapplname  WHEN '' THEN sp.program_name WHEN NULL THEN sp.program_name ELSE sp.clientapplname END 
,SUSER_NAME(sp.suid)
having count(*)>250
and SUSER_NAME(sp.suid)=@user
)

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

