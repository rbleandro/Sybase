--return objects replicated to IQ
select d.dbname,s.objname,s.phys_tablename,d.dbid from rs_objects s, rs_databases d where objname like '%iq%' and s.dbid = d.dbid;
select d.dbname,s.objname,s.phys_tablename,a.subname,a.status from rs_objects s, rs_databases d, rs_subscriptions a where objname like '%iq%' and s.dbid = d.dbid and a.dbid = d.dbid;

select top 10 * from rs_repdbs r1 where r1.dsname = 'CPDB1' and not exists (select * from rs_repdbs r2 where r1.dbname=r2.dbname and r2.dsname='CPDB4')
select top 10 * from rs_repdbs r1 where r1.dbname='rev_hist'

select distinct dbname from rs_repdbs r1 where r1.dsname = 'CPDB1' 
select distinct dbname from rs_repdbs r1 where r1.dsname = 'CPDB4' 

select top 10 * from  rs_articles
select top 10 * from  rs_asyncfuncs
select top 10 * from  rs_classes
select top 10 * from  rs_clsfunctions
select top 10 * from  rs_columns
select top 10 * from  rs_config
select top 10 * from  rs_databases where dbname='lmscan'
select top 10 * from  rs_databases where dsname='CPIQ'
select top 10 * from  rs_datatype
select top 10 * from  rs_dbreps
select top 10 * from  rs_dbsubsets
select top 10 * from  rs_diskaffinity
select top 10 * from  rs_diskpartitions
select top 10 * from  rs_erroractions where ds_errorid = 11733
# select top 10 * from  rs_exceptscmd  -- Usually not necessary
# select top 10 * from  rs_exceptshdr  -- Usually not necessary
select top 10 * from  rs_exceptslast where error_db=199
select top 10 * from  rs_functions
select top 10 * from  rs_funcstrings
select top 10 * from  rs_locater
select top 10 * from  rs_msgs
select top 10 * from  rs_objects
select top 10 * from  rs_objfunctions
select top 10 * from  rs_oqid
select top 10 * from  rs_profdetail
select top 10 * from  rs_profile
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
select top 10 * from  rs_subscriptions where subname like '%lm_revhs%';
# select top 10 * from  rs_systext   -- Usually not necessary
select top 10 * from  rs_targetobjs
select top 10 * from  rs_tbconfig
select top 10 * from  rs_translation
select top 10 * from  rs_tvalues
select top 10 * from  rs_users
select top 10 * from  rs_version
select top 10 * from  rs_whereclauses

-- PROCEDURES (RSSD):

rs_helpdbsub

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
