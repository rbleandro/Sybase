CREATE LOGIN webpool_terminal
	WITH PASSWORD 'canpar'
	DEFAULT DATABASE cpscan
	DEFAULT LANGUAGE us_english
	EXEMPT INACTIVE LOCK TRUE
go

--to change a login's password
exec sp_password 'canpar','Kenway@86','rafael_leandro'
go


use cpscan
go
exec sp_adduser N'webpool_terminal', N'webpool_terminal', N'public'
GO
GRANT INSERT, UPDATE, DELETE ON dbo.tttl_ct_cod_totals_audit TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.st_errors_cats TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.tttl_cp_cod_package TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.terminal_subnets TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.web_terminal_address TO webpool_terminal
GO
GRANT INSERT, UPDATE ON dbo.sequence TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.tttl_ct_cod_totals TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.web_url_shortener TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.temp_tttl_dc_delivery_comment TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.temp_tttl_ev_event TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.employee TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.truck TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.delivery_address TO webpool_terminal
GO
GRANT INSERT, UPDATE ON dbo.tttl_ev_event_extended TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.tttl_cp_cod_package_audit TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.promotional_offers TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.lvd_recno TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.driver_stats TO webpool_terminal
GO
GRANT SELECT, INSERT, UPDATE, DELETE, REFERENCES ON dbo.COD_OTC TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.temp_tttl_ps_pickup_shipper TO webpool_terminal
GO
GRANT INSERT, UPDATE ON dbo.st_errors TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.sales_lead TO webpool_terminal
GO
GRANT INSERT, UPDATE ON dbo.tttl_pr_pickup_record TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.employee_terminal TO webpool_terminal
GO
GRANT INSERT, UPDATE ON dbo.tttl_ps_pickup_shipper TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.cod_htws_reciepts TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.tttl_ac_address_correction TO webpool_terminal
GO
GRANT INSERT, UPDATE ON dbo.tttl_dc_delivery_comment TO webpool_terminal
GO
GRANT INSERT, UPDATE ON dbo.large_volume_delivery_address TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.delivery_address_old TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.temp_tttl_pr_pickup_record TO webpool_terminal
GO
GRANT INSERT, UPDATE ON dbo.tttl_dr_delivery_record_redirect TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.st_errors_assign TO webpool_terminal
GO
GRANT INSERT, UPDATE ON dbo.st_errors_maint TO webpool_terminal
GO
GRANT INSERT, UPDATE ON dbo.tttl_ev_event_redirect TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.truck_stats TO webpool_terminal
GO
GRANT INSERT, UPDATE ON dbo.tttl_dr_delivery_record TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.terminal_printers TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.statuses TO webpool_terminal
GO
GRANT INSERT, UPDATE ON dbo.tttl_ev_event_signature TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.temp_tttl_dr_delivery_record TO webpool_terminal
GO
GRANT INSERT, UPDATE ON dbo.tttl_dr_delivery_record_signature TO webpool_terminal
GO
GRANT INSERT, UPDATE, DELETE ON dbo.st_errors_comments TO webpool_terminal
GO
GRANT EXECUTE ON dbo.lvd_next_recno TO webpool_terminal
GO
GRANT EXECUTE ON dbo.ilentry_getbarcodes TO webpool_terminal
GO
