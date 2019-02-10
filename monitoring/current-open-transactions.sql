
select xactkey,
type = convert(char(11),v3.name),
coordinator = convert(char(10), v4.name),
starttime=convert(char(20), starttime),
state = convert(char(17),v1.name),
connection = convert(char(9), v2.name),
dbid=masterdbid, spid, loid,
failover = convert(char(26), v5.name),
s.srvname, namelen, xactname

from master..systransactions s, master..spt_values v1,
master..spt_values v2, master..spt_values v3,
master..spt_values v4, master..spt_values v5
where
s.state = v1.number and v1.type = 'T1'
and     s.connection = v2.number and v2.type = 'T2'
and     s.type = v3.number and v3.type = 'T3'
and     s.coordinator = v4.number and v4.type = 'T4'
and     s.failover = v5.number and v5.type = 'T5'
order by xactkey, s.srvname, s.failover
go
