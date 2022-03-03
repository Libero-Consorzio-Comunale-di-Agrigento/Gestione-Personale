REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      SCAGLIONI_FISCALI
REM INDEX
REM      SCFI_PK

REM
REM     SCFI - Scaglioni fiscali di imponibile per calcolo imposta
REM
PROMPT 
PROMPT Creating Table SCAGLIONI_FISCALI
CREATE TABLE scaglioni_fiscali(
 dal                             DATE             NOT NULL,
 al                              DATE             NULL,
 scaglione                       NUMBER(15,5)     NOT NULL,
 aliquota                        NUMBER(4,2)      NOT NULL,
 imposta                         NUMBER(15,5)     NULL
)
;

COMMENT ON TABLE scaglioni_fiscali
    IS 'SCFI - Scaglioni fiscali di imponibile per calcolo imposta';


REM
REM 
REM
PROMPT
PROMPT Creating Index SCFI_PK on Table SCAGLIONI_FISCALI
CREATE UNIQUE INDEX SCFI_PK ON SCAGLIONI_FISCALI
(
      dal ,
      scaglione )
PCTFREE  10
;

REM
REM  End of command file
REM