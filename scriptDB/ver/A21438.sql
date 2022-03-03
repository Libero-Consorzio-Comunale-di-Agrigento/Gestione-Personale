/*==============================================================*/
/* Table: PEB_REF_CODES                                         */
/*==============================================================*/
CREATE TABLE PEB_REF_CODES 
( 
  RV_LOW_VALUE     VARCHAR2(240)  NOT NULL, 
  RV_HIGH_VALUE    VARCHAR2(240)      NULL, 
  RV_ABBREVIATION  VARCHAR2(240)      NULL, 
  RV_DOMAIN        VARCHAR2(100)  NOT NULL, 
  RV_MEANING       VARCHAR2(240)      NULL, 
  RV_TYPE          VARCHAR2(10)       NULL,  
  RV_MEANING_AL1   VARCHAR2(240)      NULL, 
  RV_MEANING_AL2   VARCHAR2(240)
)
; 
CREATE INDEX X_PEB_REF_CODES_1 ON 
  PEB_REF_CODES(RV_DOMAIN, RV_LOW_VALUE);

start crt_gp4eb.sql
start crf_gp4eb.sql
start crp_gp4eb.sql
start crp_GP4_BADGE.sql

/* Nuovi Codici di Errore */
INSERT INTO A_ERRORI 
( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA ) 
VALUES ( 'P00700', 'Numero Badge già utilizzato', NULL, NULL, NULL); 
INSERT INTO A_ERRORI 
( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA ) 
VALUES ( 'P00701', 'Numero Badge non utilizzabile', NULL, NULL, NULL); 
INSERT INTO A_ERRORI 
( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA ) 
VALUES ( 'P00702', 'Numero Badge maggiore del massimo consentito', NULL, NULL, NULL); 
INSERT INTO A_ERRORI 
( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA ) 
VALUES ( 'P00703', 'Impossibile assegnare un Numero Badge', NULL, NULL, NULL); 
INSERT INTO A_ERRORI 
( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA ) 
VALUES ( 'P00704', 'Periodo esterno al periodo di lavoro del dipendente', NULL, NULL, NULL); 
INSERT INTO A_ERRORI 
( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA ) 
VALUES ( 'P00705', 'Il periodo di assegnazione non copre completamente il periodo di lavoro', NULL, NULL, NULL); 
INSERT INTO A_ERRORI 
( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA ) 
VALUES ( 'P00706', 'Causale Chiusura e Data chiusura attribuzione entrambi obbligatori', NULL, NULL, NULL);
