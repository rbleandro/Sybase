exec dba.dbo.sp_DeviceReport 
go
create or replace procedure sp_DeviceReport (@returnAll bit=0, @logOnly bit = 0, @dataOnly bit = 0, @excludeFull bit = 1)
as
begin

    declare @command varchar(4000)
    set @command = ''

    if @returnAll = 1
    begin
        set @command = @command + '
            select * from (
            SELECT
            DISTINCT
            D.name,
            CASE WHEN D.status = 0 THEN ''Yes''
            ELSE ''No'' END as Status,
            D.vdevno,
            CONVERT (DECIMAL (14, 2),
                     ROUND (CONVERT (DECIMAL (14, 2),
                                     (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),
                            2)) ''TotalSpaceMB'',
            CONVERT (DECIMAL (14, 2),
                     (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),
                                            2),
                                     0.0)
                      FROM
                          master..sysusages U2,
                          master..sysdevices D2,
                          master..spt_values V
                      WHERE
                          U2.vstart BETWEEN D2.low AND D2.high AND
                          D2.low <= (U2.size + U2.vstart) AND
                          D2.high >= (U2.size + U2.vstart - 1) AND
                          (D2.status & 2 = 2 OR
                           D2.status = 0) AND
                          V.type = ''S'' AND
                          U2.segmap & 7 = V.number AND
                          D.vdevno = U2.vdevno AND
                          D2.name = D.name)) ''SpaceReservedMB'',
            CONVERT (DECIMAL (14, 2),
                     ROUND (CONVERT (DECIMAL (14, 2),
                                     (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),
                            2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),
                                                        2),
                                                 0.0)
                                  FROM
                                      master..sysusages U2,
                                      master..sysdevices D2,
                                      master..spt_values V
                                  WHERE
                                      U2.vstart BETWEEN D2.low AND D2.high AND
                                      D2.low <= (U2.size + U2.vstart) AND
                                      D2.high >= (U2.size + U2.vstart - 1) AND
                                      (D2.status & 2 = 2 OR
                                       D2.status = 0) AND
                                      V.type = ''S'' AND
                                      U2.segmap & 7 = V.number AND
                                      D.vdevno = U2.vdevno AND
                                      D2.name = D.name)) ''FreeSpaceMB'',
            D.phyname,
            CASE D.mirrorname WHEN NULL THEN 0
            ELSE 1 END AS ismirrored
            
        FROM
            master..sysdevices D,
            master..spt_values V
        WHERE
            D.cntrltype = 0 AND
            (D.status & 2 = 2 OR
             D.status = 0) AND
            V.type = ''E'' AND
            V.number = 3
        )    as a'
    end
    else
    begin
        set @command = @command + '
            select * from (
            SELECT
            DISTINCT
            D.name,
            CASE WHEN D.status = 0 THEN ''Yes''
            ELSE ''No'' END as Status,
            D.vdevno,
            CONVERT (DECIMAL (14, 2),
                     ROUND (CONVERT (DECIMAL (14, 2),
                                     (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),
                            2)) ''TotalSpaceMB'',
            CONVERT (DECIMAL (14, 2),
                     (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),
                                            2),
                                     0.0)
                      FROM
                          master..sysusages U2,
                          master..sysdevices D2,
                          master..spt_values V
                      WHERE
                          U2.vstart BETWEEN D2.low AND D2.high AND
                          D2.low <= (U2.size + U2.vstart) AND
                          D2.high >= (U2.size + U2.vstart - 1) AND
                          (D2.status & 2 = 2 OR
                           D2.status = 0) AND
                          V.type = ''S'' AND
                          U2.segmap & 7 = V.number AND
                          D.vdevno = U2.vdevno AND
                          D2.name = D.name)) ''SpaceReservedMB'',
            CONVERT (DECIMAL (14, 2),
                     ROUND (CONVERT (DECIMAL (14, 2),
                                     (D.high - D.low + 1)) * (@@PAGESIZE / 1048576.0),
                            2) - (SELECT ISNULL (ROUND (SUM (U2.size * (@@MAXPAGESIZE / 1048576.0)),
                                                        2),
                                                 0.0)
                                  FROM
                                      master..sysusages U2,
                                      master..sysdevices D2,
                                      master..spt_values V
                                  WHERE
                                      U2.vstart BETWEEN D2.low AND D2.high AND
                                      D2.low <= (U2.size + U2.vstart) AND
                                      D2.high >= (U2.size + U2.vstart - 1) AND
                                      (D2.status & 2 = 2 OR
                                       D2.status = 0) AND
                                      V.type = ''S'' AND
                                      U2.segmap & 7 = V.number AND
                                      D.vdevno = U2.vdevno AND
                                      D2.name = D.name)) ''FreeSpaceMB'',
            D.phyname,
            CASE D.mirrorname WHEN NULL THEN 0
            ELSE 1 END AS ismirrored
            
        FROM
            master..sysdevices D,
            master..spt_values V
        WHERE
            D.cntrltype = 0 AND
            (D.status & 2 = 2 OR
             D.status = 0) AND
            V.type = ''E'' AND
            V.number = 3
        )    as a
        where 1=1
        and a.name not in (''master'',''sysprocsdev'',''sybmgmtdev'')'
        
        if @excludeFull = 1 set @command = @command + ' and a.FreeSpaceMB>0'
        
        if @logOnly = 1 set @command = @command + ' and D.name like ''%log%'''
        
        if @dataOnly = 1 set @command = @command + ' and D.name like ''%data%'''
        
        set @command = @command + ' ORDER BY FreeSpaceMB' 
        
        
    end
    
    --select @command
    exec(@command)
end
go