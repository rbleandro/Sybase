--MAKE SURE THE LOGICAL VOLUMES EXIST IN THE OPERATING SYSTEM

USE master
GO
disk init name = 'auditDev1'
     , physname = '/dev/vg/auditDev1'
     , vdevno = 76
     , size = 5242880
     , dsync = false
GO
USE master
GO
disk init name = 'auditDev2'
     , physname = '/dev/vg/auditDev2'
     , vdevno = 77
     , size = 5242880
     , dsync = false
GO
USE master
GO
disk init name = 'auditDev3'
     , physname = '/dev/vg/auditDev3'
     , vdevno = 78
     , size = 5242880
     , dsync = false
GO
USE master
GO
disk init name = 'auditDev4'
     , physname = '/dev/vg/auditDev4'
     , vdevno = 79
     , size = 5242880
     , dsync = false
GO
USE master
GO
disk init name = 'auditDev5'
     , physname = '/dev/vg/auditDev5'
     , vdevno = 80
     , size = 5242880
     , dsync = false
GO
USE master
GO
disk init name = 'auditDev6'
     , physname = '/dev/vg/auditDev6'
     , vdevno = 81
     , size = 5242880
     , dsync = false
GO
USE master
GO
disk init name = 'auditDev7'
     , physname = '/dev/vg/auditDev7'
     , vdevno = 82
     , size = 5242880
     , dsync = false
GO
USE master
GO
disk init name = 'auditDev8'
     , physname = '/dev/vg/auditDev8'
     , vdevno = 83
     , size = 5242880
     , dsync = false
GO
USE master
GO
disk init name = 'auditLog'
     , physname = '/dev/vg/auditLog'
     , vdevno = 84
     , size = 5242880
     , dsync = false
GO
