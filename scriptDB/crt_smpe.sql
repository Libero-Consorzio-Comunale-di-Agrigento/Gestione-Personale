REM
SET SCAN OFF

REM  Objects being generated in this file are:
REM TABLE
REM     SMT_PERIODI
REM INDEX
REM     SMPE_PK

REM
REM     SMPE - Periodi per Statistiche Ministero del Tesoro
REM
PROMPT 
PROMPT Creating Table SMT_PERIODI
CREATE TABLE SMT_PERIODI
( ANNO                  NUMBER(4)   NOT NULL,
  CI                    NUMBER(8)   NOT NULL,
  GESTIONE              VARCHAR2(8) NOT NULL,
  DAL	                DATE        NOT NULL,
  AL	                DATE,
  QUALIFICA	        VARCHAR2(6),
  DA_QUALIFICA	        VARCHAR2(6),
  FASCIA                NUMBER(1),
  CATEGORIA	        VARCHAR2(10),
  FIGURA                VARCHAR2(8),
  PROFILO               VARCHAR2(6),
  PROFILO_01            VARCHAR2(6),
  TEMPO_DETERMINATO	VARCHAR2(2),
  TEMPO_PIENO	        VARCHAR2(2),
  PART_TIME	        NUMBER(5,2),
  UNIVERSITARIO         VARCHAR2(2),
  FORMAZIONE	        VARCHAR2(2),
  LSU	                VARCHAR2(2),
  INTERINALE	        VARCHAR2(2),
  TELELAVORO	        VARCHAR2(2),
  ASSUNZIONE	        VARCHAR2(6),
  CESSAZIONE	        VARCHAR2(6),
  UTENTE                VARCHAR2(8),
  TIPO_AGG	        VARCHAR2(1),
  DATA_AGG	        DATE
)
;

COMMENT ON TABLE smt_periodi
    IS 'SMPE - Periodi per Statistiche Ministero del Tesoro';

REM
REM 
REM
PROMPT
PROMPT Creating Index  SMPE_PK on Table SMT_PERIODI

CREATE UNIQUE INDEX SMPE_PK ON SMT_PERIODI
(ANNO, GESTIONE, CI, DAL) 
; 

REM
REM  End of command file
REM
