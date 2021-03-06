REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      RIFERIMENTO_FINE_ANNO
REM INDEX
REM      RIFA_PK

REM
REM     RIFA - Dati di riferimento per le elaborazioni di Fine Anno
REM
PROMPT 
PROMPT Creating Table RIFERIMENTO_FINE_ANNO
CREATE TABLE riferimento_fine_anno(
 rifa_id                         VARCHAR(4)       NOT NULL,
 anno                            NUMBER(4,0)      NOT NULL,
 data                            DATE             NOT NULL,
 firma                           VARCHAR(50)      NULL,
 tipo_denuncia                   VARCHAR(1)       NULL
)
;

COMMENT ON TABLE riferimento_fine_anno
    IS 'RIFA - Dati di riferimento per le elaborazioni di Fine Anno';


REM
REM 
REM
PROMPT
PROMPT Creating Index RIFA_PK on Table RIFERIMENTO_FINE_ANNO
CREATE UNIQUE INDEX RIFA_PK ON RIFERIMENTO_FINE_ANNO
(
      rifa_id )
PCTFREE  10
;

REM
REM  End of command file
REM
