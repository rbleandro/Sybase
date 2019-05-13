exec sp_configure 'auditing',1
go
exec sp_displayaudit
go

exec sybsecurity..sp_spaceused sysaudits_02
go
exec sybsecurity..sp_spaceused sysaudits
go
exec sybsecurity..sp_help sysaudits
go
exec sybsecurity..sp_helpsegment "aud_seg_06"
go
exec sybsecurity..sp_helpsegment_custom "default" --
go
--truncate table sybsecurity..sysaudits_06
go
select top 1000 * from sybsecurity..sysaudits_02 where loginname = 'lm_process1'
go
select distinct ed.event, ed.description from sybsecurity..sysaudits_02 s inner join sybsecurity..event_descriptions ed on s.event=ed.event where loginname ='alex_vasilenco' and ed.event not in (62)
go
select distinct loginname from sybsecurity..sysaudits_02 s --inner join sybsecurity..event_descriptions ed on s.event=ed.event where loginname ='alex_vasilenco' and ed.event not in (62)
go
select distinct s.objname, ed.event, ed.description from sybsecurity..sysaudits_02 s inner join sybsecurity..event_descriptions ed on s.event=ed.event where loginname ='lm_process1'
--select top 10 * from sybsecurity..sysaudits_03 where loginname = 'lm_process1' order by eventtime desc --2019-05-11 12:57:05.626
go

select top 10 * from sybsecurity..sysaudits 
where 1=1
--and loginname='rafael_leandro' 
order by eventtime desc --and dbname='cpscan'
go

exec sybsecurity..sp_audit "exec_trigger",'lm_process1','default trigger',"off"
exec sybsecurity..sp_audit "exec_trigger",'all','default trigger',"off"
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
