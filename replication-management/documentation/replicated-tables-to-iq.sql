cpscan tttl_ma_eput3
cpscan tttl_ma_document 
cpscan tttl_ma_shipment
cpscan tttl_ma_barcode - transformed into batch replication just like Loomis

rev_hist bcxref 
rev_hist revhsth 
rev_hist revhstf1 

rev_hist_lm revhsth
rev_hist_lm revhstr
rev_hist_lm revhstf1 
rev_hist_lm bcxref 

svp_cp svp_parcel 


--cheat about subscription names:

CPDB2_iq_tttl_ma_barcode_sub
CPDB2_iq_tttl_ma_shipment_sub
CPDB2_iq_tttl_ma_document_sub
CPDB2_iq_tttl_ma_eput3_sub

CPDB2_iq_revhstf1_sub
CPDB2_iq_revhsth_sub
CPDB2_iq_bcxref_sub

CPDB2_iq_lm_revhsth_sub
CPDB2_iq_lm_revhstf1_sub
CPDB2_iq_lm_bcxref_sub
CPDB2_iq_lm_revhstr_sub

CPDB2_iq_cp_svp_parcel_sub --(couldn't find corresponding table in IQ)


-- cheat about replication definitions:
drop replication definition CPDB2_iq_tttl_ma_eput3_rep
drop replication definition CPDB2_iq_tttl_ma_document_rep
drop replication definition CPDB2_iq_cp_svp_parcel_rep
drop replication definition CPDB2_iq_tttl_ma_shipment_rep
drop replication definition CPDB2_iq_tttl_ma_barcode_rep

drop replication definition CPDB2_iq_revhstf1_rep
drop replication definition CPDB2_iq_lm_revhstf1_rep
drop replication definition CPDB2_iq_lm_revhsth_rep
drop replication definition CPDB2_iq_lm_bcxref_rep
drop replication definition CPDB2_iq_revhsth_rep
drop replication definition CPDB2_iq_lm_revhstr_rep
drop replication definition CPDB2_iq_lm_revhstm_rep
drop replication definition CPDB2_iq_bcxref_rep


--cheat about subscriptions and connections for IQ

drop subscription CPDB2_iq_tttl_ma_barcode_sub for CPDB2_iq_tttl_ma_barcode_rep with replicate at CPIQ.cpscan_iq_conn1 without purge;
drop subscription CPDB2_iq_tttl_ma_document_sub for CPDB2_iq_tttl_ma_document_rep with replicate at CPIQ.cpscan_iq_conn1 without purge;
drop subscription CPDB2_iq_tttl_ma_shipment_sub for CPDB2_iq_tttl_ma_shipment_rep with replicate at CPIQ.cpscan_iq_conn1 without purge;
drop subscription CPDB2_iq_tttl_ma_eput3_sub for CPDB2_iq_tttl_ma_eput3_rep with replicate at CPIQ.cpscan_iq_conn1 without purge;

drop subscription CPDB2_iq_bcxref_sub for CPDB2_iq_bcxref_rep with replicate at CPIQ.rev_hist_iq_conn1 without purge;
drop subscription CPDB2_iq_revhsth_sub for CPDB2_iq_revhsth_rep with replicate at CPIQ.rev_hist_iq_conn1 without purge;
drop subscription CPDB2_iq_revhstf1_sub for CPDB2_iq_revhstf1_rep with replicate at CPIQ.rev_hist_iq_conn1 without purge;

drop subscription CPDB2_iq_lm_bcxref_sub for CPDB2_iq_lm_bcxref_rep with replicate at CPIQ.lm_bcxref_iq_conn1 without purge;
drop subscription CPDB2_iq_lm_revhstm_sub for CPDB2_iq_lm_revhstm_rep with replicate at CPIQ.rev_hist_lm_iq_conn1 without purge;
drop subscription CPDB2_iq_lm_revhstr_sub for CPDB2_iq_lm_revhstr_rep with replicate at CPIQ.rev_hist_lm_iq_conn1 without purge;
drop subscription CPDB2_iq_lm_revhsth_sub for CPDB2_iq_lm_revhsth_rep with replicate at CPIQ.rev_hist_lm_iq_conn1 without purge;
drop subscription CPDB2_iq_lm_revhstf1_sub for CPDB2_iq_lm_revhstf1_rep with replicate at CPIQ.lm_revhstf1_iq_conn1 without purge;


drop subscription CPDB2_iq_cp_svp_parcel_sub for CPDB2_iq_cp_svp_parcel_rep with replicate at CPIQ.svp_cp_iq_conn1 without purge;




