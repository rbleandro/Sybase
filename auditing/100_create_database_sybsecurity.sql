--MAKE SURE THE DEVICES ARE PROPERLY INSTALLED BEFORE RUNNING THIS
use master
go
CREATE DATABASE sybsecurity 
	ON auditDev1 = '10485760K', 
	   auditDev2 = '10485760K', 
	   auditDev3 = '10485760K', 
	   auditDev4 = '10485760K', 
	   auditDev5 = '10485760K', 
	   auditDev6 = '10485760K', 
	   auditDev7 = '10485760K', 
	   auditDev8 = '10485760K'   
	LOG ON auditLog = '10485760K'
GO
USE master
GO
exec sp_dboption 'sybsecurity', 'trunc log on chkpt', true
GO
exec sp_dboption 'sybsecurity', 'select into/bulkcopy/pllsort', true
GO
USE sybsecurity
GO
checkpoint
GO


--exec sybsecurity..sp_helpdb sybsecurity
go
