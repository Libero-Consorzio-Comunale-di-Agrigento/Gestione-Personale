REM
REM This ORACLE V6 RDBMS command file was generated by CASE*Dictionary
REM                            on  08-SEP-93
REM
REM For application system PEC version 1
REM
SET SCAN OFF

REM  Objects being generated in this file are:-
REM TABLE
REM      VOCI_CONTABILI
REM INDEX
REM      VOCO_PK
REM      VOCO_UK
REM      VOCO_UK2
REM      VOCO_UK3
REM      VOCO_UK4
REM      VOCO_UK5
REM      VOCO_UK6

REM
REM     VOCO - Sub-classificazione contabile delle voci economiche
REM
PROMPT 
PROMPT Creating Table VOCI_CONTABILI
CREATE TABLE voci_contabili(
 voce                            VARCHAR(10)      NOT NULL,
 sub                             VARCHAR(2)       NOT NULL,
 alias                           VARCHAR(10)      NOT NULL,
 alias_al1                       VARCHAR(10)      NULL,
 alias_al2                       VARCHAR(10)      NULL,
 titolo                          VARCHAR(30)      NOT NULL,
 titolo_al1                      VARCHAR(30)      NULL,
 titolo_al2                      VARCHAR(30)      NULL,
 dal                             DATE             NULL,
 al                              DATE             NULL,
 note                            VARCHAR(240)     NULL
)
;

COMMENT ON TABLE voci_contabili
    IS 'VOCO - Sub-classificazione contabile delle voci economiche';


REM
REM 
REM
PROMPT
PROMPT Creating Index VOCO_PK on Table VOCI_CONTABILI
CREATE UNIQUE INDEX VOCO_PK ON VOCI_CONTABILI
(
      voce ,
      sub )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index VOCO_UK on Table VOCI_CONTABILI
CREATE UNIQUE INDEX VOCO_UK ON VOCI_CONTABILI
(
      alias )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index VOCO_UK2 on Table VOCI_CONTABILI
CREATE UNIQUE INDEX VOCO_UK2 ON VOCI_CONTABILI
(
      alias_al1 )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index VOCO_UK3 on Table VOCI_CONTABILI
CREATE UNIQUE INDEX VOCO_UK3 ON VOCI_CONTABILI
(
      alias_al2 )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index VOCO_UK4 on Table VOCI_CONTABILI
CREATE UNIQUE INDEX VOCO_UK4 ON VOCI_CONTABILI
(
      titolo )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index VOCO_UK5 on Table VOCI_CONTABILI
CREATE UNIQUE INDEX VOCO_UK5 ON VOCI_CONTABILI
(
      titolo_al1 )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index VOCO_UK6 on Table VOCI_CONTABILI
CREATE UNIQUE INDEX VOCO_UK6 ON VOCI_CONTABILI
(
      titolo_al2 )
PCTFREE  10
;

REM
REM  End of command file
REM
