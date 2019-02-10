use master
go
create database dba on dev22="1G" log on logdev4 ="1000M"
go
exec sp_dboption 'dba', 'trunc log on chkpt', true
GO
exec sp_dboption 'dba', 'abort tran on log full', true
GO
exec sp_dboption 'dba', 'ddl in tran', true
GO
exec sp_dboption 'dba', 'select into/bulkcopy/pllsort', true
GO
USE dba
GO
checkpoint
GO
exec dba.dbo.sp_monitor_server_custom
select top 10 * from dba.dbo.server_health order by SnapTime desc
go
CREATE TABLE dbo.server_health  ( 
	cpu_busy        	int NULL,
	io_busy         	char(25) NULL,
	idle            	char(25) NULL,
	packets_received	char(25) NULL,
	packets_sent    	char(25) NULL,
	packet_errors   	char(25) NULL,
	total_read      	char(19) NULL,
	total_write     	char(19) NULL,
	total_errors    	char(19) NULL,
	connections     	char(18) NULL,
	SnapTime        	datetime NOT NULL,
	CONSTRAINT pk_serverhealth PRIMARY KEY CLUSTERED(SnapTime)
	WITH max_rows_per_page = 0, reservepagegap = 0
	)
LOCK DATAROWS
WITH exp_row_size = 0, reservepagegap = 0, identity_gap = 0
ON [default] 
GO
truncate table dba.dbo.server_health
go

CREATE OR REPLACE PROCEDURE dbo.sp_monitor_server_custom
as

/*
**  Declare variables to be used to hold current monitor values.
*/
declare @now 		datetime
declare @cpu_busy 	int
declare @io_busy	int
declare @idle		int
declare @pack_received	int
declare @pack_sent	int
declare @pack_errors	int
declare @connections	int
declare @total_read	int
declare @total_write	int
declare @total_errors	int
declare @engonline	int
declare @interval	int
declare @mspertick	float	/* milliseconds per tick */
declare @rptline char(255)
declare @procval	int

/*
**  Set @mspertick.  This is just used to make the numbers easier to handle
**  and avoid overflow.
*/
--select object_id('dba.dbo.server_health')
if object_id('dba.dbo.server_health') is not null
begin

delete from dba.dbo.server_health where SnapTime < dateadd(dd,-7,getdate())

select @mspertick = (@@timeticks / 1000.0)
/*
**  Set engonline to number of engines currently on line (so busy/idle
**  figures are correct). If this changes under us, the figures will not
**  necessarily be accurate for the next sp_monitor call; this should not
**  be a tremendous problem.
*/

select @engonline = count(*) from master.dbo.sysengines


/*
**  Get current monitor values.
*/
select
	@now = getdate(),
	@cpu_busy = @@cpu_busy,
	@io_busy = @@io_busy,
	@idle = @@idle,
	@pack_received = @@pack_received,
	@pack_sent = @@pack_sent,
	@connections = @@connections,
	@pack_errors = @@packet_errors,
	@total_read = @@total_read,
	@total_write = @@total_write,
	@total_errors = @@total_errors

/*
**  Check to see if DataServer has been rebooted.  If it has then the
**  value of @@boottime will be more than the value of spt_monitor.lastrun.
**  If it has update spt_monitor.
*/
update master.dbo.spt_monitor
	set
		lastrun = @now,
		cpu_busy = @cpu_busy,
		io_busy = @io_busy,
		idle = @idle,
		pack_received = @pack_received,
		pack_sent = @pack_sent,
		connections = @connections,
		pack_errors = @pack_errors,
		total_read = @total_read,
		total_write = @total_write,
		total_errors = @total_errors
	where datediff(ss,lastrun,@@boottime) > 0

/*
**  Now print out old and new monitor values.
*/
set nocount on
select @interval = datediff(ss, lastrun, @now)
	from master.dbo.spt_monitor
/* To prevent a divide by zero error when run for the first
** time after boot up
*/
if @interval = 0
        select @interval = 1

insert into dba.dbo.server_health
select
cpu_busy = 
--convert(char(25),
--	   	   convert(varchar(11),
--			   convert(int,
--				   (@cpu_busy * (@mspertick / 1000))))
--		+ "("
--		+  convert(varchar(11),
--			   convert(int,
--				   ((@cpu_busy - cpu_busy) * (@mspertick / 1000))
--				  / @engonline))
--		+ ")"
--		+ "-"
--		+  
--		convert(varchar(11),
			   convert(int,
				   (((@cpu_busy - cpu_busy)
				     * (@mspertick / 1000))
				    / @engonline)) * 100
				   / @interval
--				   )
--		+ "%")
,
io_busy = convert(char(25),
		  convert(varchar(11),
			  convert(int,
				  (@io_busy * (@mspertick / 1000))
				  / @engonline))
		+ "("
		+ convert(varchar(11),
			  convert(int,
				  ((@io_busy - io_busy) * (@mspertick / 1000))
				  / @engonline))
		+ ")"
		+ "-"
		+ convert(varchar(11),
			  convert(int,
				  (((@io_busy - io_busy) * (@mspertick / 1000))
				    / @engonline))
				   * 100
				  / @interval)
		+ "%"),
idle =    convert(char(25),
	          convert(varchar(11),
		          convert(int,
			          (@idle * (@mspertick / 1000))
			          / @engonline))
		+ "("
		+ convert(varchar(11),
			  convert(int,
				  ((@idle - idle) * (@mspertick / 1000))
				  / @engonline))
		+ ")"
		+ "-"
		+ convert(varchar(11),
			  convert(int,
				  (((@idle - idle) * (@mspertick / 1000))
				    / @engonline))
				   * 100
				  / @interval)
		+ "%")
		
		,packets_received = convert(char(25), convert(varchar(11), @pack_received) + "(" +
		convert(varchar(11), @pack_received - pack_received) + ")"),
	packets_sent = convert(char(25), convert(varchar(11), @pack_sent) + "(" +
		convert(varchar(11), @pack_sent - pack_sent) + ")"),
	packet_errors = convert(char(25), convert(varchar(11), @pack_errors) + "(" +
		convert(varchar(11), @pack_errors - pack_errors) + ")")
		
		,total_read = convert(char(19), convert(varchar(11), @total_read) + "(" +
		convert(varchar(11), @total_read - total_read) + ")"),
	total_write = convert(char(19), convert(varchar(11), @total_write) + "(" +
		convert(varchar(11), @total_write - total_write) + ")"),
	total_errors = convert(char(19), convert(varchar(11), @total_errors) + "(" +
		convert(varchar(11), @total_errors - total_errors) + ")"),
	connections = convert(char(18), convert(varchar(11), @connections) + "(" +
		convert(varchar(11), @connections - connections) + ")")
		,getdate() as "SnapTime"
--into dba.dbo.server_health
from master.dbo.spt_monitor
--where 1=2

/*
**  Now update spt_monitor
*/
update master.dbo.spt_monitor
	set
		lastrun = @now,
		cpu_busy = @cpu_busy,
		io_busy = @io_busy,
		idle = @idle,
		pack_received = @pack_received,
		pack_sent = @pack_sent,
		connections = @connections,
		pack_errors = @pack_errors,
		total_read = @total_read,
		total_write = @total_write,
		total_errors = @total_errors

return (0)
end

GO
sp_procxmode 'dbo.sp_monitor_server', 'Anymode'
GO
