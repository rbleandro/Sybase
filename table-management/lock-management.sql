
To release a table lock:

dbcc lock_release( spid, "table", "{ex_tab | sh_tab | ex_int | sh_int}", dbid, objid [, "force" ] ) 

To release a page lock

dbcc lock_release( spid, "page", "{ex_page | up_page | sh_page}", dbid, objid, pageno [, "force" ] ) 

To release a row lock

dbcc lock_release( spid, "row", "{ex_row | up_row | sh_row | sh_nkl}", dbid, objid, pageno, rowno [, "force" ] ) 

--get the locks from sp_lock and use the column values on dbcc lock_release
exec sp_lock 5698
go

--To release a table lock:
dbcc lock_release( 5513, "table", "sh_int", 9, 28 ) 
go
--To release a page lock
dbcc lock_release( 5513, "page", "{ex_page | up_page | sh_page}", dbid, objid, pageno [, "force" ] ) 
go
--To release a row lock
dbcc lock_release( 5513, "row", "sh_row", 9, 28, 85, 3) 
go



