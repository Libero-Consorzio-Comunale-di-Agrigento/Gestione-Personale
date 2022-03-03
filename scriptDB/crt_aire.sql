REM  Objects being generated in this file are:-
REM TABLE
REM      ADDIZIONALE_IRPEF_REGIONALE
REM INDEX
REM      AIRE_PK
REM      AIRE_IK

REM
REM    AICO - Addizionale IRPEF Regionale 
REM
PROMPT 
PROMPT Creating Table  ADDIZIONALE_IRPEF_REGIONALE
CREATE TABLE addizionale_irpef_regionale
(
 cod_regione                     NUMBER(3)    NOT NULL,
 dal                             DATE         NOT NULL,
 al                              DATE                 ,
 aliquota                        NUMBER(7,4)      NULL,
 aliquota_cond1                  NUMBER(7,4)      NULL,
 aliquota_cond2                  NUMBER(7,4)      NULL,
 scaglione                       NUMBER(15,5) NOT NULL,
 imposta                         NUMBER(15,5)     NULL,
 regione                         number(2)
)
;
REM
REM 
REM
PROMPT
PROMPT Creating Unique Index AIRE_PK on Table ADDIZIONALE_IRPEF_REGIONALE
CREATE UNIQUE INDEX AIRE_PK ON ADDIZIONALE_IRPEF_REGIONALE
( cod_regione
 , dal
 , scaglione )
;
REM
REM 
REM
PROMPT
PROMPT Creating Index AIRE_IK on Table ADDIZIONALE_IRPEF_REGIONALE
CREATE INDEX AIRE_IK ON ADDIZIONALE_IRPEF_REGIONALE
( cod_regione )
;