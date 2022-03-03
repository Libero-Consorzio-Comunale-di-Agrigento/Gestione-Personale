-- Attivita 10955, 10283, 10283.1
-- start crp_peccarsm.sql

-- Attivita 15505
-- start crp_PECSMT12.sql
-- start crp_PECSMT13.sql

-- Attivita 15590
-- start crp_PECSMT12.sql

-- Attivita 15595
alter table SMT_INDIVIDUI add ANZIANITA_MM NUMBER(3);
alter table SMT_INDIVIDUI add ANZIANITA_GG NUMBER(4);
alter table SMT_INDIVIDUI add ANZIANITA_PREC NUMBER(3);
alter table SMT_INDIVIDUI add ANZIANITA_PREC_MM NUMBER(3);
alter table SMT_INDIVIDUI add ANZIANITA_PREC_GG NUMBER(4);

--  start crp_peccarsm.sql

INSERT INTO POSIZIONI 
( CODICE, DESCRIZIONE, SEQUENZA, POSIZIONE, RUOLO, STAGIONALE
, CONTRATTO_FORMAZIONE, TEMPO_DETERMINATO, PART_TIME, DI_RUOLO
, TIPO_FORMAZIONE, TIPO_DETERMINATO
, UNIVERSITARIO, COLLABORATORE, COPERTURA_PART_TIME, LSU, TIPO_PART_TIME, RUOLO_DO
, CONTRATTO_OPERA, SOVRANNUMERO, AMM_CONS ) 
VALUES 
( 'ANZP', 'Anzianita Pregressa', 90, NULL, 'D', 'NO'
, 'NO', 'NO', 'NO', 'N'
, NULL, NULL
, NULL, NULL, NULL, NULL, NULL, NULL
, NULL, 'NO', NULL ); 

INSERT INTO EVENTI_GIURIDICI 
( CODICE, DESCRIZIONE, SEQUENZA, DELIBERA, CERTIFICABILE, PRESSO
, STATO_SERVIZIO, RILEVANZA, POSIZIONE, UNICO, CONTO_ANNUALE, CERT_SETT
, ONAOSI, INPS )
VALUES 
( 'ANZP', 'Anzianita pregressa per Conto Annuale', 2, 'NO', 'NO', 'NO'
, 'NO', 'D', 'ANZP', 'NO', NULL, 'NO'
, NULL, NULL);

INSERT INTO SOTTOCODICI_DOCUMENTO 
( EVENTO, CODICE, DESCRIZIONE, NOTA_DEL, NOTA_DESCRIZIONE
, NOTA_NUMERO, NOTA_CATEGORIA, NOTA_PRESSO
, NOTA_N1, NOTA_N2, NOTA_N3
, NOTA_A1, NOTA_A2, NOTA_A3 )
VALUES ( 'ANZP', 'ANZP', 'Anzianita Pregressa per Conto Annuale', NULL, NULL
, NULL, NULL, NULL
, 'Anni', 'Mesi', 'Giorni'
, NULL, NULL, NULL);

-- Attivita 15596
delete from a_selezioni where voce_menu = 'PECCARSM';   

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECCARSM','1','Anno Elaborazione','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DA','PECCARSM','2','Da','10','D','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_A','PECCARSM','3','A','10','D','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ELAB','PECCARSM','4','Tipo Elaborazione','1','U','S','T','P_CARSM','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECCARSM','5','Gestione','4','U','S','%','','GEST','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TIPO','PECCARSM','6','Archiviazione','1','U','S','T','P_TIPO_CARSM','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CI','PECCARSM','7','Codice Individuale','8','N','N','','','RAIN','0','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_DECORRENZA','PECCARSM','8','Archiviazione per Decorrenza','1','U','N','X','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_COMPETENZA','PECCARSM','9','Archiviazione per Competenza','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MESE_DA','PECCARSM','10','Mese di Liquidazione DA','2','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_MESE_A','PECCARSM','11','Mese di Liquidazione A','2','N','N','','','','','');

-- start crp_peccarsm.sql

-- Attivita 15597
delete from a_passi_proc where voce_menu = 'PECSMT11';

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMT11','1','Elaborazione Stat. Min. Tesoro - Tab.11','Q','PECSMT11','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMT11','2','Stampa Statistiche Min. Tesoro - Tab.11','R','PECSMT11','','PECSMT11','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMT11','3','Elaborazione Stat. Min. Tesoro - Tab.11S','Q','PECSMT7S','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMT11','4','Stampa Statistiche Min. Tesoro - Tab.11S','R','PECSMT7S','','PECSMT7S','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSMT11','5','Cancellazione appoggio stampe','Q','ACACANAS','','','N');

-- start crp_pecsmt11.sql
-- start crp_pecsmt7s.sql

-- Attivita 15598 e A15815
alter table figure_giuridiche add CODICE_MINISTERO_01 VARCHAR2(6);
alter table smt_periodi add PROFILO_01 VARCHAR2(6);

-- Abilitazione nuovo report SSN1D

delete from a_voci_menu where voce_menu = 'PECSSN1D';   
delete from a_passi_proc where voce_menu = 'PECSSN1D';  
delete from a_selezioni where voce_menu = 'PECSSN1D';   
delete from a_menu where voce_menu = 'PECSSN1D' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PECSSN1D');  

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECSSN1D','P00','SSN1D','Statistiche Min. Tesoro - Tab.  1D','F','D','ACAPARPR','',1,'P_SMT_S');   

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSSN1D','1','Statistiche Min. Tesoro - Tab.  1D','R','PECSSN1D','','PECSSN1D','N');     

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECSSN1D','1','Elaborazione: Anno','4','N','N','','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECSSN1D','2','  Gestione','4','U','S','%','','GEST','1','1'); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_OSPE','PECSSN1D','3','  Suddivisione','2','U','S','','P_OSPE','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_CODICE','PECSSN1D','4','  Codice','15','U','S','%','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TOT','PECSSN1D','5','  Totale Generale','1','U','N','','P_X','','','');   

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1012804','1013841','PECSSN1D','16','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1012804','1013841','PECSSN1D','16','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1012804','1013841','PECSSN1D','16','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSSN1D','STATISTICHE MINISTERO DEL TESORO - TABELLA 1D','U','U','A_C','N','N','S');

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_SMT_S','1','PREN','P','Prenot.','','ACAEPRPA','*','');
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_SMT_S','2','GEST','G','Gestioni','','PGMEGESE','','');

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_OSPE','1','','I Livello Settoriale (Settore A)');    
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_OSPE','15','','I Livello Settoriale (Settore A) + Sede');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_OSPE','2','','II Livello Settoriale (Settore B)');   
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_OSPE','25','','II Livello Settoriale (Settore B) + Sede'); 
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_OSPE','3','','III Liv. Settoriale (Settore C)');     
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_OSPE','35','','III Liv. Settoriale (Settore C) + Sede');   
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_OSPE','4','','Ultimo Liv. Settoriale');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_OSPE','45','','Ultimo Liv. Settoriale + Sede');
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_OSPE','5','','Sede');  
insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_X','X','','Conferma della condizione proposta');   

-- start crp_peccarsm.sql

-- Attivita 15599
alter table tipi_rapporto add CONTO_ANNUALE NUMBER(2);
alter table contratti_storici add CONTO_ANNUALE NUMBER(2);
alter table smt_periodi add FASCIA NUMBER(1);

insert into pgm_ref_codes ( rv_low_value, rv_domain, rv_meaning, rv_type )
values ( '0', 'TIPI_RAPPORTO.CONTO_ANNUALE', 'Nessuna Fascia Retributiva', 'CFG');
insert into pgm_ref_codes ( rv_low_value, rv_domain, rv_meaning, rv_type )
values ( '1', 'TIPI_RAPPORTO.CONTO_ANNUALE', 'Prima Fascia Retributiva', 'CFG');
insert into pgm_ref_codes ( rv_low_value, rv_domain, rv_meaning, rv_type )
values ( '2', 'TIPI_RAPPORTO.CONTO_ANNUALE', 'Seconda Fascia Retributiva', 'CFG');
insert into pgm_ref_codes ( rv_low_value, rv_domain, rv_meaning, rv_type )
values ( '3', 'TIPI_RAPPORTO.CONTO_ANNUALE', 'Terza Fascia Retributiva', 'CFG');
insert into pgm_ref_codes ( rv_low_value, rv_domain, rv_meaning, rv_type )
values ( '4', 'TIPI_RAPPORTO.CONTO_ANNUALE', 'Quarta Fascia Retributiva', 'CFG');
insert into pgm_ref_codes ( rv_low_value, rv_domain, rv_meaning, rv_type )
values ( '5', 'TIPI_RAPPORTO.CONTO_ANNUALE', 'Quinta Fascia Retributiva', 'CFG');
insert into pgm_ref_codes ( rv_low_value, rv_domain, rv_meaning, rv_type )
values ( '6', 'TIPI_RAPPORTO.CONTO_ANNUALE', 'Sesta Fascia Retributiva', 'CFG');

insert into pgm_ref_codes ( rv_low_value, rv_domain, rv_meaning, rv_type )
values ( '0', 'CONTRATTI_STORICI.CONTO_ANNUALE', 'Non Archiviazione Fascia per SMT', 'CFG');
insert into pgm_ref_codes ( rv_low_value, rv_domain, rv_meaning, rv_type )
values ( '1', 'CONTRATTI_STORICI.CONTO_ANNUALE', 'Archiviazione Fascia per SMT', 'CFG');

-- Abilitazione nuovo report SSN1E

delete from a_voci_menu where voce_menu = 'PECSSN1E';  
delete from a_passi_proc where voce_menu = 'PECSSN1E'; 
delete from a_selezioni where voce_menu = 'PECSSN1E';  
delete from a_menu where voce_menu = 'PECSSN1E' and ruolo in ('*','AMM','PEC'); 
delete from a_catalogo_stampe where stampa in (select stampa from a_passi_proc where substr(stampa,1,1) = 'P' and voce_menu = 'PECSSN1E');  

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o) 
values ('PECSSN1E','P00','SSN1E','Statistiche Min. Tesoro - Tab.  1E','F','D','ACAPARPR','',1,'P_SMT_S');

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) 
values ('PECSSN1E','1','Statistiche Min. Tesoro - Tab.  1E','R','PECSSN1E','','PECSSN1E','N');  

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_ANNO','PECSSN1E','1','Elaborazione: Anno','4','N','N','','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_GESTIONE','PECSSN1E','2','    Gestione','4','U','S','%','','GEST','1','1');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) 
values ('P_TOT','PECSSN1E','3','    Totale Generale','1','U','N','','P_X','','',''); 

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1012804','1013842','PECSSN1E','17','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1012804','1013842','PECSSN1E','17','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','PEC','1012804','1013842','PECSSN1E','17','');

insert into a_catalogo_stampe (stampa,titolo,tipo_proprieta,tipo_visura,classe,stampa_bloccata,stampa_protetta,sequenziale) 
values ('PECSSN1E','STATISTICHE MINISTERO DEL TESORO - TABELLA 1E','U','U','A_E','N','N','S');  

insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_SMT_S','1','PREN','P','Prenot.','','ACAEPRPA','*',''); 
insert into a_guide_o (guida_o,sequenza,alias,lettera,titolo,guida_v,voce_menu,voce_rif,proprieta) 
values ('P_SMT_S','2','GEST','G','Gestioni','','PGMEGESE','',''); 

insert into a_domini_selezioni (dominio,valore_low,valore_high,descrizione) 
values ('P_X','X','','Conferma della condizione proposta');

update a_menu set sequenza = 18
where voce_menu = 'PECSSNSM';
-- start crp_peccarsm.sql

-- Attivita 15666
-- start crp_peccarsm.sql
-- start crp_pecsmt12.sql
-- start crp_pecsmt13.sql

-- Attivita 15815
delete from a_selezioni
where voce_menu = 'PECSSNC1';

-- pecssn1d incluso nel A15598

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK )
values ( 'P_ANNO', 'PECSSNC1', 1, 'Elaborazione: Anno', NULL, NULL, 4, 'N', 'N', NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK )
values ( 'P_GESTIONE', 'PECSSNC1', 2, '              Gestione', NULL, NULL, 4, 'U', 'S', '%', NULL, 'GEST', 1, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK )
values ( 'P_OSPE', 'PECSSNC1', 3, '              Suddivisione', NULL, NULL, 2, 'U', 'S', NULL, 'P_OSPE', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK )
values ( 'P_CODICE', 'PECSSNC1', 4, '              Codice', NULL, NULL, 15, 'U', 'S', '%', NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK )
values ( 'P_TOT', 'PECSSNC1', 5, '              Totale Generale', NULL, NULL, 1, 'U', 'N', NULL, 'P_X', NULL, NULL, NULL); 

-- Attivita 15823
-- start crp_pecssnrf.sql
-- start crp_pecssnsm.sql

delete from a_passi_proc where voce_menu = 'PECSSNSM';  

insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','1','Supporto Magnetico SMT Sanita','Q','PECSSNSM','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','2','Produzione File','R','SI4V3WAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','3','Rinomina File','Q','PECSSNRF','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','4','Produzione File','R','SI4V3WAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','5','Rinomina File','Q','PECSSNRF','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','6','Produzione File','R','SI4V3WAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','7','Rinomina File','Q','PECSSNRF','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','8','Produzione File','R','SI4V3WAS','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','9','Rinomina File','Q','PECSSNRF','','','N');  
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','10','Produzione File','R','SI4V3WAS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','11','Rinomina File','Q','PECSSNRF','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','12','Produzione File','R','SI4V3WAS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','13','Rinomina File','Q','PECSSNRF','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','14','Produzione File','R','SI4V3WAS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','15','Rinomina File','Q','PECSSNRF','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','16','Produzione File','R','SI4V3WAS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','17','Rinomina File','Q','PECSSNRF','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','18','Produzione File','R','SI4V3WAS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','19','Rinomina File','Q','PECSSNRF','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','20','Produzione File','R','SI4V3WAS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','21','Rinomina File','Q','PECSSNRF','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','22','Produzione File','R','SI4V3WAS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','23','Rinomina File','Q','PECSSNRF','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','24','Produzione File','R','SI4V3WAS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','25','Rinomina File','Q','PECSSNRF','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','26','Produzione File','R','SI4V3WAS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','27','Rinomina File','Q','PECSSNRF','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','28','Produzione File','R','SI4V3WAS','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','29','Rinomina File','Q','PECSSNRF','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling)
values ('PECSSNSM','30','Cancellazione Appoggio Stampe','Q','ACACANAS','','','N'); 

delete from a_selezioni
where voce_menu in 
('PECSSN1D','PECSSN1E','PECSSNA2','PECSSNB1','PECSSNC1')
and parametro = 'P_TOT';

/* PECSSN1D */
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK ) 
VALUES ( 'P_TOT', 'PECSSN1D', 5, '  Totale Generale', NULL, NULL, 1, 'U', 'N', NULL, 'P_SMTT', NULL, NULL, NULL); 

/* PECSSN1E */
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK ) 
VALUES ( 'P_TOT', 'PECSSN1E', 3, '    Totale Generale', NULL, NULL, 1, 'U', 'N', NULL, 'P_SMTT', NULL, NULL, NULL);

/* PECSSNA2 */
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK )
VALUES ( 'P_TOT', 'PECSSNA2', 5, 'Totale Generale', NULL, NULL, 1, 'U', 'N', NULL, 'P_SMTT', NULL, NULL, NULL);

/* PECSSNB1 */
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK )
VALUES (  'P_TOT', 'PECSSNB1', 3, 'Totale Generale', NULL, NULL, 1, 'U', 'N', NULL, 'P_SMTT', NULL, NULL, NULL);

/* PECSSNC1 */
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK )
VALUES ( 'P_TOT', 'PECSSNC1', 5, 'Totale Generale', NULL, NULL, 1, 'U', 'N', NULL, 'P_SMTT', NULL, NULL, NULL);

-- Attivita 15980
-- Compilazione package
start crp_pecsmt11.sql
start crp_pecsmt7s.sql
start crp_peccarsm.sql
start crp_PECSMT12.sql
start crp_PECSMT13.sql
start crp_pecssnrf.sql
start crp_pecssnsm.sql