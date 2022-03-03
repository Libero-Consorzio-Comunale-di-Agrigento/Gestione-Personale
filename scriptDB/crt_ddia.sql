SET SCAN OFF

REM
REM TABLE
REM      DICHIARAZIONE_DIS_ASSENZE

REM
REM     DDIA - Assenze Modulo Disoccupazione
REM
PROMPT 
PROMPT Creating Table DICHIARAZIONE_DIS_ASSENZE
CREATE TABLE DICHIARAZIONE_DIS_ASSENZE
  ( DDIS_ID           NUMBER(10)    NOT NULL,
    CI                NUMBER(8)     NOT NULL,
    DAL               DATE,          
    AL                DATE,
    MOTIVO            VARCHAR2(50),
    UTENTE            VARCHAR2(8),
    DATA_AGG          DATE,
    TIPO_AGG          VARCHAR2(1)
  )
;

COMMENT ON TABLE DICHIARAZIONE_DIS_ASSENZE
    IS 'DDIA - Assenze Modulo Disoccupazione';

REM
REM  End of command file
REM
