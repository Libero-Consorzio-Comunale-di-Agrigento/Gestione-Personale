REM  Objects being generated in this file are:-
REM TABLE
REM      DENUNCIA_DMA_QUOTE
REM INDEX
REM      DDMQ_GEST_FK
REM      DDMQ_PK
REM      DDMQ_RAIN_FK

REM
REM      DDMQ - Denuncia DMA dati per sezione F1 "Quote di Ammortamento"
REM
PROMPT 
PROMPT Creating Table DENUNCIA_DMA_QUOTE
CREATE TABLE denuncia_dma_quote(
ddmq_id     number(10)   not null,
anno		number(4)	 not null,
mese 		number(2)	 not null,
riferimento	number(6)    null,	
gestione	varchar2(8)  null,
ci		number(8) 	 not null,
cassa		varchar2(1)  null,
tipo_amm	varchar2(2)  null,	
scadenza	date         null,
importo	number(12,2) null,
sanzione	number(12,2) null,
operazione	varchar2(1)  null,	
cf_versante	number(11)   null,
utente      varchar2(8)  null,
tipo_agg	varchar2(1)  null,
data_agg	date         null
)
--STORAGE  (
--  INITIAL   &1DIMx2500
--  NEXT   &1DIMx1250
--  MINEXTENTS  1
--  MAXEXTENTS  121 
--  PCTINCREASE  0
--  )
;

COMMENT ON TABLE denuncia_dma_quote
    IS 'DDMQ - Dati relativi alla sezione F1 - Denuncia DMA';


REM
REM 
REM
PROMPT
PROMPT Creating Index DDMQ_PK on Table DENUNCIA_DMA_QUOTE
CREATE INDEX DDMQ_PK ON DENUNCIA_DMA_QUOTE
(      ddmq_id )
PCTFREE  10
;

REM
REM 
REM
PROMPT
PROMPT Creating Index DDMQ_GEST_FK on Table DENUNCIA_DMA_QUOTE
CREATE INDEX DDMQ_GEST_FK ON DENUNCIA_DMA_QUOTE
(      gestione )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index DDMQ_IK on Table DENUNCIA_DMA_QUOTE
CREATE INDEX DDMQ_IK ON DENUNCIA_DMA_QUOTE
(     anno,
      mese,
      ci ,
      gestione)
PCTFREE  10
-- STORAGE  (
--  INITIAL   &1DIMx1500     
--  NEXT   &1DIMx750    
--  MINEXTENTS  1
--  MAXEXTENTS  121 
--  PCTINCREASE  0
--  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index DDMQ_RAIN_FK on Table DENUNCIA_DMA_QUOTE
CREATE INDEX DDMQ_RAIN_FK ON DENUNCIA_DMA_QUOTE
(      ci )
PCTFREE  10
;



REM
REM  End of command file
REM
