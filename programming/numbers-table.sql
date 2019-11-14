use dba
go
DROP TABLE Numbers
go
DECLARE @RunDate datetime
SET @RunDate=GETDATE()
SELECT TOP 10000 Number=identity(10) 
    INTO Numbers_aux
    FROM sysobjects s1       --use sys.columns if you don't get enough rows returned to generate all the numbers you need
    ,syscolumns s2 --use sys.columns if you don't get enough rows returned to generate all the numbers you need
go
create table Numbers (N int)
go
insert Numbers
select * from Numbers_aux
go
DROP TABLE Numbers_aux
go
ALTER TABLE Numbers ADD CONSTRAINT PK_Numbers PRIMARY KEY CLUSTERED (Number)
go
SELECT top 25 * FROM Numbers
go
set identity_insert Numbers off
insert into Numbers(Number) values(0)
go

--example usage(get number of records inserted per hour within a time frame)

declare @date datetime
set @date = '2019-08-09'
select 
convert(date,@date),N1.N as hour ,isnull(a.qty,0)
from dba..Numbers N1 
left join 
(
    select count(*) as qty,  datepart(hh,updated_on_cons) as h
    from lmscan..tttl_dr_delivery_record  
    where updated_on_cons >= @date
    and updated_on_cons < dateadd(dd,1,@date)
    group by datepart(hh,updated_on_cons)
) a on a.h = N1.N
where N1.N <=23
order by N1.N
go