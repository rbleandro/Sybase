dbcc checkstorage

use pubs

--run this command to estimate the space necessary for a table
sp_estspace 'sales', 100

exec sp_helpdb pubs2

use master
exec sp_dboption pubs2, "select into/bulkcopy/pllsort", true

use pubs2
select * into sales_bkp from sales

--creating database with 16M for data and 4M for log
create database sampledb4 on datadev4 = "16M" log on logdev4 = "4M" 
--<database used for some time> 
--expanding the database with more 16M for data and 4M for log
alter database sampledb4 on datadev5 = "16M" log on logdev5 = "4M"


select * from master.dbo.sysusages where dbid=4
select * from syssegments
select * from master.dbo.sysdatabases