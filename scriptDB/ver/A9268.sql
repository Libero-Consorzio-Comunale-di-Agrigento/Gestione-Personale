delete from a_voci_menu where voce_menu = 'PECCNOCU';
delete from a_passi_proc where voce_menu = 'PECCNOCU';  
delete from a_selezioni where voce_menu = 'PECCNOCU';
delete from a_menu where voce_menu = 'PECCNOCU' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PECCNOCU','P00','CNOCU','Caricamento Archivio Note CUD','F','D','ACAPARPR','',1,'P_ARDE_Q'); 

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCNOCU','1','Verifica Scadenza denuncia','Q','CHK_SCAD','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCNOCU','2','Caricamento Archivio Note CUD','Q','PECCNOCU','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCNOCU','3','Verifica Presenza Errori','Q','CHK_ERR','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCNOCU','91', 'Stampa Segnalazioni Anomalie', 'R', 'ACARAPPR', '', 'PECCNOCU', 'N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCNOCU','92', 'Cancellazione Segnalazioni', 'Q', 'ACACANRP', '', '', 'N'); 


insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO_DENUNCIA','PECCNOCU','0','Tipo Denuncia','10','U','N','CUD','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANNO','PECCNOCU','1','Anno','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_GESTIONE','PECCNOCU','2','Gestione ....:','4','U','S','%','','GEST','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO','PECCNOCU','3','Archiviazione:','1','U','S','T','P_CARCP','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DAL','PECCNOCU','4','Cessazione: Dal','10','D','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_AL','PECCNOCU','5','Al','10','D','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECCNOCU','6','Singolo Individuo : Codice','8','N','N','','','RAIN','1','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANNO_SFASATO','PECCNOCU','7','Anno Prev. da Nov.(note cas.6)','1','U','N','','P_X','','','');  

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','*','1000555','1013766','PECCNOCU','5',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','AMM','1000555','1013766','PECCNOCU','5',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante)
values ('GP4','PEC','1000555','1013766','PECCNOCU','5',''); 

INSERT INTO A_CATALOGO_STAMPE ( STAMPA, TITOLO, TIPO_PROPRIETA, TIPO_VISURA, CLASSE, STAMPA_BLOCCATA, STAMPA_PROTETTA, SEQUENZIALE ) 
VALUES ( 'PECCNOCU', 'SEGNALAZIONI ARCHIVIAZIONE FISCALE', 'U', 'U', 'A_C', 'N', 'N', 'S'); 

start crp_peccnocu.sql