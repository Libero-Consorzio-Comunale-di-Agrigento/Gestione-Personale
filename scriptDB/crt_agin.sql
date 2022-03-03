REM
SET SCAN OFF
REM  Objects being generated in this file are:
REM TABLE
REM     AGENTI_INFORTUNIO   

REM
REM     AGIN - Agenti di Infortunio per Denuncia
REM
PROMPT 
PROMPT Creating Table AGENTI_INFORTUNIO

CREATE TABLE AGENTI_INFORTUNIO 
( CAUSA        VARCHAR2 (6)  NOT NULL, 
  AGENTE       VARCHAR2 (6)  NOT NULL, 
  DESCRIZIONE  VARCHAR2 (120)  NOT NULL, 
  SEQUENZA     NUMBER(4), 
  STATISTICO   VARCHAR2 (6)
);

COMMENT ON TABLE agenti_infortunio
    IS 'AGIN - Agenti di Infortunio per Denuncia';  

REM 
REM
PROMPT
PROMPT Creating Index AGIN_PK on Table AGENTI_INFORTUNIO
CREATE UNIQUE INDEX AGIN_PK ON AGENTI_INFORTUNIO
(causa,agente )
;
REM
REM  End of command file
REM
