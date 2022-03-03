-- Parametri di selezione per Voce di menu CUD 2007 

delete from a_selezioni where voce_menu = 'PECSMCU6'; 

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANNO','PECSMCU6','1','Elaborazione:Anno','4','N','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO','PECSMCU6','2','Tipo','1','U','S','T','P_SM101','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECSMCU6','3','Individuale :Codice','8','N','N','','','RAIN','0','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DAL','PECSMCU6','4','Cessazione:Dal','10','D','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_AL','PECSMCU6','5','Al','10','D','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ESTRAZIONE_I','PECSMCU6','6','Estrazione Individui:','1','U','N','','P_ESTR_I','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_1','PECSMCU6','7','Collettiva:Raggruppam. 1)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_2','PECSMCU6','8',' 2)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_3','PECSMCU6','9',' 3)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_4','PECSMCU6','10',' 4)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TOTALI','PECSMCU6','11','Totali Generali:','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO_DESFORMAT','PECSMCU6','12','Tipo Stampa','4','U','S','','P_SMCU6','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TERZA_PAGINA','PECSMCU6','13','Stampa Terza Pagina','1','U','S','','D_TERZA_PAGINA','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ORDINAMENTO','PECSMCU6','14','Ordinamento come modello CUD','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ETICHETTE','PECSMCU6','15','Stampa Etichette','1','U','N','','P_SECU3','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DICITURA','PECSMCU6','16','Originale/Copia:','1','U','N','','P_DICI','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DOMICILIO','PECSMCU6','17','Domicilio','1','U','N','X','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_STAMPA_ENTE','PECSMCU6','18','Stampa indirizzo per cessati','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_PREVIDENZIALE','PECSMCU6','19','Non stampa dati Previdenziali','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DMA_ASS','PECSMCU6','20','Suddivisione DMA per Ass.','1','U','N','X','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_NOTE_1','PECSMCU6','21','Note fisse : 1 Riga','70','C','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_NOTE_2','PECSMCU6','22','2 Riga','70','C','N','','','','','');

-- Passi procedurali PECSMCU6

delete from a_passi_proc where voce_menu = 'PECSMCU6';  

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','1','Estrazione dati per Stampa CUD','Q','PECSMCUD','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','2','Lista Anomalie CUD','R','PECANCUD','','PECANCUD','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','3','Stampa Modulo Certificazione Redditi','R','PECSMCU6','P_TIPO_DESFORMAT','PECSMCU6','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','4','Controllo per Stampa Terza Pagina','Q','P00UPDPP','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','5','Stampa Terza Pagina CUD','R','PECSMCU3','P_TIPO_DESFORMAT','PECSMCU3','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','6','Stampa Allegato Annotazioni','R','PECALCUD','','PECALCUD','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','7','Stampa Lista Firme','R','PECLMCUD','','PECLMCUD','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','8','Controllo per Stampa Etichette','Q','P00UPDPP','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','9','Stampa Etichette CUD','R','PECSECU4','','PECSECU4','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','10','Controllo per Stampa Etichette','Q','P00UPDPP','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','11','Stampa Etichette CUD','R','PECSECU3','','PECSECU3','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','12','Conteggio moduli','Q','PECCUDEP','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','13','Stampa Lista Nominativa nr. pagine','R','PECSAPST','','PECSCUEP','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','14','Stampa Lista Dipendenti con piu moduli','R','PECSAPST','','PECSCUEE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','15','Cancellazione registrazioni di lavoro','Q','ACACANAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','16','Pulizia tabella tab_report_fine_anno','Q','PECDTBFA','','','N'); 

start crp_p00updpp.sql
