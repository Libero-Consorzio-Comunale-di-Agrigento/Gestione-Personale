REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      TEMP_LONG     

REM
REM     TELO - Tavola temporanea per la determinazione delle singole righ
REM            delle note giuridiche 
REM
PROMPT 
PROMPT Creating Table TEMP_LONG
CREATE TABLE temp_long (
 prenotazione                    NUMBER(6,0)      NOT NULL,
 progressivo                     NUMBER(4,0)      NOT NULL,
 ci                              NUMBER(8,0)      NOT NULL,
 rilevanza                       VARCHAR(1)       NOT NULL,
 dal                             DATE             NOT NULL,
 descrizione                     VARCHAR(250)     NULL,
 terminale                       VARCHAR(10)      NULL
)
;

COMMENT ON TABLE temp_long
    IS 'TELO - Tavola temporanea per dividere in righe i campi long';

REM
REM  End of command file
REM
