select convert(varchar(30),o.name) AS table_name,
row_count(db_id(), o.id) AS row_count,
data_pages(db_id(), o.id, 0) AS pages,
(data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024)/1024) AS mbs
--,data_pages(db_id(), o.id, 0) * (@@maxpagesize/1024) AS kbs
,'select count(*) from ' + db_name() + '..' + o.name + ' where inserted_on < dateadd(dd,-7,getdate())'
from sysobjects o
where type = 'U'
order by mbs desc
go

--
-- select
-- top 10
-- name,
-- used_pages(db_id(),id) /(1024.0 / (@@maxpagesize/1024.0) ) as "Used MB"
-- from
-- sysobjects
-- order by
-- used_pages(db_id(),id) desc
-- go