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

exec sp_showoptstats 'cpscan..tttl_ma_shipment'
go

optdiag statistics canshipws.dbo.address_book -Usa -o/opt/sap/db_backups/optdiag/address_book.opt -SCPDB1 -X
optdiag statistics canshipws.dbo.address -Usa -o/opt/sap/db_backups/optdiag/address_book.opt -SCPDB1 -X

