-- Contiene anche gli script per le attvita 16250 - 16375 - 16251

-- Modifica stuttura del DB
alter table denuncia_fiscale add ( 
 C146                            VARCHAR(20)      NULL,
 C147                            VARCHAR(20)      NULL,
 C148                            VARCHAR(20)      NULL,
 C149                            VARCHAR(20)      NULL,
 C150                            VARCHAR(20)      NULL,
 C151                            NUMBER(20,5)     NULL,
 C152                            NUMBER(20,5)     NULL,
 C153                            NUMBER(20,5)     NULL,
 C154                            NUMBER(20,5)     NULL,
 C155                            NUMBER(20,5)     NULL,
 C156                            NUMBER(20,5)     NULL,
 C157                            NUMBER(20,5)     NULL,
 C158                            NUMBER(20,5)     NULL,
 C159                            NUMBER(20,5)     NULL,
 C160                            NUMBER(20,5)     NULL,
 C161                            NUMBER(20,5)     NULL
);

-- Abilitazione dei package modificati ( A16250 )

start crp_chk_scad.sql
start crp_cursore_fiscale.sql
start crp_pecsmfa1.sql
start crp_pecsmfa2.sql
start crp_peccatfr.sql
start crp_pecsmcud.sql
start crp_PECXAC40.sql

-- cancellazione voci di menù estemporanea anno precedente

delete from a_voci_menu where voce_menu = 'PECX770P';
delete from a_passi_proc where voce_menu = 'PECX770P';
delete from a_selezioni where voce_menu = 'PECX770P';
delete from a_menu where voce_menu = 'PECX770P';

delete from a_voci_menu where voce_menu = 'PECXAC62';
delete from a_passi_proc where voce_menu = 'PECXAC62';
delete from a_selezioni where voce_menu = 'PECXAC62';
delete from a_menu where voce_menu = 'PECXAC62';

delete from a_passi_proc where voce_menu = 'PECL70SA';

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECL70SA','1','Elenco nominativo e File 770/SA','Q','PECSMFA1','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECL70SA','2','Elenco nominativo e File 770/SA','Q','PECSMFA2','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECL70SA','3','Stampa nominativa 770/SA','R','PECL70SA','','PECL70SA','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECL70SA','4','Elenco nominativo e File 770/SA','Q','PECCF770','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECL70SA','5','Produzione File 770/SA','R','SI4V3WAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECL70SA','6','Elenco nominativo e File 770/SA','Q','ACACANAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECL70SA','91','Stampa Segnalazioni 770/SA','R','ACARAPPR','','ACARAPPR','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECL70SA','92','Pulizia appoggio stampe','Q','ACACANAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECL70SA','93','Pulizia segnalazioni errore','Q','ACACANRP','','','N');

delete from a_selezioni where voce_menu = 'PECL70SA';

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_RTRIM','PECL70SA','0','Abilita rtrim','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('TXTFILE','PECL70SA','0','Nome TXT da produrre','80','C','S','PECCSMFA.txt','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECL70SA','1','Elaborazione  : Anno','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_COD_FIS','PECL70SA','2','Dichiarante: Codice Fiscale','16','U','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECL70SA','3','Tipo','1','U','S','T','P_L70SA','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECL70SA','4','Codice Individuale','8','N','N','','','RAIN','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ESTRAZIONE_I','PECL70SA','5','Individui da estrarre :','1','N','N','','P_ESTR_I','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_1','PECL70SA','6','Raggruppamento: 1)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_2','PECL70SA','7','Raggruppamento: 2)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_FILTRO_3','PECL70SA','8','Raggruppamento: 3)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_4','PECL70SA','9','Raggruppamento: 4)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DMA_ASS','PECL70SA','10','Suddivisione DMA per Ass.','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DECIMALI','PECL70SA','11','Elabora i dati con i decimali','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TOTALE','PECL70SA','12','Stampa Totali','1','U','N','','P_X','','','');


delete from a_passi_proc where voce_menu = 'PECCSMFA';

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCSMFA','1','Elenco nominativo e File 770/SA','Q','PECSMFA1','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCSMFA','2','Elenco nominativo e File 770/SA','Q','PECSMFA2','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCSMFA','3','Elenco nominativo e File 770/SA','Q','PECCF770','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCSMFA','4','Produzione File 770/SA','R','SI4V3WAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCSMFA','91','Stampa Segnalazioni 770/SA','R','ACARAPPR','','ACARAPPR','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCSMFA','92','Pulizia appoggio stampe','Q','ACACANAS','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECCSMFA','93','Pulizia segnalazioni errore','Q','ACACANRP','','','N');

delete from a_selezioni where voce_menu = 'PECCSMFA';

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('SE_RTRIM','PECCSMFA','0','Abilita rtrim','2','C','S','SI','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('TXTFILE','PECCSMFA','0','Nome TXT da produrre','80','C','S','PECCSMFA.txt','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ANNO','PECCSMFA','1','Elaborazione  : Anno','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_COD_FIS','PECCSMFA','2','Dichiarante: Codice Fiscale','16','U','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_TIPO','PECCSMFA','3','Tipo','1','U','S','T','P_L70SA','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECCSMFA','4','Codice Individuale','8','N','N','','','RAIN','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_ESTRAZIONE_I','PECCSMFA','5','Individui da estrarre :','1','N','N','','P_ESTR_I','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_1','PECCSMFA','6','Raggruppamento: 1)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_2','PECCSMFA','7','Raggruppamento: 2)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_3','PECCSMFA','8','Raggruppamento: 3)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_FILTRO_4','PECCSMFA','9','Raggruppamento: 4)','15','U','S','%','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DMA_ASS','PECCSMFA','10','Suddivisione DMA per Ass.','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_DECIMALI','PECCSMFA','11','Elabora i dati con i decimali','1','U','N','','P_X','','','');

-- Nuova voce di menù estemporanea per memorizzazione casella 40

delete from a_voci_menu where voce_menu = 'PECXAC40'; 
delete from a_passi_proc where voce_menu = 'PECXAC40';
delete from a_selezioni where voce_menu = 'PECXAC40';
delete from a_menu where voce_menu = 'PECXAC40' and ruolo in ('*','AMM','PEC'); 

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECXAC40','P00','XAC40','Agg. Altri Redditi cas.40 770/06','F','D','ACAPARPR','',1,'A_PARA');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECXAC40','1','Verifica scadenza denuncia','Q','CHK_SCAD','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECXAC40','2','Agg. Qualifica Denuncia Inpdap - C62/770','Q','PECXAC40','','','N'); 

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO_DENUNCIA','PECXAC40','0','Tipo Denuncia','10','U','N','770','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECXAC40','1','Anno ....:','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECXAC40','2','Archiviazione:','1','U','S','T','P_S_T','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk)
values ('P_CI','PECXAC40','3','Singolo Individuo : Codice','8','N','N','','','RAIN','0','1');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1000555','1013849','PECXAC40','99','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1000555','1013849','PECXAC40','99','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1000555','1013849','PECXAC40','99','');

-- Inserimento caselle fiscali

delete from CASELLE_FISCALI where anno = 2005 and tipo_dichiarazione = 'S';

INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 1, 'Casella 1', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 2, 'Casella 2', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 3, 'Casella 3', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 4, 'Casella 4', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 5, 'Casella 5', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 6, 'Casella 6', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 7, 'Casella 7', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 8, 'Casella 8', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 9, 'Casella 9', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 10, 'Casella 10', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 11, 'Casella 11', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 12, 'Casella 12', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 13, 'Casella 13', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 14, 'Casella 14', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 15, 'Casella 15', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 16, 'Casella 16', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 17, 'Casella 17', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 18, 'Casella 18', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 19, 'Casella 19', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 20, 'Casella 20', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 21, 'Casella 21', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 22, 'Casella 22', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 23, '770: Casella 23', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 24, '770: Casella 24', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 25, '770: Casella 25', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 26, 'Casella 26', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 27, 'Casella 27', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 28, 'Casella 28', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 29, 'Casella 29', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 30, 'Casella 30', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 31, 'Casella 31', 'T', '101'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 33, 'Casella 33', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 34, 'Casella 34', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 35, 'Casella 35', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 36, 'Casella 36', 'T', '104'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 38, '770: Casella 38', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 39, '770: Casella 39', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 40, '770: Casella 40', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 41, '770: Casella 41', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 42, '770: Casella 42', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 43, 'Casella 43', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 44, 'Casella 44', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 45, 'Casella 45', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 46, 'Casella 46', 'T', '102'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 48, '770: Casella 48', 'D', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 49, '770: Casella 49', 'D', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 50, '770: Casella 50', 'D', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 51, '770: Casella 51', 'D', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 52, '770: Casella 52', 'D', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 53, '770: Casella 53', 'D', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 54, '770: Casella 54', 'D', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 55, '770: Casella 55', 'D', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 56, '770: Casella 56', 'D', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 57, 'Casella 57/61', 'D', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 58, 'Casella 58/62', 'D', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 59, 'Casella 59/63', 'D', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 60, 'Casella 60/64', 'D', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 61, '770: Casella 65', 'D', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 62, '770: Casella 66', 'D', '105'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 68, 'Casella 68', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 69, 'Casella 69', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 70, 'Casella 70', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 71, 'Casella 71', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 72, 'Casella 72', 'T', '103'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 73, 'TFR: Casella 75', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 74, 'TFR: Casella 76', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 75, 'TFR: Casella 77', 'T', '142'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 76, 'TFR: Casella 79', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 77, 'TFR: Casella 80', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 78, 'TFR: Casella 81', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 79, 'TFR: Casella 82', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 80, 'TFR: Casella 83', 'T', '84'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 81, 'Prev.Casella 68', 'T', '82'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 82, 'Prev.Casella 69', 'T', '83'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 83, 'Prev.Casella 70', 'T', '136'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 84, 'TFR: Casella 84', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 85, 'TFR: Casella 85', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 86, 'TFR: Casella 86', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 88, 'TFR: Casella 88', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 89, 'TFR: Casella 89', 'T', '143'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 91, 'TFR: Casella 91', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 92, 'TFR: Casella 92', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 93, 'TFR: Casella 93', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 94, 'TFR: Casella 94', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 95, 'TFR: Casella 95', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 96, 'TFR: Casella 96', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 98, 'TFR: Casella 98', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 99, 'TFR: Casella 99', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 100, 'TFR: Cas. 100', 'T', '111'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 101, '770: Casella 32', 'T', '33'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 102, '770: Casella 47', 'D', '48'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 103, 'Cas.8 Prev.Com.', 'T', '108'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 104, '770: Casella 37', 'T', '38'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 105, '770: Casella 67', 'D', '68'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 108, 'TFR: Casella 73', 'T', '109'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 109, 'TFR: Casella 74', 'T', '73'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 111, 'TFR: Cas. 101', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 112, 'TFR: Cas. 102', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 114, 'TFR: Cas. 104', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 115, 'TFR: Cas. 105', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 116, 'TFR: Cas. 106', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 117, 'TFR: Cas. 107', 'T', '144'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 119, 'TFR: Cas. 109', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 120, 'TFR: Cas. 110', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 121, 'TFR: Cas. 111', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 122, 'TFR: Cas. 112', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 123, 'TFR: Cas. 113', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 124, 'TFR: Cas. 114', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 126, 'TFR: Cas. 116', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 127, 'TFR: Cas. 117', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 128, 'TFR: Cas. 118', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 129, 'TFR: Cas. 119', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 131, 'TFR: Cas. 121', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 132, 'TFR: Cas. 122', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 133, 'TFR: Cas. 123', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 134, 'TFR: Cas. 124', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 135, 'TFR: Cas. 144', 'T', '140'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 136, 'Prev.Cas.74', 'T', '137'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 137, 'Prev.Cas.75', 'T', '138'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 138, 'Prev.Cas.76', 'T', '139'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 139, 'App. per Note', 'T', '1'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 140, 'TFR: Cas. 145', 'T', '151'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 141, 'Prev - Cas.5', 'T', '81'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 142, 'TFR: Casella 78', 'T', '76'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 143, 'TFR: Casella 90', 'T', '91'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 144, 'TFR: Cas. 108', 'T', '119'); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 151, 'TFR: Cas. 146', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 152, 'TFR: Cas. 147', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 153, 'TFR: Cas. 148', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 154, 'TFR: Cas. 149', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 155, 'TFR: Cas. 150', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 156, 'TFR: Cas. 151', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 157, 'TFR: Cas. 152', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 158, 'TFR: Cas. 153', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 159, 'TFR: Cas. 154', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 160, 'TFR: Cas. 155', 'T', NULL); 
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2005, 'S', 161, 'TFR: Cas. 156', 'T', '141');



