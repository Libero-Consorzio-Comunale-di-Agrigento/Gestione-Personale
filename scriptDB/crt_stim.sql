REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      SMTTR_IMPORTI
REM INDEX
REM      STIM_PK
REM      STIM_FK
REM      STIM_FK1

REM
REM     STIM - Statistiche Trimestrali Importi 
REM
PROMPT 
PROMPT Creating Table SMTTR_IMPORTI
CREATE TABLE SMTTR_IMPORTI
(
  STRM_ID      NUMBER(8)                        NOT NULL,
  ANNO         NUMBER(4)                        NOT NULL,
  MESE         NUMBER(2)                        NOT NULL,
  CI           NUMBER(8)                        NOT NULL,
  GESTIONE     VARCHAR2(4)                      NOT NULL,
  DAL          DATE                             NOT NULL,
  AL           DATE                             NULL,
  COLONNA      VARCHAR2(30)                     NOT NULL,
  VOCE         VARCHAR2(10)                     NOT NULL,
  SUB          VARCHAR2(2)                      NOT NULL,
  IMPORTO      NUMBER(12,2)                     NULL,
  ANNO_RIF     NUMBER(4)                        NULL,
  UTENTE       VARCHAR2(8)                      NULL,
  TIPO_AGG     VARCHAR2(1)                      NULL,
  DATA_AGG     DATE 				NULL
);

COMMENT ON TABLE SMTTR_IMPORTI
    IS 'STIM - Statistiche Trimestrali Importi ';

REM
REM 
REM
PROMPT
PROMPT Creating Unique Index STIM_PK on smttr_importi
CREATE UNIQUE INDEX STIM_PK ON SMTTR_IMPORTI
(STRM_ID);

REM
REM 
REM
PROMPT
PROMPT Creating Index STIM_FK on smttr_importi
CREATE INDEX STIM_FK ON SMTTR_IMPORTI
(COLONNA, VOCE, SUB);

REM
REM 
REM
PROMPT
PROMPT Creating Index STIM_FK1 on smttr_importi
CREATE INDEX STIM_FK1 ON SMTTR_IMPORTI
(ANNO, MESE, CI, GESTIONE, DAL);

REM
REM  End of command file
REM
