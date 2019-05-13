select * from sysdatabases
go -m csv 2>/dev/null >"/home/sybase/db_backups/sysdatabases.csv"
select * from sysdevices
go -m csv 2>/dev/null >"/home/sybase/db_backups/sysdevices.csv"
select * from sysusages
go -m csv 2>/dev/null >"/home/sybase/db_backups/sysusages.csv"
select * from sysloginroles
go -m csv 2>/dev/null >"/home/sybase/db_backups/sysloginroles.csv"
select * from syslogins
go -m csv 2>/dev/null >"/home/sybase/db_backups/syslogins.csv"
select * from sysconfigures
go -m csv 2>/dev/null >"/home/sybase/db_backups/sysconfigures.csv"
select * from syscharsets
go -m csv 2>/dev/null >"/home/sybase/db_backups/syscharsets.csv"
select * from sysservers
go -m csv 2>/dev/null >"/home/sybase/db_backups/sysservers.csv"
select * from sysremotelogins
go -m csv 2>/dev/null >"/home/sybase/db_backups/sysremotelogins.csv"
select * from sysresourcelimits
go -m csv 2>/dev/null >"/home/sybase/db_backups/sysresourcelimits.csv"
select * from systimeranges
go -m csv 2>/dev/null >"/home/sybase/db_backups/systimeranges.csv"
