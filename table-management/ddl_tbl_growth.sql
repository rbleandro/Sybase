 use cpscan
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use lmscan
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use cmf_data
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use cmf_data_lm
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use canship_webdb
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use rev_hist
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use rev_hist_lm
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use canada_post
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use svp_lm
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use svp_cp
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use canshipws
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use cdpvkm
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use collectpickup
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use collectpickup_lm
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use dqm_data_lm
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use sort_data
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use liberty_db
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use eput_db
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use evkm_data
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use linehaul_data
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use lm_stage
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use pms_data
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use rate_update
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use shippingws
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use termexp
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use uss
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use mpr_data
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO
 use mpr_data_lm
GO
DROP TABLE dbo.tbl_growth 
GO

CREATE TABLE dbo.tbl_growth  ( 
	table_name	varchar(30) NOT NULL,
	row_count 	numeric(18,0) NULL,
	pages     	unsigned int NULL,
	mbs       	int NULL,
	Allocated_MB decimal(19,2) NOT NULL,
	Used_MB decimal(19,2) NOT NULL,
	SnapTime  	datetime NOT NULL,
	SnapId    	int NOT NULL 
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0, COMPRESSION = PAGE
ON [default] 
GO