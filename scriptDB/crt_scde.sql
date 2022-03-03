REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  30-MAY-94
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      SCADENZE_DENUNCE
REM INDEX
PROMPT 
PROMPT Creating Table SCADENZE_DENUNCE
CREATE TABLE SCADENZE_DENUNCE(
 codice                          VARCHAR(10)      NOT NULL,
 data_scadenza                   DATE             NOT NULL,
 data_forzatura                  DATE             NULL,  
 utente                          VARCHAR(8)       NULL,
 data_agg                        DATE             NULL
)
;
create UNIQUE index SCDE_PK on SCADENZE_DENUNCE (CODICE)
;

REM
REM  End of command file
REM

