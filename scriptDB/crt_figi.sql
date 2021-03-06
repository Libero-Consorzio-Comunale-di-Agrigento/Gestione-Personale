REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  07-SEP-93
REM
REM For application system PGM version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      FIGURE_GIURIDICHE
REM INDEX
REM      FIGI_CARR_FK
REM      FIGI_PK
REM      FIGI_POFU_FK
REM      FIGI_QUAL_FK
REM      FIGI_UK
REM      FIGI_IK

REM
REM     FIGI - Attributi storici delle figure professionali
REM
PROMPT 
PROMPT Creating Table FIGURE_GIURIDICHE
CREATE TABLE figure_giuridiche(
 numero                          NUMBER(6,0)      NOT NULL,
 dal                             DATE             NOT NULL,
 al                              DATE             NULL,
 codice                          VARCHAR(8)       NOT NULL,
 descrizione                     VARCHAR(120)     NULL,
 descrizione_al1                 VARCHAR(120)     NULL,
 descrizione_al2                 VARCHAR(120)     NULL,
 profilo                         VARCHAR(4)       NULL,
 posizione                       VARCHAR(4)       NULL,
 carriera                        VARCHAR(4)       NULL,
 qualifica                       NUMBER(6,0)      NOT NULL,
 cert_att                        VARCHAR(2)       NOT NULL,
 cert_set                        VARCHAR(1)       NULL,
 note                            VARCHAR(4000)    NULL,
 note_al1                        VARCHAR(4000)    NULL,
 note_al2                        VARCHAR(4000)    NULL,
 cert_qua                        VARCHAR(2)       NULL,
 cod_reg                         VARCHAR(6)       NULL,
 codice_ministero                VARCHAR(6)       NULL,
 codice_ministero_01             VARCHAR(6)       NULL
)
;

COMMENT ON TABLE figure_giuridiche
    IS 'FIGI - Attributi storici delle figure professionali';


REM
REM 
REM
PROMPT
PROMPT Creating Index FIGI_CARR_FK on Table FIGURE_GIURIDICHE
CREATE INDEX FIGI_CARR_FK ON FIGURE_GIURIDICHE
(
      carriera )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index FIGI_PK on Table FIGURE_GIURIDICHE
CREATE UNIQUE INDEX FIGI_PK ON FIGURE_GIURIDICHE
(
      numero ,
      dal )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index FIGI_POFU_FK on Table FIGURE_GIURIDICHE
CREATE INDEX FIGI_POFU_FK ON FIGURE_GIURIDICHE
(
      profilo ,
      posizione )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index FIGI_QUAL_FK on Table FIGURE_GIURIDICHE
CREATE INDEX FIGI_QUAL_FK ON FIGURE_GIURIDICHE
(
      qualifica )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index FIGI_UK on Table FIGURE_GIURIDICHE
CREATE UNIQUE INDEX FIGI_UK ON FIGURE_GIURIDICHE
(
      codice ,
      dal )
PCTFREE  10
;

PROMPT
PROMPT Creating Index FIGI_IK on Table FIGURE_GIURIDICHE
CREATE INDEX FIGI_IK ON FIGURE_GIURIDICHE
(
      codice_ministero )
PCTFREE  10
;

REM
REM  End of command file
REM
