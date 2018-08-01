use lmscan
go

select
	USER_NAME(tab.uid),
	ind.name,
	tab.name,
	case status when 0 then 'NONCLUSTERED' WHEN 2050 then 'PRIMARY KEY' else convert(varchar(50),status) end as 'status',
	status2,
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 1),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 2),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 3),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 4),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 5),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 6),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 7),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 8),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 9),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 10),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 11),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 12),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 13),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 14),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 15),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 16),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 17),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 18),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 19),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 20),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 21),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 22),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 23),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 24),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 25),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 26),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 27),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 28),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 29),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 30),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 31),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 1),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 2),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 3),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 4),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 5),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 6),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 7),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 8),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 9),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 10),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 11),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 12),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 13),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 14),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 15),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 16),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 17),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 18),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 19),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 20),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 21),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 22),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 23),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 24),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 25),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 26),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 27),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 28),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 29),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 30),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 31) 
from
	sysindexes ind,
	sysobjects tab 
where
	ind.id = tab.id and
	ind.indid > 0.0 and
	ind.indid < 255.0 and
	tab.name = 'tttl_ie_international_events' 
	--and	ind.name = 'pk_tttl_ie_international_events' 
	and	USER_NAME(tab.uid) = 'dbo'
	
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
	ind.name,
	tab.name,
	ind.status,
	ind.status2,
	bunique = (ind.status & 2),
	bident = (ind.status2 & 4),
	bclustered = ((ind.status & 16) | (ind.status2 & 512)),
	seg.name,
	ind.indid,
	index_size_kb = @low * data_pages(db_id('lmscan'), ind.id, ind.indid),
	index_reserved_kb = 
	case ind.indid 
		when 1 
		then @low * (reserved_pages(db_id('lmscan'),ind.id, 0) + reserved_pages(db_id('lmscan'),ind.id, ind.indid)) 
		else @low * (reserved_pages(db_id('lmscan'),ind.id, ind.indid)) 
	end,
	index_data_kb = 
	case ind.indid 
		when 1 
		then @low * data_pages(db_id('lmscan'), ind.id, 0) 
		else @low * data_pages(db_id('lmscan'), ind.id, ind.doampg) 
	end,
	index_unused_kb = 
	case ind.indid 
		when 1 
		then @low * ((reserved_pages(db_id('lmscan'),ind.id, 0) + reserved_pages
		(db_id('lmscan'),ind.id, ind.indid)) - (data_pages(db_id('lmscan'), ind.
		id, 0) + data_pages(db_id('lmscan'), ind.id, ind.indid))) 
		else @low * (reserved_pages(db_id('lmscan'),ind.id, ind.indid) - 
		data_pages(db_id('lmscan'), ind.id, ind.indid)) 
	end,
	ind.crdate,
	ind.fill_factor,
	ind.maxrowsperpage,
	ind.res_page_gap,
	ind.status3,
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 1),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 2),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 3),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 4),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 5),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 6),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 7),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 8),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 9),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 10),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 11),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 12),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 13),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 14),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 15),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 16),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 17),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 18),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 19),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 20),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 21),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 22),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 23),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 24),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 25),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 26),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 27),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 28),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 29),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 30),
	index_col(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 31),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 1),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 2),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 3),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 4),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 5),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 6),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 7),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 8),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 9),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 10),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 11),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 12),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 13),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 14),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 15),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 16),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 17),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 18),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 19),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 20),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 21),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 22),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 23),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 24),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 25),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 26),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 27),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 28),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 29),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 30),
	index_colorder(USER_NAME(tab.uid) + '.' + tab.name, ind.indid, 31),
	tab.sysstat2,
	ind.status4 
FROM
	sysindexes ind,
	sysobjects tab,
	syssegments seg 
WHERE
	ind.id = tab.id AND
	ind.indid > 0.0 AND
	ind.indid < 255.0 AND
	ind.segment = seg.segment AND
	tab.name = 'tttl_ie_international_events' AND
	UPPER(USER_NAME(tab.uid)) = 'DBO' 
ORDER BY
	(ind.status & 16)
go