REM  Objects being generated in this file are:-
REM TABLE
REM      RAPPORTI_INDIVIDUALI
REM INDEX
REM      RAIN_CLRA_FK
REM      RAIN_GRRA_FK
REM      RAIN_IK
REM      RAIN_INDI_FK
REM      RAIN_PK

REM
REM     RAIN - Rapporti dell"individuo con l"ente
REM
PROMPT 
PROMPT Creating Table RAPPORTI_INDIVIDUALI
CREATE TABLE rapporti_individuali(
 ci                              NUMBER(8,0)      NOT NULL,
 cognome                         VARCHAR(40)      NOT NULL,
 nome                            VARCHAR(36)      NULL,
 ni                              NUMBER(8,0)      NOT NULL,
 data_nas                        DATE             NULL,
 rapporto                        VARCHAR(4)       NOT NULL,
 cc                              VARCHAR(30)      NULL,
 dal                             DATE             NOT NULL,
 al                              DATE             NULL,
 gruppo                          VARCHAR(12)      NULL,
 note                            VARCHAR(4000)    NULL,
 ambiente                        VARCHAR(8)       NULL,
 tipo_ni                         VARCHAR(1)       NULL,
 fascicolo			 VARCHAR(20)      NULL,
 telefono_ufficio                VARCHAR(14)      NULL,
 fax_ufficio                     VARCHAR(14)      NULL,
 e_mail                          VARCHAR(2000)    NULL,
 indirizzo_rec                   VARCHAR2(40)     NULL,
 indirizzo_rec_al1               VARCHAR2(40)     NULL,
 indirizzo_rec_al2               VARCHAR2(40)     NULL,
 provincia_rec                   NUMBER(3)        NULL,
 comune_rec                      NUMBER(3)        NULL,
 cap_rec                         VARCHAR2(5)      NULL,
 tel_rec                         VARCHAR2(12)     NULL,
 fax_rec                         VARCHAR2(14)     NULL,
 mail_cedolino                   NUMBER(1)        NULL
)
STORAGE  (
  INITIAL   &1DIMx200 
  NEXT   &1DIMx100 
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

COMMENT ON TABLE rapporti_individuali
    IS 'RAIN - Rapporti dell"individuo con l"ente';


REM
REM 
REM
PROMPT
PROMPT Creating Index RAIN_CLRA_FK on Table RAPPORTI_INDIVIDUALI
CREATE INDEX RAIN_CLRA_FK ON RAPPORTI_INDIVIDUALI
(
      rapporto )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx50       
  NEXT   &1DIMx25    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index RAIN_GRRA_FK on Table RAPPORTI_INDIVIDUALI
CREATE INDEX RAIN_GRRA_FK ON RAPPORTI_INDIVIDUALI
(
      gruppo )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index RAIN_IK on Table RAPPORTI_INDIVIDUALI
CREATE INDEX RAIN_IK ON RAPPORTI_INDIVIDUALI
(
      cognome ,
      nome ,
      ni ,
      dal )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx90       
  NEXT   &1DIMx45     
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

PROMPT Creating Index RAIN_IK2 on Table RAPPORTI_INDIVIDUALI
CREATE INDEX RAIN_IK2 ON 
  RAPPORTI_INDIVIDUALI(FASCICOLO) 
; 

REM
REM 
REM
PROMPT
PROMPT Creating Index RAIN_INDI_FK on Table RAPPORTI_INDIVIDUALI
CREATE INDEX RAIN_INDI_FK ON RAPPORTI_INDIVIDUALI
(
      ni )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx30       
  NEXT   &1DIMx15     
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index RAIN_PK on Table RAPPORTI_INDIVIDUALI
CREATE UNIQUE INDEX RAIN_PK ON RAPPORTI_INDIVIDUALI
(
      ci )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx30       
  NEXT   &1DIMx15     
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM  End of command file
REM
