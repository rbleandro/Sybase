select @@VERSION 'DBMS_VER'
exec master.dbo.sp_server_info

select crdate as server_start_time from master..sysdatabases where name = 'tempdb'