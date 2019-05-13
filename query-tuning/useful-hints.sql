select d.* 
from cmf_data_lm..pr_fee_packageid  d 
inner join cmf_data_lm..pr_shipment f (index idx1) on d.customer_num = f.customer_num and d.waybill=f.waybill  and d.document_date=f.document_date and d.document_id=f.document_id 
where f.inserted_on < dateadd(yy,-1,getdate())
plan '(use optgoal allrows_oltp)'
go


set statistics time off
set statistics io off
set statistics plancost off