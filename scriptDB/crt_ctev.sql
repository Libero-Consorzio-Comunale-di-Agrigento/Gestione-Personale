REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  28-SEP-94
REM
REM For application system PPA version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      CATEGORIE_EVENTO
REM INDEX
REM      CTEV_PK

REM
REM     CTEV - Categorie Evento di Presenza/Assenza
REM
PROMPT 
PROMPT Creating Table CATEGORIE_EVENTO
CREATE TABLE categorie_evento(
 codice                          VARCHAR(8)       NOT NULL,
 descrizione                     VARCHAR(30)      NULL,
 descrizione_al1                 VARCHAR(30)      NULL,
 descrizione_al2                 VARCHAR(30)      NULL,
 sequenza                        NUMBER(3,0)      NULL,
 dal                             DATE             NULL,
 al                              DATE             NULL,
 note                            VARCHAR(240)     NULL,
 gestione                        VARCHAR(1)       NOT NULL,
 opzione                         VARCHAR(1)       NOT NULL,
 controllo                       VARCHAR(2)       NOT NULL,
 lim_min                         NUMBER(12,2)     NULL,
 seg_min                         VARCHAR(1)       NULL,
 msg_min                         VARCHAR(70)      NULL,
 msg_min_al1                     VARCHAR(70)      NULL,
 msg_min_al2                     VARCHAR(70)      NULL,
 lim_max                         NUMBER(12,2)     NULL,
 seg_max                         VARCHAR(1)       NULL,
 msg_max                         VARCHAR(70)      NULL,
 msg_max_al1                     VARCHAR(70)      NULL,
 msg_max_al2                     VARCHAR(70)      NULL,
 segno                           VARCHAR(1)       NULL,
 voce                            VARCHAR(10)      NULL,
 sub                             VARCHAR(2)       NULL,
 delibera                        VARCHAR(4)       NULL,
 sede                            VARCHAR(8)       NOT NULL,
 cdc                             VARCHAR(8)       NOT NULL,
 causale_co                      VARCHAR(8)       NULL,
 sede_co                         NUMBER(6,0)      NULL,
 cdc_co                          VARCHAR(8)       NULL,
 budget                          VARCHAR(4)       NULL
)
;

COMMENT ON TABLE categorie_evento
    IS 'CTEV - Categorie Evento di Presenza/Assenza';


REM
REM 
REM
PROMPT
PROMPT Creating Index CTEV_PK on Table CATEGORIE_EVENTO
CREATE UNIQUE INDEX CTEV_PK ON CATEGORIE_EVENTO
(
      codice )
PCTFREE  10
;

REM
REM  End of command file
REM