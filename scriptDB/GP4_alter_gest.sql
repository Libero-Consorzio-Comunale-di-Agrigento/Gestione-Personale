/*==============================================================*/
/* Aggiornamento campi GESTIONE per new install della 4.8       */
/*==============================================================*/

alter table AUTOMATISMI_PRESENZA modify gestione varchar2(8);
alter table CALCOLI_RETRIBUTIVI modify gestione varchar2(8);
alter table DENUNCIA_GLA modify gestione varchar2(8);
alter table DENUNCIA_IMPORTI_GLA modify gestione varchar2(8);
alter table DENUNCIA_INAIL modify gestione varchar2(8);
alter table DENUNCIA_INPDAP modify gestione varchar2(8);
alter table DENUNCIA_O1_INPS modify gestione varchar2(8);
alter table DEPOSITO_PERIODI_PRESENZA modify gestione varchar2(8);
alter table ESTRAZIONI_VOCE modify gestione varchar2(8);
alter table MOVIMENTI_BILANCIO_PREVISIONE modify gestione varchar2(8);
alter table PERIODI_GIURIDICI modify gestione varchar2(8);
alter table PERIODI_RETRIBUTIVI modify gestione varchar2(8);
alter table PERIODI_RETRIBUTIVI_BP modify gestione varchar2(8);
alter table QUALIFICHE_GESTIONI modify gestione varchar2(8);
alter table RAPPORTI_GIURIDICI modify gestione varchar2(8);
alter table RIPARTIZIONI_CONTABILI modify gestione varchar2(8);
alter table SETTORI modify gestione varchar2(8);
alter table SMT_IMPORTI modify gestione varchar2(8);
alter table SMT_INDIVIDUI modify gestione varchar2(8);
alter table SMT_PERIODI modify gestione varchar2(8);
alter table SOSPENSIONI_PROGRESSIONE modify gestione varchar2(8);
alter table VALORI_BASE_VOCE modify gestione varchar2(8);
alter table VALORI_BASE_VOCE_BP modify gestione varchar2(8);
