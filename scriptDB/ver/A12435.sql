start crp_pecxac62.sql
start crp_pecsmfa1.sql

delete from a_voci_menu where voce_menu = 'PECXAC62';  
delete from a_passi_proc where voce_menu = 'PECXAC62'; 
delete from a_selezioni where voce_menu = 'PECXAC62';  
delete from a_menu where voce_menu = 'PECXAC62' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECXAC62','P00','XAC62','Agg. Qualifica Denuncia Inpdap - C62/770','F','D','ACAPARPR','',1,'P_ARDE_Q');   

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECXAC62','1','Verifica scadenza denuncia','Q','CHK_SCAD','','','N');    
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECXAC62','2','Agg. Qualifica Denuncia Inpdap - C62/770','Q','PECXAC62','','','N');    
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECXAC62','3','Verifica Presenza Errori','Q','CHK_ERR','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECXAC62','91','Stampa Segnalazioni Anomalie','R','ACARAPPR','','PECCARDP','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECXAC62','92','Cancellazione Segnalazioni','Q','ACACANRP','','','N');  

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_DENUNCIA','PECXAC62','0','Tipo Denuncia','10','U','N','770','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECXAC62','1','Anno ....:','4','N','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECXAC62','2','Gestione ....:','4','U','S','%','','GEST','1','1');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_PREVIDENZA','PECXAC62','3','Previdenza ..:','6','U','S','CP%','P_CP_PREV','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECXAC62','4','Archiviazione:','1','U','S','T','P_S_T','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECXAC62','5','Singolo Individuo : Codice','8','N','N','','','RAIN','0','1');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MOD','PECXAC62','6','Modifica solo qual. nulle','1','U','N','X','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_COMPARTO','PECXAC62','7','Codice del Comparto','2','U','S','','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SOTTOCOMPARTO','PECXAC62','8','Codice del Sottocomparto','2','U','S','','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO_SFASATO','PECXAC62','9','Anno Previdenziale da Novembre','1','U','N','','P_X','','',''); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1005912','1013814','PECXAC62','13','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1005912','1013814','PECXAC62','13','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1005912','1013814','PECXAC62','13','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_S_T','S','','Singolo Individuo');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_S_T','T','','Totale'); 
