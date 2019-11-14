use master
go
CREATE OR REPLACE PROCEDURE dbo.sp_add_database_space (@db varchar(100),@segment varchar(50),@remainingspacetoadd int,@ignoreProd bit=0)
as
begin
    --declare @db varchar(100),@segment varchar(50)
    
    if not exists (select * from dba.dbo.sysobjects where name='check_prod')
    begin
        raiserror 99999 "Table check_prod not defined in the server. Please run the commands below to set it up.
        
use master
go
exec sp_configure 'enable file access',1
go
use dba
go
create proxy_table check_prod
external file
at '/opt/sap/cron_scripts/passwords/check_prod'
go

"
    end
    else
    begin
        declare @msg varchar(4000),@cmd varchar(8000),@stdbyspacetoadd bigint,@device varchar(100),@curaddedspace int,@cpdb1space bigint,@curaddedspace_actual int,@step smallint,@totalAvailableSpace int
        ,@dbgrowth smallint,@isprod bit
        --set @db = 'sort_data' --input the database name here
        --set @segment='default' --values: default, image_seg or log
        --set @cpdb1space = 37000 --input the current production db space here (after adding the space there)
        
        set @stdbyspacetoadd=0
        set @step = 5000
        
        if object_id('dba.dbo.db_space') is not null and exists(select * from dba..db_space)
        begin
            select @dbgrowth=sum(d1.data_used_MB - d2.data_used_MB) 
            from dba..db_space d1 inner join dba..db_space d2 on d1.[db_name]=d2.[db_name]
            where d1.SnapId=d2.SnapId+1
            and d1.SnapId = (select max(SnapId)-0 from dba..db_space where [db_name]=d1.[db_name] and datepart(weekday,SnapTime) between 2 and 6)
            and (d1.data_used_MB - d2.data_used_MB) > 0
        end
        
        set @isprod=0
        
        if exists(select * from  dba.dbo.check_prod where record like '%1')
        begin
            set @isprod=1
        end
        
        if @db not like 'tempdb%'
        begin
            if @isprod=1
            begin
                if @segment = 'default'
                begin
                    --set @remainingspacetoadd=@step
                    
                    select top 1 @device=name,@curaddedspace=FreeSpaceMB 
                    from (
                    SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                    ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                    FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                    AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                    FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                    AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                    master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                    where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                    and name not like 'log%'
                    and name like 'dev%'
                    ORDER BY FreeSpaceMB
                    
                    while @remainingspacetoadd > 0
                    begin
                        if @curaddedspace >= @step and @remainingspacetoadd >= @step
                            set @curaddedspace_actual = @step
                        
                        else if @curaddedspace >= @step and @remainingspacetoadd < @step
                            set @curaddedspace_actual = @remainingspacetoadd
                        
                        else if @curaddedspace < @step and @remainingspacetoadd >= @step
                            set @curaddedspace_actual = @remainingspacetoadd - @curaddedspace
                            
                        else if @curaddedspace <= @step and @remainingspacetoadd < @step
                        begin
                            set @curaddedspace_actual = @curaddedspace
                            if @curaddedspace_actual <= 0
                                set @curaddedspace_actual = @remainingspacetoadd
                        end 
                           
                        set @msg = 'adding ' + convert(varchar(50),@curaddedspace_actual) + ' using device ' + @device + '. Space left to add: ' + convert(varchar(50),@remainingspacetoadd - @curaddedspace_actual) + '.'
                        print @msg
                        
                        set @cmd = 'alter database ' + @db + ' on ' + @device + ' = ' + convert(varchar(50),@curaddedspace_actual)
                        exec (@cmd)
                               
                        set @remainingspacetoadd = @remainingspacetoadd - @curaddedspace_actual
                        
                        select top 1 @device=name,@curaddedspace=FreeSpaceMB from (
                        SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes' ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                        ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                        FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                        AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                        FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                        AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                        master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                        where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                        and name not like 'log%'
                        and name like 'dev%'
                        ORDER BY FreeSpaceMB
                        
                    end
                    
                    select @totalAvailableSpace=sum(FreeSpaceMB) from (
                    SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes' ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                    ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                    FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                    AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                    FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                    AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                    master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                    where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                    and name not like 'log%'
                    and name like 'dev%'
                     
                    set @msg = char(10) + char(10) + 'You have ' + cast(@totalAvailableSpace as varchar(50)) + ' MB of free space available for data segments.' + char(10) + char(10)
                    
                    if @dbgrowth is not null
                        set @msg = @msg + 'Current daily growth is at ' + convert(varchar(50),@dbgrowth) + ' MB. Sybase will run out of space in ' + convert(varchar(50),round(@totalAvailableSpace/@dbgrowth,2)) + ' days based on the current growth.' + char(10) + char(10)
                    else
                        set @msg = @msg + 'Information about growth rate not available. Create and populate table dba.dbo.db_space to display the growth trends.'
                    
                    print @msg
                    --select 'You have ' + cast(@totalAvailableSpace as varchar(50)) + ' MB of free space available for data segments.'
                end
                
                if @segment not in ('default','logsegment')
                begin
                
                    select top 1 @device=name,@curaddedspace=FreeSpaceMB 
                    from (
                    SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                    ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                    FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                    AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                    FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                    AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                    master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                    where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                    and name not like 'log%'
                    and name like 'dev%'
                    ORDER BY FreeSpaceMB
                    
                    while @remainingspacetoadd > 0
                    begin
                        if @curaddedspace >= @step and @remainingspacetoadd >= @step
                            set @curaddedspace_actual = @step
                        
                        else if @curaddedspace >= @step and @remainingspacetoadd < @step
                            set @curaddedspace_actual = @remainingspacetoadd
                        
                        else if @curaddedspace < @step and @remainingspacetoadd >= @step
                            set @curaddedspace_actual = @remainingspacetoadd - @curaddedspace
                            
                        else if @curaddedspace <= @step and @remainingspacetoadd < @step
                        begin
                            set @curaddedspace_actual = @curaddedspace
                            if @curaddedspace_actual <= 0
                                set @curaddedspace_actual = @remainingspacetoadd
                        end
                            
                        set @msg = 'adding ' + convert(varchar(50),@curaddedspace_actual) + ' using device ' + @device + '. Space left to add: ' + convert(varchar(50),@remainingspacetoadd - @curaddedspace_actual) + '.'
                        print @msg
                        
                        set @cmd = 'alter database ' + @db + ' on ' + @device + ' = ' + convert(varchar(50),@curaddedspace_actual)
                        exec (@cmd)
                               
                        set @remainingspacetoadd = @remainingspacetoadd - @curaddedspace_actual
                        
                        set @cmd = 'exec '+ @db + '..sp_extendsegment  '''+@segment+''',''' + @db + ''', ' + @device
                        exec (@cmd)
                        
                        select top 1 @device=name,@curaddedspace=FreeSpaceMB from (
                        SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                        ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                        FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                        AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                        FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                        AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                        master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                        where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                        and name not like 'log%'
                        and name like 'dev%'
                        ORDER BY FreeSpaceMB
                        
                    end
                    
                    select @totalAvailableSpace=sum(FreeSpaceMB) from (
                    SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes' ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                    ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                    FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                    AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                    FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                    AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                    master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                    where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                    and name not like 'log%'
                    and name like 'dev%'
                    
                    set @msg = char(10) + char(10) + 'You have ' + cast(@totalAvailableSpace as varchar(50)) + ' MB of free space available for data segments.' + char(10)  + char(10)
                    
                    if @dbgrowth is not null
                        set @msg = @msg + 'Current daily growth is at ' + convert(varchar(50),@dbgrowth) + ' MB. Sybase will run out of space in ' + convert(varchar(50),round(@totalAvailableSpace/@dbgrowth,2)) + ' days based on the current growth.' + char(10) + char(10)
                    else
                        set @msg = @msg + 'Information about growth rate not available. Create and populate table dba.dbo.db_space to display the growth trends.'
                    print @msg
                    --select 'You have ' + cast(@totalAvailableSpace as varchar(50)) + ' MB of free space available for data segments.'
                end
                
                if @segment = 'logsegment'
                begin
                
                    select top 1 @device=name,@curaddedspace=FreeSpaceMB from (
                    SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                    ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                    FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                    AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                    FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                    AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                    master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                    where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                    and name like 'log%'
                    ORDER BY FreeSpaceMB
                    
                    while @remainingspacetoadd > 0
                    begin
                        if @curaddedspace >= @step and @remainingspacetoadd >= @step
                            set @curaddedspace_actual = @step
                        
                        else if @curaddedspace >= @step and @remainingspacetoadd < @step
                            set @curaddedspace_actual = @remainingspacetoadd
                        
                        else if @curaddedspace < @step and @remainingspacetoadd >= @step
                            set @curaddedspace_actual = @remainingspacetoadd - @curaddedspace
                            
                        else if @curaddedspace <= @step and @remainingspacetoadd < @step
                        begin
                            set @curaddedspace_actual = @curaddedspace
                            if @curaddedspace_actual <= 0
                                set @curaddedspace_actual = @remainingspacetoadd
                        end
                            
                        set @msg = 'adding ' + convert(varchar(50),@curaddedspace_actual) + ' using device ' + @device + '. Space left to add: ' + convert(varchar(50),@remainingspacetoadd - @curaddedspace_actual) + '.'
                        print @msg
                        
                        set @cmd = 'use master alter database ' + @db + ' log on ' + @device + ' = ' + convert(varchar(5),@step)
                        exec (@cmd)
                        
                        set @remainingspacetoadd = @remainingspacetoadd - @curaddedspace_actual
                        
                        select top 1 @device=name,@curaddedspace=FreeSpaceMB from (
                        SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                        ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                        FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                        AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                        FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                        AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                        master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                        where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                        and name like 'log%'
                        ORDER BY FreeSpaceMB
                    end
                    
                    select @totalAvailableSpace=sum(FreeSpaceMB) from (
                    SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes' ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                    ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                    FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                    AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                    FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                    AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                    master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                    where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                    and name like 'log%'
                    
                    set @msg = char(10) + char(10) + 'You have ' + cast(@totalAvailableSpace as varchar(50)) + ' MB of free space available for log segments.' + char(10)
                    print @msg
                    --select 'You have ' + cast(@totalAvailableSpace as varchar(50)) + ' MB of free space available for data segments.'
                end
                
                
                delete from dba.dbo.db_last_space where name = @db
                insert into dba.dbo.db_last_space (name,dataSize,logSize)
                select d.name, ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )),ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) 
                from master..sysdatabases d, master..sysusages u
                where u.dbid = d.dbid  and d.status2 & 16 = 0 
                and d.name = @db
                group by d.dbid
                
            end
            else
            begin
                
                if @segment = 'default'
                begin    
                    if @ignoreProd = 0
                    begin
                        select @cpdb1space = dataSize from master..prod_db_space where name = @db
                        
                        if @cpdb1space is null 
                        begin
                            RAISERROR 99999 'Could not get the current space used for the database from the production server. Check if the appropriate proxy table is created and that there are records for this database.'
                            return 1
                        end
                        
                        select @stdbyspacetoadd=@cpdb1space - ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end ))
                        from master..sysdatabases d, master..sysusages u
                        where u.dbid = d.dbid  and d.status != 256
                        and @db=d.name
                        group by d.dbid
                        
                        set @remainingspacetoadd = @stdbyspacetoadd
                    end
                    
                    if @remainingspacetoadd > 0 
                    begin
                    
                        select top 1 @device=name,@curaddedspace=FreeSpaceMB 
                        from (
                        SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                        ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                        FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                        AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                        FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                        AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                        master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                        where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                        and name not like 'log%'
                        and name like 'dev%'
                        ORDER BY FreeSpaceMB
                        
                        while @remainingspacetoadd > 0
                        begin
                            if @curaddedspace >= @step and @remainingspacetoadd >= @step
                                set @curaddedspace_actual = @step
                            
                            else if @curaddedspace >= @step and @remainingspacetoadd < @step
                                set @curaddedspace_actual = @remainingspacetoadd
                            
                            else if @curaddedspace < @step and @remainingspacetoadd >= @step
                                set @curaddedspace_actual = @remainingspacetoadd - @curaddedspace
                                
                            else if @curaddedspace <= @step and @remainingspacetoadd < @step
                            begin
                                set @curaddedspace_actual = @curaddedspace
                                if @curaddedspace_actual <= 0
                                    set @curaddedspace_actual = @remainingspacetoadd
                            end
                                
                            set @msg = 'adding ' + convert(varchar(50),@curaddedspace_actual) + ' using device ' + @device + '. Space left to add: ' + convert(varchar(50),@remainingspacetoadd - @curaddedspace_actual) + '.'
                            print @msg
                            
                            set @cmd = 'alter database ' + @db + ' on ' + @device + ' = ' + convert(varchar(50),@curaddedspace_actual)
                            exec (@cmd)
                                   
                            set @remainingspacetoadd = @remainingspacetoadd - @curaddedspace_actual
                            
                            select top 1 @device=name,@curaddedspace=FreeSpaceMB from (
                            SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                            ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                            FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                            AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                            FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                            AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                            master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                            where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                            and name not like 'log%'
                            and name like 'dev%'
                            ORDER BY FreeSpaceMB
                            
                        end
                        
                        select @totalAvailableSpace=sum(FreeSpaceMB) from (
                        SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes' ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                        ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                        FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                        AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                        FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                        AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                        master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                        where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                        and name not like 'log%'
                        and name like 'dev%'
                            
                        set @msg = char(10) + char(10) + 'You have ' + cast(@totalAvailableSpace as varchar(50)) + ' MB of free space available for data segments.' + char(10) + char(10)
                    
                        if @dbgrowth is not null
                            set @msg = @msg + 'Current daily growth is at ' + convert(varchar(50),@dbgrowth) + ' MB. Sybase will run out of space in ' + convert(varchar(50),round(@totalAvailableSpace/@dbgrowth,2)) + ' days based on the current growth.' + char(10) + char(10)
                        else
                            set @msg = @msg + 'Information about growth rate not available. Create and populate table dba.dbo.db_space to display the growth trends.'
                            print @msg
                        --select 'You have ' + cast(@totalAvailableSpace as varchar(50)) + ' MB of free space available for data segments.'
                    end
                end   
                if @segment not in ('default','logsegment')
                begin
                
                    select top 1 @device=name,@curaddedspace=FreeSpaceMB 
                    from (
                    SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                    ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                    FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                    AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                    FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                    AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                    master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                    where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                    and name not like 'log%'
                    and name like 'dev%'
                    ORDER BY FreeSpaceMB
                    
                    while @remainingspacetoadd > 0
                    begin
                        if @curaddedspace >= @step and @remainingspacetoadd >= @step
                            set @curaddedspace_actual = @step
                        
                        else if @curaddedspace >= @step and @remainingspacetoadd < @step
                            set @curaddedspace_actual = @remainingspacetoadd
                        
                        else if @curaddedspace < @step and @remainingspacetoadd >= @step
                            set @curaddedspace_actual = @remainingspacetoadd - @curaddedspace
                            
                        else if @curaddedspace <= @step and @remainingspacetoadd < @step
                        begin
                            set @curaddedspace_actual = @curaddedspace
                            if @curaddedspace_actual <= 0
                                set @curaddedspace_actual = @remainingspacetoadd
                        end
                            
                        set @msg = 'adding ' + convert(varchar(50),@curaddedspace_actual) + ' using device ' + @device + '. Space left to add: ' + convert(varchar(50),@remainingspacetoadd - @curaddedspace_actual) + '.'
                        print @msg
                        
                        set @cmd = 'alter database ' + @db + ' on ' + @device + ' = ' + convert(varchar(50),@curaddedspace_actual)
                        exec (@cmd)
                               
                        set @remainingspacetoadd = @remainingspacetoadd - @curaddedspace_actual
                        
                        set @cmd = 'exec '+ @db + '..sp_extendsegment  '''+@segment+''',''' + @db + ''', ' + @device
                        exec (@cmd)
                        
                        select top 1 @device=name,@curaddedspace=FreeSpaceMB from (
                        SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                        ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                        FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                        AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                        FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                        AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                        master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                        where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                        and name not like 'log%'
                        and name like 'dev%'
                        ORDER BY FreeSpaceMB
                        
                    end
                    
                    select @totalAvailableSpace=sum(FreeSpaceMB) from (
                    SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes' ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                    ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                    FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                    AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                    FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                    AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                    master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                    where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                    and name not like 'log%'
                    and name like 'dev%'
                    
                    set @msg = char(10) + char(10) + 'You have ' + cast(@totalAvailableSpace as varchar(50)) + ' MB of free space available for data segments.' + char(10) + char(10)
                
                    if @dbgrowth is not null
                        set @msg = @msg + 'Current daily growth is at ' + convert(varchar(50),@dbgrowth) + ' MB. Sybase will run out of space in ' + convert(varchar(50),round(@totalAvailableSpace/@dbgrowth,2)) + ' days based on the current growth.' + char(10) + char(10)
                    else
                        set @msg = @msg + 'Information about growth rate not available. Create and populate table dba.dbo.db_space to display the growth trends.'
                        print @msg
                    --select 'You have ' + cast(@totalAvailableSpace as varchar(50)) + ' MB of free space available for data segments.'
                end
                    
                if @segment = 'logsegment'
                begin
                    if @ignoreProd = 0
                    begin
                        select @cpdb1space = logSize from master..prod_db_space where name = @db
                
                        if @cpdb1space is null 
                        begin
                            RAISERROR 99999 'Could not get the current space used for the database from the production server. Check if the appropriate proxy table is created and that there are records for this database.'
                            return 1
                        end
                        
                        select @stdbyspacetoadd=@cpdb1space - ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end))
                        from master..sysdatabases d, master..sysusages u
                        where u.dbid = d.dbid  and d.status != 256
                        and @db=d.name
                        group by d.dbid
                        
                        set @remainingspacetoadd = @stdbyspacetoadd
                    end
                    
                    if @remainingspacetoadd <= 0
                    begin
                        print 'no space left to add'
                    end
                    else
                    begin
                        select top 1 @device=name,@curaddedspace=FreeSpaceMB from (
                        SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                        ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                        FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                        AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                        FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                        AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                        master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                        where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                        and name like 'log%'
                        ORDER BY FreeSpaceMB
                        
                        while @remainingspacetoadd > 0
                        begin
                            if @curaddedspace >= @step and @remainingspacetoadd >= @step
                                set @curaddedspace_actual = @step
                            
                            else if @curaddedspace >= @step and @remainingspacetoadd < @step
                                set @curaddedspace_actual = @remainingspacetoadd
                            
                            else if @curaddedspace < @step and @remainingspacetoadd >= @step
                                set @curaddedspace_actual = @remainingspacetoadd - @curaddedspace
                                
                            else if @curaddedspace <= @step and @remainingspacetoadd < @step
                            begin
                                set @curaddedspace_actual = @curaddedspace
                                if @curaddedspace_actual <= 0
                                    set @curaddedspace_actual = @remainingspacetoadd
                            end
                                
                            set @msg = 'adding ' + convert(varchar(50),@curaddedspace_actual) + ' using device ' + @device + '. Space left to add: ' + convert(varchar(50),@remainingspacetoadd - @curaddedspace_actual) + '.'
                            print @msg
                            
                            set @cmd = 'alter database ' + @db + ' log on ' + @device + ' = ' + convert(varchar(5),@curaddedspace_actual)
                            exec (@cmd)
                            
                            set @remainingspacetoadd = @remainingspacetoadd - @curaddedspace_actual
                            
                            select top 1 @device=name,@curaddedspace=FreeSpaceMB from (
                            SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                            ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                            FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                            AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                            FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                            AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                            master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                            where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                            and name like 'log%'
                            ORDER BY FreeSpaceMB
                        end
                    
                        select @totalAvailableSpace=sum(FreeSpaceMB) from (
                        SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes' ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                        ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                        FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                        AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                        FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                        AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                        master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                        where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                        and name like 'log%'
                        
                        set @msg = char(10) + char(10) + 'You have ' + cast(@totalAvailableSpace as varchar(50)) + ' MB of free space available for log segments.' + char(10)
                        print @msg
                        --select 'You have ' + cast(@totalAvailableSpace as varchar(50)) + ' MB of free space available for data segments.'
                    end
                end
            end    
        end
    end
end
GO
