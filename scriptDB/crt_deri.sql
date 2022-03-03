REM
REM For application system PPA version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      DEPOSITO_EVENTI_RILEVAZIONE
REM

REM
REM     DERI - Deposito Eventi individuali provenienti da un sistema di
REM            Rilevazione Presenze
REM
PROMPT 
PROMPT Creating Table deposito_eventi_rilevazione
CREATE TABLE deposito_eventi_rilevazione (
 evento                          VARCHAR(10)      NULL,
 ci                              VARCHAR(8)       NULL,
 giustificativo                  VARCHAR(8)   NOT NULL,
 motivo                          VARCHAR(8)       NULL,
 dal                             VARCHAR(8)       NULL,
 al                              VARCHAR(8)       NULL,
 riferimento                     VARCHAR(8)       NULL,
 chiuso                          VARCHAR(2)       NULL,
 input                           VARCHAR(1)       NULL,
 classe                          VARCHAR(10)      NULL,
 dalle                           VARCHAR(4)       NULL,
 alle                            VARCHAR(4)       NULL,
 valore                          VARCHAR(12)      NULL,
 cdc                             VARCHAR(8)       NULL,
 sede                            VARCHAR(6)       NULL,
 note                            VARCHAR(240)     NULL,
 utente                          VARCHAR(8)       NULL,
 data_agg                        VARCHAR(8)       NULL
)
;

COMMENT ON TABLE deposito_eventi_rilevazione
    IS 'DERI - Deposito Eventi Rilevazione';


REM
REM 
REM
PROMPT
PROMPT Creating Index DERI_GIUS_FK on Table DEPOSITO_EVENTI_RILEVAZIONE
CREATE INDEX DERI_GIUS_FK ON DEPOSITO_EVENTI_RILEVAZIONE
(
      giustificativo )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index DERI_IK1 on Table DEPOSITO_EVENTI_RILEVAZIONE
CREATE INDEX DERI_IK1 ON DEPOSITO_EVENTI_RILEVAZIONE
(
      ci ,
      dal )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index DERI_IK3 on Table DEPOSITO_EVENTI_RILEVAZIONE
CREATE INDEX DERI_IK3 ON DEPOSITO_EVENTI_RILEVAZIONE
(
      data_agg )
PCTFREE  10
;

REM
REM  End of command file
REM
