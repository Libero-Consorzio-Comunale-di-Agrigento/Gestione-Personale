REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  26-JUL-93
REM
REM For application system PIP version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      APPLICAZIONI_INCENTIVO
REM INDEX
REM      APIP_DELI_DEL_FK
REM      APIP_DELI_SAL_FK
REM      APIP_PAAP_FK
REM      APIP_PK

REM
REM     APIP - Attribuzione del Progetto allo specifico periodo di applicazione
REM
PROMPT 
PROMPT Creating Table APPLICAZIONI_INCENTIVO
CREATE TABLE applicazioni_incentivo(
 progetto                        VARCHAR(8)       NOT NULL,
 scp                             VARCHAR(4)       NOT NULL,
 descrizione                     VARCHAR(30)      NULL,
 descrizione_al1                 VARCHAR(30)      NULL,
 descrizione_al2                 VARCHAR(30)      NULL,
 parte                           VARCHAR(4)       NOT NULL,
 dal                             DATE             NOT NULL,
 al                              DATE             NULL,
 sede_del                        VARCHAR(4)       NULL,
 anno_del                        NUMBER(4,0)      NULL,
 numero_del                      NUMBER(7,0)      NULL,
 stato                           VARCHAR(1)       NOT NULL,
 per_liq                         NUMBER(5,2)      NOT NULL,
 per_rag                         NUMBER(5,2)      NULL,
 valorizzazione                  VARCHAR(1)       NOT NULL,
 note                            VARCHAR(240)     NULL,
 d_elab                          DATE             NULL,
 flag_elab                       VARCHAR(1)       NULL,
 flag_cong                       VARCHAR(1)       NULL,
 d_cong                          DATE             NULL,
 d_rett                          DATE             NULL,
 d_saldo                         DATE             NULL,
 sede_saldo                      VARCHAR(4)       NULL,
 anno_saldo                      NUMBER(4,0)      NULL,
 numero_saldo                    NUMBER(7,0)      NULL
)
;

COMMENT ON TABLE applicazioni_incentivo
    IS 'APIP - Attribuzione del Progetto allo specifico periodo di applicazione';


REM
REM 
REM
PROMPT
PROMPT Creating Index APIP_DELI_DEL_FK on Table APPLICAZIONI_INCENTIVO
CREATE INDEX APIP_DELI_DEL_FK ON APPLICAZIONI_INCENTIVO
(
      sede_del ,
      anno_del ,
      numero_del )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index APIP_DELI_SAL_FK on Table APPLICAZIONI_INCENTIVO
CREATE INDEX APIP_DELI_SAL_FK ON APPLICAZIONI_INCENTIVO
(
      sede_saldo ,
      anno_saldo ,
      numero_saldo )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index APIP_PAAP_FK on Table APPLICAZIONI_INCENTIVO
CREATE INDEX APIP_PAAP_FK ON APPLICAZIONI_INCENTIVO
(
      parte )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index APIP_PK on Table APPLICAZIONI_INCENTIVO
CREATE UNIQUE INDEX APIP_PK ON APPLICAZIONI_INCENTIVO
(
      progetto ,
      scp )
PCTFREE  10
;

REM
REM  End of command file
REM
