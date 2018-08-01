exec sp_helpserver
exec sp_helpdb  
--shutdown SYB_BACKUP
startserver SYB_BACKUP -m 8160

--dump database model to '/home/sybase/db_backups/model.dmp'
