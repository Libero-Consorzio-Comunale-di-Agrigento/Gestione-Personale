alter table informazioni_extracontabili 
add (
 ipn_fam_1                       NUMBER(12,2)     NULL,
 ipn_fam_2                       NUMBER(12,2)     NULL,
 ipn_fam_3                       NUMBER(12,2)     NULL,
 ipn_fam_4                       NUMBER(12,2)     NULL,
 ipn_fam_5                       NUMBER(12,2)     NULL,
 ipn_fam_6                       NUMBER(12,2)     NULL,
 ipn_fam_7                       NUMBER(12,2)     NULL,
 ipn_fam_8                       NUMBER(12,2)     NULL,
 ipn_fam_9                       NUMBER(12,2)     NULL,
 ipn_fam_10                      NUMBER(12,2)     NULL,
 ipn_fam_11                      NUMBER(12,2)     NULL,
 ipn_fam_12                      NUMBER(12,2)     NULL
);

update informazioni_extracontabili
set ipn_fam_1 = nvl(ipn_fam_1, ipn_fam_2ap)
  , ipn_fam_2 = nvl(ipn_fam_2, ipn_fam_2ap)
  , ipn_fam_3 = nvl(ipn_fam_3, ipn_fam_2ap)
  , ipn_fam_4 = nvl(ipn_fam_4, ipn_fam_2ap)
  , ipn_fam_5 = nvl(ipn_fam_5, ipn_fam_2ap)
  , ipn_fam_6 = nvl(ipn_fam_6, ipn_fam_2ap)
where nvl(IPN_FAM_2ap,0) != 0
/
update informazioni_extracontabili
set ipn_fam_7 = nvl(ipn_fam_7, ipn_fam_1ap)
  , ipn_fam_8 = nvl(ipn_fam_8, ipn_fam_1ap)
  , ipn_fam_9 = nvl(ipn_fam_9, ipn_fam_1ap)
  , ipn_fam_10 = nvl(ipn_fam_10, ipn_fam_1ap)
  , ipn_fam_11 = nvl(ipn_fam_11, ipn_fam_1ap)
  , ipn_fam_12 = nvl(ipn_fam_12, ipn_fam_1ap)
where nvl(IPN_FAM_1AP,0) != 0
/

start crp_gp4_inex.sql
start crp_gp4_cafa.sql
start crf_rire_cambio_anno.sql
start crp_peccadmi.sql
start crp_peccmore3.sql
start crp_peccmocp3.sql
start crp_peccsmdm.sql
start crp_pecsmor6.sql