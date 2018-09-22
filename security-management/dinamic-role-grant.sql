--adding user to role
grant role developers to alex_vasilenco
go
--checking permissions for the role
exec sp_helprotect alex_vasilenco
go

--dinamically granting permissions to all tables and views
declare grantPermission scroll cursor
for select name from sysobjects where type ='U' or type = 'V' 
go
declare @temp varchar(255)
declare @query varchar(255)
open grantPermission
fetch next from grantPermission into @temp

while @@fetch_status=0
begin
 select @query = "grant select on " + @temp + " to developers"
 execute (@query)
 fetch next from grantPermission into @temp
end

deallocate grantPermission
go
