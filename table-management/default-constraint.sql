--alter the value for a default cosntraint
alter table points_no_ranges replace service_dg default 'Y'
alter table points_no_ranges replace service_cos default 'Y'
go

--adding a new column with a default value bound to it
alter table cmf_data..misc_charges_hist add inserted_on datetime default (getdate()) null
go
