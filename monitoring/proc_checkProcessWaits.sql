use dba
go
--alter table dba.dbo.processwaits add WaitEventID smallint
go
create or replace procedure checkProcessWaits (@spid int, @showPlan bit, @DiffOnly bit)
as

--declare @spid int
--set @spid=327
if @DiffOnly is null 
    set @DiffOnly=0


if @showPlan=1
    exec sp_showplan @spid

if @DiffOnly=1
begin
    delete from dba.dbo.processwaits
    
    insert into dba.dbo.processwaits
    select w.*,e.Description
    from master..monProcessWaits w 
    inner join master..monWaitEventInfo e on w.WaitEventID=e.WaitEventID
    where SPID=@spid
    
    waitfor delay '00:00:02'
    
    select w.SPID, t.Description,w.WaitTime - t.WaitTime as DiffWaitTime, w.Waits - t.Waits as DiffWaits,w.WaitEventID
    from master..monProcessWaits w 
    inner join master..monWaitEventInfo e on w.WaitEventID=e.WaitEventID
    inner join dba.dbo.processwaits t on t.SPID=w.SPID and t.WaitEventID=w.WaitEventID
    where w.SPID=@spid
end

else
begin
    select w.*,e.Description ,e.WaitEventID
    from master..monProcessWaits w 
    inner join master..monWaitEventInfo e on w.WaitEventID=e.WaitEventID
    where SPID=@spid
end
go