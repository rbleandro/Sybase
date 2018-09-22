/*********************************************************************
*                                                                    *
* This stored procedure looks for unused indexes in a server.        *
*                                                                    *
* May be copied and redistributed freely with the inclusion of this: *
* Written by Peter Sap (www.petersap.nl)                             *
*                                                                    *
* All disclamers apply                                               *
*                                                                    *
* To use this tool, you need:                                        *
* - ASE 12.5.0.3 or later                                            *
* - Monitoring tables should be installed                            *
* - Appropriate permissions (mon_role)                               *
*********************************************************************/
go

set	nocount on
set	flushmessage on
go

if	not exists(
	select	1
		from	master.dbo.sysservers
		where	srvname	= "loopback")
begin
	print	""
	print	"loopback server is not configured, you need to install monitoring tables."
	print	"Aborting install..."
	select	""
	select	syb_quit()
end
go

if	object_id("master..monOpenObjectActivity") = null
begin
	print	""
	print	"Monitoring tables are not installed, do this first."
	print	"Aborting install..."
	select	""
	select	syb_quit()
end
go

use	sybsystemprocs
go

if	object_id("sp_unused_indexes")	!= null
	drop	proc	sp_unused_indexes
go

-- Create this table for compile purposes, will be dropped at the end of this script
create	proxy_table tempdb.guest.unused_indexes
	external table at "loopback.tempdb.dbo.sysindexes"
go

create	proc	sp_unused_indexes
as

declare	@rt		int,
	@max_db		int,
	@max_obj	int,
	@max_ind	int,
	@reuse_db	int,
	@reuse_obj	int,
	@reuse_ind	int,
	@open_db	int,
	@open_obj	int,
	@open_ind	int,
	@dbid		int,
	@location	varchar(255),
	@cmd		varchar(255),
	@error		int

set	flushmessage on
set	nocount on

print	""
print	"Finding unused indexes for server: %1!",
	@@servername

if	object_id("master..monOpenObjectActivity") = null
begin
	raiserror 20000 "Error:	Monitoring tables have not been installed, install these first"

	return	1
end

select	@rt	= datediff(dd,@@boottime,getdate())

if	@rt	< 7
begin
	print	"* WARNING *"
	print	"This program will only return reliable results when all of the regular queries have been run on the server. Your server has been running for %1! days now. This might be to short.",
		@rt
end
else
	print	"This server is running for %1! days now.",
		@rt

print	""

-- Get the configvalue for number of open databases
select	@open_db	= value
	from	master.dbo.sysconfigures
	where	config	= 105

if	@@error	!= 0
	return	1

-- Get the configvalue for number of open objects
select	@open_obj	= value
	from	master.dbo.sysconfigures
	where	config	= 107

if	@@error	!= 0
	return	1

select	@open_ind	= value
	from	master.dbo.sysconfigures
	where	config	= 263

if	@@error	!= 0
	return	1

select	@reuse_db	= config_admin(22,105,4,0,"open_database_reuse_requests",null)

if	@@error	!= 0
	return	1

if	@reuse_db in (null,-1)
begin
	raiserror 20000	"Invalid parameters for config_admin(22,105,4)"
	return	1
end

select	@reuse_obj	= config_admin(22,107,4,0,"open_object_reuse_requests",null)

if	@@error	!= 0
	return	1

if	@reuse_obj in (null,-1)
begin
	raiserror 20000	"Invalid parameters for config_admin(22,107,4)"
	return	1
end

select	@reuse_ind	= config_admin(22,263,4,0,"open_index_reuse_requests",null)

if	@@error	!= 0
	return	1

if	@reuse_ind in (null,-1)
begin
	raiserror 20000 "Invalid parameters for config_admin(22,263)"
	return	1
end

select	@max_db		= config_admin(22,105,3,0,"open_database_reuse_requests",null)

if	@@error	!= 0
	return	1

if	@max_db in (null,-1)
begin
	raiserror 20000 "Invalid parameters for config_admin(22,105,3)"
	return	1
end

select	@max_obj	= config_admin(22,107,3,0,"open_object_reuse_requests",null)

if	@@error	!= 0
	return	1

if	@max_obj in (null,-1)
begin
	raiserror 20000	"Invalid parameters for config_admin(22,107,3)"
	return 1
end

select	@max_ind	= config_admin(22,263,3,0,"open_index_reuse_requests",null)

if	@@error	!= 0
	return 1

if	@max_ind in (null,-1)
begin
	raiserror 20000	"Invalid parameters for config_admin(22,263,3)"
	return 1
end

select	DBID,
	ObjectID,
	ObjectName	= object_name(ObjectID,DBID),
	IndexID
	into	#work_input
	from	master..monOpenObjectActivity
	where	UsedCount	= 0
	and	IndexID		> 1
	and	IndexID		!= 255
	and	db_name(DBID)	not in ("master","model","sybsystemdb","dbccdb","dbccalt","sybmgmtdb","sybsecurity")

if	@@error	!= 0
	return	1

create	table	#work_output(
	db_name		varchar(30)	not null,
	table_name	varchar(30)	not null,
	index_name	varchar(30)	not null)

if	@@error	!= 0
	return	1

declare	curs cursor for
	select	distinct DBID
		from	#work_input
		for	read only

open	curs

if	@@error	!= 0
	return	1

fetch	curs into
	@dbid

while	@@sqlstatus = 0
begin
	select	@cmd	= "create proxy_table tempdb.guest.unused_indexes external table at 'loopback."
			+ db_name(@dbid)
			+ ".dbo.sysindexes'"

	exec	(@cmd)

	if	@@error	!= 0
		return	1

	exec	@error	= sp_unused_indexes;2	@dbid

	if	@@error	!= 0
		return	1

	if	@error	!= 0
		return	1

	if	object_id("tempdb.guest.unused_indexes")	!= null
		drop	table	tempdb.guest.unused_indexes

	if	@@error	!= 0
		return	1

	fetch	curs into
		@dbid
end

close	curs

deallocate cursor curs

select	convert(varchar(45),rtrim(db_name) + ".." + rtrim(table_name)) as "Object",
	index_name as "Index"
	from	#work_output
	order	by db_name, table_name

if	@@error	!= 0
	return	1

if	@reuse_obj	> 0
or	@reuse_ind	> 0
or	@reuse_db	> 0
begin
	print	""
	print	"* WARNING: *"

	if	@reuse_db	> 0
		print	"A number of database descriptors have been reused."

	if	@reuse_obj	> 0
		print	"A number of object descriptors have been reused."

	if	@reuse_ind	> 0
		print	"A number of index descriptors have been reused."

	print	"Because of this unreliable results have been reported."

	if	@max_db		= @open_db
	and	@reuse_db	> 0
		print	"Increase the configuration parameter 'number of open databases' currently set at %1!.",
			@open_db

	if	@max_obj	= @open_obj
	and	@reuse_obj	> 0
		print	"Increase the configuration parameter 'number of open objects' currently set at %1!.",
			@open_obj

	if	@max_ind	= @open_ind
	and	@reuse_ind	> 0
		print	"Increase the configuration parameter 'number of open indexes' currently set at %1!.",
			@open_ind

	print	"To clear the reused indicators reboot the server %1!.",
		@@servername
end

drop	table #work_input, #work_output
go

create	table	#work_output(
	db_name		varchar(30)	not null,
	table_name	varchar(30)	not null,
	index_name	varchar(30)	not null)
go

create	table	#work_input(
	DBID		int		not null,
	ObjectID	int		not null,
	ObjectName	varchar(30)	not null,
	IndexID		int		not null)
go

create	proc	sp_unused_indexes;2	@dbid	int
as

insert	into	#work_output
	select	db_name(@dbid),
		i.ObjectName,
		p.name
		from	tempdb.guest.unused_indexes p,
			#work_input i
		where	p.id	= i.ObjectID
		and	p.indid	= i.IndexID

if	@@error	!= 0
	return	1

return	0
go

drop	table	tempdb.guest.unused_indexes,
		#work_output,
		#work_input
go

