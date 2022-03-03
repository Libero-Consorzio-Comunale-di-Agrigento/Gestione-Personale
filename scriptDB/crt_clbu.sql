REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      CLASSI_BUDGET
REM INDEX
REM      CLBU_PK

REM
REM     CLBU - Riclassificazioni di spesa per analisi di previsione
REM
PROMPT 
PROMPT Creating Table CLASSI_BUDGET
CREATE TABLE classi_budget(
 codice                          VARCHAR(4)       NOT NULL,
 descrizione                     VARCHAR(30)      NULL,
 descrizione_al1                 VARCHAR(30)      NULL,
 descrizione_al2                 VARCHAR(30)      NULL,
 sequenza                        NUMBER(3,0)      NULL,
 costo                           VARCHAR(1)       NULL
)
;

COMMENT ON TABLE classi_budget
    IS 'CLBU - Riclassificazioni di spesa per analisi di previsione';


REM
REM 
REM
PROMPT
PROMPT Creating Index CLBU_PK on Table CLASSI_BUDGET
CREATE UNIQUE INDEX CLBU_PK ON CLASSI_BUDGET
(
      codice )
PCTFREE  10
;

REM
REM  End of command file
REM