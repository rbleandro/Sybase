select  * 
,(SELECT 0 + COUNT(r2.employee_num)
FROM lmscan..lm_employee_xref r2
WHERE 1=1  
and (
        (r2.driver_num = r.driver_num and (r2.employee_num = r.employee_num) )
        or (r2.driver_num = r.driver_num and (r2.employee_num < r.employee_num) )
    )
) as rownum
from lmscan..lm_employee_xref r
where 1=1
and driver_num='897020064'
go



insert cpscan..tttl_mobitrax_jobs 
(
    raw_barcode, service_type, shipper_num, reference_num, barcode_lm, barcode_company,
    stop_type, conv_time_date, employee_num, scan_time_date, terminal_num, truck_num
)

select raw_barcode, service_type, shipper_num, reference_num, barcode, company,
   'DEL' as stop_type, session_start, employee_num, scanned_on, terminal_num, param_13
from 
(
    select bc.raw_barcode, bc.service_type, bc.shipper_num, bc.reference_num, bc.barcode, bc.company,
       'DEL' as stop_type, ev.session_start, ev.employee_num, ev.scanned_on, ev.terminal_num, ev.param_1
       ,(
           SELECT 0 + COUNT(ev2.barcode)
            FROM hub_db..event ev2
            WHERE 1=1  
            and 
            (
                (ev2.barcode = ev.barcode and (ev2.session_start = ev.session_start) )
                or (ev2.barcode = ev.barcode and (ev2.session_start > ev.session_start) )
            )
        ) as rownum
    from #event_bc bc
    join hub_db..event ev on (bc.raw_barcode=ev.barcode)
    where ev.status in ('WC')
) as a
where a.rownum=1
go


----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


select * 
into #to_delete
from (
select reference_num ,updated_on_cons
,(
           SELECT 0 + COUNT(ev2.reference_num)
            FROM rev_hist_lm..svb_outstanding ev2
            WHERE 1=1  
            and 
            (
                (ev2.reference_num = ev.reference_num and (ev2.updated_on_cons = ev.updated_on_cons) )
                or (ev2.reference_num = ev.reference_num and (ev2.updated_on_cons > ev.updated_on_cons) )
            )
        ) as rownum

from rev_hist_lm..svb_outstanding ev
--group by reference_num having count(reference_num) > 1
) as a
where a.rownum > 1
and reference_num in (select reference_num from rev_hist_lm..svb_outstanding group by reference_num having count(reference_num) > 1)
go

select * from rev_hist_lm..svb_outstanding where reference_num='0033738323                              '
go

select * from #to_delete
go

begin tran
delete rev_hist_lm..svb_outstanding 
from rev_hist_lm..svb_outstanding ev
inner join  #to_delete t on t.reference_num = ev.reference_num and t.updated_on_cons = ev.updated_on_cons
where t.rownum > 1
--commit
go

create unique nonclustered index idx_unique_refnum on rev_hist_lm..svb_outstanding(reference_num)
go


select (service_type + shipper_num + reference_num) as waybill from rev_hist..svb_outstanding group by (service_type + shipper_num + reference_num) having count((service_type + shipper_num + reference_num)) > 1
go

----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------



----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------