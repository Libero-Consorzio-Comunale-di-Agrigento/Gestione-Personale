REM  Objects being generated in this file are:-
REM TABLE
REM      RAPPORTI_RETRIBUTIVI
REM INDEX
REM      RARE_ASIN_FK
REM      RARE_IK
REM      RARE_ISCR_FK
REM      RARE_PK
REM      RARE_RARE_FK
REM      RARE_SPOR_FK
REM      RARE_TRPR_FK

REM
REM     RARE - Identificazione dei rapporti con caratteristiche retributive
REM
PROMPT 
PROMPT Creating Table RAPPORTI_RETRIBUTIVI
CREATE TABLE rapporti_retributivi(
 ci                              NUMBER(8,0)      NOT NULL,
 matricola                       NUMBER(8,0)      NOT NULL,
 istituto                        VARCHAR(5)       NOT NULL,
 sportello                       VARCHAR(5)       NOT NULL,
 conto_corrente                  VARCHAR(15)      NULL,
 delega                          VARCHAR2(50)      NULL,
 spese                           NUMBER(2,0)      NULL,
 ulteriori                       NUMBER(2,0)      NULL,
 posizione_inail                 VARCHAR(4)       NULL,
 data_inail                      DATE             NULL,
 trattamento                     VARCHAR(4)       NULL,
 codice_cpd                      VARCHAR(10)      NULL,
 posizione_cpd                   VARCHAR(8)       NULL,
 data_cpd                        DATE             NULL,
 codice_cps                      VARCHAR(10)      NULL,
 posizione_cps                   VARCHAR(8)       NULL,
 data_cps                        DATE             NULL,
 codice_inps                     VARCHAR(10)      NULL,
 codice_iad                      VARCHAR(9)       NULL,
 data_iad                        DATE             NULL,
 ci_erede                        NUMBER(8,0)      NULL,
 quota_erede                     NUMBER(5,2)      NULL,
 statistico1                     VARCHAR(12)      NULL,
 statistico2                     VARCHAR(12)      NULL,
 statistico3                     VARCHAR(12)      NULL,
 utente                          VARCHAR(8)       NULL,
 data_agg                        DATE             NULL,
 tipo_erede                      VARCHAR(1)       NULL,
 tipo_ulteriori                  VARCHAR(2)       NULL,
 tipo_spese                      VARCHAR(2)       NULL,
 attribuzione_spese              NUMBER(1)        NULL,
 COD_NAZIONE                     varchar2(2)      NULL,
 CIN_EUR                         number(2)        NULL,
 CIN_ITA                         varchar2(1)      NULL,
 TIPO_TRATTAMENTO                VARCHAR2(1)
)
STORAGE  (
  INITIAL   &1DIMx100  
  NEXT   &1DIMx50   
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

COMMENT ON TABLE rapporti_retributivi
    IS 'RARE - Identificazione dei rapporti con caratteristiche retributive';


REM
REM 
REM
PROMPT
PROMPT Creating Index RARE_ASIN_FK on Table RAPPORTI_RETRIBUTIVI
CREATE INDEX RARE_ASIN_FK ON RAPPORTI_RETRIBUTIVI
(
      posizione_inail )
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
REM Unico escludento CI diversi di stesso NI e CI di GESTIONI diverse
REM
PROMPT
PROMPT Creating Index RARE_IK on Table RAPPORTI_RETRIBUTIVI
CREATE INDEX RARE_IK ON RAPPORTI_RETRIBUTIVI
(
      matricola )
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
PROMPT Creating Index RARE_ISCR_FK on Table RAPPORTI_RETRIBUTIVI
CREATE INDEX RARE_ISCR_FK ON RAPPORTI_RETRIBUTIVI
(
      istituto )
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
PROMPT Creating Index RARE_PK on Table RAPPORTI_RETRIBUTIVI
CREATE UNIQUE INDEX RARE_PK ON RAPPORTI_RETRIBUTIVI
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
REM 
REM
PROMPT
PROMPT Creating Index RARE_RARE_FK on Table RAPPORTI_RETRIBUTIVI
CREATE INDEX RARE_RARE_FK ON RAPPORTI_RETRIBUTIVI
(
      ci_erede )
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
PROMPT Creating Index RARE_SPOR_FK on Table RAPPORTI_RETRIBUTIVI
CREATE INDEX RARE_SPOR_FK ON RAPPORTI_RETRIBUTIVI
(
      istituto ,
      sportello )
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
PROMPT Creating Index RARE_TRPR_FK on Table RAPPORTI_RETRIBUTIVI
CREATE INDEX RARE_TRPR_FK ON RAPPORTI_RETRIBUTIVI
(
      trattamento )
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
