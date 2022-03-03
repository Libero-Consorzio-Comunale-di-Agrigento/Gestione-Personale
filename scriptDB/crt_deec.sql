REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  20-DEC-93
REM
REM For application system PPA version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      DEPOSITO_EVENTI_EC

REM
REM     DEEC - Deposito voci per Gestione economica
REM
PROMPT 
PROMPT Creating Table DEPOSITO_EVENTI_EC
CREATE TABLE deposito_eventi_ec(
 ci                              NUMBER(8,0)      NOT NULL,
 voce                            VARCHAR(10)      NOT NULL,
 sub                             VARCHAR(2)       NOT NULL,
 riferimento                     DATE             NOT NULL,
 arr                             VARCHAR(1)       NULL,
 gestione                        VARCHAR(1)       NOT NULL,
 input                           VARCHAR(1)       NULL,
 qta                             NUMBER(8,2)      NULL,
 tar                             NUMBER(15,5)        NULL,
 imp                             NUMBER(12,2)     NULL,
 delibera                        VARCHAR(4)       NULL
)
;
create index deec_ik
on deposito_eventi_ec
(ci,voce,sub)
;
COMMENT ON TABLE deposito_eventi_ec
    IS 'DEEC - Deposito voci per Gestione economica';

REM
REM  End of command file
REM
