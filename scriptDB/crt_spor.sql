REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      SPORTELLI
REM INDEX
REM      SPOR_PK

REM
REM     SPOR - Sportelli bancari degli istituti di credito
REM
PROMPT 
PROMPT Creating Table SPORTELLI
CREATE TABLE sportelli(
 ISTITUTO            VARCHAR2(5)               NOT NULL,
  SPORTELLO           VARCHAR2(5)               NOT NULL,
  DESCRIZIONE         VARCHAR2(30),
  DESCRIZIONE_AL1     VARCHAR2(30),
  DESCRIZIONE_AL2     VARCHAR2(30),
  INDIRIZZO           VARCHAR2(40),
  PROVINCIA           NUMBER(3),
  COMUNE              NUMBER(3),
  CAP                 VARCHAR2(5),
  CAB                 VARCHAR2(5),
  ARROTONDAMENTO      NUMBER(12,2),
  DIPENDENZA          VARCHAR2(5),
  MODALITA_PAGAMENTO  NUMBER(1),
  NOTE                VARCHAR2(4000),
  NOTE_AL1            VARCHAR2(4000),
  NOTE_AL2            VARCHAR2(4000))
;

COMMENT ON TABLE sportelli
    IS 'SPOR - Sportelli bancari degli istituti di credito';


REM
REM 
REM
PROMPT
PROMPT Creating Index SPOR_PK on Table SPORTELLI
CREATE UNIQUE INDEX SPOR_PK ON SPORTELLI
(
      istituto ,
      sportello )
PCTFREE  10
;

REM
REM  End of command file
REM