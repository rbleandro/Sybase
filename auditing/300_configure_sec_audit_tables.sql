use sybsecurity
go

--exec sp_addaudittable auditDev1
go
exec sp_addaudittable auditDev2
go
exec sp_addaudittable auditDev3
go
exec sp_addaudittable auditDev4
go
exec sp_addaudittable auditDev5
go
exec sp_addaudittable auditDev6
go
exec sp_addaudittable auditDev7
go
exec sp_addaudittable auditDev8
go

exec sp_help sysaudits_01
go
exec sp_helpsegment aud_seg_01
go