use master exec sp_dboption rev_hist_20181227, single, true
go
use rev_hist_20181227 checkpoint 
go
sp_renamedb rev_hist_20181227, rev_hist
go
use master exec sp_dboption rev_hist, single, false 
go
use rev_hist checkpoint
go
