exec canada_post..sp_helprotect 'public'
exec canship_webdb..sp_helprotect 'public'
exec canshipws..sp_helprotect 'public'
exec cdpvkm..sp_helprotect 'public'
exec cmf_data..sp_helprotect 'public'
exec cmf_data_lm..sp_helprotect 'public'
exec collectpickup..sp_helprotect 'public'
exec collectpickup_lm..sp_helprotect 'public'
exec cpscan..sp_helprotect 'public'
exec dqm_data_lm..sp_helprotect 'public'
exec eput_db..sp_helprotect 'public'
exec evkm_data..sp_helprotect 'public'
exec liberty_db..sp_helprotect 'public'
exec linehaul_data..sp_helprotect 'public'
exec lm_stage..sp_helprotect 'public'
exec lmscan..sp_helprotect 'public'
exec mpr_data..sp_helprotect 'public'
exec mpr_data_lm..sp_helprotect 'public'
exec pms_data..sp_helprotect 'public'
exec rate_update..sp_helprotect 'public'
exec rev_hist..sp_helprotect 'public'
exec rev_hist_lm..sp_helprotect 'public'
exec shippingws..sp_helprotect 'public'
exec sort_data..sp_helprotect 'public'
exec svp_cp..sp_helprotect 'public'
exec svp_lm..sp_helprotect 'public'
exec termexp..sp_helprotect 'public'
exec uss..sp_helprotect 'public'
go

use master
go
select 'exec ' + name + '..sp_helprotect ''public''',* from sysdatabases where name not in ('master','model') and name not like 'tempdb%' and name not like 'syb%' order by name
go

select s.name, user_name(o.uid), o.name, p.action, p.protecttype, o.type from sysroles r, master..syssrvroles s, sysprotects p, sysobjects o, master..spt_values v where r.id =  s.srid AND r.lrid = p.uid AND p.id = o.id AND p.action = v.number AND v.type = N'T' and ( p.columns is null or p.columns = 0x01) and s.name = 'sa_role' and (o.type = 'U' OR o.type = 'S' OR o.type = 'V' OR o.type = 'F' OR o.type = 'SF' OR o.type = 'P' OR o.type = 'XP') 
go
select sl.name, sr.name from master..sysloginroles slr, master..syslogins sl, master..syssrvroles sr where slr.suid = sl.suid and slr.srid = sr.srid and sr.name = 'sa_role'
go
SELECT name, password, pwdate, status, logincount FROM master.dbo.syssrvroles WHERE name = N'sa_role' ORDER BY name
go