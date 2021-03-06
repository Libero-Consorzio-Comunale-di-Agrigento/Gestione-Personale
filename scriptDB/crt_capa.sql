REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  25-JUL-94
REM
REM For application system PPA version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      CALCOLO_PROSPETTI_PRESENZA
REM INDEX
REM      CAPA_IK
REM      CAPA_IK2
REM      CAPA_IK3

REM
REM     
REM
PROMPT 
PROMPT Creating Table CALCOLO_PROSPETTI_PRESENZA
CREATE TABLE calcolo_prospetti_presenza(
 prenotazione                    NUMBER(6,0)      NOT NULL,
 tipo_record                     VARCHAR(2)       NOT NULL,
 prpa_sequenza                   NUMBER(6,0)      NULL,
 prpa_codice                     VARCHAR(8)       NOT NULL,
 prpa_descrizione                VARCHAR(120)      NULL,
 sede_sequenza                   NUMBER(6,0)      NULL,
 sede_codice                     VARCHAR(8)       NULL,
 sede_numero                     NUMBER(6,0)      NULL,
 sede_descrizione                VARCHAR(45)      NULL,
 ceco_codice                     VARCHAR(8)       NULL,
 ceco_descrizione                VARCHAR(30)      NULL,
 gest_codice                     VARCHAR(4)       NULL,
 gest_descrizione                VARCHAR(40)      NULL,
 sett_codice                     VARCHAR(15)      NULL,
 sett_numero                     NUMBER(6,0)      NULL,
 sett_descrizione                VARCHAR(30)      NULL,
 rain_cognome                    VARCHAR(40)      NOT NULL,
 rain_nome                       VARCHAR(36)      NOT NULL,
 rain_ci                         NUMBER(8,0)      NOT NULL,
 pspa_contratto                  VARCHAR(4)       NULL,
 pspa_dal_contratto              DATE             NULL,
 pspa_qualifica                  NUMBER(6,0)      NULL,
 pspa_dal_qualifica              DATE             NULL,
 pspa_figura                     NUMBER(6,0)      NULL,
 pspa_dal_figura                 DATE             NULL,
 pspa_rilevanza                  VARCHAR(1)       NULL,
 pspa_dal_periodo                DATE             NULL,
 pspa_dal_rapporto               DATE             NULL,
 dal                             DATE             NULL,
 al                              DATE             NULL,
 cod_01                          VARCHAR(8)       NULL,
 des_01                          VARCHAR(10)      NULL,
 ges_01                          VARCHAR(1)       NULL,
 val_01                          NUMBER(17,5)     NULL,
 cod_02                          VARCHAR(8)       NULL,
 des_02                          VARCHAR(10)      NULL,
 ges_02                          VARCHAR(1)       NULL,
 val_02                          NUMBER(17,5)     NULL,
 cod_03                          VARCHAR(8)       NULL,
 des_03                          VARCHAR(10)      NULL,
 ges_03                          VARCHAR(1)       NULL,
 val_03                          NUMBER(17,5)     NULL,
 cod_04                          VARCHAR(8)       NULL,
 des_04                          VARCHAR(10)      NULL,
 ges_04                          VARCHAR(1)       NULL,
 val_04                          NUMBER(17,5)     NULL,
 cod_05                          VARCHAR(8)       NULL,
 des_05                          VARCHAR(10)      NULL,
 ges_05                          VARCHAR(1)       NULL,
 val_05                          NUMBER(17,5)     NULL,
 cod_06                          VARCHAR(8)       NULL,
 des_06                          VARCHAR(10)      NULL,
 ges_06                          VARCHAR(1)       NULL,
 val_06                          NUMBER(17,5)     NULL,
 cod_07                          VARCHAR(8)       NULL,
 des_07                          VARCHAR(10)      NULL,
 ges_07                          VARCHAR(1)       NULL,
 val_07                          NUMBER(17,5)     NULL,
 cod_08                          VARCHAR(8)       NULL,
 des_08                          VARCHAR(10)      NULL,
 ges_08                          VARCHAR(1)       NULL,
 val_08                          NUMBER(17,5)     NULL,
 cod_09                          VARCHAR(8)       NULL,
 des_09                          VARCHAR(10)      NULL,
 ges_09                          VARCHAR(1)       NULL,
 val_09                          NUMBER(17,5)     NULL,
 cod_10                          VARCHAR(10)       NULL,
 des_10                          VARCHAR(10)      NULL,
 ges_10                          VARCHAR(1)       NULL,
 val_10                          NUMBER(17,5)     NULL,
 cod_11                          VARCHAR(8)       NULL,
 des_11                          VARCHAR(10)      NULL,
 ges_11                          VARCHAR(1)       NULL,
 val_11                          NUMBER(17,5)     NULL,
 cod_12                          VARCHAR(8)       NULL,
 des_12                          VARCHAR(10)      NULL,
 ges_12                          VARCHAR(1)       NULL,
 val_12                          NUMBER(17,5)     NULL,
 cod_13                          VARCHAR(8)       NULL,
 des_13                          VARCHAR(10)      NULL,
 ges_13                          VARCHAR(1)       NULL,
 val_13                          NUMBER(17,5)     NULL,
 cod_14                          VARCHAR(8)       NULL,
 des_14                          VARCHAR(10)      NULL,
 ges_14                          VARCHAR(1)       NULL,
 val_14                          NUMBER(17,5)     NULL,
 cod_15                          VARCHAR(8)       NULL,
 des_15                          VARCHAR(10)      NULL,
 ges_15                          VARCHAR(1)       NULL,
 val_15                          NUMBER(17,5)     NULL,
 cod_16                          VARCHAR(8)       NULL,
 des_16                          VARCHAR(10)      NULL,
 ges_16                          VARCHAR(1)       NULL,
 val_16                          NUMBER(17,5)     NULL,
 cod_17                          VARCHAR(8)       NULL,
 des_17                          VARCHAR(10)      NULL,
 ges_17                          VARCHAR(1)       NULL,
 val_17                          NUMBER(17,5)     NULL,
 cod_18                          VARCHAR(8)       NULL,
 des_18                          VARCHAR(10)      NULL,
 ges_18                          VARCHAR(1)       NULL,
 val_18                          NUMBER(17,5)     NULL,
 cod_19                          VARCHAR(8)       NULL,
 des_19                          VARCHAR(10)      NULL,
 ges_19                          VARCHAR(1)       NULL,
 val_19                          NUMBER(17,5)     NULL,
 cod_20                          VARCHAR(8)       NULL,
 des_20                          VARCHAR(10)      NULL,
 ges_20                          VARCHAR(1)       NULL,
 val_20                          NUMBER(17,5)     NULL
)
;


REM
REM 
REM
PROMPT
PROMPT Creating Index CAPA_IK on Table CALCOLO_PROSPETTI_PRESENZA
CREATE INDEX CAPA_IK ON CALCOLO_PROSPETTI_PRESENZA
(
      prenotazione )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index CAPA_IK2 on Table CALCOLO_PROSPETTI_PRESENZA
CREATE INDEX CAPA_IK2 ON CALCOLO_PROSPETTI_PRESENZA
(
      prpa_codice )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index CAPA_IK3 on Table CALCOLO_PROSPETTI_PRESENZA
CREATE INDEX CAPA_IK3 ON CALCOLO_PROSPETTI_PRESENZA
(
      rain_ci )
PCTFREE  10
;

REM
REM  End of command file
REM
