REM  Objects being generated in this file are:-
REM TABLE
REM      INFORMAZIONI_RETRIBUTIVE
REM INDEX
REM      INRE_ISCR_FK
REM      INRE_PK
REM      INRE_QUAL_FK
REM      INRE_VOCO_FK

REM
REM     INRE - Informazioni sulle voci e sui valori che compongono la retribuzi
REM - one
REM
PROMPT 
PROMPT Creating Table INFORMAZIONI_RETRIBUTIVE
CREATE TABLE informazioni_retributive(
 ci                              NUMBER(8,0)      NOT NULL,
 voce                            VARCHAR(10)      NOT NULL,
 sub                             VARCHAR(2)       NOT NULL,
 sequenza_voce                   NUMBER(4,0)      NOT NULL,
 tariffa                         NUMBER(15,5)     NULL,
 dal                             DATE             NULL,
 al                              DATE             NULL,
 tipo                            VARCHAR(1)       NOT NULL,
 qualifica                       NUMBER(6,0)      NULL,
 tipo_rapporto                   VARCHAR(4)       NULL,
 sospensione                     NUMBER(2,0)      NULL,
 imp_tot                         NUMBER(12,2)     NULL,
 rate_tot                        NUMBER(4,0)      NULL,
 note                            VARCHAR(4000)    NULL,
 istituto                        VARCHAR(5)       NULL,
 numero                          VARCHAR(12)      NULL,
 data                            DATE             NULL,
 utente                          VARCHAR(8)       NULL,
 data_agg                        DATE             NULL
)
STORAGE  (
  INITIAL   &1DIMx2500
  NEXT   &1DIMx1250
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

COMMENT ON TABLE informazioni_retributive
    IS 'INRE - Informazioni sulle voci e sui valori che compongono la retribuzione';


REM
REM 
REM
PROMPT
PROMPT Creating Index INRE_ISCR_FK on Table INFORMAZIONI_RETRIBUTIVE
CREATE INDEX INRE_ISCR_FK ON INFORMAZIONI_RETRIBUTIVE
(
      istituto )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index INRE_PK on Table INFORMAZIONI_RETRIBUTIVE
CREATE UNIQUE INDEX INRE_PK ON INFORMAZIONI_RETRIBUTIVE
(
      ci ,
      voce ,
      sub ,
      dal )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx1500     
  NEXT   &1DIMx750    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index INRE_QUAL_FK on Table INFORMAZIONI_RETRIBUTIVE
CREATE INDEX INRE_QUAL_FK ON INFORMAZIONI_RETRIBUTIVE
(
      qualifica )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx700       
  NEXT   &1DIMx350    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index INRE_VOCO_FK on Table INFORMAZIONI_RETRIBUTIVE
CREATE INDEX INRE_VOCO_FK ON INFORMAZIONI_RETRIBUTIVE
(
      voce ,
      sub )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx1000      
  NEXT   &1DIMx500    
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

REM
REM  End of command file
REM
