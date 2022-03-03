start crt_asfi.sql
start crp_PECCASFI.sql
start crp_PECSMFA2.sql

-- Nuova voce di menu PECCASFI
delete from a_voci_menu where voce_menu = 'PECCASFI'; 
delete from a_passi_proc where voce_menu = 'PECCASFI';
delete from a_selezioni where voce_menu = 'PECCASFI'; 
delete from a_menu where voce_menu = 'PECCASFI' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCASFI','P00','CASFI','Caricamento Archivio Ass. Fiscale','F','D','ACAPARPR','',1,'P_ARDE_Q');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCASFI','1','Verifica Scadenza denuncia','Q','CHK_SCAD','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCASFI','2','Caricamento Archivio Ass. Fiscale','Q','PECCASFI','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCASFI','3','Verifica presenza errori','Q','CHK_ERR','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCASFI','91','Stampa Segnalazioni Anomalie','R','ACARAPPR','','PECCARFI','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCASFI','92','Cancellazione Segnalazioni','Q','ACACANRP','','','N');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO_DENUNCIA','PECCASFI','0','Tipo Denuncia','10','U','N','770','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCASFI','1','Anno','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_GESTIONE','PECCASFI','2','Gestione ....:','4','U','S','%','','GEST','1','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO','PECCASFI','3','Archiviazione:','1','U','S','T','P_TIPO','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECCASFI','4','Singolo Individuo : Codice','8','N','N','','','RAIN','1','1');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1006751','1013850','PECCASFI','8',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1006751','1013850','PECCASFI','8',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1006751','1013850','PECCASFI','8',''); 

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCARFI','SEGNALAZIONI ARCHIVIAZIONE FISCALE','U','U','A_C','N','N','S'); 

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_ARDE_Q','1','PREN','P','Prenot.','','ACAEPRPA','*',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_ARDE_Q','2','GEST','G','Gestioni','','PGMEGEST','',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_ARDE_Q','3','RAIN','I','Individui','','P00RANAG','','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_TIPO','I','','Non altera Individui Inseriti'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_TIPO','P','','Parziale (non altera Inseriti/Variati)');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_TIPO','S','','Singolo Individuo'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_TIPO','T','','Totale');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_TIPO','V','','Non altera Individui Variati');


-- Nuova form PECAASFI
delete from a_voci_menu where voce_menu = 'PECAASFI';
delete from a_menu where voce_menu = 'PECAASFI' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECAASFI','P00','AASFI','Agg. Archivio Assistenza Fiscale','F','F','PECAASFI','',1,'P_RIRE');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1006751','1013851','PECAASFI','9',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1006751','1013851','PECAASFI','9',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1006751','1013851','PECAASFI','9',''); 
