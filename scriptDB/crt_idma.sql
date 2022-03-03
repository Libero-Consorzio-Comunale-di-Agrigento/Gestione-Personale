REM  Objects being generated in this file are:-
REM TABLE
REM      INDIVIDUI_DMA
REM INDEX
REM      IDMA_PK ON 

REM
REM      IDMA - Individui Denuncia DMA
REM
PROMPT 
PROMPT Creating Table INDIVIDUI_DMA

CREATE TABLE INDIVIDUI_DMA
( ANNO           NUMBER(4)     NOT NULL
, MESE           NUMBER(2)     NOT NULL
, CF_DIC         VARCHAR2(16)  NOT NULL
, CF_APP         VARCHAR2(16)  NOT NULL
, CF_VERS        VARCHAR2(16)  NOT NULL
, CI             NUMBER(8)     NOT NULL
, NR_FILE        NUMBER(2)     
);

COMMENT ON TABLE INDIVIDUI_DMA
    IS 'IDMA - Archivio Individui per Denuncia DMA';

REM 
REM
PROMPT
PROMPT Creating Index IDMA_PK on Table INDIVIDUI_DMA
CREATE UNIQUE INDEX IDMA_PK ON 
  INDIVIDUI_DMA( ANNO, MESE, CF_DIC, CF_APP, CF_VERS, CI, NR_FILE)
; 
