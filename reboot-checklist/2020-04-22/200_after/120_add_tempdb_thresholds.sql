exec sp_helpcache
go

select * from master..sysdatabases
go

exec tempdb..sp_addthreshold tempdb, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb..sp_addthreshold tempdb, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb..sp_addthreshold tempdb, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb1..sp_addthreshold tempdb1, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb1..sp_addthreshold tempdb1, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb1..sp_addthreshold tempdb1, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb2..sp_addthreshold tempdb2, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb2..sp_addthreshold tempdb2, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb2..sp_addthreshold tempdb2, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb3..sp_addthreshold tempdb3, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb3..sp_addthreshold tempdb3, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb3..sp_addthreshold tempdb3, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb4..sp_addthreshold tempdb4, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb4..sp_addthreshold tempdb4, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb4..sp_addthreshold tempdb4, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb5..sp_addthreshold tempdb5, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb5..sp_addthreshold tempdb5, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb5..sp_addthreshold tempdb5, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb6..sp_addthreshold tempdb6, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb6..sp_addthreshold tempdb6, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb6..sp_addthreshold tempdb6, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb7..sp_addthreshold tempdb7, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb7..sp_addthreshold tempdb7, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb7..sp_addthreshold tempdb7, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb8..sp_addthreshold tempdb8, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb8..sp_addthreshold tempdb8, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
exec tempdb8..sp_addthreshold tempdb8, "logsegment", 5120000, sp_thresholdaction --10000 MB threshold for the logsegment
go
exec tempdb9..sp_addthreshold tempdb9, "logsegment", 512000, sp_thresholdaction --1000 threshold for the logsegment
exec tempdb9..sp_addthreshold tempdb9, "logsegment", 2560000, sp_thresholdaction --5000 MB threshold for the logsegment
go


exec tempdb..sp_helpthreshold
go
exec tempdb1..sp_helpthreshold
go
exec tempdb2..sp_helpthreshold
go
exec tempdb3..sp_helpthreshold
go
exec tempdb4..sp_helpthreshold
go
exec tempdb5..sp_helpthreshold
go
exec tempdb6..sp_helpthreshold
go
exec tempdb7..sp_helpthreshold
go
exec tempdb8..sp_helpthreshold
go
exec tempdb9..sp_helpthreshold
go
