exec sp_helpcache
go

sp_poolconfig 'default data cache'
go
sp_poolconfig 'tempdb0'
go
sp_poolconfig 'tempdb1'
go
sp_poolconfig 'tempdb2'
go
sp_poolconfig 'tempdb3'
go
sp_poolconfig 'tempdb4'
go
sp_poolconfig 'tempdb5'
go

sp_poolconfig 'default data cache', "10000M", "4K"
go
sp_poolconfig 'default data cache', "20000M", "16K"
go
sp_poolconfig 'default data cache', "2K", "wash=61440K"
go
sp_poolconfig 'default data cache', "4K", "wash=1966080K"
go
sp_poolconfig 'default data cache', "16K", "wash=1966080K"
go
sp_poolconfig 'tempdb0', "2000M", "4K" --do this for each tempdb
go
sp_poolconfig 'tempdb0', "1000M", "4K" --do this for each tempdb
go
sp_poolconfig 'tempdb0', "2K", "wash=983040K" --do this for each tempdb
go
sp_poolconfig 'tempdb0', "4K", "wash=409600K" --do this for each tempdb
go
sp_poolconfig 'tempdb0', "16K", "wash=204800K" --do this for each tempdb
go 

exec canada_post..sp_logiosize "4"
exec canship_webdb..sp_logiosize "4"
exec canshipws..sp_logiosize "4"
exec cdpvkm..sp_logiosize "4"
exec cmf_data..sp_logiosize "4"
exec cmf_data_lm..sp_logiosize "4"
exec collectpickup..sp_logiosize "4"
exec collectpickup_lm..sp_logiosize "4"
exec cpscan..sp_logiosize "4"
exec dba..sp_logiosize "4"
exec dqm_data_lm..sp_logiosize "4"
exec eput_db..sp_logiosize "4"
exec evkm_data..sp_logiosize "4"
exec liberty_db..sp_logiosize "4"
exec linehaul_data..sp_logiosize "4"
exec lm_stage..sp_logiosize "4"
exec lmscan..sp_logiosize "4"
exec mpr_data..sp_logiosize "4"
exec mpr_data_lm..sp_logiosize "4"
exec pms_data..sp_logiosize "4"
exec rate_update..sp_logiosize "4"
exec rev_hist..sp_logiosize "4"
exec rev_hist_lm..sp_logiosize "4"
exec scan_compliance..sp_logiosize "4"
exec shippingws..sp_logiosize "4"
exec sort_data..sp_logiosize "4"
exec svp_cp..sp_logiosize "4"
exec svp_lm..sp_logiosize "4"
exec tempdb..sp_logiosize "4"
exec tempdb1..sp_logiosize "4"
exec tempdb2..sp_logiosize "4"
exec tempdb3..sp_logiosize "4"
exec tempdb4..sp_logiosize "4"
exec tempdb5..sp_logiosize "4"
exec tempdb6..sp_logiosize "4"
exec tempdb7..sp_logiosize "4"
exec tempdb8..sp_logiosize "4"
exec tempdb9..sp_logiosize "4"
exec termexp..sp_logiosize "4"
exec uss..sp_logiosize "4"
go

