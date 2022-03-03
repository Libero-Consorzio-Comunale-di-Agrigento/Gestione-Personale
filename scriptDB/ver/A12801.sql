delete from a_passi_proc where voce_menu = 'PECCARST';

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARST','1','Caricamento Archivio Stat. Trimestrali','Q','PECCARST','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARST','91','Stampa Anomalie Archiviazione Trim.','R','PECSMTTA','','PECSMTTA','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCARST','92','Cancellazione appoggio stampe','Q','ACACANAS','','','N');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSMTTA','LISTA ANOMALIE CARICAMENTO STATISTICHE MINISTERO DEL TESORO','U','U','A_C','N','N','S');

delete from a_selezioni where voce_menu = 'PECCARST';

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCARST','1','Elaborazione Anno:','4','N','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MESE_DA','PECCARST','2',' Mese Da:','2','N','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MESE_A','PECCARST','3',' Mese A:','2','N','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ELAB','PECCARST','4','Tipo Elaborazione:','1','U','S','T','P_CARSM','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_COMPETENZA','PECCARST','5','Competenza Economica:','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECCARST','6','Gestione:','4','U','S','%','','GEST','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECCARST','7','Archiviazione','1','U','S','T','P_TIPO_CARSM','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECCARST','8','Codice individuale','8','N','N','','','RAIN','1','1');  

start crp_peccarst.sql