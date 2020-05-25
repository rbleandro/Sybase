use sybsecurity
go
drop table event_descriptions
go
create table event_descriptions(event int, description varchar(255))
go
declare @a int
select @a=1
while (@a<120)
begin
      insert event_descriptions values (@a, audit_event_name(@a))
      select @a=@a + 1
end
go
select * from event_descriptions
go
