REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  17-SEP-93
REM
REM For application system PIP version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      RAPPORTI_INCENTIVO
REM INDEX
REM      RAIP_PK
REM      RAIP_RAGI_FK

REM
REM     RAIP - Rapporto di Incentivo su Applicazione Progetto
REM
PROMPT 
PROMPT Creating Table RAPPORTI_INCENTIVO
CREATE TABLE rapporti_incentivo(
 progetto                        VARCHAR(8)       NOT NULL,
 scp                             VARCHAR(4)       NOT NULL,
 ci                              NUMBER(8,0)      NOT NULL,
 flag_elab                       VARCHAR(1)       NULL,
 flag_cong                       VARCHAR(1)       NULL,
 d_rett                          DATE             NULL,
 d_cong                          DATE             NULL,
 ini_blocco                      DATE             NULL,
 fin_blocco                      DATE             NULL
)
;

COMMENT ON TABLE rapporti_incentivo
    IS 'RAIP - Rapporto di Incentivo su Applicazione Progetto';


REM
REM 
REM
PROMPT
PROMPT Creating Index RAIP_PK on Table RAPPORTI_INCENTIVO
CREATE UNIQUE INDEX RAIP_PK ON RAPPORTI_INCENTIVO
(
      progetto ,
      scp ,
      ci )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index RAIP_RAGI_FK on Table RAPPORTI_INCENTIVO
CREATE INDEX RAIP_RAGI_FK ON RAPPORTI_INCENTIVO
(
      ci )
PCTFREE  10
;

REM
REM  End of command file
REM