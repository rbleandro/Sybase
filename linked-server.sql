--it is possible to map ASE user steve, password sybase to DB2 login name login1, password password1: 
exec sp_addexternlogin DB2, steve, login1, password1
go

--It is also possible to provide a many-to-one mapping so that all ASE users that need a connection to DB2 can be assigned the same name and password: 
exec sp_addexternlogin DB2, NULL, login2, password2
go

--In addition, it is possible to assign external logins to ASE roles. With this capability, anyone with a particular role can be assigned a corresponding login name/password for any given remote server: 
sp_addexternlogin DB2, null, login3, password3, rolename
go

exec sp_helpremotelogin
exec sp_helpexternlogin
go

exec sp_helpserver
go
exec sp_addserver CPSYBTEST, ASEnterprise, "cpsybtest2:4100"
go


------ to create a linked server to a table in IQ from ASE
exec sp_addexternlogin CPIQ, NULL, 'DBA', 'speed' --create the external login that will be used to connect to IQ
go

create existing table tttl_dr_delivery_record_cpiq --create the local table that maps to the remote table on IQ
(
conv_time_date            	datetime NOT NULL,
	employee_num              	char(6) NOT NULL,
	delivery_rec_num          	varchar(10) NOT NULL,
	multiple_del_rec_flag     	integer NOT NULL,
	manual_entry_flag         	integer NOT NULL,
	consignee_name            	varchar(12) NOT NULL,
	consignee_num             	varchar(8) NOT NULL,
	consignee_unit_number_name	varchar(100) NOT NULL ,
	consignee_street_number   	varchar(10) NOT NULL ,
	consignee_street_name     	varchar(100) NOT NULL ,
	consignee_more_address    	varchar(100) NOT NULL ,
	consignee_city            	varchar(100) NOT NULL ,
	consignee_postal_code     	varchar(6) NOT NULL ,
	residential_flag          	integer NOT NULL ,
	inserted_on_cons          	datetime NOT NULL,
	updated_on_cons           	datetime NOT NULL 

)
at 'CPIQ.cpiq1.dbo.tttl_dr_delivery_record'
go