use cpscan
go

exec sp_helprotect bctt_delivery_ev_search_v2
go
--grant role sa_role to  huong_le
--go

-- Check if role exists in db
SELECT [RolesInDb] = svr.name
FROM  master..syssrvroles svr,
      sysroles            db
WHERE svr.srid = db.id
AND   svr.name = "developers"
go


-- List roles in db
SELECT [RolesInDb] = svr.name,
   [Locked]    = CASE svr.status & 2 
        WHEN 2 THEN "Locked" 
        ELSE         CHAR(0)
        END,
   [Expired]   = CASE svr.status & 4 
        WHEN 4 THEN "Expired" 
        ELSE         CHAR(0)
        END
FROM  master..syssrvroles svr,
      sysroles            db
WHERE svr.srid = db.id
GO

--list all users within a role
select sl.name, sr.name from master..sysloginroles slr, master..syslogins sl, master..syssrvroles sr where slr.suid = sl.suid and slr.srid = sr.srid and sr.name = 'sa_role'
go
--checking user role assignments
select sl.name, sr.name from master..sysloginroles slr, master..syslogins sl, master..syssrvroles sr where slr.suid = sl.suid and slr.srid = sr.srid 
and sr.name not in ('sa_role','sso_role','oper_role','sybase_ts_role','replication_role','mon_role','js_admin_role','js_user_role','sa_serverprivs_role')
and sr.name not like 'replication%'
go
    
select 'grant select on ' + name + ' to public ' from sysobjects where type ='U' order by name
go

select 'grant exec on ' + name + ' to public ' from sysobjects where type ='P' order by name
go    

sp_displayroles tech_user
go