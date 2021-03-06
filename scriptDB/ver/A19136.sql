-- contiene anche attivita 16555, 19252 , 19276 e  19138

-- Parametri di selezione per Voce di menu CUD 2007 

delete from a_menu where voce_menu = 'PECSMCUD'; 
delete from a_menu where voce_menu = 'PECSMCU4'; 

delete from a_selezioni where voce_menu = 'PECSMCU6'; 

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_TIPO_DESFORMAT', 'PECSMCU6', 0, 'Tipo Stampa', NULL, NULL, 4, 'U', 'S', NULL, 'P_SMCU6', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_TERZA_PAGINA', 'PECSMCU6', 0, 'Stampa Terza Pagina', NULL, NULL, 1, 'U', 'S', NULL, 'D_TERZA_PAGINA', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_ANNO', 'PECSMCU6', 1, 'Elaborazione:Anno', NULL, NULL, 4, 'N', 'N', NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_TIPO', 'PECSMCU6', 2, 'Tipo', NULL, NULL, 1, 'U', 'S', 'T', 'P_SM101', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_CI', 'PECSMCU6', 3, 'Individuale :Codice', NULL, NULL, 8, 'N', 'N', NULL, NULL, 'RAIN', 0, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_DAL', 'PECSMCU6', 4, 'Cessazione:Dal', NULL, NULL, 10, 'D', 'N', NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_AL', 'PECSMCU6', 5, 'Al', NULL, NULL, 10, 'D', 'N', NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_ESTRAZIONE_I', 'PECSMCU6', 6, 'Estrazione Individui:', NULL, NULL, 1, 'U', 'N', NULL, 'P_ESTR_I', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_FILTRO_1', 'PECSMCU6', 7, 'Collettiva:Raggruppam. 1)', NULL, NULL, 15, 'U', 'S', '%', NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_FILTRO_2', 'PECSMCU6', 8, ' 2)', NULL, NULL, 15, 'U', 'S', '%', NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_FILTRO_3', 'PECSMCU6', 9, ' 3)', NULL, NULL, 15, 'U', 'S', '%', NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_FILTRO_4', 'PECSMCU6', 10, ' 4)', NULL, NULL, 15, 'U', 'S', '%', NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_TOTALI', 'PECSMCU6', 11, 'Totali Generali:', NULL, NULL, 1, 'U', 'N', NULL, 'P_X', NULL, NULL, NULL);
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_ORDINAMENTO', 'PECSMCU6', 14, 'Ordinamento come modello CUD', NULL, NULL, 1, 'U', 'N', NULL, 'P_X', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_ETICHETTE', 'PECSMCU6', 15, 'Stampa Etichette', NULL, NULL, 1, 'U', 'N', NULL, 'P_SECU3', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_DICITURA', 'PECSMCU6', 16, 'Originale/Copia:', NULL, NULL, 1, 'U', 'N', NULL, 'P_DICI', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_DOMICILIO', 'PECSMCU6', 17, 'Domicilio', NULL, NULL, 1, 'U', 'N', 'X', 'P_X', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_STAMPA_ENTE', 'PECSMCU6', 18, 'Stampa indirizzo per cessati', NULL, NULL, 1, 'U', 'N', NULL, 'P_X', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_PREVIDENZIALE', 'PECSMCU6', 19, 'Non stampa dati Previdenziali', NULL, NULL, 1, 'U', 'N', NULL, 'P_X', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_DMA_ASS', 'PECSMCU6', 20, 'Suddivisione DMA per Ass.', NULL, NULL, 1, 'U', 'N', 'X', 'P_X', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_NOTE_1', 'PECSMCU6', 21, 'Note fisse : 1 Riga', NULL, NULL, 70, 'C', 'N', NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,NUMERO_FK )
VALUES ( 'P_NOTE_2', 'PECSMCU6', 22, '2 Riga', NULL, NULL, 70, 'C', 'N', NULL, NULL, NULL, NULL, NULL); 

-- Nuove Stampe
delete from A_CATALOGO_STAMPE 
where stampa in ('PECSCUEE','PECSCUEP');

INSERT INTO A_CATALOGO_STAMPE ( STAMPA, TITOLO,TIPO_PROPRIETA, TIPO_VISURA, CLASSE, STAMPA_BLOCCATA, STAMPA_PROTETTA, SEQUENZIALE ) 
VALUES ( 'PECSCUEE', 'Lista Dipendenti con Numero Moduli superiore o inferiore a Base', 'U', 'U', 'PDF', 'N', 'N' , 'S'); 
INSERT INTO A_CATALOGO_STAMPE ( STAMPA, TITOLO,TIPO_PROPRIETA, TIPO_VISURA, CLASSE, STAMPA_BLOCCATA, STAMPA_PROTETTA, SEQUENZIALE ) 
VALUES ( 'PECSCUEP', 'Lista Nominativa Numero pagine CUD e Note', 'U', 'U', 'PDF', 'N', 'N', 'S'); 

-- Passi procedurali PECSMCU6

delete from a_passi_proc where voce_menu = 'PECSMCU6';  

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','1','Estrazione dati per Stampa CUD','Q','PECSMCUD','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMCU6','2','Lista Anomalie CUD','R','PECANCUD','','PECANCUD','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','3','Stampa Modulo Certificazione Redditi','R','PECSMCU6','P_TIPO_DESFORMAT','PECSMCU6','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','4','Controllo per Stampa Terza Pagina','Q','P00UPDPP','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','5','Stampa Terza Pagina CUD','R','PECSMCU3','P_TIPO_DESFORMAT','PECSMCU3','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','6','Stampa Allegato Annotazioni','R','PECALCUD','','PECALCUD','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','7','Stampa Lista Firme','R','PECLMCUD','','PECLMCUD','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','8','Controllo per Stampa Etichette','Q','P00UPDPP','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','9','Stampa Etichette CUD','R','PECSECU4','','PECSECU4','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','10','Controllo per Stampa Etichette','Q','P00UPDPP','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','11','Stampa Etichette CUD','R','PECSECU3','','PECSECU3','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','12','Conteggio moduli','Q','PECCUDEP','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','13','Stampa Lista Nominativa nr. pagine','R','PECSAPST','','PECSCUEP','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','14','Stampa Lista Dipendenti con piu moduli','R','PECSAPST','','PECSCUEE','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','15','Cancellazione registrazioni di lavoro','Q','ACACANAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSMCU6','16','Pulizia tabella tab_report_fine_anno','Q','PECDTBFA','','','N'); 

start crp_cursore_fiscale.sql
start crp_pecsmcud.sql
start crp_PECCUDEP.sql
-- start crp_P00UPDPP.sql incluso in A19092