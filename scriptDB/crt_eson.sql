REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      ESTRAZIONE_ONERI
REM INDEX
REM      ESON_PK
REM      ESON_VOCO_FK
REM      ESON_VOCO_RIV_FK

REM
REM     ESON - Parametri di estrazione degli elenchi di dettaglio Oneri
REM
PROMPT 
PROMPT Creating Table ESTRAZIONE_ONERI
CREATE TABLE estrazione_oneri(
 sequenza                        NUMBER(3,0)      NOT NULL,
 titolo                          VARCHAR(30)      NULL,
 titolo_al1                      VARCHAR(30)      NULL,
 titolo_al2                      VARCHAR(30)      NULL,
 giorni                          VARCHAR(1)       NULL,
 voce                            VARCHAR(10)      NOT NULL,
 sub                             VARCHAR(2)       NOT NULL,
 riv_voce                        VARCHAR(10)      NULL,
 riv_sub                         VARCHAR(2)       NULL
)
;

COMMENT ON TABLE estrazione_oneri
    IS 'ESON - Parametri di estrazione degli elenchi di dettaglio Oneri';


REM
REM 
REM
PROMPT
PROMPT Creating Index ESON_PK on Table ESTRAZIONE_ONERI
CREATE UNIQUE INDEX ESON_PK ON ESTRAZIONE_ONERI
(
      sequenza )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index ESON_VOCO_FK on Table ESTRAZIONE_ONERI
CREATE INDEX ESON_VOCO_FK ON ESTRAZIONE_ONERI
(
      voce ,
      sub )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index ESON_VOCO_RIV_FK on Table ESTRAZIONE_ONERI
CREATE INDEX ESON_VOCO_RIV_FK ON ESTRAZIONE_ONERI
(
      riv_sub ,
      riv_voce )
PCTFREE  10
;

REM
REM  End of command file
REM
