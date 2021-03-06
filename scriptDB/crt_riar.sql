REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  15-OCT-93
REM
REM For application system GIP version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      RIFERIMENTO_ARCHIVIAZIONE
REM INDEX
REM      RIAR_PK

REM
REM     RIAR - Dati identificativi della fase di Archiviazione
REM
PROMPT 
PROMPT Creating Table RIFERIMENTO_ARCHIVIAZIONE
CREATE TABLE riferimento_archiviazione(
 riar_id                         VARCHAR(4)       NOT NULL,
 anno                            NUMBER(4,0)      NOT NULL,
 stato                           VARCHAR(1)       NULL,
 modulo                          VARCHAR(4)       NULL
)
;

COMMENT ON TABLE riferimento_archiviazione
    IS 'RIAR - Dati identificativi della fase di Archiviazione';


REM
REM 
REM
PROMPT
PROMPT Creating Index RIAR_PK on Table RIFERIMENTO_ARCHIVIAZIONE
CREATE UNIQUE INDEX RIAR_PK ON RIFERIMENTO_ARCHIVIAZIONE
(
      riar_id )
PCTFREE  10
;

REM
REM  End of command file
REM
