REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      RELAZIONE_ATTRIBUTI
REM INDEX
REM      REAT_PK
REM      REAT_REOG_FK

REM
REM     REAT - Attributi degli oggetti previsti dalle Estrazioni Parametriche
REM
PROMPT 
PROMPT Creating Table RELAZIONE_ATTRIBUTI
CREATE TABLE relazione_attributi(
 attributo                       VARCHAR(20)      NOT NULL,
 descrizione                     VARCHAR(60)      NULL,
 descrizione_al1                 VARCHAR(60)      NULL,
 descrizione_al2                 VARCHAR(60)      NULL,
 oggetto                         VARCHAR(10)      NULL,
 colonna                         VARCHAR(240)     NOT NULL
)
;

COMMENT ON TABLE relazione_attributi
    IS 'REAT - Attributi degli oggetti previsti dalle Estrazioni Parametriche';


REM
REM 
REM
PROMPT
PROMPT Creating Index REAT_PK on Table RELAZIONE_ATTRIBUTI
CREATE UNIQUE INDEX REAT_PK ON RELAZIONE_ATTRIBUTI
(
      attributo )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index REAT_REOG_FK on Table RELAZIONE_ATTRIBUTI
CREATE INDEX REAT_REOG_FK ON RELAZIONE_ATTRIBUTI
(
      oggetto )
PCTFREE  10
;

REM
REM  End of command file
REM
