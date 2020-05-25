
--GET SERVER WAITS INFO
select case ServerUserID
               when 0 then "Y"
               else "N"
       end as "Server",
       Description,
       convert(bigint,sum(convert(bigint,w.Waits))) as "Count"
       ,convert(bigint,sum(convert(bigint,w.WaitTime))/1000) as "Seconds"
       from    monProcessWaits w,
               monWaitEventInfo ei
       where   w.WaitEventID   = ei.WaitEventID
       group   by case ServerUserID
               when 0 then "Y"
               else "N"
       end,Description
       order   by 1 ASC,4 desc
go

--GET PROCESS WAITS INFO
select Description,
       convert(int,sum(w.Waits)) as "Count",
       convert(int,sum(w.WaitTime)/1000) as "Seconds"
       from    monSysWaits w,
               monWaitEventInfo ei
       where   w.WaitEventID   = ei.WaitEventID
       group   by Description
       order   by 3 desc
go


select WaitEventID,
 convert(numeric(16,0),Waits) as "Waits",
 convert(numeric(16,0),WaitTime) as "WaitTime"
 into #waits1
 from monSysWaits
go
select Description,
 convert(int,sum(w.Waits)) as "Count",
 convert(int,sum(w.WaitTime)/1000) as "Seconds"
 from #waits1 w,
 monWaitEventInfo ei
 where w.WaitEventID = ei.WaitEventID
 group by Description
 order by 3 desc