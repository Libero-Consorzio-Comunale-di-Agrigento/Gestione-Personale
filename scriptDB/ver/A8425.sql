delete from a_voci_menu where voce_menu = 'PECLVOEC';   
delete from a_passi_proc where voce_menu = 'PECLVOEC';  
delete from a_selezioni where voce_menu = 'PECLVOEC';   
delete from a_domini_selezioni where dominio in ('CLASSE_LVOEC','TIPO_LVOEC','P_ORD_VOCI');
delete from a_catalogo_stampe where stampa = 'PECLVOEC'; 
delete from a_menu where voce_menu = 'PECLVOEC' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECLVOEC','P00','LVOEC','Lista Voci Economiche','F','D','ACAPARPR','',1,'A_PARA');   

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECLVOEC','1','Lista Voci Economiche','R','PECLVOEC','','PECLVOEC','N');  

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CODICE_VOCE','PECLVOEC','1','Codice Voce','10','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CLASSE','PECLVOEC','2','Classe','1','U','S','%','CLASSE_LVOEC','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECLVOEC','3','Tipo','1','U','S','%','TIPO_LVOEC','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ORDINE','PECLVOEC','4','Ordinamento','1','U','S','S','P_ORD_VOCI','','','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('CLASSE_LVOEC','%','','');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('CLASSE_LVOEC','A','','');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('CLASSE_LVOEC','B','','');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('CLASSE_LVOEC','C','','');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('CLASSE_LVOEC','I','','');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('CLASSE_LVOEC','P','','');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('CLASSE_LVOEC','Q','','');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('CLASSE_LVOEC','R','','');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('CLASSE_LVOEC','T','','');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('CLASSE_LVOEC','V','','');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_ORD_VOCI','C','','Ordinamento per Codice Voce economica');   
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_ORD_VOCI','S','','Ordinamento per Sequenza di esposizione'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('TIPO_LVOEC','%','','');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('TIPO_LVOEC','C','','');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('TIPO_LVOEC','F','','');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('TIPO_LVOEC','Q','','');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('TIPO_LVOEC','T','','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECLVOEC','LISTA VOCI ECONOMICHE','U','U','A_C','N','N','S');  

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000467','1000603','PECLVOEC','10','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000467','1000603','PECLVOEC','10','');  
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000467','1000603','PECLVOEC','10','');  

