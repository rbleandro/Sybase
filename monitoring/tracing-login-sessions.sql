create or replace procedure ltrigg as
declare @filepath varchar(100)
select @filepath="/home/sybase/db_backups/trace/trace_for_spid_" +
convert(varchar(10),@@spid) + "_user_" + suser_name() + "_at_" +
convert(varchar(10),getdate(),5) + "_" +
convert(varchar(10),getdate(),8) + ".txt"
set tracefile @filepath
set export_options on
set show_sqltext on
--set showplan on
go

create role trace_role
grant set tracing to trace_role
grant execute on ltrigg to trace_role
go

declare @login varchar(50)
select @login="rafael_leandro"
--exec sp_role "grant", trace_role, @login
--exec sp_modifylogin @login, "add default role", "trace_role"
exec sp_modifylogin @login, "defdb", master
exec sp_modifylogin @login, "login script", ltrigg
go

/*
sp_helpapptrace

set tracefile off for 453
set tracefile off for 687

*/

