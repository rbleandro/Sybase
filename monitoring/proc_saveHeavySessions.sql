drop table dba.dbo.heavy_queries
go
CREATE TABLE dba.dbo.heavy_queries  ( 
	SPID      	int NOT NULL,
	CpuTime   	int NOT NULL,
	SQLText   	varchar(16384) NULL 
	,SnapTime datetime default getdate()
	)
LOCK DATAROWS
GO

alter table dbo.heavy_queries add constraint PK_heavy_queries primary key (SnapTime,SPID)
go

create or replace procedure dbo.saveHeavySessions(@threshold int=1000)
as
begin
set nocount on

delete from dba.dbo.heavy_queries where SnapTime < dateadd(day,-7,getdate())

declare @spid int,@sqltext varchar(16384),@cputime int,@partialtext varchar(255)

select s.SPID,s.CpuTime,t.LineNumber,t.SequenceInLine,t.SQLText
into #heavysession
from master..monProcessStatement s, master..monProcessSQLText t 
where s.SPID = t.SPID and CpuTime > @threshold 

declare c1 cursor for select distinct SPID,CpuTime from #heavysession
open c1
fetch next from c1 into @spid,@cputime
while @@fetch_status<>-1
begin
    set @sqltext=""
    declare c2 cursor for select SQLText from #heavysession where SPID=@spid order by LineNumber,SequenceInLine
    open c2
    fetch next from c2 into @partialtext
    while @@fetch_status<>-1
    begin
        if (len(@sqltext)+len(@partialtext)) < 1940
            set @sqltext=@sqltext+@partialtext
        
        fetch next from c2 into @partialtext
    end
    close c2
    deallocate c2
    
    insert into dba.dbo.heavy_queries(SPID,CpuTime,SQLText,SnapTime) values (@spid,@cputime,@sqltext,getdate())
    
    fetch next from c1 into @spid,@cputime
end
close c1
deallocate c1

end
go

exec dba.dbo.saveHeavySessions
go
--delete from dba.dbo.heavy_queries
go
select case when len(SQLText)<=50 then SQLText else 'Check the table by Snaptime+spid' end as SQLText,'#',max(CpuTime) as CPUTime,'#',max(SnapTime) as SnapTime,'#',max(SPID) as spid
from dba.dbo.heavy_queries
where 1=1
group by SQLText
--order by SQLText, LineNumber
go
--select * from dba.dbo.heavy_queries
go
--select s.*,'***************',t.*
--from master..monProcessStatement s, master..monProcessSQLText t 
--where s.SPID = t.SPID and CpuTime > 1000 
--go
