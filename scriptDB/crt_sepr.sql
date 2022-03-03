REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  07-SEP-93
REM
REM For application system PGM version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      SEDI_PROVVEDIMENTO
REM INDEX
REM      SEPR_PK

REM
REM     SEPR - Sedi di emissione dei provvedimenti deliberativi
REM
PROMPT 
PROMPT Creating Table SEDI_PROVVEDIMENTO
CREATE TABLE sedi_provvedimento(
 codice                          VARCHAR(4)       NOT NULL,
 descrizione                     VARCHAR(40)      NULL,
 descrizione_al1                 VARCHAR(40)      NULL,
 descrizione_al2                 VARCHAR(40)      NULL,
 registro                        VARCHAR(4)       NULL,
 tipo_documento                  VARCHAR(4)       NULL
)
;

COMMENT ON TABLE sedi_provvedimento
    IS 'SEPR - Sedi di emissione dei provvedimenti deliberativi';


REM
REM 
REM
PROMPT
PROMPT Creating Index SEPR_PK on Table SEDI_PROVVEDIMENTO
CREATE UNIQUE INDEX SEPR_PK ON SEDI_PROVVEDIMENTO
(
      codice )
PCTFREE  10
;

REM
REM  End of command file
REM
