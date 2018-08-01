use svp_cp
go
set textsize 100000
go
set fmtonly on
go
set showplan on
go
--set show_missing_stats long
--go
exec dbo.svp_proc_source_failure
go

