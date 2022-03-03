REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      FONDI (personalizzazione per AUSL 9 - Ferrara)

REM
REM    FOND - Tabella riepilogativa dei pagamenti delle voci richieste per 
REM         - la gestione dei FONDI di spesa
REM
PROMPT 
PROMPT Creating Table FONDI 
CREATE TABLE fondi(
 estrazione                      VARCHAR2(20)     NOT NULL,
 anno                            NUMBER(4,0)      NOT NULL,
 mese                            NUMBER(2,0)      NOT NULL,
 mensilita                       VARCHAR2(4)      NOT NULL, 
 anno_competenza                 NUMBER(4,0)      NOT NULL,
 mese_competenza                 NUMBER(2,0)      NOT NULL,
 contratto                       VARCHAR2(4)      NULL,
 ruolo                           VARCHAR2(4)      NULL,
 settore                         NUMBER(6,0)      NULL,
 colonna                         VARCHAR2(30)     NULL,
 importo                         NUMBER(15,5)     NULL
)
;

CREATE INDEX FOND_IK on FONDI (estrazione,anno,mese,mensilita)
;

COMMENT ON TABLE fondi
    IS 'FOND - Tabella riepilogativa voci richieste per gestione FONDI di spesa';

REM
REM  End of command file
REM