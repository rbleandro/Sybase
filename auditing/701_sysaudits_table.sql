use sybsecurity
go

CREATE TABLE dbo.sysaudits  ( 
	event    	smallint NOT NULL,
	eventmod 	smallint NOT NULL,
	spid     	smallint NOT NULL,
	eventtime	datetime NOT NULL,
	sequence 	smallint NOT NULL,
	suid     	int NOT NULL,
	dbid     	smallint NULL,
	objid    	int NULL,
	xactid   	binary(6) NULL,
	loginname	varchar(30) NULL,
	dbname   	varchar(30) NULL,
	objname  	varchar(255) NULL,
	objowner 	varchar(30) NULL,
	extrainfo	varchar(255) NULL,
	nodeid   	tinyint NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0
ON [default] 
GO
CREATE NONCLUSTERED INDEX idx1
	ON dbo.sysaudits(eventtime)
	ON [default]
GO

exec sp_help sysaudits
go