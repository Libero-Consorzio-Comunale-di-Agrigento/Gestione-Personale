start crp_peccarfi.sql
start crp_PECXAC7B.sql

-- Nuova voce di menù estemporanea per memorizzazione casella 7 Bis c32 di denuncia fiscale

delete from a_voci_menu where voce_menu = 'PECXAC7B'; 
delete from a_passi_proc where voce_menu = 'PECXAC7B';
delete from a_selezioni where voce_menu = 'PECXAC7B';
delete from a_menu where voce_menu = 'PECXAC7B' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECXAC7B','P00','XAC7B','Archiviazione Acconto Add.Com. 2007','F','D','ACAPARPR','',1,'A_PARA');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECXAC7B','1','Verifica scadenza denuncia','Q','CHK_SCAD','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECXAC7B','2','Archiviazione Acconto Add.Com. 2007','Q','PECXAC7B','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECXAC7B','3','Verifica presenza errori','Q','CHK_ERR','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECXAC7B','91','Stampa Segnalazioni Anomalie','R','ACARAPPR','','PECCARFI','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECXAC7B','92','Cancellazione Segnalazioni','Q','ACACANRP','','','N');


insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_DENUNCIA','PECXAC7B','0','Tipo Denuncia','10','U','N','CUD','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECXAC7B','1','Anno ....:','4','N','N','2006','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECXAC7B','2','Archiviazione:','1','U','S','T','P_S_T','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECXAC7B','3','Singolo Individuo : Codice','8','N','N','','','RAIN','0','1');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000555','1013849','PECXAC7B','99','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000555','1013849','PECXAC7B','99','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000555','1013849','PECXAC7B','99','');


