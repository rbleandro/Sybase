/*
Once you find the spid(s) of interest, check the associated rows in master..sysprocesses, master..monProcess and master..monProcessLookup.  
The objective here is to get login, application, host and/or ipaddress details to help track down the application(s) that owns the spid(s).

Also take a look at master..monProcessSQLText (for the associated spid(s)) to see what SQL is currently executing in archive_db.  
The objective is to use the SQL to 
a) determine the parent applicatoin and 
b) perhaps provide some details as to why the log is filling up (eg, is the query processing 10 million rows instead of 10 thousand rows?).
*/

select distinct top 10 db_name(slh.dbid) as 'Database',slh.reserved,slh.spid,slh.page
,slh.starttime
,sp.status,sp.program_name,sp.hostprocess,sp.cmd,sp.cpu,sp.physical_io,sp.blocked,sp.priority,sp.affinity,sp.ipaddr
--,sp.*
--,mp.HostName
,mpl.ClientHost
,mpl.Login
,mpst.SQLText,sp.execution_time
from master..syslogshold slh
inner join master..sysprocesses sp on slh.spid = sp.spid
inner join master..monProcess mp on sp.spid = slh.spid
inner join master..monProcessLookup mpl on mpl.SPID = slh.spid
inner join master..monProcessSQLText mpst on mpst.SPID = slh.spid 
where slh.spid <> 0 
order by sp.execution_time desc
