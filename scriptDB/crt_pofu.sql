REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  07-SEP-93
REM
REM For application system PGM version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      POSIZIONI_FUNZIONALI
REM INDEX
REM      POFU_PK
REM      POFU_IK

REM
REM     POFU - Posizioni funzionali nell"ambito del profilo professionale
REM
PROMPT 
PROMPT Creating Table POSIZIONI_FUNZIONALI
CREATE TABLE posizioni_funzionali(
 profilo                         VARCHAR(4)       NOT NULL,
 codice                          VARCHAR(4)       NOT NULL,
 descrizione                     VARCHAR(120)     NULL,
 descrizione_al1                 VARCHAR(120)     NULL,
 descrizione_al2                 VARCHAR(120)     NULL,
 sequenza                        NUMBER(3,0)      NULL,
 codice_ministero                VARCHAR(6)       NULL
)
;

COMMENT ON TABLE posizioni_funzionali
    IS 'POFU - Posizioni funzionali nell"ambito del profilo professionale';


REM
REM 
REM
PROMPT
PROMPT Creating Index POFU_PK on Table POSIZIONI_FUNZIONALI
CREATE UNIQUE INDEX POFU_PK ON POSIZIONI_FUNZIONALI
(
      profilo ,
      codice )
PCTFREE  10
;

PROMPT
PROMPT Creating Index POFU_IK on Table POSIZIONI_FUNZIONALI
CREATE INDEX POFU_IK ON POSIZIONI_FUNZIONALI
(
      codice_ministero   )
PCTFREE  10
;

REM
REM  End of command file
REM
