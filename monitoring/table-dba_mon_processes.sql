drop table dbo.dba_mon_processes
go
CREATE TABLE dbo.dba_mon_processes  ( 
	spid          	smallint NOT NULL,
	cmd             varchar(30),
	db              varchar(30) NULL,
	extime	        bigint NULL,
	status        	char(12) NOT NULL,
	username        varchar(30) NULL,
	server        	varchar(30) NULL,
	program       	varchar(30) NULL,
	memusage      	int NOT NULL,
	cpu           	int NOT NULL,
	physical_io   	int NOT NULL,
	blkpid        	smallint NOT NULL,
	tblk           	int NULL,
	bblkpid         smallint null,
	bcmd            varchar(30) NULL,
	bstatus         char(12) NULL,
	bprogram        varchar(30) NULL,
	bhost           varchar(30) NULL,
	buser           varchar(30) NULL,
	qtybtran          int null,
	snapTime      	datetime NOT NULL,
	CONSTRAINT pk_currsessions PRIMARY KEY CLUSTERED(snapTime,spid)
	WITH max_rows_per_page = 0, reservepagegap = 0
	)
LOCK ALLPAGES
WITH max_rows_per_page = 0, reservepagegap = 0, identity_gap = 0
ON [default] 
GO
select * from dba_mon_processes
go