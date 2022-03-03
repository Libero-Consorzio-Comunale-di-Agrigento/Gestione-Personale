REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  07-SEP-93
REM
REM For application system PAM version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      TITOLI_STUDIO
REM INDEX
REM      TIST_PK

REM
REM     TIST - Titoli di studio intesi come livello di scolarita`
REM
PROMPT 
PROMPT Creating Table TITOLI_STUDIO
CREATE TABLE titoli_studio(
 codice                          VARCHAR(4)       NOT NULL,
 descrizione                     VARCHAR(30)      NULL,
 descrizione_al1                 VARCHAR(30)      NULL,
 descrizione_al2                 VARCHAR(30)      NULL,
 sequenza                        NUMBER(3,0)      NULL,
 cat_fiscale                     VARCHAR(1)       NULL,
 conto_annuale                   NUMBER(2,0)      NULL
)
;

COMMENT ON TABLE titoli_studio
    IS 'TIST - Titoli di studio intesi come livello di scolarita`';


REM
REM 
REM
PROMPT
PROMPT Creating Index TIST_PK on Table TITOLI_STUDIO
CREATE UNIQUE INDEX TIST_PK ON TITOLI_STUDIO
(
      codice )
PCTFREE  10
;

REM
REM  End of command file
REM
