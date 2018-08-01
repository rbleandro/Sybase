--it is possible to map ASE user steve, password sybase to DB2 login name login1, password password1: 

exec sp_addexternlogin DB2, steve, login1, password1

--It is also possible to provide a many-to-one mapping so that all ASE users that need a connection to DB2 can be assigned the same name and password: 

exec sp_addexternlogin DB2, NULL, login2, password2

--In addition, it is possible to assign external logins to ASE roles. With this capability, anyone with a particular role can be assigned a corresponding login name/password for any given remote server: 

sp_addexternlogin DB2, null, login3, password3, rolename



exec sp_helpremotelogin
exec sp_helpserver
exec sp_helpexternlogin


