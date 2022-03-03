REM
REM
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      CAPITOLI_CONTABILITA
REM INDEX
REM      CAPC_PK
REM
REM     Appoggio per Integrazione con CF4
REM
PROMPT 
PROMPT Creating Table CAPITOLI_CONTABILITA

CREATE TABLE CAPITOLI_CONTABILITA(
  ESERCIZIO                       NUMBER(4)     NOT NULL 
, E_S                             VARCHAR2(1)   NOT NULL
, RISORSA_INTERVENTO              NUMBER(7)     NOT NULL
, CAPITOLO                        NUMBER(6)     NOT NULL
, ARTICOLO                        NUMBER(2)     NOT NULL
, DESCRIZIONE                     VARCHAR2(140) NOT NULL 
, TITOLO                          NUMBER(2)
, CATEGORIA                       NUMBER(2)
, COD_INTERVENTO                  NUMBER(2)
, CTERZI                          NUMBER(2)
, DIVISIONE                       VARCHAR2(2000)
)
;
REM
REM 
REM
PROMPT
PROMPT Creating Unique Index CAPC_PK on Table CAPITOLI_CONTABILITA
CREATE UNIQUE INDEX CAPC_PK ON CAPITOLI_CONTABILITA
( ESERCIZIO
, E_S
, RISORSA_INTERVENTO
, CAPITOLO
, ARTICOLO
)
PCTFREE  10
;
REM
REM  End of command file
REM


