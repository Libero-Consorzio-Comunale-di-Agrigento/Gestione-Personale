REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      CONDIZIONI_FAMILIARI
REM INDEX
REM      COFA_PK

REM
REM     COFA - Condizioni di situazione familiare per assegni
REM
PROMPT 
PROMPT Creating Table CONDIZIONI_FAMILIARI
CREATE TABLE condizioni_familiari(
 codice                          VARCHAR(4)       NOT NULL,
 descrizione                     VARCHAR(30)      NULL,
 descrizione_al1                 VARCHAR(30)      NULL,
 descrizione_al2                 VARCHAR(30)      NULL,
 sequenza                        NUMBER(3,0)      NULL,
 tabella                         VARCHAR(3)       NULL,
 tabella_inps                    VARCHAR(3)       NULL,
 COD_SCAGLIONE                   VARCHAR2(2)      NOT NULL
)
;

COMMENT ON TABLE condizioni_familiari
    IS 'COFA - Condizioni di situazione familiare per assegni';


REM
REM 
REM
PROMPT
PROMPT Creating Index COFA_PK on Table CONDIZIONI_FAMILIARI
CREATE UNIQUE INDEX COFA_PK ON CONDIZIONI_FAMILIARI
(
      codice )
PCTFREE  10
;

REM
REM  End of command file
REM
