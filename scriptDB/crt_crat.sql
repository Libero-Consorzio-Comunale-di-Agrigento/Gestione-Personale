SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      CODICI_REGIONALI_ATTIVITA
REM INDEX
REM     CRAT_PK

REM
REM     CRAT - Codici Regionali Attivita` per denuncia infortuni
REM
PROMPT 
PROMPT Creating Table CODICI_REGIONALI_ATTIVITA
CREATE TABLE CODICI_REGIONALI_ATTIVITA
(codice                          VARCHAR(2)       NOT NULL,
 descrizione                     VARCHAR(120)     NULL,
 sequenza                        NUMBER(6,0)      NULL
)
;

COMMENT ON TABLE CODICI_REGIONALI_ATTIVITA
    IS 'CRAT - Codici Regionali Attivita` per denuncia infortuni';

REM 
REM
PROMPT
PROMPT Creating Unique Index CRAT_PK on Table CODICI_REGIONALI_ATTIVITA
CREATE UNIQUE INDEX CRAT_PK ON CODICI_REGIONALI_ATTIVITA
( codice )
PCTFREE  10
;

REM
REM  End of command file
REM
