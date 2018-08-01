1. Run dataserver with the -b option to create a new master device: dataserver -b /dev/rsd1b 
2. Start Adaptive Server in single-user mode: startserver -f RUN_SYBASE -m We may use the master database, but presently it does not have any references to any user databases or sybsystemprocs. 
3. If master was expanded beyond its default size, run alter database to extend it. 
4. Update Backup Server name in sysservers if it is not SYB_BACKUP: 
begin transaction 
update sysservers set srvnetname = "PROD_BACKUP" where servname = "SYB_BACKUP" 
commit transaction 

Note that since sybsystemprocs is unavailable, we don’t have access to the usual sp_addserver procedure. 

5. Load the backup of the master database; once the load completes, it will shut down Adaptive Server automatically. load database master from masterdump 

6. Start Adaptive Server in single-user mode and check that all databases/devices/logins appear to be restored correctly. If everything appears OK, you are nearly done. 
Shut down and restart Adaptive Server normally, and skip to item 

7. If everything does not appear OK, you have more work to do. 
If additional devices, databases, logins, or users of master were created after the last backup of master, you will need to recreate them. 
Adaptive Server provides two commands to recover existing devices and databases to a restored master database: disk reinit and disk refit.

Use disk reinit to recover devices created since the last dump of master. Disk reinit restores information to sysdevices without reinitializing the device, retaining the data that is on the device. 
Values supplied to disk reinit should match values supplied to the original disk init command. CAUTION: If the wrong values are supplied to disk reinit, you can permanently corrupt your databases! 

Syntax: disk reinit name = logical_device_name, physname = physical_device_name, vdevno = virtual_device_number, size = number_of_pages |K|M|G|T [, vstart = virtual_address, cntrltype = controller_number]

Disk refit is used after running disk reinit to rebuild the sysusages and sysdatabases tables in master from the database fragments found on the restored devices. disk refit 

7. After executing disk refit, (assuming you need to run it) ASE will automatically shut down the server. You should restart Adaptive Server in single-user mode and verify that all databases are properly restored and are the correct sizes. Run dbcc checkalloc() on all recovered databases. If everything appears OK, shut down and restart Adaptive Server normally. Any changes or additions to logins, configuration options, remote servers, remote logins, and roles will still need to be recreated.

