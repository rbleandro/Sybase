/*
==Step 1:
Check which segment fails (eg default, or image_seg) in the email subject.
*/
/*
==Step 2: 
Find out how much space is actually left:
*/
use master
declare @db varchar(100),@cpdb1space bigint,@stdbyspacetoadd bigint,@segment varchar(50),@device varchar(100),@curaddedspace int,@remainingspacetoadd int,@msg varchar(4000),@cmd varchar(8000)
set @db = 'lmscan' --input the database name here
set @segment='default' --values: default, image_seg or log
set @cpdb1space =  2063515 --input the current production db space here (after adding the space there)
set @stdbyspacetoadd=0

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
--exec sp_helpdb lmscan
--select @@servername

if @@servername = 'CPDB2' --input the current production server (machine host) here!!!
begin
    if @segment = 'default'
    begin
        set @remainingspacetoadd=50000
        
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
        and name not like 'logdev%'
        ORDER BY FreeSpaceMB
        
        while @remainingspacetoadd > 0
        begin
            if @curaddedspace > 10000
                set @curaddedspace = 10000
                
            set @msg = 'adding ' + convert(varchar(50),@curaddedspace) + ' using device ' + @device + '. Space left to add: ' + convert(varchar(50),@remainingspacetoadd - @curaddedspace) + '.'
            print @msg
            
            set @cmd = 'alter database ' + @db + ' on ' + @device + ' = ' + convert(varchar(50),@curaddedspace)
            
            exec (@cmd)
                   
            set @remainingspacetoadd = @remainingspacetoadd - @curaddedspace
            
            select top 1 @device=name,@curaddedspace=FreeSpaceMB from (
            SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
            ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
            FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
            AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
            FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
            AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
            master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
            where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
            and name not like 'logdev%'
            ORDER BY FreeSpaceMB
            
        end
        
        exec sp_helpdb lmscan
    end
    
    if @segment = 'image_seg'
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
        and name not like 'logdev%'
        ORDER BY FreeSpaceMB
        
        while @remainingspacetoadd > 0
        begin
            if @curaddedspace > 10000
                set @curaddedspace = 10000
                
            set @msg = 'adding ' + convert(varchar(50),@curaddedspace) + ' using device ' + @device + '. Space left to add: ' + convert(varchar(50),@remainingspacetoadd - @curaddedspace) + '.'
            print @msg
            
            set @cmd = 'alter database ' + @db + ' on ' + @device + ' = ' + convert(varchar(50),@curaddedspace)
            
            exec (@cmd)
                   
            set @remainingspacetoadd = @remainingspacetoadd - @curaddedspace
            
            select top 1 @device=name,@curaddedspace=FreeSpaceMB from (
            SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
            ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
            FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
            AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
            FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
            AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
            master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
            where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
            and name not like 'logdev%'
            ORDER BY FreeSpaceMB
            
        end
        
        set @cmd = 'exec sp_extendsegment  ''image_seg'',''' + @db + ''', ' + @device
        exec (@cmd)
        
        exec sp_helpdb lmscan
    end
    
    
end
else
begin
    select db_name(d.dbid) as db_name,
    ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) as data_size_MB,
    ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then size - curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end)/1048576.*@@maxpagesize) as data_used_MB,
    --ceiling(100 * (1 - 1.0 * sum(case when u.segmap != 4 and vdevno >= 0 then curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end) / sum(case when u.segmap != 4 then u.size end))) as data_used_pct,
    ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) as log_size_MB,
    ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end) - lct_admin("logsegment_freepages",d.dbid)/1048576.*@@maxpagesize) as log_used_MB
    --ceiling(100 * (1 - 1.0 * lct_admin("logsegment_freepages",d.dbid) / sum(case when u.segmap in (4, 7) and vdevno >= 0 then u.size end))) as log_used_pct 
    ,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) - ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then size - curunreservedpgs(u.dbid, u.lstart, u.unreservedpgs) end)/1048576.*@@maxpagesize) as UnusedDataSpace_MB
    ,ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) - ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end) - lct_admin("logsegment_freepages",d.dbid)/1048576.*@@maxpagesize) as UnusedLogSpace_MB
    ,ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) + ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)) as TotalDatabaseSpace_MB
    ,case when @cpdb1space - (ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) + ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end))) <=0 then 0 else @cpdb1space - (ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) + ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end))) end as SpaceToAdd_MB
    from master..sysdatabases d, master..sysusages u
    where u.dbid = d.dbid  and d.status != 256
    and @db=db_name(d.dbid)
    group by d.dbid
    order by db_name(d.dbid)
    
    select @stdbyspacetoadd=@cpdb1space - (ceiling(sum(case when u.segmap != 4 and vdevno >= 0 then (u.size/1048576.)*@@maxpagesize end )) + ceiling(sum(case when u.segmap = 4 and vdevno >= 0 then u.size/1048576.*@@maxpagesize end)))
    from master..sysdatabases d, master..sysusages u
    where u.dbid = d.dbid  and d.status != 256
    and @db=db_name(d.dbid)
    group by d.dbid
    order by db_name(d.dbid)
    
    /*
    select * from (
    SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
    ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
     FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
     AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
     FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
     AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
     master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
     where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev') 
     ORDER BY FreeSpaceMB
    */
    
    set @remainingspacetoadd = @stdbyspacetoadd
    select @remainingspacetoadd
    
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
        and name not like 'logdev%'
        ORDER BY FreeSpaceMB
        
        while @remainingspacetoadd > 0
        begin
            if @curaddedspace > 10000
                set @curaddedspace = 10000
                
            set @msg = 'adding ' + convert(varchar(50),@curaddedspace) + ' using device ' + @device + '. Space left to add: ' + convert(varchar(50),@remainingspacetoadd - @curaddedspace) + '.'
            print @msg
            
            set @cmd = 'alter database ' + @db + ' on ' + @device + ' = ' + convert(varchar(50),@curaddedspace)
            
            exec (@cmd)
                   
            set @remainingspacetoadd = @remainingspacetoadd - @curaddedspace
            
            select top 1 @device=name,@curaddedspace=FreeSpaceMB from (
            SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
            ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
            FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
            AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
            FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
            AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
            master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
            where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
            and name not like 'logdev%'
            ORDER BY FreeSpaceMB
            
        end
    end
    
    if @segment = 'image_seg'
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
        and name not like 'logdev%'
        ORDER BY FreeSpaceMB
        
        while @remainingspacetoadd > 0
        begin
            if @curaddedspace > 10000
                set @curaddedspace = 10000
                
            set @msg = 'adding ' + convert(varchar(50),@curaddedspace) + ' using device ' + @device + '. Space left to add: ' + convert(varchar(50),@remainingspacetoadd - @curaddedspace) + '.'
            print @msg
            
            set @cmd = 'alter database ' + @db + ' on ' + @device + ' = ' + convert(varchar(50),@curaddedspace)
            
            exec (@cmd)
                   
            set @remainingspacetoadd = @remainingspacetoadd - @curaddedspace
            
            select top 1 @device=name,@curaddedspace=FreeSpaceMB from (
            SELECT    DISTINCT D.name,CASE WHEN D.status = 0 THEN 'Yes'ELSE 'No' END as Status,D.vdevno,CONVERT (DECIMAL (14, 2),ROUND (CONVERT (DECIMAL (14, 2),(D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),2)) 'TotalSpaceMB',CONVERT (DECIMAL (14, 2)
            ,(SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),2),0.0)
            FROM master..sysusages U2,master..sysdevices D2,master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number AND D.vdevno = U2.vdevno 
            AND D2.name = D.name)) 'SpaceReservedMB', CONVERT (DECIMAL (14, 2), ROUND (CONVERT (DECIMAL (14, 2), (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0), 2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)), 2), 0.0) 
            FROM master..sysusages U2, master..sysdevices D2, master..spt_values V WHERE U2.vstart BETWEEN D2.low AND D2.high AND D2.low <= (U2.size + U2.vstart) AND D2.high >= (U2.size + U2.vstart - 1) AND (D2.status & 2 = 2 OR D2.status = 0) AND V.type = 'S' AND U2.segmap & 7 = V.number 
            AND D.vdevno = U2.vdevno AND D2.name = D.name)) 'FreeSpaceMB', D.phyname, CASE D.mirrorname WHEN NULL THEN 0 ELSE 1 END AS ismirrored FROM
            master..sysdevices D, master..spt_values V WHERE D.cntrltype = 0 AND (D.status & 2 = 2 OR D.status = 0) AND V.type = 'E' AND V.number = 3 )    as a 
            where a.FreeSpaceMB>0 and a.name not in ('master','sysprocsdev','sybmgmtdev','systemdbdev') 
            and name not like 'logdev%'
            ORDER BY FreeSpaceMB
            
        end
        
        set @cmd = 'exec sp_extendsegment  ''image_seg'',''' + @db + ''', ' + @device
        exec (@cmd)
    end
end    
go


---- log space or package
--use master
--go
--alter database lmscan log on logdev# = 10000

/*
==Step 5:
The above steps must be performed on CPDB2 as well!
If CPDB2 was forgotten, sp_helpdb on CPDB1 will show the history of the increases, so that you can sync them.

==Step 6:
Use sp_helpdb to validate that the size has increased.
The db_size from sp_helpdb must match between CPDB1 and CPDB2
*/
/*
go
use lmscan
go
sp_dropsegment "default",lmscan,systemdbdev
go
use master
go
select dbid, name, segmap
from sysusages, sysdevices
where sysdevices.low <= sysusages.size + vstart
  and sysdevices.high >= sysusages.size + vstart -1
  and dbid = (select dbid from sysdatabases where name='lmscan')
  and (status = 2 or status = 3)
go
*/