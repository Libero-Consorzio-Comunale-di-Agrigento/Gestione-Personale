REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      MESI
REM INDEX
REM      MESE_PK

REM
REM     MESE - Mesi dell"anno
REM
PROMPT 
PROMPT Creating Table MESI
CREATE TABLE mesi(
 anno                            NUMBER(4,0)      NOT NULL,
 mese                            NUMBER(2,0)      NOT NULL,
 ini_mese                        DATE             NOT NULL,
 fin_mese                        DATE             NOT NULL,
 alq_tfr                         NUMBER(9,8)      NULL
)
;

COMMENT ON TABLE mesi
    IS 'MESE - Mesi dell"anno';


REM
REM 
REM
PROMPT
PROMPT Creating Index MESE_PK on Table MESI
CREATE UNIQUE INDEX MESE_PK ON MESI
(
      anno ,
      mese )
PCTFREE  10
;

REM
REM  End of command file
REM