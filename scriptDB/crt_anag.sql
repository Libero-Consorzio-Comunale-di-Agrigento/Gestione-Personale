CREATE TABLE anagrafici(
 ni                              NUMBER(8,0)      NOT NULL,
 cognome                         VARCHAR(40)      NOT NULL,
 nome                            VARCHAR(36)      NULL,
 sesso                           VARCHAR(1)       NULL,
 data_nas                        DATE             NULL,
 provincia_nas                   NUMBER(3,0)      NULL,
 comune_nas                      NUMBER(3,0)      NULL,
 luogo_nas                       VARCHAR(30)      NULL,
 dal                             DATE             NOT NULL,
 al                              DATE             NULL,
 codice_fiscale                  VARCHAR(16)      NULL,
 cittadinanza                    VARCHAR(3)       NULL,
 indirizzo_res                   VARCHAR(40)      NULL,
 indirizzo_res_al1               VARCHAR(40)      NULL,
 indirizzo_res_al2               VARCHAR(40)      NULL,
 provincia_res                   NUMBER(3,0)      NULL,
 comune_res                      NUMBER(3,0)      NULL,
 cap_res                         VARCHAR(5)       NULL,
 tel_res                         VARCHAR(12)      NULL,
 presso                          VARCHAR(40)      NULL,
 indirizzo_dom                   VARCHAR(40)      NULL,
 indirizzo_dom_al1               VARCHAR(40)      NULL,
 indirizzo_dom_al2               VARCHAR(40)      NULL,
 provincia_dom                   NUMBER(3,0)      NULL,
 comune_dom                      NUMBER(3,0)      NULL,
 cap_dom                         VARCHAR(5)       NULL,
 tel_dom                         VARCHAR(12)      NULL,
 stato_civile                    VARCHAR(4)       NULL,
 cognome_coniuge                 VARCHAR(36)      NULL,
 titolo_studio                   VARCHAR(4)       NULL,
 titolo                          VARCHAR(20)      NULL,
 categoria_protetta              VARCHAR(4)       NULL,
 gruppo_ling                     VARCHAR(4)       NULL,
 partita_iva                     VARCHAR(11)      NULL,
 tessera_san                     VARCHAR(10)      NULL,
 numero_usl                      VARCHAR(40)      NULL,
 provincia_usl                   VARCHAR(3)       NULL,
 tipo_doc                        VARCHAR(4)       NULL,
 numero_doc                      VARCHAR(16)      NULL,
 provincia_doc                   NUMBER(3,0)      NULL,
 comune_doc                      NUMBER(3,0)      NULL,
 note                            VARCHAR(4000)    NULL,
 utente                          VARCHAR(8)       NULL,
 data_agg                        DATE             NULL,
 codice_fiscale_estero           VARCHAR(40)      NULL,
 fax_res                         VARCHAR(14)      NULL,
 fax_dom                         VARCHAR(14)      NULL,
 ambiente_prop                   VARCHAR(8)       NULL,
 telefono_ufficio                VARCHAR(14)      NULL,
 fax_ufficio                     VARCHAR(14)      NULL,
 e_mail                          VARCHAR(2000)    NULL,
 DENOMINAZIONE                   VARCHAR2(120),
 DENOMINAZIONE_AL1               VARCHAR2(120),
 DENOMINAZIONE_AL2               VARCHAR2(120),
 COMPETENZA_ESCLUSIVA            VARCHAR2(1),
 FLAG_TRG                        VARCHAR2(1),
 STATO_CEE                       VARCHAR2(2),
 TIPO_SOGGETTO                   VARCHAR2(4),
 FINE_VALIDITA                   DATE,
 id_foto                         NUMBER,
 GRUPPO_LING_PREF                VARCHAR2(4)
)
STORAGE  ( INITIAL &1DIMx500 )
;
COMMENT ON TABLE anagrafici
    IS 'ANAG - Anagrafe storica del personale';

PROMPT
PROMPT Creating Index ANAG_CAPR_FK on Table ANAGRAFICI
CREATE INDEX ANAG_CAPR_FK ON ANAGRAFICI
(
      categoria_protetta )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index ANAG_GRLI_FK on Table ANAGRAFICI
CREATE INDEX ANAG_GRLI_FK ON ANAGRAFICI
(
      gruppo_ling )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index ANAG_IK on Table ANAGRAFICI
CREATE INDEX ANAG_IK ON ANAGRAFICI
(
      cognome ,
      nome ,
      ni ,
      dal )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx200
  NEXT      &1DIMx100  
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index ANAG_IK2 on Table ANAGRAFICI
CREATE INDEX ANAG_IK2 ON ANAGRAFICI
(
      codice_fiscale )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index ANAG_INDI_FK on Table ANAGRAFICI
CREATE INDEX ANAG_INDI_FK ON ANAGRAFICI
(
      ni )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index ANAG_PK on Table ANAGRAFICI
CREATE UNIQUE INDEX ANAG_PK ON ANAGRAFICI
(
      ni ,
      dal )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index ANAG_STCI_FK on Table ANAGRAFICI
CREATE INDEX ANAG_STCI_FK ON ANAGRAFICI
(
      stato_civile )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index ANAG_TIST_FK on Table ANAGRAFICI
CREATE INDEX ANAG_TIST_FK ON ANAGRAFICI
(
      titolo_studio )
PCTFREE  10
;

REM
REM  End of command file
REM
