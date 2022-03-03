REM
REM
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      SUBIMP_CONTABILITA
REM INDEX
REM      SUCO_PK
REM
REM     Appoggio per Integrazione con CF4
REM
PROMPT 
PROMPT Creating Table SUBIMP_CONTABILITA

CREATE TABLE SUBIMP_CONTABILITA(
  ESERCIZIO                       NUMBER(4) NOT NULL
, E_S                             VARCHAR(1) NOT NULL
, RISORSA_INTERVENTO              NUMBER(7) NOT NULL
, CAPITOLO                        NUMBER(6) NOT NULL
, ARTICOLO                        NUMBER(2) NOT NULL
, ANNO_IMP                        NUMBER(4) NOT NULL
, NUMERO_IMP                      NUMBER(5) NOT NULL
, ANNO_SUBIMP                     NUMBER(4) NOT NULL
, NUMERO_SUBIMP                   NUMBER(5) NOT NULL
, ANNO_DEL                        VARCHAR2(2000)
, NUMERO_DEL                      VARCHAR2(2000)
, SEDE_DEL                        VARCHAR2(2000)
, SOGGETTO                        VARCHAR2(2000)
, DIVISIONE                       VARCHAR2(2000)
)
;
REM
REM 
REM
PROMPT
PROMPT Creating Unique Index SUCO_PK on Table SUBIMP_CONTABILITA
CREATE UNIQUE INDEX SUCO_PK ON SUBIMP_CONTABILITA
( ESERCIZIO
, E_S
, RISORSA_INTERVENTO
, CAPITOLO
, ARTICOLO
, ANNO_IMP
, NUMERO_IMP
, ANNO_SUBIMP
, NUMERO_SUBIMP
)
PCTFREE  10
;
 
REM
REM  End of command file
REM