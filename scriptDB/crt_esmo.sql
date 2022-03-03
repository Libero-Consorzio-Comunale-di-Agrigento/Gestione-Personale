REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      ESTRAZIONE_MODULI
REM INDEX
REM      ESMO_PK

REM
REM     ESMO - Parametri di estrazione dei Moduli di Raccolta Variabili
REM
PROMPT 
PROMPT Creating Table ESTRAZIONE_MODULI
CREATE TABLE estrazione_moduli(
 codice                          VARCHAR(4)       NOT NULL,
 descrizione                     VARCHAR(30)      NULL,
 descrizione_al1                 VARCHAR(30)      NULL,
 descrizione_al2                 VARCHAR(30)      NULL
)
;

COMMENT ON TABLE estrazione_moduli
    IS 'ESMO - Parametri di estrazione dei Moduli di Raccolta Variabili';


REM
REM 
REM
PROMPT
PROMPT Creating Index ESMO_PK on Table ESTRAZIONE_MODULI
CREATE UNIQUE INDEX ESMO_PK ON ESTRAZIONE_MODULI
(
      codice )
PCTFREE  10
;

REM
REM  End of command file
REM
