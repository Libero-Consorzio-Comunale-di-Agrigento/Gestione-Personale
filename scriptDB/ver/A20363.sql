-- Esecuzione in UPGRADE degli script di allineamento DB previste in NEW INSTALL con DB standard

-- Eliminazione voci di menu del modulo PCW distribuite in Beta prima dell'installazione ufficiale del Modulo

delete from a_guide_o where guida_o = 'P_SWFAP';
delete from a_voci_menu where voce_menu = 'PGMSWFAP';
delete from a_menu where voce_menu = 'PGMSWFAP';

delete from a_voci_menu where voce_menu = 'PGMDSTMW';
delete from a_menu where voce_menu = 'PGMDSTMW';

delete from a_domini_selezioni where dominio = 'SWFAP.MODELLO';

-- Installazione degli oggetti di DB

/*==============================================================*/
/* Table: PCW_REF_CODES                                         */
/*==============================================================*/
CREATE TABLE PCW_REF_CODES 
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
CREATE INDEX X_PCW_REF_CODES_1 ON 
  PCW_REF_CODES(RV_DOMAIN, RV_LOW_VALUE);    

start crt_mowo.sql
start crt_stmw.sql
drop TABLE WORD_TEMP;
start crt_wote.sql

start crf_wpegi_qi_evento.sql

start crv_wana.sql
start crv_wass.sql
start crv_wcarr.sql
start crv_wcont.sql
start crv_wente.sql
start crv_wfam.sql
start CRV_wpegi.sql
start CRV_wpegi_d.sql
start CRV_wpegi_qi.sql
start CRV_wpegi_se.sql
start crv_wpse.sql
start crv_wsedi.sql
start crv_wsettori.sql

start crp_GP4_PEGI.sql
start crp_PCWSWFAP.sql

delete from pgm_ref_codes
 where rv_domain = 'MODELLI_WORD.VISTE';

-- Inserimento codici di errore

INSERT INTO A_ERRORI 
( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2, PROPRIETA )
VALUES ( 'P04400', 'Modello WORD non definito ', NULL, NULL, NULL); 

