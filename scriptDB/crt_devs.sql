REM
REM For application system PPA version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      DEPOSITO_VARIAZIONI_SETTORE        
REM

REM
REM     DERI - Deposito Variazioni di Settore provenienti dal sistema di
REM            Rilevazione Presenze IRIS-WIN
REM
PROMPT 
PROMPT Creating Table deposito_variazioni_settore
CREATE TABLE deposito_variazioni_settore 
(
 ni                              number(8)        NULL,
 settore                         VARCHAR(15)       NULL,
 sede                            VARCHAR(8)       NULL,
 dal                             date             NULL,
 al                              date             NULL,
 data_agg                        date
)
;

COMMENT ON TABLE deposito_variazioni_settore
    IS 'DEVS - Deposito Variazioni Settore ';


CREATE INDEX DEVS_IK1 ON DEPOSITO_VARIAZIONI_SETTORE  
(
      ni             )
PCTFREE  10
;
CREATE INDEX DEVS_IK2 ON DEPOSITO_VARIAZIONI_SETTORE  
(
      data_agg             )
PCTFREE  10
;
