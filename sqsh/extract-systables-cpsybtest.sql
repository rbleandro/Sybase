select * from sysdatabases
go -m csv 2>/dev/null >"/tmp/sysdatabases.csv"
select * from sysdevices
go -m csv 2>/dev/null >"/tmp/sysdevices.csv"
select * from sysusages
go -m csv 2>/dev/null >"/tmp/sysusages.csv"
select * from sysloginroles
go -m csv 2>/dev/null >"/tmp/sysloginroles.csv"
select * from syslogins
go -m csv 2>/dev/null >"/tmp/syslogins.csv"
select * from sysconfigures
go -m csv 2>/dev/null >"/tmp/sysconfigures.csv"
select * from syscharsets
go -m csv 2>/dev/null >"/tmp/syscharsets.csv"
select * from sysservers
go -m csv 2>/dev/null >"/tmp/sysservers.csv"
select * from sysremotelogins
go -m csv 2>/dev/null >"/tmp/sysremotelogins.csv"
select * from sysresourcelimits
go -m csv 2>/dev/null >"/tmp/sysresourcelimits.csv"
select * from systimeranges
go -m csv 2>/dev/null >"/tmp/systimeranges.csv"
