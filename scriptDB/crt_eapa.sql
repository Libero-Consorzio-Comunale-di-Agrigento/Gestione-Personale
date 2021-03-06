REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  16-JUN-94
REM
REM For application system PPA version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      EVENTI_AUTOMATICI_PRESENZA
REM INDEX
REM      EAPA_CAEV_FK
REM      EAPA_CECO_FK
REM      EAPA_PK
REM      EAPA_SEDE_FK

REM
REM     EAPA - Automatismi individuali di Presenza / Assenza
REM
PROMPT 
PROMPT Creating Table EVENTI_AUTOMATICI_PRESENZA
CREATE TABLE eventi_automatici_presenza(
 ci                              NUMBER(8,0)      NOT NULL,
 causale                         VARCHAR(8)       NOT NULL,
 motivo                          VARCHAR(8)       NULL,
 dal                             DATE             NULL,
 al                              DATE             NULL,
 attivo                          VARCHAR(2)       NOT NULL,
 attribuzione                    VARCHAR(1)       NOT NULL,
 specie                          VARCHAR(1)       NOT NULL,
 gg_ratei                        NUMBER(3)        NULL,
 quantita                        NUMBER(12,2)     NOT NULL,
 sede                            NUMBER(6,0)      NULL,
 cdc                             VARCHAR(8)       NULL,
 condizione                      VARCHAR(1)       NOT NULL,
 stato_condizione                VARCHAR(1)       NULL,
 utente                          VARCHAR(8)       NULL,
 data_agg                        DATE             NULL
)
;

COMMENT ON TABLE eventi_automatici_presenza
    IS 'EAPA - Automatismi individuali di Presenza / Assenza';


REM
REM 
REM
PROMPT
PROMPT Creating Index EAPA_CAEV_FK on Table EVENTI_AUTOMATICI_PRESENZA
CREATE INDEX EAPA_CAEV_FK ON EVENTI_AUTOMATICI_PRESENZA
(
      causale )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index EAPA_CECO_FK on Table EVENTI_AUTOMATICI_PRESENZA
CREATE INDEX EAPA_CECO_FK ON EVENTI_AUTOMATICI_PRESENZA
(
      cdc )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index EAPA_PK on Table EVENTI_AUTOMATICI_PRESENZA
CREATE UNIQUE INDEX EAPA_PK ON EVENTI_AUTOMATICI_PRESENZA
(
      ci ,
      causale ,
      motivo ,
      dal )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index EAPA_SEDE_FK on Table EVENTI_AUTOMATICI_PRESENZA
CREATE INDEX EAPA_SEDE_FK ON EVENTI_AUTOMATICI_PRESENZA
(
      sede )
PCTFREE  10
;

REM
REM  End of command file
REM
