REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  07-SEP-93
REM
REM For application system GIP version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      CORRISPONDENZE
REM INDEX
REM      CORR_PK

REM
REM     CORR - Protocollo della corrispondenza ricevuta e spedita
REM
PROMPT 
PROMPT Creating Table CORRISPONDENZE
CREATE TABLE corrispondenze(
 registro                        VARCHAR(4)       NOT NULL,
 anno                            NUMBER(4,0)      NOT NULL,
 numero                          NUMBER(7,0)      NOT NULL,
 data                            DATE             NOT NULL,
 oggetto                         VARCHAR(240)     NULL,
 descrizione                     VARCHAR(50)      NULL
)
;

COMMENT ON TABLE corrispondenze
    IS 'CORR - Protocollo della corrispondenza ricevuta e spedita';


REM
REM 
REM
PROMPT
PROMPT Creating Index CORR_PK on Table CORRISPONDENZE
CREATE UNIQUE INDEX CORR_PK ON CORRISPONDENZE
(
      registro ,
      anno ,
      numero )
PCTFREE  10
;

REM
REM  End of command file
REM
