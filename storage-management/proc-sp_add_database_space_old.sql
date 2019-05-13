create or replace procedure sp_add_database_space (@db varchar(100),@segment varchar(50),@remainingspacetoadd int)
as
begin
    --declare @db varchar(100),@segment varchar(50)
    
    declare @msg varchar(4000),@cmd varchar(8000),@stdbyspacetoadd bigint,@device varchar(100),@curaddedspace int,@cpdb1space bigint,@curaddedspace_actual int,@step smallint
    --set @db = 'sort_data' --input the database name here
    --set @segment='default' --values: default, image_seg or log
    --set @cpdb1space = 37000 --input the current production db space here (after adding the space there)
    
    set @stdbyspacetoadd=0
    set @step = 5000
    
    if @db not like 'tempdb%'
    begin
        if @@servername in ('CPDB2'/*,'CPSYBTEST'*/)  --input the current production server (machine host) here!!! You can provide the result from the global variable @@servername.
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
                        set @curaddedspace_actual = @remainingspacetoadd - @curaddedspace
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
                    ORDER BY FreeSpaceMB
                    
                end
                
                --exec sp_helpdb @db
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
                        set @curaddedspace_actual = @remainingspacetoadd - @curaddedspace
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
                    ORDER BY FreeSpaceMB
                    
                end
                
            end
            
            --if @segment = 'logsegment'
            --begin
            --    select top 1 @device=name,@curaddedspace=FreeSpaceMB from (
            --    SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
            --    ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
            --    FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
            --    AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
            --    FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
            --    AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
            --    master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
            --    where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
            --    and name like 'log%'
            --    ORDER BY FreeSpaceMB
            --    
            --    set @cmd = 'use master alter database ' + @db + ' log on ' + @device + ' = ' + convert(varchar(5),@step)
            --    exec (@cmd)
            --    
            --    --exec sp_helpdb @db
            --end
            
            
            delete from dba.dbo.db_last_space where name = @db
            insert into dba.dbo.db_last_space (name,size)
            select d.name, ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) + ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) as TotalDatabaseSpace_MB
            from master..sysdatabases d, master..sysusages u
            where u.dbid = d.dbid  and d.status2 & 16 = 0 
            and d.name = @db
            group by d.dbid
            
        end
        else
        begin
            --select db_name(d.dbid) as db_name,
            --ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) as data_size_MB,
            --ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then size - curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end)/1048576.*@@maxpagesize) as data_used_MB,
            ----ceiling(100 * (1 - 1.0 * sum(case when u.segmap != 4 and vdevno >= 0 then curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end) / sum(case when u.segmap != 4 then u.size end))) as data_used_pct,
            --ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) as log_size_MB,
            --ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end) - lct_admin("logsegment_freepages",d.dbid)/1048576.*@@maxpagesize) as log_used_MB
            ----ceiling(100 * (1 - 1.0 * lct_admin("logsegment_freepages",d.dbid) / sum(case when u.segmap in (4, 7) and vdevno >= 0 then u.size end))) as log_used_pct 
            --,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) - ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then size - curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end)/1048576.*@@maxpagesize) as UnusedDataSpace_MB
            --,ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) - ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end) - lct_admin("logsegment_freepages",d.dbid)/1048576.*@@maxpagesize) as UnusedLogSpace_MB
            --,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) + ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) as TotalDatabaseSpace_MB
            --,case when @cpdb1space - (ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) + ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end))) <=0 then 0 else @cpdb1space - (ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) + ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end))) end as SpaceToAdd_MB
            --from master..sysdatabases d, master..sysusages u
            --where u.dbid = d.dbid  and d.status != 256
            --and @db=db_name(d.dbid)
            --group by d.dbid
            --order by db_name(d.dbid)
            
            select @cpdb1space = size from master..prod_db_space where name = @db
            
            if @cpdb1space is null 
            begin
                RAISERROR 99999 'Could not get the current space used for the database from the production server. Check if the appropriate proxy table is created and that there are records for this database.'
                return 1
            end
            
            select @stdbyspacetoadd=@cpdb1space - (ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) + ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)))
            from master..sysdatabases d, master..sysusages u
            where u.dbid = d.dbid  and d.status != 256
            and @db=d.name
            group by d.dbid
            
            set @remainingspacetoadd = @stdbyspacetoadd
            --select @remainingspacetoadd,@stdbyspacetoadd,@cpdb1space
            
            if @remainingspacetoadd > 0 
            begin
                if @segment = 'default'
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
                            set @curaddedspace_actual = @remainingspacetoadd - @curaddedspace
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
                        ORDER BY FreeSpaceMB
                        
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
                            set @curaddedspace_actual = @remainingspacetoadd - @curaddedspace
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
                        ORDER BY FreeSpaceMB
                        
                    end
                    
                   
                end
                
                --if @segment = 'logsegment'
                --begin
                --    select top 1 @device=name,@curaddedspace=FreeSpaceMB from (
                --    SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
                --    ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
                --    FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
                --    AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
                --    FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
                --    AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
                --    master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
                --    where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
                --    and name like 'log%'
                --    ORDER BY FreeSpaceMB
                --    
                --    set @cmd = 'use master alter database ' + @db + ' log on ' + @device + ' = ' + convert(varchar(5),@step)
                --    exec (@cmd)
                --    
                --    --exec sp_helpdb @db
                --end
            end
        end    
    end
end
go

