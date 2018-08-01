--select count(*) from lmscan..tttl_pr_pickup_record where  updated_on_cons < dateadd(yy,-7,getdate())
--select count(*) from lmscan..tttl_ps_pickup_shipper where  updated_on_cons < dateadd(yy,-7,getdate())
--select count(*) from lmscan..tttl_pt_pickup_totals where  updated_on_cons < dateadd(yy,-7,getdate())
--go
--
--select count(*) from cpscan..tttl_pr_pickup_record where  updated_on_cons < dateadd(yy,-7,getdate())
--select count(*) from cpscan..tttl_ps_pickup_shipper where  updated_on_cons < dateadd(yy,-7,getdate())
--select count(*) from cpscan..tttl_pt_pickup_totals where  updated_on_cons < dateadd(yy,-7,getdate())
--
--go

declare @count int
set @count=1000
--delete top 4000 from cpscan..tttl_pr_pickup_record where  updated_on_cons < dateadd(yy,-7,getdate())
--select @count=@@rowcount
--waitfor delay '00:00:02'
--select @count

set rowcount @count
while @count > 0
begin
delete top 1000 from cpscan..tttl_pr_pickup_record where  updated_on_cons < dateadd(yy,-7,getdate())
select @count=@@rowcount
waitfor delay '00:00:02'
select @count
end
go

