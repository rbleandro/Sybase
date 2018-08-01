--changing the default device for the server. Do this right after the installation
disk init name = "data_dev1", physname = "D:\SAP\data\data_dev1.dat", size = "100M"
exec sp_diskdefault 'master','defaultoff'
exec sp_diskdefault 'data_dev1','defaulton'
disk init name = "data_dev1", physname = "D:\SAP\data\data_dev1.dat", size = "1000000M"

--checking the configured number of devices
exec sp_configure 'number of devices'

--creating a device to be used later by a database 
disk init name = sales_index1, physname = 'D:\SAP\data\sales_index1.dat', size = '150M'
disk init name = "masterlog1", physname = "D:\SAP\data\sales_index1.log", size = "150M"

--changing properties of database device
exec sp_deviceattr 'sales_data1','dsync','true'

--removing database device (do not forget to drop the physical file on the disk, if it is a regular file)
exec sp_dropdevice 'sales_index1'

disk resize name=master, size='512M'
alter database master log on master = "512M" 
exec sp_extendsegment logsegment, master, masterlog1

--perform a checkpoint to write down any comands to the physical data file
checkpoint

--clean up the transaction log
dump transaction master with truncate_only
go

-- the two queries below will give you an overview of the space consumption on the server
select sum( round ( (d.high-d.low) / 512.0, 0 ) ) as total_device_space_mb
from   master.dbo.sysdevices d,
       master.dbo.spt_values v 
where  d.status & 2=2 and 
       v.number=1 and 
       v.type='E'

select total_database_space = convert(decimal(17,2),(sum(convert(decimal(15,4),size)) / 512.0) * (select low / 2048 from master.dbo.spt_values where type='E' AND number=1 )) from master..sysusages

--metadata about files and devices
select * from syslogshold
select * from sysdevices
select * from syssegments
exec sp_helpsegment
exec sp_helpdevice
exec sp_helpdb
select * from sysdatabases
select * from sysusages

-- check the database distribution in the currently available devices
select st.name 'Database',sd.name 'Device',sd.phyname
from sysusages su
inner join sysdevices sd on su.vdevno = sd.vdevno
inner join sysdatabases st on st.dbid = su.dbid
order by sd.name

select low/16777216 from sysdevices where cntrltype=0 order by low

--enabling mirroring at the software (sybase) level
disk mirror name = 'data_dev1', mirror = '/sybase/mirror_devices/data_dev1_mir.dat', writes = noserial
