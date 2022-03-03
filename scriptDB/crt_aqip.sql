REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  26-JUL-93
REM
REM For application system PIP version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      ATTRIBUZIONE_QUOTE_INCENTIVO
REM INDEX
REM      AQIP_PK

REM
REM     AQIP - Parametrizzazione delle quote di progetto per la gestione dell"a
REM - ttribuzione e dell"assegnazione del personale.
REM
PROMPT 
PROMPT Creating Table ATTRIBUZIONE_QUOTE_INCENTIVO
CREATE TABLE attribuzione_quote_incentivo(
 progetto                        VARCHAR(8)       NOT NULL,
 dal                             DATE             NOT NULL,
 al                              DATE             NULL,
 equipe                          VARCHAR(4)       NOT NULL,
 gruppo                          VARCHAR(2)       NOT NULL,
 rapporto                        VARCHAR(4)       NOT NULL,
 ruolo                           VARCHAR(2)       NOT NULL,
 livello                         VARCHAR(4)       NOT NULL,
 contratto                       VARCHAR(4)       NOT NULL,
 qualifica                       VARCHAR(8)       NOT NULL,
 tipo_rapporto                   VARCHAR(4)       NOT NULL,
 mesi                            NUMBER(2,0)      NOT NULL,
 prestazione                     VARCHAR(1)       NOT NULL,
 ore                             NUMBER(5,2)      NULL,
 importo                         NUMBER(12,2)     NULL,
 utente                          VARCHAR(8)       NULL,
 data_agg                        DATE             NULL
)
;

COMMENT ON TABLE attribuzione_quote_incentivo
    IS 'AQIP - Parametrizzazione delle quote di progetto per la gestione dell"attribuzione e dell"assegnazione del personale.';


REM
REM 
REM
PROMPT
PROMPT Creating Index AQIP_PK on Table ATTRIBUZIONE_QUOTE_INCENTIVO
CREATE UNIQUE INDEX AQIP_PK ON ATTRIBUZIONE_QUOTE_INCENTIVO
(
      progetto ,
      dal ,
      equipe ,
      gruppo ,
      rapporto ,
      ruolo ,
      livello ,
      contratto ,
      qualifica ,
      tipo_rapporto ,
      mesi )
PCTFREE  10
;

REM
REM  End of command file
REM