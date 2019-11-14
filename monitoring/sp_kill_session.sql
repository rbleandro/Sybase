use dba
go

CREATE OR REPLACE PROCEDURE dbo.sp_kill_session (@spid smallint,@StatusOnly bit=0, @Force bit=0)
as

declare @cmd varchar(4000)

SELECT @cmd='kill ' + cast(@spid as varchar(6))

if @StatusOnly=1
    set @cmd = @cmd + ' with statusonly'
else if @Force=1
    set @cmd = @cmd + ' with force'

exec (@cmd)
GO

exec sp_kill_session 1,1,0
go