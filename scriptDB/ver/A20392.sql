-- Nuova voce di menù estemporanea per memorizzazione casella 61 eredi

delete from a_voci_menu where voce_menu = 'PECXAC61'; 
delete from a_passi_proc where voce_menu = 'PECXAC61';
delete from a_selezioni where voce_menu = 'PECXAC61';
delete from a_menu where voce_menu = 'PECXAC61' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECXAC61','P00','XAC61','Agg. Anno Apertura Succ. cas.61 770/07','F','D','ACAPARPR','',1,'A_PARA');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECXAC61','1','Verifica scadenza denuncia','Q','CHK_SCAD','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECXAC61','2','Agg. Anno Apertura Succ. cas.61 770/07','Q','PECXAC61','','','N'); 

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_DENUNCIA','PECXAC61','0','Tipo Denuncia','10','U','N','770','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECXAC61','1','Anno ....:','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECXAC61','2','Archiviazione:','1','U','S','T','P_S_T','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECXAC61','3','Singolo Individuo : Codice','8','N','N','','','RAIN','0','1');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1005912','1013814','PECXAC61','13','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1005912','1013814','PECXAC61','13','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1005912','1013814','PECXAC61','13','');

start crp_pecxac61.sql
start crp_peccarfi.sql