create procedure print_object_definition(@trigger_name varchar(255))
as
begin
	create table tempdb..triggertext (triggertext text)

	declare trigger_text_cursor cursor
	for select c.text 
	from syscomments c, sysobjects o 
	where o.id=c.id and o.name=@trigger_name order by c.colid
	for read only

	declare @triggertext varchar(16384)
	declare @triggertext2 varchar(16384)
	declare @text varchar(255)
	declare @index int

	open trigger_text_cursor
	fetch trigger_text_cursor into @text

	while @@sqlstatus = 0
	begin
		-- Appends each line of the trigger text in syscomments to the text already gathered.
		set @triggertext=coalesce(@triggertext, '')+@text 		
		-- Loop through the lines (delimited by a line feed
		select @index=charindex(Char(10),@triggertext)
		while (@index >0)
		begin
			select @triggertext2=substring(@triggertext,1,@index-1)			
			-- Add each line to the table
			if (@triggertext2 is not null)
				insert into tempdb..triggertext (triggertext) values(@triggertext2)
			-- Continue with the rest of the string
			select @triggertext=substring(@triggertext,@index+1,16384)
			select @index=charindex(Char(10),@triggertext)
		end
		fetch trigger_text_cursor into @text
	end

	close trigger_text_cursor
	deallocate cursor trigger_text_cursor

	if (@triggertext is not null)
		insert into tempdb..triggertext (triggertext) values(@triggertext)

	select triggertext from tempdb..triggertext
	drop table tempdb..triggertext
end
go

exec print_object_definition 'bctt_delivery_ev_search_v2'