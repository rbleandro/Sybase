select db_name() as 'database',name,crdate 
from sysobjects 
where crdate < dateadd(mm,-3,getdate()) 
and (name like 'bk%' or name like 'LM%' or name like 'CP%')
and name not like 'sys%'
order by crdate
go