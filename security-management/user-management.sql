--creating server-wite role
use master create role developer_write
go
use mpr_data_lm
go

--adding user to role
grant role developer_write to sukhmanbir_kaur
go

--adding user to database
exec sp_adduser N'sukhmanbir_kaur', N'sukhmanbir_kaur', N'public'
GO

exec sp_addalias webpool_canshipws, 'dbo'
go

--granting permissions to role dynamically to all tables and views
declare grantPermission scroll cursor
for select name from sysobjects --where type ='U' or type = 'V' 
go
declare @temp varchar(255)
declare @query varchar(255)
open grantPermission
fetch next from grantPermission into @temp

while @@fetch_status=0
begin
 select @query = "grant all on " + @temp + " to developers"
 execute (@query)
 fetch next from grantPermission into @temp
end

deallocate grantPermission
go
--checking assigned permissions
exec sp_helprotect sukhmanbir_kaur
go
exec sp_helprotect developer_write
go

--GET USER AND ITS MAPPINGS INSIDE THE DATABASE
declare @user varchar(100)
set @user = 'sort_data_maint'

SELECT
u.name as UserInDB,
l.name as LoginName,
g.name as UserGroup,
CASE l.status 
    WHEN null 
    THEN 0 
    ELSE l.status 
END as status,
o.name as 'alias'
FROM sysusers u 
LEFT JOIN master..syslogins l ON u.suid = l.suid 
LEFT JOIN sysusers g ON u.gid = g.uid 
LEFT JOIN sysalternates a ON u.suid = a.altsuid 
LEFT JOIN master..syslogins o ON a.suid = o.suid 
WHERE 1=1 AND u.suid != -2 AND u.uid != u.gid 
and (u.name = @user or l.name = @user or o.name = @user) --provide user name here
ORDER BY u.name
go