REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  30-MAY-94
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      DENUNCIA_CP
REM INDEX
REM      DECP_GEST_FK
REM      DECP_PK
REM      DECP_RARE_FK

REM
REM     DECP - Archivio Denuncia Cassa Pensione
REM
PROMPT 
PROMPT Creating Table DENUNCIA_CP
CREATE TABLE denuncia_cp(
 anno                            NUMBER(4,0)      NOT NULL,
 previdenza                      VARCHAR(6)       NOT NULL,
 ci                              NUMBER(8,0)      NOT NULL,
 gestione                        VARCHAR(8)       NULL,
 codice                          VARCHAR(10)      NULL,
 posizione                       VARCHAR(8)       NULL,
 rilevanza                       VARCHAR(1)       NOT NULL,
 dal                             DATE             NULL,
 al                              DATE             NULL,
 importo                         NUMBER(12,2)     NULL,
 riferimento                     NUMBER(4,0)      NULL,
 tipo_contratto                  VARCHAR(1)       NULL,
 tipo_cessazione                 VARCHAR(1)       NULL,
 utente                          VARCHAR(8)       NULL,
 tipo_agg                        VARCHAR(1)       NULL,
 data_agg                        DATE             NULL,
 riporto                         VARCHAR(1)       NULL,
 numero                          NUMBER(3,0)      NULL,
 ore                             NUMBER(5,2)      NULL,
 contributi                      NUMBER(12,2)     NULL,
 tipo_servizio                   varchar(1)       NULL,
 competenza                      number(4,0)      NULL,
 gg_utili                        number(3,0)      NULL,
 retr_accessorie                 number(12,2)     NULL,
 retr_inadel                     number(12,2)     NULL,
 premio_prod                     number(12,2)     NULL,
 data_cessazione                 date             NULL
)
;

COMMENT ON TABLE denuncia_cp
    IS 'DECP - Archivio Denuncia Cassa Pensione';


REM
REM 
REM
PROMPT
PROMPT Creating Index DECP_GEST_FK on Table DENUNCIA_CP
CREATE INDEX DECP_GEST_FK ON DENUNCIA_CP
(
      gestione )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index DECP_PK on Table DENUNCIA_CP
CREATE UNIQUE INDEX DECP_PK ON DENUNCIA_CP
(
      anno ,
      previdenza ,
      ci ,
      rilevanza ,
      dal )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index DECP_RARE_FK on Table DENUNCIA_CP
CREATE INDEX DECP_RARE_FK ON DENUNCIA_CP
(
      ci )
PCTFREE  10
;

REM
REM  End of command file
REM
