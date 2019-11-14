use master
go
create login test_user with password '1q2w3e4r!Q@W#E$R'
go

revoke role developers from test_user
go

exec sp_addgroup N'developer'
go
exec sp_changegroup N'developer', N'frank_orourke_upd'
exec sp_changegroup N'developer', N'kanya_kotur_upd'
exec sp_changegroup N'developer', N'alex_vasilenco_upd'
exec sp_changegroup N'developer', N'dominic_shou_upd'
exec sp_changegroup N'developer', N'keith_borgmann_upd'
exec sp_changegroup N'developer', N'frasier_bellam_upd'
exec sp_changegroup N'developer', N'jim_pepper_upd'
exec sp_changegroup N'developer', N'frank_orourke'
exec sp_changegroup N'developer', N'alex_vasilenco'
exec sp_changegroup N'developer', N'frank_qi'
exec sp_changegroup N'developer', N'kanya_kotur'
exec sp_changegroup N'developer', N'robbie_toyota'
exec sp_changegroup N'developer', N'frank_qi_upd'
exec sp_changegroup N'developer', N'kenny_ip'
exec sp_changegroup N'developer', N'glenn_mcfarlane'
go

select sl.name, sr.name 
,'exec sp_adduser '''+sl.name+''','''+sl.name+''',''public'''
,'exec sp_changegroup N''developer'', N'''+sl.name+'''' 
from master..sysloginroles slr, master..syslogins sl, master..syssrvroles sr 
where slr.suid = sl.suid and slr.srid = sr.srid and sr.name = 'developers'
go

select 'grant select on ' + name + ' to developer' from sysobjects where type = 'U'
go

declare spidcurs cursor for
select 'grant select on ' + name + ' to developer' from sysobjects where type = 'U'
go
Declare @str varchar(1000)

open spidcurs
fetch next from spidcurs into @str
While @@fetch_status = 0
Begin

exec(@str)

set @str=''

fetch next from spidcurs into @str
End
Deallocate spidcurs
go

declare spidcurs cursor for
select 'grant exec on ' + name + ' to developer' from sysobjects where type = 'P'
go
Declare @str varchar(1000)

open spidcurs
fetch next from spidcurs into @str
While @@fetch_status = 0
Begin

exec(@str)

set @str=''

fetch next from spidcurs into @str
End
Deallocate spidcurs
go