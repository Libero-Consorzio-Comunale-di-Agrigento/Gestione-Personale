REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      SCAGLIONI_ASSEGNO_FAMILIARE
REM INDEX
REM      SCAF_PK

REM
REM     SCAF - Scaglioni di reddito familiare per assegno di nucleo familiare
REM
PROMPT 
PROMPT Creating Table SCAGLIONI_ASSEGNO_FAMILIARE
CREATE TABLE scaglioni_assegno_familiare(
 dal                             DATE             NOT NULL,
 al                              DATE             NULL,
 scaglione                       NUMBER(12,2)     NOT NULL,
 COD_SCAGLIONE                   VARCHAR2(2)      NOT NULL,
 NUMERO_FASCIA                   NUMBER(3)        NOT NULL)
;

COMMENT ON TABLE scaglioni_assegno_familiare
    IS 'SCAF - Scaglioni di reddito familiare per assegno di nucleo familiare';


REM
REM 
REM
PROMPT
PROMPT Creating Index SCAF_PK on Table SCAGLIONI_ASSEGNO_FAMILIARE
CREATE UNIQUE INDEX SCAF_PK ON SCAGLIONI_ASSEGNO_FAMILIARE
(DAL, COD_SCAGLIONE, NUMERO_FASCIA)
PCTFREE  10
;

REM
REM  End of command file
REM