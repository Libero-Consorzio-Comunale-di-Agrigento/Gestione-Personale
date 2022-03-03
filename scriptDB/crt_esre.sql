REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      ESTRAZIONE_REPORT
REM INDEX
REM      ESRE_PK
REM      ESRE_REOG_FK

REM
REM     ESRE - Definizione dei Report parametrici personalizzabili
REM
PROMPT 
PROMPT Creating Table ESTRAZIONE_REPORT
CREATE TABLE estrazione_report(
 estrazione                      VARCHAR(20)      NOT NULL,
 descrizione                     VARCHAR(60)      NULL,
 descrizione_al1                 VARCHAR(60)      NULL,
 descrizione_al2                 VARCHAR(60)      NULL,
 sequenza                        NUMBER(3,0)      NULL,
 oggetto                         VARCHAR(10)      NOT NULL,
 num_ric                         NUMBER(1,0)      NOT NULL,
 note                            VARCHAR(240)     NULL
)
;

COMMENT ON TABLE estrazione_report
    IS 'ESRE - Definizione dei Report parametrici personalizzabili';


REM
REM 
REM
PROMPT
PROMPT Creating Index ESRE_PK on Table ESTRAZIONE_REPORT
CREATE UNIQUE INDEX ESRE_PK ON ESTRAZIONE_REPORT
(
      estrazione )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index ESRE_REOG_FK on Table ESTRAZIONE_REPORT
CREATE INDEX ESRE_REOG_FK ON ESTRAZIONE_REPORT
(
      oggetto )
PCTFREE  10
;

REM
REM  End of command file
REM
