declare @text varchar(100)
select @text        = "%tttl%"

select distinct o.name object
from sysobjects o,
    syscomments c
where o.id=c.id
and o.type='P'
and (c.text like @text
or  exists(
    select 1 from syscomments c2 
        where c.id=c2.id 
        and c.colid+1=c2.colid 
        and right(c.text,100)+ substring(c2.text, 1, 100) like @text 
    )
)
order by 1