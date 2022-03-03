REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  07-SEP-93
REM
REM For application system PGM version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      ERRORI_POGM
REM INDEX
REM      ATTI_PK

REM
REM     ERPG - Errori in Fasi Differite di Pianta Organica e Giuridico
REM
PROMPT 
PROMPT Creating Table ERRORI_POGM
CREATE TABLE errori_pogm(
 prenotazione                    NUMBER(6)        NOT NULL,
 voce_menu                       VARCHAR(8)       NOT NULL,
 data                            DATE             NOT NULL,
 errore                          VARCHAR(240)     NULL
)
;

REM
REM 
REM
PROMPT
PROMPT Creating Index ERPG_PK on Table ERRORI_POGM
CREATE UNIQUE INDEX ERPG_PK ON ERRORI_POGM
(
      prenotazione )
PCTFREE  10
;

REM
REM  End of command file
REM
