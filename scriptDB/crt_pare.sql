REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  07-SEP-93
REM
REM For application system PAM version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      PARENTELE
REM INDEX
REM      PARE_PK
REM      PARE_UK

REM
REM     PARE - Relazioni di parentela dei familiari dell"individuo
REM
PROMPT 
PROMPT Creating Table PARENTELE
CREATE TABLE parentele(
 codice                          VARCHAR(4)       NOT NULL,
 descrizione                     VARCHAR(30)      NULL,
 descrizione_al1                 VARCHAR(30)      NULL,
 descrizione_al2                 VARCHAR(30)      NULL,
 sequenza                        NUMBER(3,0)      NOT NULL,
 nucleo_fam                      VARCHAR(2)       NOT NULL,
 carico_fis                      VARCHAR(2)       NOT NULL,
 cod_previdenza                  VARCHAR(1)       NULL
)
;

COMMENT ON TABLE parentele
    IS 'PARE - Relazioni di parentela dei familiari dell"individuo';


REM
REM 
REM
PROMPT
PROMPT Creating Index PARE_PK on Table PARENTELE
CREATE UNIQUE INDEX PARE_PK ON PARENTELE
(
      sequenza )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index PARE_UK on Table PARENTELE
CREATE UNIQUE INDEX PARE_UK ON PARENTELE
(
      codice )
PCTFREE  10
;

REM
REM  End of command file
REM