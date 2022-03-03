REM
REM
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      ACC_IMP_CONTABILITA
REM INDEX
REM      ACON_PK 
REM
REM     Appoggio per Integrazione con CF4
REM
PROMPT 
PROMPT Creating Table ACC_IMP_CONTABILITA
CREATE TABLE ACC_IMP_CONTABILITA 
( ESERCIZIO                                NUMBER       NOT NULL
, E_S                                      VARCHAR2(1)  NOT NULL
, RISORSA_INTERVENTO                       NUMBER       NOT NULL
, CAPITOLO                                 NUMBER       NOT NULL
, ARTICOLO                                 NUMBER       NOT NULL
, ANNO_IMP_ACC                             NUMBER       NOT NULL
, NUMERO_IMP_ACC                           NUMBER       NOT NULL
, ANNO_DEL                                 VARCHAR2(2000)
, NUMERO_DEL                               VARCHAR2(2000)
, SEDE_DEL                                 VARCHAR2(2000)
, SOGGETTO                                 VARCHAR2(2000)
, DIVISIONE                                VARCHAR2(2000)
) 
;
REM
REM 
REM
PROMPT
PROMPT Creating Unique Index ACON_PK on Table ACC_IMP_CONTABILITA
CREATE UNIQUE INDEX ACON_PK ON ACC_IMP_CONTABILITA
( ESERCIZIO
, E_S
, RISORSA_INTERVENTO
, CAPITOLO
, ARTICOLO
, ANNO_IMP_ACC
, NUMERO_IMP_ACC
)
PCTFREE  10
;
REM
REM  End of command file
REM