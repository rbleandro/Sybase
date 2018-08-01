-- memory configuration overview
select convert(decimal(17,2), (value / 512.0)) as total_memory from master..syscurconfigs where config = (select distinct config from master..sysconfigures where name = 'max memory')
select convert(decimal(17,2), (value / 512.0)) as total_logical_memory from master..syscurconfigs where config = (select distinct config from master..sysconfigures where name = 'total logical memory')

select convert(decimal(17,2), (memory_used / 1024.0)) as total_data_memory from master..syscurconfigs where config = 132
select convert(decimal(17,2), (value / 1048576.0) * @@maxpagesize ) as total_procedure_memory from master..syscurconfigs where config = 146

