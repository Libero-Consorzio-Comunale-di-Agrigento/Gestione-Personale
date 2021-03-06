REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  07-SEP-93
REM
REM For application system PGM version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      QUALIFICHE_GIURIDICHE
REM INDEX
REM      QUGI_PK
REM      QUGI_RUOL_FK
REM      QUGI_UK

REM
REM     QUGI - Attributi storici delle qualifiche retributive
REM
PROMPT 
PROMPT Creating Table QUALIFICHE_GIURIDICHE
CREATE TABLE qualifiche_giuridiche(
 numero                          NUMBER(6,0)      NOT NULL,
 dal                             DATE             NOT NULL,
 al                              DATE             NULL,
 contratto                       VARCHAR(4)       NOT NULL,
 codice                          VARCHAR(8)       NOT NULL,
 descrizione                     VARCHAR(120)     NULL,
 descrizione_al1                 VARCHAR(120)     NULL,
 descrizione_al2                 VARCHAR(120)     NULL,
 ruolo                           VARCHAR(4)       NOT NULL,
 livello                         VARCHAR(4)       NOT NULL,
 note                            VARCHAR(4000)    NULL,
 note_al1                        VARCHAR(4000)    NULL,
 note_al2                        VARCHAR(4000)    NULL
)
;

COMMENT ON TABLE qualifiche_giuridiche
    IS 'QUGI - Attributi storici delle qualifiche retributive';


REM
REM 
REM
PROMPT
PROMPT Creating Index QUGI_PK on Table QUALIFICHE_GIURIDICHE
CREATE UNIQUE INDEX QUGI_PK ON QUALIFICHE_GIURIDICHE
(
      numero ,
      dal )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index QUGI_RUOL_FK on Table QUALIFICHE_GIURIDICHE
CREATE INDEX QUGI_RUOL_FK ON QUALIFICHE_GIURIDICHE
(
      ruolo )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index QUGI_UK on Table QUALIFICHE_GIURIDICHE
CREATE UNIQUE INDEX QUGI_UK ON QUALIFICHE_GIURIDICHE
(
      contratto ,
      codice ,
      dal )
PCTFREE  10
;

REM
REM  End of command file
REM
