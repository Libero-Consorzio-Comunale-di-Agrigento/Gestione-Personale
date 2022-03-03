DROP INDEX IDMA_PK;
DROP INDEX TOZ1_PK;

alter table individui_dma 
  add cf_vers varchar2(16);

update individui_dma 
   set cf_vers = cf_dic
 where cf_vers is null;
update individui_dma 
   set cf_app = cf_dic
 where cf_app is null;

alter table individui_dma 
modify cf_vers varchar2(16) not null;
alter table individui_dma 
modify cf_app varchar2(16) not null;

alter table totali_dma_z1 
  add cf_vers varchar2(16);

update totali_dma_z1  
   set cf_vers = cf_dic
 where cf_vers is null;
update totali_dma_z1 
   set cf_app = cf_dic
 where cf_app is null;

alter table totali_dma_z1
modify cf_vers varchar2(16) not null;
alter table totali_dma_z1
modify cf_app varchar2(16) not null;

CREATE UNIQUE INDEX IDMA_PK ON 
  INDIVIDUI_DMA( ANNO, MESE, CF_DIC, CF_APP, CF_VERS, CI, NR_FILE)
; 

CREATE UNIQUE INDEX TOZ1_PK ON 
  TOTALI_DMA_Z1( ANNO, MESE, CF_DIC, CF_APP, CF_VERS, CASSA, TIPO_ALIQUOTA, RIFERIMENTO, NR_FILE)
; 

start crf_ddma_tma.sql
start crf_ddmq_tma.sql
start crp_pecctdma.sql
start crp_pecsmdma.sql
