exec sp_helpdb cpscan
go
--10.200.000
use cpscan
go
--exec sp_extendsegment 'image_seg',cpscan,dev32
go
/*
TotalSizeMB  FreeSizeMB  UsedSizeMB  ReservedMB
1289046      77037       1212009     0
*/
exec sp_helpsegment_custom 'image_seg'
GO

exec sp_helpsegment 'default'
go
exec sp_helpsegment 'parcel_seg'
go
exec sp_helpthreshold
go
--transforming number of pages into MB. Replace the first number in the equations
select (19641794/1048576.)*@@maxpagesize
go
--exec sp_dropsegment image_seg, cpscan, dev29
go
