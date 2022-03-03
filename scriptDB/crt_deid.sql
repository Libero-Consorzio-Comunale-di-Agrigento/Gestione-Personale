REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  06-MAY-94
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      DENUNCIA_INADEL
REM INDEX
REM      DEID_GEST_FK
REM      DEID_PK
REM      DEID_RARE_FK

REM
REM     DEID - Archivio Denuncia I.N.A.D.E.L.
REM
PROMPT 
PROMPT Creating Table DENUNCIA_INADEL
CREATE TABLE denuncia_inadel(
 anno                            NUMBER(4,0)      NOT NULL,
 ci                              NUMBER(8,0)      NOT NULL,
 gestione                        VARCHAR(8)       NOT NULL,
 codice                          VARCHAR(9)       NULL,
 data_assunzione                 DATE             NULL,
 data_cessazione                 DATE             NULL,
 data_passaggio                  DATE             NULL,
 flag_data                       VARCHAR(1)       NULL,
 qualifica                       NUMBER(6,0)      NULL,
 tp                              VARCHAR(1)       NULL,
 cod_asp1                        VARCHAR(4)       NULL,
 gg_asp1                         NUMBER(3,0)      NULL,
 cod_asp2                        VARCHAR(4)       NULL,
 gg_asp2                         NUMBER(3,0)      NULL,
 cod_asp3                        VARCHAR(4)       NULL,
 gg_asp3                         NUMBER(3,0)      NULL,
 utente                          VARCHAR(8)       NULL,
 tipo_agg                        VARCHAR(1)       NULL,
 data_agg                        DATE             NULL,
 posizione                       VARCHAR(4)       NULL
)
;

COMMENT ON TABLE denuncia_inadel
    IS 'DEID - Archivio Denuncia I.N.A.D.E.L.';


REM
REM 
REM
PROMPT
PROMPT Creating Index DEID_GEST_FK on Table DENUNCIA_INADEL
CREATE INDEX DEID_GEST_FK ON DENUNCIA_INADEL
(
      gestione )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index DEID_PK on Table DENUNCIA_INADEL
CREATE UNIQUE INDEX DEID_PK ON DENUNCIA_INADEL
(
      anno ,
      ci )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index DEID_RARE_FK on Table DENUNCIA_INADEL
CREATE INDEX DEID_RARE_FK ON DENUNCIA_INADEL
(
      ci )
PCTFREE  10
;

REM
REM  End of command file
REM