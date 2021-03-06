REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  21-DEC-93
REM
REM For application system PPA version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      DEPOSITO_EVENTI_RP

REM
REM     DERP - Deposito eventi da Rilevazione presenze (CARP e CARPX)
REM
PROMPT 
PROMPT Creating Table DEPOSITO_EVENTI_RP
CREATE TABLE deposito_eventi_rp(
 ci                              VARCHAR(8)       NULL,
 badge                           VARCHAR(5)       NULL,
 giustificativo                  VARCHAR(8)       NOT NULL,
 giorno                          VARCHAR(6)       NULL,     
 data_rif                        VARCHAR(8)       NOT NULL,
 dalle                           VARCHAR(4)       NULL,
 alle                            VARCHAR(4)       NULL,
 quantita                        VARCHAR(12)      NULL,
 riferimento                     number(8)
)
;

COMMENT ON TABLE deposito_eventi_rp
    IS 'DERP - Deposito eventi da Rilevazione presenze (CARP e CARPX)';

REM
REM  End of command file
REM
