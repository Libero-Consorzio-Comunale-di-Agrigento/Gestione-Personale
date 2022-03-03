REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      RELAZIONE_OGGETTI
REM INDEX
REM      REOG_PK

REM
REM     REOG - Oggetti previsti dalle Estrazioni Parametriche
REM
PROMPT 
PROMPT Creating Table RELAZIONE_OGGETTI
CREATE TABLE relazione_oggetti(
 oggetto                         VARCHAR(10)      NOT NULL,
 descrizione                     VARCHAR(60)      NULL,
 descrizione_al1                 VARCHAR(60)      NULL,
 descrizione_al2                 VARCHAR(60)      NULL,
 tabella                         VARCHAR(30)      NOT NULL
)
;

COMMENT ON TABLE relazione_oggetti
    IS 'REOG - Oggetti previsti dalle Estrazioni Parametriche';


REM
REM 
REM
PROMPT
PROMPT Creating Index REOG_PK on Table RELAZIONE_OGGETTI
CREATE UNIQUE INDEX REOG_PK ON RELAZIONE_OGGETTI
(
      oggetto )
PCTFREE  10
;

REM
REM  End of command file
REM