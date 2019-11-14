select DB = db_name(),
TableName = object_name(i.id, db_id()),
IndexName = i.name,
IndID = i.indid
,a.UsedCount 
from master..monOpenObjectActivity a, 
sysindexes i
where a.ObjectID = i.id
and a.IndexID = i.indid
and (a.UsedCount = 0 or a.UsedCount is NULL)
and i.indid > 0
and i.id > 99 -- No system tables
--and db_name()='svp_cp'
and object_name(i.id, db_id())='address'
order by 2, 4 asc
go


declare @low bigint 

SELECT
	@low = d.low/1024 
from
	master.dbo.spt_values d 
where
	d.number = 1 and
	d.type = 'E' 

SELECT 
	USER_NAME(tab.uid),
	tab.name as 'Table Name',
	ind.name as 'Index Name',
	row_count(db_id(), tab.id) AS 'row_count',
	ind.indid
--	index_size_kb = @low * data_pages(db_id(db_name()), ind.id, ind.indid),
	,index_reserved_kb = 
	case ind.indid 
		when 1 
		then @low * (reserved_pages(db_id(db_name()),ind.id, 0) + reserved_pages(db_id(db_name()),ind.id, ind.indid)) 
		else @low * (reserved_pages(db_id(db_name()),ind.id, ind.indid)) 
	end
    
--	--convert(decimal(10,2),(c.leafcnt*(@@maxpagesize/1000.00)/1000.00)) as 'IndexMBytes'
--	,index_unused_kb = 
--	case ind.indid 
--		when 1 
--		then @low * ((reserved_pages(db_id(db_name()),ind.id, 0) + reserved_pages
--		(db_id(db_name()),ind.id, ind.indid)) - (data_pages(db_id(db_name()), ind.
--		id, 0) + data_pages(db_id(db_name()), ind.id, ind.indid))) 
--		else @low * (reserved_pages(db_id(db_name()),ind.id, ind.indid) - 
--		data_pages(db_id(db_name()), ind.id, ind.indid)) 
--	end
	,ind.crdate
	,ind.fill_factor
	--,m.UsedCount

FROM
	sysindexes ind,
	sysobjects tab,
	syssegments seg 
	,systabstats c
	,master..monOpenObjectActivity m
WHERE
	ind.id = tab.id AND
	ind.indid > 0.0 AND
	ind.indid < 255.0 
	and ind.segment = seg.segment 
	and c.id = tab.id 
	and c.indid = ind.indid
	and UPPER(USER_NAME(tab.uid)) = 'DBO' 
	and m.UsedCount	= 0
	and db_name(m.DBID)=db_name()
	and m.ObjectID = ind.id
	and m.IndexID = ind.indid
	
ORDER BY
	index_reserved_kb desc
go