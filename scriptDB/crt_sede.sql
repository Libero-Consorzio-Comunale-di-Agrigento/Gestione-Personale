REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  07-SEP-93
REM
REM For application system PGM version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      SEDI
REM INDEX
REM      SEDE_CALE_FK
REM      SEDE_PK
REM      SEDE_UK

REM
REM     SEDE - Sedi fisiche o dislocazioni nell"ambito dell"ente
REM
PROMPT 
PROMPT Creating Table SEDI
CREATE TABLE sedi(
 codice                          VARCHAR(8)       NOT NULL,
 descrizione                     VARCHAR(45)      NULL,
 descrizione_al1                 VARCHAR(45)      NULL,
 descrizione_al2                 VARCHAR(45)      NULL,
 indirizzo                       VARCHAR(60)      NULL,
 sequenza                        NUMBER(6,0)      NULL,
 numero                          NUMBER(6,0)      NOT NULL,
 calendario                      VARCHAR(4)       NULL
)
;

COMMENT ON TABLE sedi
    IS 'SEDE - Sedi fisiche o dislocazioni nell"ambito dell"ente';


REM
REM 
REM
PROMPT
PROMPT Creating Index SEDE_CALE_FK on Table SEDI
CREATE INDEX SEDE_CALE_FK ON SEDI
(
      calendario )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index SEDE_PK on Table SEDI
CREATE UNIQUE INDEX SEDE_PK ON SEDI
(
      numero )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index SEDE_UK on Table SEDI
CREATE UNIQUE INDEX SEDE_UK ON SEDI
(
      codice )
PCTFREE  10
;

REM
REM  End of command file
REM
