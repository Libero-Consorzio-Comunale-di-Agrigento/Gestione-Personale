delete from a_selezioni where voce_menu = 'PECCDNAG';

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
values ('P_TRATTA_ASSENZE','PECCDNAG','5','Tratta Assenze','1','U','N','X','P_X','','','');     

start crp_peccdnag.sql