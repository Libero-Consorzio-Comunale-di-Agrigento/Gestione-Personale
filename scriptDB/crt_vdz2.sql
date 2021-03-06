REM  Objects being generated in this file are:-
REM TABLE
REM      VERSAMENTI_DMA_Z2
REM INDEX
REM      VDZ2_PK ON 

REM
REM      VDZ2 - Estremi Versamento / pagamento per Totali Z2 Denuncia DMA
REM
PROMPT 
PROMPT Creating Table VERSAMENTI_DMA_Z2

CREATE TABLE VERSAMENTI_DMA_Z2
( VDZ2_ID               NUMBER(10)      NOT NULL
, ANNO                  NUMBER(4)	NOT NULL
, MESE                  NUMBER(2)	NOT NULL
, CF_DIC                VARCHAR2(16)	NOT NULL
, CASSA                 VARCHAR2(1)	NOT NULL
, RIFERIMENTO           NUMBER(6)       NOT NULL
, VERSAMENTO            VARCHAR2(2)	NOT NULL	
, DATA_VERSAMENTO       DATE
, PAGAMENTO             VARCHAR2(1)
, CONTO_CORRENTE        VARCHAR2(16)
, ESTREMI_PAGAMENTO     VARCHAR2(16) 
, UTENTE                VARCHAR2 (8) 
, TIPO_AGG              VARCHAR2 (1)
, DATA_AGG              DATE
);

COMMENT ON TABLE VERSAMENTI_DMA_Z2
    IS 'VDZ2 - Estremi Versamento / pagamento per Totali Z2 Denuncia DMA';

REM 
REM
PROMPT
PROMPT Creating Index VDZ2_PK on Table VERSAMENTI_DMA_Z2
CREATE UNIQUE INDEX VDZ2_PK ON 
  VERSAMENTI_DMA_Z2( VDZ2_ID);

PROMPT
PROMPT Creating Index VDZ2_IK on Table VERSAMENTI_DMA_Z2
CREATE INDEX VDZ2_IK ON 
  VERSAMENTI_DMA_Z2( ANNO, MESE, CF_DIC, CASSA, RIFERIMENTO, VERSAMENTO, DATA_VERSAMENTO)
; 

