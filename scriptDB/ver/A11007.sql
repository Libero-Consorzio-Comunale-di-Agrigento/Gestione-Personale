alter table denuncia_dma
add gestione_app varchar2(8);

INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P00113', 'La Provenienza non pur essere uguale alla Gestione', NULL, NULL, NULL); 

start crp_pecsmdma.sql
start crp_peccfdma.sql