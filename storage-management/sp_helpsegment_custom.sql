use dba
go
CREATE OR REPLACE PROCEDURE dbo.sp_helpsegment_custom
@segname varchar(255) = NULL		/* segment name */
as

declare @segbit         int,		/* this is the bit version of the segment # */
	@segment        int,		/* the segment number of the segment */
	@free_pages     bigint,		/* unused pages in segment */
	@factor         float,		/* conversion factor to convert to MB */
	@clr_pages	bigint,		/* Space reserved for CLRs */
	@total_pages	bigint,		/* total allocatable log space */
	@used_pages	bigint,		/* allocated log space */
	@used_pages_wo_APs		/* allocated log space without inc */
			bigint,		/* allocation pages */
	@msg		varchar(1024)	/* message text */


if @@trancount = 0
begin
	set chained off
end

set transaction isolation level 1

set nocount on

/*
**  If no segment name given, get 'em all.
*/
if @segname is null
begin
	exec sp_autoformat @fulltabname = "syssegments",
		@orderby = "order by segment" 
	return (0)
end

/*
**  Make sure the segment exists
*/
if not exists (select *
	from syssegments
		where name = @segname)
begin
	/* 17520, "There is no such segment as '%1!'." */
	raiserror 17520, @segname
	return (1)
end

/*
**  Show the syssegment entry, then the fragments and size it is on,
**  then any dependent objects in the database.
*/
/* Adaptive Server has expanded all '*' elements in the following statement */ select syssegments.segment, syssegments.name, syssegments.status
into #sphelpsegment2rs
	from syssegments
		where name = @segname
exec sp_autoformat @fulltabname = #sphelpsegment2rs
drop table #sphelpsegment2rs
/*
**  Set the bit position for the segment.
*/
select @segment = segment
	from syssegments
		where name = @segname

/*
**  Now set the segments on @devname sysusages.
*/
if (@segment < 31)
	select @segbit = power(2, @segment)
else
	/*
	**  Since this is segment 31, power(2, 31) will overflow
	**  since segmap is an int.  We'll grab the machine-dependent
	**  bit mask from spt_values to set the right bit.
	*/
	select @segbit = low
		from master.dbo.spt_values
			where type = "E"
				and number = 2

/*
** Get factor for conversion of pages to megabytes from spt_values
*/
select @factor = convert(float, low) / 1048576.0
        from master.dbo.spt_values
        where number = 1 and type = "E"

select @total_pages = sum(u.size)
	from master.dbo.sysusages u
	where u.segmap & @segbit = @segbit
	and u.dbid = db_id()


/*
** Select the sizes of the segments
*/
if (@segbit = 4)
begin
    select device = d.name,
	size = convert(varchar(20), round((sum(u.size) * @factor), 0)) + "MB"
    into #sphelpsegment3rs
	from master.dbo.sysusages u, master.dbo.sysdevices d
	    where u.segmap & @segbit = @segbit
		and u.dbid = db_id()
		and ((d.status & 2 = 2)  or (d.status2 & 8 = 8))
		and u.vdevno = d.vdevno
	    group by d.name
    exec sp_autoformat @fulltabname = #sphelpsegment3rs,
		@orderby = "order by 1"
    drop table #sphelpsegment3rs

    -- To avoid errors while creating this sproc because
    -- sp_spaceused appears later in the create list.
    -- execute the procedure in the current user database's context
    set @msg = "sp_spaceused_syslogs"
    exec @msg @total_pages	output
		, @free_pages		output
		, @used_pages		output
		, @used_pages_wo_APs	output
		, @clr_pages		output

end
else
begin
    select device = d.name,
	size = convert(varchar(20), round((sum(u.size) * @factor), 0)) + "MB",
	free_pages = sum(curunreservedpgs(db_id(), u.lstart, u.unreservedpgs)),
	FreeSizeMB= round(sum(curunreservedpgs(db_id(), u.lstart, u.unreservedpgs))*@factor,0)
    into #sphelpsegment4rs
	from master.dbo.sysusages u, master.dbo.sysdevices d
            where u.segmap & @segbit = @segbit
		and u.dbid = db_id()
		and ((d.status & 2 = 2)  or (d.status2 & 8 = 8))
		and u.vdevno = d.vdevno
	    group by d.name

    exec sp_autoformat @fulltabname = #sphelpsegment4rs,
		@orderby = "order by 1"

    drop table #sphelpsegment4rs

    select @free_pages = sum(curunreservedpgs(db_id(), u.lstart, u.unreservedpgs))
	from master.dbo.sysusages u
	    where u.segmap & @segbit = @segbit
		and u.dbid = db_id()

    select @used_pages = @total_pages - @free_pages
    select @clr_pages = 0
end

/*
** Select the dependent objects
** The segment information for a table is stored at both
** sysindexes and syspartitions. The segment in syspartitions
** tells where the future location of data in this partition.
** The segment in sysindexes is the default segment specified
** for the whole table/index. Any partitions under this table/
** index that doesn't have the segment specification for its
** own will use this default segment in sysindexes.
*/
if (@segname = 'logsegment')
begin
	print " "
	/* 19342, "Objects on segment '%1!':" */
	exec sp_getmessage 19342, @msg output
	print @msg, @segname
	print " "

	/*
	** Do some special-handling for logsegment. We know that only syslogs
	** will reside on it, so hard-code the id/indid in the WHERE clause
	** below. One reason why we do this is that if you run this sproc on
	** logsegment when a large utility (e.g. ALTER LOCK CHANGE) is going on
	** concurrently, some times we end up with the scan on syspartitions
	** below being blocked by the large utility. To avoid that, and to get
	** the results of the objects bound to logsegment, do this hard-path
	** short cut.
	*/
	select table_name = object_name(p.id), index_name = i.name, i.indid,
	       partition_name = p.name
	into #result3
	from sysindexes i, syssegments s, syspartitions p
	where s.name = @segname
	  and s.segment = p.segment
	  and p.id = i.id
	  and p.indid = i.indid
	  and p.id = object_id('syslogs')
	  and p.indid = 0

	exec sp_autoformat @fulltabname='#result3', @orderby='order by 1,3,4'
end

else if exists (select *
	   from syspartitions p, syssegments s
	   where s.name = @segname
	     and s.segment = p.segment)
begin
	print " "
	/* 19342, "Objects on segment '%1!':" */
	exec sp_getmessage 19342, @msg output
	print @msg, @segname
	print " "

	select table_name = object_name(p.id), index_name = i.name, i.indid,
	       partition_name = p.name
	into #result1
	from sysindexes i, syssegments s, syspartitions p
	where s.name = @segname
	  and s.segment = p.segment
	  and p.id = i.id
	  and p.indid = i.indid

	exec sp_autoformat @fulltabname='#result1', @orderby='order by 1,3,4'
end


if exists (select *
	   from syssegments s, sysindexes i
	   where s.name = @segname
	     and s.segment = i.segment)
begin
	print " "
	/* 19341, "Objects currently bound to segment '%1!':" */
	exec sp_getmessage 19341, @msg output
	print @msg, @segname
	print " "

	select table_name = object_name(i.id), index_name = i.name, i.indid
	into #result2
	from sysindexes i, syssegments s
	where s.name = @segname
	  and s.segment = i.segment

	exec sp_autoformat @fulltabname='#result2', @orderby='order by 1,3'
	print " "
end

/*
** Print total_size, total_pages, free_pages, used_pages and reserved_pages
*/

select TotalSizeMB = round(@total_pages * @factor, 0),
	--total_pages = convert(char(15), @total_pages),
	--free_pages = convert(char(15), @free_pages),
	FreeSizeMB=round(@free_pages * @factor, 0),
	--used_pages = convert(char(15), @used_pages),
	UsedSizeMB=round(@used_pages * @factor, 0),
	--reserved_pages = convert(char(15), @clr_pages)
	ReservedMB=round(@clr_pages * @factor, 0)
		
return (0)


GO
sp_procxmode 'dbo.sp_helpsegment_custom', 'Anymode'
GO
