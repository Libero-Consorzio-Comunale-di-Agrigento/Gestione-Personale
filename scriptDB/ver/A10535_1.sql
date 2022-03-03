alter table denuncia_dma modify PERC_PART_TIME NUMBER(5,2);

insert into a_catalogo_stampe 
       (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSTDMA','TOTALI DENUNCIA DMA','U','U','A_A','N','N','S'); 

INSERT INTO A_CATALOGO_STAMPE 
( STAMPA, TITOLO, TIPO_PROPRIETA, TIPO_VISURA, CLASSE,STAMPA_BLOCCATA, STAMPA_PROTETTA, SEQUENZIALE ) 
VALUES ( 'PECLSDMA', 'Lista Segnalazioni Errore DMA', 'U', 'U', 'A_C', 'N', 'N', 'S'); 

delete from a_passi_proc where voce_menu = 'PECSMDMA';
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMDMA','1','Elaborazione Supporto Magnetico DMA','Q','PECSMDMA','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMDMA','2','Elaborazione Supporto Magnetico DMA','Q','PECCFDMA','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMDMA','3','Elaborazione Supporto Magnetico DMA','R','SI4V3WAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMDMA','4','Elaborazione Supporto Magnetico DMA','R','PECSTDMA','','PECSTDMA','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMDMA','5','Elaborazione Supporto Magnetico DMA','Q','ACACANAS','','','N');

start crp_cursore_dma.sql
start crp_peccadma.sql
start crp_pecsmdma.sql
