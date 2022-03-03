delete from a_passi_proc where voce_menu = 'PECCDNAG';  
delete from a_selezioni where voce_menu = 'PECCDNAG';   
delete from a_catalogo_stampe where stampa = 'PECCDNAG';
delete from a_domini_selezioni where dominio = 'P_CDNAG';

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCDNAG','1','Creazione file','Q','PECCDNAG','','','N');     
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCDNAG','2','Creazione file','R','SI4V3WAS','','','N');     
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCDNAG','3','Creazione Prima Stampa','R','PECSAPST','','PECSAPST','N');     
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCDNAG','4','Creazione Seconda Stampa','R','PECSAPST','','PECCDNAG','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCDNAG','5','Cancellazione appoggio stampe','Q','ACACANAS','','','N');      

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('NUM_CARATTERI','PECCDNAG','0','Caratteri per substr','4','C','N','168','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_SUBSTR','PECCDNAG','0','Abilita substr','2','C','N','SI','','','','');     
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_UPPER','PECCDNAG','0','Abilita upper','2','C','N','SI','','','','');       
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('TXTFILE','PECCDNAG','0','Nome file TXT','30','C','N','inail_dna.txt','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DAL','PECCDNAG','1','Dal','10','D','N','','','','','');     
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_AL','PECCDNAG','2','Al','10','D','N','','','','','');       
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_RAPPORTO','PECCDNAG','3','Rapporto','4','U','N','%','','CLRA','0','1');     
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_NON_ISCRITTI','PECCDNAG','4','Non Iscritti','1','U','N','','P_CDNAG','','','');     
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_COD_ACCESSO','PECCDNAG','5','Codice accesso inail','4','C','N','0000','','','',''); 

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCDNAG','Stampa File Assuzioni INAIL','U','U','A_C','N','N','S');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione)
values ('P_CDNAG','S','','Emetti Solo in Stampa Nominativa');       
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione)
values ('P_CDNAG','T','','Emetti nelle Stampe e nel File'); 

start crp_peccdnag.sql
