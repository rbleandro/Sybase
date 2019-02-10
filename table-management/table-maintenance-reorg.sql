--command to run optdiag
--$SYBASE/$SYBASE_ASE/bin/optdiag statistics cmf_data_lm -Usa -o /home/sybase/db_backups/cmfdatalm_stats.opt -SCPDB1
--$SYBASE/$SYBASE_ASE/bin/optdiag statistics cpscan -Usa -o /home/sybase/db_backups/cpscan_stats.opt -SCPDB1
--$SYBASE/$SYBASE_ASE/bin/optdiag statistics cmf_data_lm..waybill_prefix -Usa -o /home/sybase/db_backups/cmfdatalm_stats.opt -SCPDB1
use canada_post
go
select top 10 object_name(s.id) tname,forwrowcnt,delrowcnt,unusedpgcnt
,data_pages(db_id(), o.id, 0) as '#pages', forwrowcnt*100/data_pages(db_id(), o.id, 0) as '%forwrowcnt', delrowcnt*100/data_pages(db_id(), o.id, 0) as '%delrowcnt', unusedpgcnt*100/data_pages(db_id(), o.id, 0) as '%unusedpgcnt'
,rowcnt, 'use '+db_name()+' reorg compact ' + object_name(s.id) as command
from systabstats s inner join sysobjects o on s.id=o.id
where o.type='U'
and rowcnt>0
order by forwrowcnt desc
go
select top 10 object_name(s.id) tname,forwrowcnt,delrowcnt,unusedpgcnt
,data_pages(db_id(), o.id, 0) as '#pages', forwrowcnt*100/data_pages(db_id(), o.id, 0) as '%forwrowcnt', delrowcnt*100/data_pages(db_id(), o.id, 0) as '%delrowcnt', unusedpgcnt*100/data_pages(db_id(), o.id, 0) as '%unusedpgcnt'
,rowcnt, 'use '+db_name()+' reorg compact ' + object_name(s.id) as command
from systabstats s inner join sysobjects o on s.id=o.id
where o.type='U'
order by delrowcnt desc
go
select top 10 object_name(s.id) tname,forwrowcnt,delrowcnt,unusedpgcnt
,data_pages(db_id(), o.id, 0) as '#pages', forwrowcnt*100/data_pages(db_id(), o.id, 0) as '%forwrowcnt', delrowcnt*100/data_pages(db_id(), o.id, 0) as '%delrowcnt', unusedpgcnt*100/data_pages(db_id(), o.id, 0) as '%unusedpgcnt'
,rowcnt, 'use '+db_name()+' reorg compact ' + object_name(s.id) as command
from systabstats s inner join sysobjects o on s.id=o.id
where o.type='U'
order by unusedpgcnt desc
go

select top 10 * from sysstatistics
go
--exec sp_spaceused waybill_prefix --1.669.446

use cmf_data_lm reorg forwarded_rows waybill_prefix
use cmf_data_lm reorg reclaim_space waybill_prefix
use cmf_data_lm reorg compact waybill_prefix --reclaims space and gets rid of forwaded rows

go

select indid,p.name,derived_stat(p.id,p.indid,p.name,'dpcr') as dpcr,derived_stat(p.id,p.indid,p.name,'ipcr') as ipcr,derived_stat(p.id,p.indid,p.name,'drcr') as drcr,derived_stat(p.id,p.indid,p.name,'lgio') as lgio
,lockscheme(p.id)
from cpscan..syspartitions p 
where p.id=object_id('tttl_ev_event')
go

exec sp_configure "lock scheme"
go
