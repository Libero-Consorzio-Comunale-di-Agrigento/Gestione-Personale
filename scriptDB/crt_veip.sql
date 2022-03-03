REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  10-FEB-94
REM
REM For application system PIP version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      VERSIONI_IPOTESI_INCENTIVO
REM INDEX
REM      VEIP_PK

REM
REM     Created from Entity VERSIONE IPOTESI INCENTIVO by P00 on 10-NOV-93
REM
PROMPT 
PROMPT Creating Table VERSIONI_IPOTESI_INCENTIVO
CREATE TABLE versioni_ipotesi_incentivo(
 codice                          VARCHAR(4)       NOT NULL,
 data_cre                        DATE             NULL,
 descrizione                     VARCHAR(30)      NULL,
 descrizione_al1                 VARCHAR(30)      NULL,
 descrizione_al2                 VARCHAR(30)      NULL,
 dal                             DATE             NOT NULL,
 al                              DATE             NOT NULL,
 data_estr                       DATE             NULL
)
;

COMMENT ON TABLE versioni_ipotesi_incentivo
    IS 'Created from Entity VERSIONE IPOTESI INCENTIVO by P00 on 10-NOV-93';


REM
REM 
REM
PROMPT
PROMPT Creating Index VEIP_PK on Table VERSIONI_IPOTESI_INCENTIVO
CREATE UNIQUE INDEX VEIP_PK ON VERSIONI_IPOTESI_INCENTIVO
(
      codice )
PCTFREE  10
;

REM
REM  End of command file
REM
