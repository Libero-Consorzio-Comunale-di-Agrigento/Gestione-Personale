start crp_cursore_fiscale_05.sql
start crp_peccud05.sql

-- Abilitazione del sotto-menu "Modelli Storici"
delete from a_voci_menu where voce_menu = 'PECECFFS';   
delete from a_menu where voce_menu = 'PECECFFS' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECECFFS','P00','ECFFS','Modelli Storici','N','M','','',1,'');   

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000555','1013825','PECECFFS','60','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000555','1013825','PECECFFS','60','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000555','1013825','PECECFFS','60','');

-- Abilitazione della voce di menu del CUD 2005 - redditi 2004
delete from a_voci_menu where voce_menu = 'PECCUD05';   
delete from a_passi_proc where voce_menu = 'PECCUD05';  
delete from a_selezioni where voce_menu = 'PECCUD05';   
delete from a_menu where voce_menu = 'PECCUD05' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PECCUD05');  

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECCUD05','P00','CUD05','Stampa Modello CUD/2005 - Redditi 2004','F','D','ACAPARPR','FINE_ANNO',1,'P_INDI_S');   

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCUD05','1','Estrazione dati per Stampa CUD','Q','PECCUD05','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCUD05','2','Stampa Modulo Certificazione Redditi','R','PECCUD05','','PECCUD05','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCUD05','3','Stampa Informativa CUD','R','PECSIC05','','PECSIC05','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCUD05','4','Stampa Allegato Annotazioni','R','PECALC05','','PECALC05','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCUD05','5','Eliminazione registrazioni di lavoro','Q','ACACANAS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECCUD05','6','Pulizia tabella tab_report_fine_anno','Q','PECDTBFA','','','N');   

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCUD05','1','Elaborazione:  Anno','4','N','N','2004','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECCUD05','2','  Tipo','1','U','S','T','P_SM101','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECCUD05','3','Individuale :  Codice','8','N','N','','','RAIN','0','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DAL','PECCUD05','4','Cessazione  :  Dal','10','D','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_AL','PECCUD05','5','  Al','10','D','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_1','PECCUD05','6','Collettiva  :  Raggruppam. 1)','15','U','S','%','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_2','PECCUD05','7',' 2)','15','U','S','%','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_3','PECCUD05','8',' 3)','15','U','S','%','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_4','PECCUD05','9',' 4)','15','U','S','%','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ESTRAZIONE_I','PECCUD05','10','Estrazione Individui:','1','U','N','','P_ESTR_I','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TOTALI','PECCUD05','10','Totali Generali:','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_SERVIZIO','PECCUD05','11','Dettagli INPDAP: Servizio','1','U','S','6','P_CUD_SER','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ARRETRATI','PECCUD05','12','Arretrati','1','U','S','3','P_CUD_ARR','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CONTRATTO','PECCUD05','16','Contratto INPS: Tipo','1','U','S','X','P_CONTRATTO','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_NOTE_1','PECCUD05','18','Note fisse : 1 Riga','70','C','N','','','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_NOTE_2','PECCUD05','19','2 Riga','70','C','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ETICHETTE','PECCUD05','21','Stampa Etichette','1','U','N','','P_SECU3','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DICITURA','PECCUD05','22','Originale/Copia:','1','U','N','','P_DICI','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DOMICILIO','PECCUD05','24','Domicilio','1','U','N','X','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_STAMPA_ENTE','PECCUD05','24','Stampa indirizzo per cessati','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_STAMPA_INQ','PECCUD05','26','Stampa inq. solo per CP Stato','1','U','N','','P_X','','',''); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1013825','1013826','PECCUD05','1',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1013825','1013826','PECCUD05','1',''); 
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1013825','1013826','PECCUD05','1',''); 

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECALC05','ALLEGATO CUD PER ANNOTAZIONI','U','U','A_A','N','N','S');   
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSIC05','Stampa Informativa CUD','U','U','PDF','N','N','S'); 
insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECCUD05','STAMPA MODULO CERTIFICAZIONE REDDITI','U','U','PDF','N','N','S');   

