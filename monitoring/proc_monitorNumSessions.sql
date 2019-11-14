use dba
go
CREATE TABLE dbo.monNumSession  ( 
	snapTime   	datetime NOT NULL,
	hostname   	varchar(64) NULL,
	username   	varchar(30) NULL,
	NumSessions	int NOT NULL,
	status     	char(12) NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0
ON [default] 
GO
CREATE CLUSTERED INDEX idx_cl_snapTime
	ON dbo.monNumSession(snapTime)
	WITH allow_dup_row
	ON [default]
GO


CREATE OR REPLACE PROCEDURE monitor_num_connections AS 
BEGIN 
    delete from dba.dbo.monNumSession where snapTime < dateadd(mi,-60,getdate())
    
    insert into dba.dbo.monNumSession
    SELECT getdate() AS snapTime, CASE sp.clienthostname WHEN '' THEN isnull(sp.hostname,ipaddr) WHEN NULL THEN isnull(sp.hostname,ipaddr) ELSE sp.clienthostname END 'hostname'
    , SUSER_NAME(sp.suid) AS username,COUNT(spid) AS NumSessions ,status 
    FROM master..sysprocesses sp 
    WHERE 1=1 
    --AND suid<>0 
    GROUP BY CASE sp.clienthostname WHEN '' THEN isnull(sp.hostname,ipaddr) WHEN NULL THEN isnull(sp.hostname,ipaddr) ELSE sp.clienthostname END, SUSER_NAME(sp.suid) ,status
    --having count(spid)>50
    ORDER BY COUNT(spid) DESC 
END
go


select sum(NumSessions) as NumTotalConn
from dba.dbo.monNumSession
where snapTime = (select max(snapTime) from dba.dbo.monNumSession)
gos
select top 1 * 
from dba.dbo.monNumSession 
where 1=1
and NumSessions>50 
and snapTime = (select max(snapTime) from dba.dbo.monNumSession)
order by NumSessions desc
go

truncate table dba.dbo.monNumSession
go