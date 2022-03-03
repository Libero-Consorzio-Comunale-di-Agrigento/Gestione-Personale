REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      RIGHE_TARIFFA_VOCE
REM INDEX
REM      RTVO_PK
REM      RTVO_VOCO_CON_FK
REM      RTVO_VOCO_OPE_FK

REM
REM     RTVO - Righe di composizione della tariffa della voce retributiva
REM
PROMPT 
PROMPT Creating Table RIGHE_TARIFFA_VOCE
CREATE TABLE righe_tariffa_voce(
 voce                            VARCHAR(10)      NOT NULL,
 dal                             DATE             NOT NULL,
 al                              DATE             NULL,
 sequenza                        NUMBER(3,0)      NOT NULL,
 cod_voce                        VARCHAR(10)      NULL,
 sub_voce                        VARCHAR(2)       NULL,
 val_voce                        VARCHAR(1)       NULL,
 segno1                          VARCHAR(1)       NULL,
 dato1                           NUMBER(15,5)     NULL,
 segno2                          VARCHAR(1)       NULL,
 dato2                           NUMBER(15,5)     NULL,
 segno3                          VARCHAR(1)       NULL,
 dato3                           NUMBER(15,5)     NULL,
 segno4                          VARCHAR(1)       NULL,
 dato4                           NUMBER(15,5)     NULL,
 con_voce                        VARCHAR(10)      NULL,
 con_sub                         VARCHAR(2)       NULL
)
;

COMMENT ON TABLE righe_tariffa_voce
    IS 'RTVO - Righe di composizione della tariffa della voce retributiva';


REM
REM 
REM
PROMPT
PROMPT Creating Index RTVO_PK on Table RIGHE_TARIFFA_VOCE
CREATE UNIQUE INDEX RTVO_PK ON RIGHE_TARIFFA_VOCE
(
      voce ,
      dal ,
      sequenza )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index RTVO_VOCO_CON_FK on Table RIGHE_TARIFFA_VOCE
CREATE INDEX RTVO_VOCO_CON_FK ON RIGHE_TARIFFA_VOCE
(
      con_voce ,
      con_sub )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index RTVO_VOCO_OPE_FK on Table RIGHE_TARIFFA_VOCE
CREATE INDEX RTVO_VOCO_OPE_FK ON RIGHE_TARIFFA_VOCE
(
      cod_voce ,
      sub_voce )
PCTFREE  10
;

REM
REM  End of command file
REM
