REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  07-JUL-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      QUALIFICHE_MINISTERIALI
REM INDEX
REM      QUMI_PK

REM
REM     QUMI - Codifica Ministeriale delle Qualifiche retributive
REM
PROMPT 
PROMPT Creating Table QUALIFICHE_MINISTERIALI
CREATE TABLE qualifiche_ministeriali(
 codice                          VARCHAR(6)       NOT NULL,
 descrizione                     VARCHAR(45)      NULL,
 sequenza                        NUMBER(6,0)      NULL,
 dal                             DATE             NOT NULL,
 al                              DATE             NULL,
 categoria                       VARCHAR2(10)     NULL,
 comparto                        varchar2(10)     NULL
)
;

COMMENT ON TABLE qualifiche_ministeriali
    IS 'QUMI - Codifica Ministeriale delle Qualifiche retributive';


REM
REM 
REM
PROMPT
PROMPT Creating Index QUMI_PK on Table QUALIFICHE_MINISTERIALI
CREATE UNIQUE INDEX QUMI_PK ON QUALIFICHE_MINISTERIALI
(     dal,
      codice )
PCTFREE  10
;

REM
REM  End of command file
REM
