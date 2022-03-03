-- Attività 17716 Modifiche a oggetti di GM per BO e DISCOVERER
start crp_gp4gm.sql
start crp_gp4_anag.sql
start crp_gp4_atti.sql
start crp_gp4_ceco.sql
start crp_gp4_clfu.sql
start crp_gp4_cont.sql
start crp_gp4_evra.sql
start crp_gp4_figi.sql
start crp_gp4_pofu.sql
start crp_gp4_ruol.sql
start crp_gp4_tira.sql
start crp_gp4_atgi.sql
start crp_gp4_coat.sql
start crp_gp4_prpr.sql

-- Nuovi campi su RELAZIONI_UO
alter table RELAZIONI_UO add SEQUENZA_FIGLIO NUMBER(6);
alter table RELAZIONI_UO add SEQUENZA_PADRE NUMBER(6);
alter table RELAZIONI_UO add DESCRIZIONE_FIGLIO VARCHAR2(120);
alter table RELAZIONI_UO add DESCRIZIONE_PADRE VARCHAR2(120);
alter table RELAZIONI_UO add LIVELLO_FIGLIO NUMBER(2);
alter table RELAZIONI_UO add LIVELLO_PADRE NUMBER(2);

-- Nuovi triggers di allineamento di REUO
start crf_STAM_REUO_TMA.sql
start crf_SUST_REUO_TMA.sql
start crf_UNOR_REUO_TMA.sql

-- Nuove viste

start crv_bi_anin.sql
start crv_bi_unor.sql
start crv_bi_asco.sql
start crv_bi_asgi.sql
start crv_bi_dogi.sql
start crv_bi_pedo.sql
start crv_bi_pegi.sql
start crv_bi_pera.sql

