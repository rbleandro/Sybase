--generate drop sub commands for the standby server
select 'drop subscription CPDB2_'+name+'_dbsub for database replication definition CPDB2_'+name+'_dbrep with primary at CPDB2.'+name+' with replicate at CPDB1.'+name+' without purge;' 
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','lm_stage','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
go
--generate drop sub commands for the dr server
select 'drop subscription CPDB4_'+name+'_dbsub for database replication definition CPDB2_'+name+'_dbrep with primary at CPDB2.'+name+' with replicate at CPDB4.'+name+' without purge;' 
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','lm_stage','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
go

--generate commands to resume/suspend connections and to drop rep defs (in case of failover)
select 'resume connection to CPDB1.'+name+';'
,'resume connection to CPDB4.'+name+';' 
,'drop database replication definition CPDB2_'+name+'_dbrep with primary at CPDB2.'+name+';'
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','lm_stage','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
go

select 'alter connection to CPDB4.'+name+' set error class canpar_error_class;'
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','lm_stage','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
go

--generate the commands to recreate rep definition and subscription
select 'use '+name+'
go
sp_stop_rep_agent '+name+'
go
sp_config_rep_agent '+name+',disable
go
dbcc settrunc(ltm,ignore)
go'
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
select 'alter connection to CPDB2.'+name+' set log transfer on' as string,name,0 as rn
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
union
select 'alter connection to CPDB4.'+name+' set dsi_bulk_copy to ''off'';' as string,name,0.1 as rn
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
union
select '
use master
go
exec sp_locklogin '''+name+'_maint'',unlock
go' as string,name,0.2 as rn
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
union
select '
use '+name+'
go
exec sp_dropalias '''+name+'_maint''
go
exec sp_addalias  '''+name+'_maint'',''dbo''
go' as string,name,0.3 as rn
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
union
select '
use '+name+'
go
dbcc settrunc(ltm,ignore)
go
dbcc settrunc(ltm,valid)
go
sp_start_rep_agent '+name+'
go' as string,name,0.4 as rn
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
union
select 'drop database replication definition CPDB2_'+name+'_dbrep with primary at CPDB2.'+name+';' as string,name,1 as rn
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
union
select 'drop database replication definition CPDB2_'+name+'_dbrep with primary at CPDB2.'+name+';' as string,name,1 as rn
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
union
select 'create database replication definition CPDB2_'+name+'_dbrep with primary at CPDB1.'+name+' replicate DDL replicate system procedures;' as string,name,2 as rn 
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
union
select 'define subscription CPDB4_'+name+'_dbsub for database replication definition CPDB2_'+name+'_dbrep with primary at CPDB1.'+name+' with replicate at CPDB4.'+name+' subscribe to truncate table use dump marker;' as string,name,3 as rn
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
union
select 'validate subscription CPDB4_'+name+'_dbsub for database replication definition CPDB2_'+name+'_dbrep with primary at CPDB1.'+name+' with replicate at CPDB4.'+name+';' as string,name,4 as rn
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
union
select 'perl /opt/sap/cron_scripts/dump_databases_to_dr.pl '+name + ' rleandro 1' as string,name,5 as rn
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
union
select 'resume connection to CPDB4. '+name as string,name,6 as rn
from master..sysdatabases 
where 1=1
and name not in ('master','model','sybmgmtdb','sybsecurity','sybsystemdb','sybsystemprocs','canshipws','mpr_data','mpr_data_lm','shippingws','termexp','uss','dba')
and name not like 'tempdb%'
order by name
go


--cheat about replication definitions names for ASE

CPDB2_cpscan_dbrep 234
CPDB2_lmscan_dbrep 198
CPDB2_cdpvkm_dbrep 201
CPDB2_cmf_data_dbrep 203
CPDB2_canada_post_dbrep 192
CPDB2_canship_webdb_dbrep 195
CPDB2_cmf_data_lm_dbrep 205
CPDB2_collectpickup_dbrep 206
CPDB2_collectpickup_lm_dbrep 209
CPDB2_dqm_data_lm_dbrep 211
CPDB2_eput_db_dbrep 212
CPDB2_evkm_data_dbrep 215
CPDB2_liberty_db_dbrep 216
CPDB2_linehaul_data_dbrep 219
CPDB2_pms_data_dbrep 220
CPDB2_rate_update_dbrep 223
CPDB2_rev_hist_dbrep 224
CPDB2_rev_hist_lm_dbrep 227
CPDB2_sort_data_dbrep 228
CPDB2_svp_cp_dbrep 231
CPDB2_svp_lm_dbrep 232
CPDB1_scan_compliance_dbrep 264