start crp_pecxaggp.sql

delete from a_voci_menu where voce_menu = 'PECXAGGP';  
delete from a_passi_proc where voce_menu = 'PECXAGGP';
delete from a_domini_selezioni where dominio = 'P_S_T';
delete from a_selezioni where voce_menu = 'PECXAGGP';  
delete from a_menu where voce_menu = 'PECXAGGP' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa = 'PECSAPST';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECXAGGP','P00','XAGGP','Agg. Automatico Periodi Retributivi','F','D','ACAPARPR','',1,'P_CADMI');  

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECXAGGP','1','Agg. Automatico Periodi Retributivi','Q','PECXAGGP','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECXAGGP','2','Stampa Dipendenti Trattati','R','PECSAPST','','PECSAPST','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECXAGGP','3','Cancellazione appoggio stampe','Q','ACACANAS','','','N');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_S_T','S','','Singolo Individuo');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_S_T','T','','Totale'); 

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_INIZIO','PECXAGGP','1','Inizio Periodo da Trattare','10','D','N','','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FINE','PECXAGGP','2','Fine Periodo da Trattare','10','D','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECXAGGP','3','Tipo Elaborazione :','1','U','S','T','P_S_T','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECXAGGP','4','Singolo Individuo: Codice','8','N','N','','','RAIN','0','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECXAGGP','5','Gestione :','4','U','N','%','','GEST','1','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_RAPPORTO','PECXAGGP','6','Rapporto :','4','U','N','%','','CLRA','0','1');    

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013748','1013772','PECXAGGP','4',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013748','1013772','PECXAGGP','4',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013748','1013772','PECXAGGP','4',''); 

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSAPST','Stampa Elenco','U','U','A_C','N','N','S');    

