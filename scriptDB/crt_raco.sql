REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  23-SEP-93
REM
REM For application system PGC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      RAPPORTI_CONCORSUALI
REM INDEX
REM      RACO_PK
REM      RACO_PRPO_FK

REM
REM     RACO - Identificazione dei rapporti con caratteristiche concorsuali
REM
PROMPT 
PROMPT Creating Table RAPPORTI_CONCORSUALI
CREATE TABLE rapporti_concorsuali(
 ci                              NUMBER(8,0)      NOT NULL,
 pratica                         VARCHAR(12)      NOT NULL,
 rilevanza                       VARCHAR(4)       NULL,
 ammesso                         VARCHAR(2)       NULL,
 note_ammissione                 VARCHAR(240)     NULL,
 idoneo                          VARCHAR(2)       NULL,
 punteggio                       NUMBER(8,3)      NULL,
 graduatoria                     NUMBER(5,0)      NULL,
 disponibile                     VARCHAR(2)       NULL,
 note_disponibilita              VARCHAR(240)     NULL,
 indennita                       NUMBER(12,2)     NULL,
 compenso                        NUMBER(12,2)     NULL,
 rimborso                        NUMBER(12,2)     NULL,
 precedenza                      NUMBER(8,0)      NULL
)
;

COMMENT ON TABLE rapporti_concorsuali
    IS 'RACO - Identificazione dei rapporti con caratteristiche concorsuali';


REM
REM 
REM
PROMPT
PROMPT Creating Index RACO_PK on Table RAPPORTI_CONCORSUALI
CREATE UNIQUE INDEX RACO_PK ON RAPPORTI_CONCORSUALI
(
      ci )
PCTFREE  10
;

REM
REM 
REM
PROMPT
PROMPT Creating Index RACO_PRPO_FK on Table RAPPORTI_CONCORSUALI
CREATE INDEX RACO_PRPO_FK ON RAPPORTI_CONCORSUALI
(
      pratica ,
      rilevanza )
PCTFREE  10
;

REM
REM  End of command file
REM
