REM
REM
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      QUIETANZE_CONTABILITA
REM INDEX
REM      QUCO_PK
REM
REM     Appoggio per Integrazione con CF4
REM
PROMPT 
PROMPT Creating Table QUIETANZE_CONTABILITA

CREATE TABLE QUIETANZE_CONTABILITA(
  SOGGETTO           NUMBER(6) NOT NULL 
, NUM_QUIETANZA      NUMBER(2) NOT NULL 
, DESCRIZIONE                  VARCHAR2(2000)
, SCADENZA                     DATE
, DIVISIONE                    VARCHAR2(2000)
)
;
REM
REM 
REM
PROMPT
PROMPT Creating Unique Index CFQTN_PK on Table QUIETANZE_CONTABILITA
CREATE UNIQUE INDEX QUCO_PK ON QUIETANZE_CONTABILITA
( SOGGETTO,
  NUM_QUIETANZA
)
PCTFREE  10
;
REM
REM  End of command file
REM