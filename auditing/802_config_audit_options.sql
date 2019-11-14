/*
exec sp_configure 'auditing',0
go
exec sp_configure 'max memory',27072043
go
exec sybsecurity..sp_spaceused sysaudits_06
go
--truncate table sybsecurity..sysaudits_06
go
select top 1000 * from sybsecurity..sysaudits_06
go
exec sp_displayaudit
go
select top 10 * from sybsecurity..sysaudits_01 where loginname='rafael_leandro' order by eventtime desc --and dbname='cpscan'
go
select top 1000 * from sysaudits where loginname='kenny_ip'
go
exec sybsecurity..sp_audit "all",'kenny_ip','all',"off"
go
exec sp_helpsegment "aud_seg_01"
go
use cpscan 
select top 10 * from cpscan..tttl_ev_event
go
insert into cpscan..tttl_ev_event
select top 1 '000001951400', 'A', shipper_num, conv_time_date, employee_num, status, scan_time_date, terminal_num, pickup_shipper_num, postal_code, additional_serv_flag, mod10b_fail_flag, multiple_barcode_flag, multiple_shipper_flag, comments_flag, inserted_on_cons, updated_on_cons
from cpscan..tttl_ev_event
GO
select top 10000 * from sybsecurity..audit_report_vw 
where loginname='kenny_ip'
and objname='tttl_ma_barcode'
and dbname='lmscan'
go
*/
--select * from sybsecurity..dbo.event_descriptions
--select name,audflags from master.dbo.syslogins where audflags != 0

exec sybsecurity..sp_audit "all",'alex_vasilenco','all',"on"
exec sybsecurity..sp_audit "all",'alex_vasilenco_upd','all',"on"
exec sybsecurity..sp_audit "all",'an_phan','all',"on"
exec sybsecurity..sp_audit "all",'chris_krupey','all',"on"
exec sybsecurity..sp_audit "all",'dan_pham','all',"on"
exec sybsecurity..sp_audit "all",'dominic_shou','all',"on"
exec sybsecurity..sp_audit "all",'dominic_shou_upd','all',"on"
exec sybsecurity..sp_audit "all",'frank_orourke','all',"on"
exec sybsecurity..sp_audit "all",'frank_orourke_upd','all',"on"
exec sybsecurity..sp_audit "all",'frank_qi','all',"on"
exec sybsecurity..sp_audit "all",'frasier_bellam','all',"on"
exec sybsecurity..sp_audit "all",'frasier_bellam_upd','all',"on"
exec sybsecurity..sp_audit "all",'glenn_mcfarlane','all',"on"
exec sybsecurity..sp_audit "all",'jim_pepper','all',"on"
exec sybsecurity..sp_audit "all",'jim_pepper_upd','all',"on"
exec sybsecurity..sp_audit "all",'kanya_kotur','all',"on"
exec sybsecurity..sp_audit "all",'kanya_kotur_upd','all',"on"
exec sybsecurity..sp_audit "all",'keith_borgmann','all',"on"
exec sybsecurity..sp_audit "all",'keith_borgmann_upd','all',"on"
exec sybsecurity..sp_audit "all",'ryan_shan','all',"off"
exec sybsecurity..sp_audit "all",'kenny_ip','all',"on"
exec sybsecurity..sp_audit "all",'rafael_leandro','all',"off"
exec sybsecurity..sp_audit "all",'a_rtoyota','all',"off"