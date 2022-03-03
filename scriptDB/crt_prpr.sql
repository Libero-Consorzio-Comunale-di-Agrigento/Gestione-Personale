REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  07-SEP-93
REM
REM For application system PGM version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      PROFILI_PROFESSIONALI
REM INDEX
REM      PRPR_PK
REM      PRPR_IK

REM
REM     PRPR - Profili professionali in ambito contrattuale
REM
PROMPT 
PROMPT Creating Table PROFILI_PROFESSIONALI
CREATE TABLE profili_professionali(
 codice                          VARCHAR(4)       NOT NULL,
 descrizione                     VARCHAR(120)     NULL,
 descrizione_al1                 VARCHAR(120)     NULL,
 descrizione_al2                 VARCHAR(120)     NULL,
 sequenza                        NUMBER(3,0)      NULL,
 suddivisione_po                 VARCHAR(1)       NULL,
 codice_ministero                VARCHAR(6)       NULL
)
;

COMMENT ON TABLE profili_professionali
    IS 'PRPR - Profili professionali in ambito contrattuale';


REM
REM 
REM
PROMPT
PROMPT Creating Index PRPR_PK on Table PROFILI_PROFESSIONALI
CREATE UNIQUE INDEX PRPR_PK ON PROFILI_PROFESSIONALI
(
      codice )
PCTFREE  10
;
PROMPT
PROMPT Creating Index PRPR_IK on Table PROFILI_PROFESSIONALI
CREATE INDEX PRPR_IK ON PROFILI_PROFESSIONALI
(
      codice_ministero    )
PCTFREE  10
;

REM
REM  End of command file
REM