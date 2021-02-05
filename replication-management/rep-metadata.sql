--return objects replicated to IQ
select d.dbname,s.objname,s.phys_tablename,d.dbid from rs_objects s, rs_databases d where objname like '%iq%' and s.dbid = d.dbid;
select d.dbname,s.objname,s.phys_tablename,a.subname,a.status from rs_objects s, rs_databases d, rs_subscriptions a where objname like '%iq%' and s.dbid = d.dbid and a.dbid = d.dbid;
select d.dbname,s.objname,s.phys_tablename,a.subname,a.status from rs_objects s, rs_databases d, rs_subscriptions a where objname like '%CPDB%' and s.dbid = d.dbid and a.dbid = d.dbid;

select top 10 * from  rs_subscriptions where subname like '%_iq_%';

select top 10 * from rs_repdbs r1 where r1.dsname = 'CPDB1' and not exists (select * from rs_repdbs r2 where r1.dbname=r2.dbname and r2.dsname='CPDB4')
select top 10 * from rs_repdbs r1 where r1.dbname='rev_hist_lm'

select distinct dbname from rs_repdbs r1 where r1.dsname = 'CPDB1'
select distinct dbname from rs_repdbs r1 where r1.dsname = 'CPDB4'

select * from rs_subscriptions s, rs_databases d where 1=1 and subname like '%CPDB%' and s.dbid = d.dbid
select top 10 * from  rs_articles
select top 10 * from  rs_asyncfuncs
select top 10 * from  rs_classes where classname = ''
select top 10 * from  rs_clsfunctions
select top 10 * from  rs_columns
select top 10 * from  rs_config --server wide configurations
select top 10 * from  rs_databases where dbname='lmscan'
select top 10 * from  rs_databases where dsname='CPIQ'
select top 10 * from  rs_datatype
select top 10 * from  rs_dbreps --information on replication definitions
select top 10 * from  rs_dbsubsets
select top 10 * from  rs_diskaffinity
select top 10 * from  rs_diskpartitions -- information on queues
--use the query below to check the error actions mapped to each error in the error class
select * from  rs_erroractions where errorclassid=0x0100006501000065
--and action=6
and ds_errorid=17260
order by ds_errorid
go
--use the query below to check the exceptions skipped or logged for a connection
select textval
--,max(log_time)
,log_time,error_site
from rs_exceptshdr hdr,rs_exceptscmd cmd,rs_systext
where error_site in ('CPDB4','CPDB2')
and error_db = 'svp_cp'
and hdr.sys_trans_id = cmd.sys_trans_id
and cmd_id = parentid
and textval not like '%begin transaction%'
and textval not like '%commit transaction%'
and textval not like '%roman8%'
and textval not like '%rs_update_lastcommit%'
and textval not like '%~$%'
and textval not like '%@conn_id%'
and textval not like '%if @@error <> 0 rollback transaction%'
and cmd_type='L'
and log_time > '2019-07-31'
--group by textval
--order by textval,max(log_time) desc
order by textval,log_time desc
go
--use the query below to find out what connections had commands skipped
select error_site,error_db
from rs_exceptshdr hdr,rs_exceptscmd cmd,rs_systext
where 1=1
and hdr.sys_trans_id = cmd.sys_trans_id
and cmd_id = parentid
and textval not like '%begin transaction%'
and textval not like '%commit transaction%'
and textval not like '%roman8%'
and textval not like '%rs_update_lastcommit%'
and textval not like '%~$%'
and textval not like '%@conn_id%'
and textval not like '%if @@error <> 0 rollback transaction%'
and cmd_type='L'
and log_time > '2019-07-17'
group by error_site,error_db
--order by log_time desc
go
select top 10 * from  rs_functions
select top 10 * from  rs_funcstrings
select top 10 * from  rs_locater
select top 10 * from  rs_msgs
select top 10 * from  rs_objects where objname like '%iq%'
select top 10 * from  rs_objfunctions
select top 10 * from  rs_oqid
select top 10 * from  rs_profdetail
select top 10 * from  rs_profile -- types of connections to different data systems
select top 10 * from  rs_publications
select top 10 * from  rs_queues
select top 10 * from  rs_recovery
select top 10 * from  rs_repdbs where dbname like '%cmf%'
select top 10 * from  rs_repobjs
select top 10 * from  rs_routes
select top 10 * from  rs_routeversions
select top 10 * from  rs_rules
select top 10 * from  rs_scheduletxt
select top 10 * from  rs_schedule
select top 10 * from  rs_segments
select top 10 * from  rs_sites
select top 10 * from  rs_statcounters
select top 10 * from  rs_statdetail
select top 10 * from  rs_statrun
select top 10 * from  rs_subscriptions where subname like '%_iq_%';
select top 10 * from  rs_subscriptions where subname like '%sort_data%';
select top 10 * from  rs_systext   -- Usually not necessary
select top 10 * from  rs_targetobjs
select top 10 * from  rs_tbconfig -- info about table configurations such as dsi_command_convert
select top 10 * from  rs_translation
select top 10 * from  rs_tvalues
select top 10 * from  rs_users
select top 10 * from  rs_version
select top 10 * from  rs_whereclauses

--creating partitions (queues):
create partition sq8 on '/home/sybase/stableqs/sq8.dat' with size 20000
create partition sq9 on '/home/sybase/stableqs/sq9.dat' with size 20000
create partition sq10 on '/home/sybase/stableqs/sq10.dat' with size 20000
create partition sq11 on '/home/sybase/stableqs/sq11.dat' with size 20000
create partition sq12 on '/home/sybase/stableqs/sq12.dat' with size 20000
create partition sq13 on '/home/sybase/stableqs/sq13.dat' with size 20000
create partition sq14 on '/home/sybase/stableqs/sq14.dat' with size 20000
create partition sq15 on '/home/sybase/stableqs/sq15.dat' with size 20000

-- PROCEDURES (RSSD):

rs_helpdbsub --info on database subscriptions
rs_helpdbrep --ifo on database replication definitions
rs_helprep --info on table replication definitions
rs_helpsub --info on table subscriptions
rs_helpuser
rs_helperror 529 -- information about error action for a specific error
rs_helpdb -- overview on connections' properties, including error classes used

--ADMIN COMMANDS
admin config
go | egrep "memory|cache"

admin config,"connection",CPDB4,svp_cp
go

admin config,"connection",CPIQ,svp_cp_iq_conn1
go | grep "dsi_command_convert"

admin config,"connection",CPIQ,svp_cp_iq_conn1
go | grep "dsi_row_count_validation"

admin config
go | egrep "sqt_max_cache_size"
admin config,"connection",CPDB4,canada_post
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|dsi_sqt_max_cache_size"
admin config,"connection",CPDB4,lm_stage
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|dsi_sqt_max_cache_size"
admin config,"connection",CPDB4,uss
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|dsi_sqt_max_cache_size"
admin config,"connection",CPDB4,svp_cp
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|dsi_sqt_max_cache_size"
admin config,"connection",CPDB4,canshipws
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|dsi_sqt_max_cache_size"
admin config,"connection",CPDB4,cmf_data
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|dsi_sqt_max_cache_size"

admin config,"connection",CPDB2,canada_post
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|dsi_sqt_max_cache_size"
admin config,"connection",CPDB2,lmscan
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|dsi_sqt_max_cache_size|dsi_keep_triggers|dsi_large_xact_size"
admin config,"connection",CPDB2,cpscan
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|dsi_sqt_max_cache_size|dsi_keep_triggers|dsi_large_xact_size|dsi_compile_max_cmds"
admin config,"connection",CPDB2,svp_cp
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size"
admin config,"connection",CPDB2,cpscan
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size"
admin config,"connection",CPDB2,rev_hist_lm
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size"
admin config,"connection",CPDB2,cmf_data_lm
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|error"
admin config,"connection",CPDB2,rev_hist
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size"
admin config,"connection",CPDB2,cmf_data
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|error"
admin config,"connection",CPDB2,pms_data
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|error"

admin config,"connection",CPDB1,svp_lm
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|error"
admin config,"connection",CPDB1,cmf_data_lm
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|error"
admin config,"connection",CPDB1,cmf_data
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|error"
admin config,"connection",CPDB1,rev_hist_lm
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|error"
admin config,"connection",CPDB1,cpscan
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|error"
admin config,"connection",CPDB1,lmscan
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|error"
admin config,"connection",CPDB1,rev_hist
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|error"
admin config,"connection",CPDB1,canship_webdb
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|error"
admin config,"connection",CPDB1,scan_compliance
go | egrep "dsi_bulk_copy|dsi_compile_enable|dist_sqt_max_cache_size|error"


admin config,"connection",CPIQ,rev_hist_iq_conn1
go | egrep "dsi_bulk_copy|dsi_compile_enable|dsi_cmd_batch_size|dsi_compile_max_cmds|dsi_cdb_max_size|dist_sqt_max_cache_size|error"

admin config,"connection",CPIQ,rev_hist_lm_iq_conn1
go | egrep "dsi_bulk_copy|dsi_compile_enable|dsi_cmd_batch_size|dsi_compile_max_cmds|dsi_cdb_max_size|dist_sqt_max_cache_size|error"

admin who_is_down
go | grep "svp_lm"

admin who_is_up
go | grep "svp_lm"

admin who_is_up
go | grep "REP AGENT"

admin who_is_down
go | grep "svp_lm"

admin disk_space
go | egrep "sq|Used";

admin who,sqt
go | egrep "sort_data|Closed"

admin who,sqt
go | egrep "rev_hist|Closed"

--CONFINGURE ERROR ACTIONS FOR ERRORS IN REPLICATION
http://infocenter.sybase.com/help/index.jsp?topic=/com.sybase.infocenter.dc35920.1571200/doc/html/jer1346925054962.html
http://infocenter.sybase.com/help/index.jsp?topic=/com.sybase.infocenter.dc32410.1570/doc/html/san1273714385572.html

create error class svp_cp_error_class set template to rs_sqlserver_error_class
drop error class iq_error_class
create error class iq_error_class set template to rs_iq_error_class

alter connection to CPDB4.svp_cp set error class canpar_error_class
alter connection to CPIQ.cmf_data_lm_iq_conn1 set error class iq_error_class
assign action retry_stop for canpar_error_class to 529
assign action retry_stop for canpar_error_class to 3621
assign action log for canpar_error_class to 17260
assign action warn for iq_error_class to -1002003
assign action stop_replication for iq_error_class to 1002003
assign action stop_replication for iq_error_class to -1002003

ignore - Assume that the command succeeded and that there is no error or warning condition to process. This action can be used for a return status that indicates successful execution.
warn - Log a warning message, but do not roll back the transaction or interrupt execution.
retry_log - Roll back the transaction and retry it. The number of retry attempts is set with the configure connection command. If the error continues after retrying, write the transaction into the exceptions log, and continue, executing the next transaction.
log - Roll back the current transaction and log it in the exceptions log; then continue, executing the next transaction.
retry_stop - Roll back the transaction and retry it. The number of retry attempts is set with the configure connection command. If the error recurs after retrying, suspend replication for the database.
stop_replication - Roll back the current transaction and suspend replication for the database. This is equivalent to using the suspend connection command. This action is the default. Since this action stops all replication activity for the database, it is important to identify the data server errors that can be handled without shutting down the database connection, and assign them to another action.

-- PROCEDURES (ASE):

exec sp_stop_rep_agent rev_hist_lm
go

exec cmf_data_lm..sp_config_rep_agent cmf_data_lm,disable --this will return an error if replication has never been configured for the database
go
exec sp_help_rep_agent cmf_data_lm
go

select is_rep_agent_enabled(db_id('cmf_data_lm'))
go

select 'if is_rep_agent_enabled(db_id('''+name+'''))=1 exec '+name+'..sp_config_rep_agent '+name+',disable' from sysdatabases order by name --run this to generate the comand to disable the replication agent (useful after restoring a database from production)
go
select 'select is_rep_agent_enabled(db_id('''+name+''')), '''+name+''' as db, ''exec '+name+'..sp_config_rep_agent '+name+',disable'' as cmd union' from sysdatabases order by name
go
