REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  07-SEP-93
REM
REM For application system PGM version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      ATTIVITA
REM INDEX
REM      ATTI_ATTI_FK
REM      ATTI_PK

REM
REM     ATTI - Attivita` e Aree di attivita` o Discipline e Aree funzionali
REM
PROMPT 
PROMPT Creating Table ATTIVITA
CREATE TABLE attivita(
 codice                          VARCHAR(4)       NOT NULL,
 descrizione                     VARCHAR(120)     NULL,
 descrizione_al1                 VARCHAR(120)     NULL,
 descrizione_al2                 VARCHAR(120)     NULL,
 sequenza                        NUMBER(6,0)      NULL,
 area                            VARCHAR(4)       NULL,
 cat_fiscale                     VARCHAR(1)       NULL
)
;

COMMENT ON TABLE attivita
    IS 'ATTI - Attivita` e Aree di attivita` o Discipline e Aree funzionali';


REM
REM 
REM
PROMPT
PROMPT Creating Index ATTI_ATTI_FK on Table ATTIVITA
CREATE INDEX ATTI_ATTI_FK ON ATTIVITA
(
      area )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index ATTI_PK on Table ATTIVITA
CREATE UNIQUE INDEX ATTI_PK ON ATTIVITA
(
      codice )
PCTFREE  10
;

REM
REM  End of command file
REM
