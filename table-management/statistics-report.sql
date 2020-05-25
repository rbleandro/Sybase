--collecting the columns statistics
select  datachange(object_name(sc.id),null,null) as datachange,
        sc.name,
        --ss.statid,
        convert(int,ss.c0) as version
        ,convert(int,ss.c1) as 'status bits'
        ,convert(varchar,ss.moddate,109)  as 'modify date'
        ,ltrim(str(round(convert(double precision,ss.c2),16),24,16)) as 'range density'
        ,ltrim(str(round(convert(double precision,ss.c3),16),24,16)) as tot_density
        ,convert(int,ss.c4) as steps_act 
        ,convert(int,ss.c5) as 'requested steps'
        ,st.name
        ,ltrim(str(convert(int,ss.c7),5)) as 'datatype length'
        ,ltrim(str(convert(int,ss.c8),3)) as 'datatype precision'
        ,ltrim(str(convert(int,ss.c9),3)) as 'datatype scale'
        ,ltrim(str(round(convert(double precision,ss.c10),16),24,16)) as inequality
        ,ltrim(str(round(convert(double precision,ss.c11),16),24,16)) as inbetween
        ,ltrim(str(round(convert(double precision,ss.c14),16),24,16)) as rangeval
        ,ltrim(str(round(convert(double precision,ss.c15),16),24,16)) as totalval
        ,ltrim(str(round(convert(double precision,ss.c16),16),24,16)) as avgcolwidth
        ,ltrim(str(round(convert(double precision,ss.c17),16),24,16)) as 'total rows'
        ,ltrim(str(round(convert(double precision,ss.c18),16),24,16)) as 'join skew threshold'
        ,convert(int,ss.c12)              as TuningFact
        ,convert(int,ss.c13)              as samplingPct
        ,ss.partitionid       
from syscolumns sc, sysstatistics ss, systypes st
where sc.id = object_id('tttl_ma_barcode')
--and   sc.name like isnull(@colname,"%")
and   ss.id = sc.id
and   convert(int,ss.c6) = st.type
and   st.name not in ("timestamp","sysname", "longsysname", "nchar", "nvarchar")
and   st.usertype < 100
and   sc.number = 0
and   convert(smallint, substring(ss.colidarray,1,2)) = sc.colid
and   ss.formatid = 100
order by sc.id, sc.name, ss.colidarray, ss.partitionid
plan "( sort ( nl_join ( nl_join ( i_scan csyscolumns ( table ( sc syscolumns ) ) ) (i_scan csysstatistics ( table ( ss sysstatistics ) ) ) ) ( store_index ( i_scan ncsystypes ( table ( st systypes ) ) ) ) ) )"
go



--collecting the mod date for the table
SELECT distinct
	i.name,
	USER_NAME(t.uid),
	t.name,
	i.status,
	i.status2 
	,tt.statmoddate
	,t.sysstat
	,t.sysstat2
	,t.sysstat3
FROM
	dbo.sysindexes i,
	dbo.sysobjects t, 
	dbo.systabstats tt
WHERE
	i.id = t.id AND
	tt.indid = i.indid and
	tt.id = t.id and
	i.indid > 0.0 AND
	i.indid < 255.0 AND
	t.name = 'tttl_ma_shipment' AND
	USER_NAME(t.uid) = 'dbo' 
ORDER BY
	i.name
go	

exec sp_showoptstats 'lmscan..tttl_ma_barcode'
go

optdiag statistics canshipws.dbo.address_book -Usa -o/opt/sap/db_backups/optdiag/address_book.opt -SCPDB1 -X
optdiag statistics canshipws.dbo.address -Usa -o/opt/sap/db_backups/optdiag/address_book.opt -SCPDB1 -X

optdiag statistics lmscan.dbo.tttl_ma_barcode -Usa -o/opt/sap/db_backups/optdiag/tttl_ma_barcode.opt -SCPDB1 -X
optdiag statistics cpscan.dbo.tttl_ev_event_hospital -Usa -o/opt/sap/db_backups/optdiag/tttl_ev_event_hospital.opt -SCPDB1 -X
