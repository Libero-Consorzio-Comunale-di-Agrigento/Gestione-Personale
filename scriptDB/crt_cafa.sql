REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN ON
REM  Objects being generated in this file are:-
REM TABLE
REM      CARICHI_FAMILIARI
REM INDEX
REM      CAFA_COFA_FK
REM      CAFA_COFI_FK
REM      CAFA_MESE_ATT_FK
REM      CAFA_MESE_RIF_FK
REM      CAFA_PK

REM
REM     CAFA - Carichi familiari individuali per assegni e detrazioni fiscali
REM
PROMPT 
PROMPT Creating Table CARICHI_FAMILIARI
CREATE TABLE carichi_familiari
(
 ci                              NUMBER(8)        NOT NULL,
 anno                            NUMBER(4)        NOT NULL,
 mese                            NUMBER(2)        NOT NULL,
 sequenza                        NUMBER(2)        NOT NULL,
 giorni                          NUMBER(2,0)      NULL,
 cond_fam                        VARCHAR(4)       NULL,
 nucleo_fam                      NUMBER(2,0)      NULL,
 cond_fis                        VARCHAR(4)       NULL,
 scaglione_coniuge               NUMBER(2,0)      NULL,
 coniuge                         NUMBER(2,0)      NULL,
 scaglione_figli                 NUMBER(2,0)      NULL,
 figli                           NUMBER(2,0)      NULL,
 figli_dd                        NUMBER(2,0)      NULL,
 altri                           NUMBER(2,0)      NULL,
 mese_att                        NUMBER(2,0)      NOT NULL,
 mese_att_ass                    NUMBER(2,0)      NULL, 
 utente                          VARCHAR(8)       NULL,
 data_agg                        DATE             NULL,
 figli_fam                       NUMBER(2,0)      NULL,
 figli_mn                        NUMBER(2,0)      NULL,
 figli_mn_dd                     NUMBER(2,0)      NULL,
 figli_hh                        NUMBER(2,0)      NULL,
 figli_hh_dd                     NUMBER(2,0)      NULL
)
STORAGE  (
  INITIAL   &1DIMx700
  NEXT   &1DIMx350
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

COMMENT ON TABLE carichi_familiari
    IS 'CAFA - Carichi familiari individuali per assegni e detrazioni fiscali';


REM
REM 
REM
PROMPT
PROMPT Creating Index CAFA_COFA_FK on Table CARICHI_FAMILIARI
CREATE INDEX CAFA_COFA_FK ON CARICHI_FAMILIARI
(
      cond_fam )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index CAFA_COFI_FK on Table CARICHI_FAMILIARI
CREATE INDEX CAFA_COFI_FK ON CARICHI_FAMILIARI
(
      cond_fis )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx250
  NEXT   &1DIMx125
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index CAFA_MESE_ATT_FK on Table CARICHI_FAMILIARI
CREATE INDEX CAFA_MESE_ATT_FK ON CARICHI_FAMILIARI
(
      anno ,
      mese_att )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx250
  NEXT   &1DIMx125
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index CAFA_MESE_RIF_FK on Table CARICHI_FAMILIARI
CREATE INDEX CAFA_MESE_RIF_FK ON CARICHI_FAMILIARI
(
      anno ,
      mese )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx250
  NEXT   &1DIMx125
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index CAFA_PK on Table CARICHI_FAMILIARI
CREATE UNIQUE INDEX CAFA_PK ON CARICHI_FAMILIARI
(
      ci ,
      anno ,
      mese ,
      sequenza )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx440
  NEXT   &1DIMx220
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

REM
REM  End of command file
REM
