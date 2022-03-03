update a_voci_menu set guida_o = 'P_ECATE' where voce_menu = 'PAMECATE';
update a_voci_menu set guida_o = 'P_RIRE' where voce_menu = 'PECAARDO';
update a_voci_menu set guida_o = 'P_CDEIN' where voce_menu = 'PECCDEIN';
update a_voci_menu set guida_o = 'P_DAGIN' where voce_menu = 'PECDAGIN';
update a_voci_menu set guida_o = 'P_SCFI' where voce_menu = 'PECDSCFI';
update a_voci_menu set guida_o = 'P_ERICO' where voce_menu = 'PECERICO';
update a_voci_menu set guida_o = 'P_ESVC_S' where voce_menu = 'PECSEPFI';
update a_voci_menu set guida_o = 'P_QUST' where voce_menu = 'PGMDQUST';
update a_voci_menu set guida_o = 'P_DGEST' where voce_menu = 'PGMEGEST';
update a_voci_menu set guida_o = 'P_DRUOL' where voce_menu = 'PGMERUOL';
update a_voci_menu set guida_o = 'P_DTIRA' where voce_menu = 'PGMETIRA';

update a_voci_menu set modulo = 'ACAPARPR' where voce_menu = 'PECCALPI' and modulo is null;
update a_voci_menu set modulo = 'ACAPARPR' where voce_menu = 'PECSICUD' and modulo is null;
update a_voci_menu set modulo = 'ACAPARPR' where voce_menu = 'PGPCQUAL' and modulo is null;
update a_voci_menu set modulo = 'ACAPARPR' where voce_menu = 'PGPCVOCI' and modulo is null;
-- Estrazione a_selezioni cadpm / caedp / cardp 
delete from a_selezioni where voce_menu in ( 'PECCADPM', 'PECCAEDP', 'PERCCARDP');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TIPO_DENUNCIA','PECCARDP','0','Tipo Denuncia','10','U','N','CUD','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECCARDP','1','Anno ....:','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECCARDP','2','Gestione ....:','4','U','S','%','','GEST','1','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_PREVIDENZA','PECCARDP','3','Previdenza ..:','6','U','S','CP%','P_CP_PREV','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TIPO','PECCARDP','4','Archiviazione:','1','U','S','T','P_CARCP','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DAL','PECCARDP','5','Cessazione   : Dal','10','D','N','','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_AL','PECCARDP','6','   Al','10','D','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_CI','PECCARDP','7','Singolo Individuo : Codice','8','N','N','','','RAIN','0','1');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_CASSA','PECCARDP','8','Archiviazione Econ. Per Cassa','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GIORNI','PECCARDP','9','Giorni in 365:','1','U','N','','P_X','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ULTIMA_CESS','PECCARDP','10','Solo Ultima Cessazione:','1','U','N','X','P_X','','','');     
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_RAPPORTA_SOMME','PECCARDP','11','Rapporta Competenze Fisse','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECCARDP','12','Codice del Comparto','2','U','S','','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_SOTTOCOMPARTO','PECCARDP','13','Codice del Sottocomparto','2','U','S','','','','','');

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TIPO_DENUNCIA','PECCAEDP','0','Tipo Denuncia','10','U','N','CUD','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECCAEDP','1','Anno ....:','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECCAEDP','2','Gestione ....:','4','U','S','%','','GEST','1','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_PREVIDENZA','PECCAEDP','3','Previdenza ..:','6','U','S','CP%','P_CP_PREV','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TIPO','PECCAEDP','4','Archiviazione:','1','U','N','T','P_CARCP','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_DAL','PECCAEDP','5','Cessazione   : Dal','10','D','N','','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_AL','PECCAEDP','6','   Al','10','D','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_CI','PECCAEDP','7','Singolo Individuo : Codice','8','N','N','','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_CASSA','PECCAEDP','8','Archiviazione Econ. Per Cassa','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GIORNI','PECCAEDP','9','Giorni in 365:','1','U','N','','P_X','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_RAPPORTA_SOMME','PECCAEDP','10','Rapporta Competenze Fisse','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECCAEDP','11','Codice Comparto','2','U','S','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_SOTTOCOMPARTO','PECCAEDP','12','Codice Sottocomparto','2','U','S','','','','','');    

insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO','PECCADPM','1','Anno ....:','4','N','N','','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PECCADPM','2','Gestione ....:','4','U','S','%','','GEST','1','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_RAPPORTO','PECCADPM','3','Rapporto ....:','4','U','S','%','','CLRA','1','1');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GRUPPO','PECCADPM','4','Gruppo .....:','12','U','S','%','','GRRA','1','1');     
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_PREVIDENZA','PECCADPM','5','Previdenza ..:','6','U','S','CP%','P_CP_PREV','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TIPO','PECCADPM','6','Archiviazione:','1','U','S','T','P_CADPM','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_CI','PECCADPM','7','Singolo Individuo : Codice','8','N','N','','','RAIN','0','1');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ULTIMA_CESS','PECCADPM','8','Solo Ultima Cessazione:','1','U','N','X','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_RIFERIMENTO','PECCADPM','9','Data di riferimento','10','D','S','SYSDATE','','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ECONOMICA','PECCADPM','10','Archiviazione Economica:','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_CASSA','PECCADPM','11','Archiviazione Econ. Per Cassa','1','U','N','','P_X','','','');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GIORNI','PECCADPM','12','Giorni in 365:','1','U','N','','P_X','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_RAPPORTA_SOMME','PECCADPM','13','Rapporta Competenze Fisse','1','U','N','','P_X','','',''); 
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_COMPARTO','PECCADPM','14','Codice Comparto','2','U','S','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_SOTTOCOMPARTO','PECCADPM','15','Codice Sottocomparto','2','U','S','','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_ANNO_SFASATO','PECCADPM','16','Anno Previdenziale da Novembre','1','U','N','','P_X','','','');    
-- Aggiornamento att. 6711_1 per new install
UPDATE A_VOCI_MENU SET MODULO = 'ACAPARPR' WHERE VOCE_MENU = 'PGPLVOS7';

INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'P_ORDINAMENTO', '1', NULL, 'Contratto, Voce, Dal, Codice', NULL, NULL); 
INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'P_ORDINAMENTO', '2', NULL, 'Codice, Contratto, Voce, Dal', NULL, NULL); 

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_ORDINAMENTO', 'PGPLVOS7', 1, 'Ordinamento per', NULL, NULL, 1, 'N', 'N', '1', 'P_ORDINAMENTO'
, NULL, NULL, NULL); 

-- Aggiornamento att. 6712_1 per new install
UPDATE A_VOCI_MENU SET MODULO = 'ACAPARPR' WHERE VOCE_MENU = 'PGPLQUS7';

INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'P_ORDINAMENTO2', '1', NULL, 'Contratto, Qualifica, Dal, Codice', NULL, NULL); 
INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'P_ORDINAMENTO2', '2', NULL, 'Codice, Contratto, Qualifica, Dal', NULL, NULL); 

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_ORDINAMENTO', 'PGPLQUS7', 1, 'Ordinamento per', NULL, NULL, 1, 'N', 'N', '1', 'P_ORDINAMENTO2'
, NULL, NULL, NULL); 

-- Aggiornamento att. 7588 per new install
update a_selezioni set valore_default = 70 where voce_menu = 'PGP4PERI' and parametro = 'NUM_CARATTERI';
update a_selezioni set valore_default = 70 where voce_menu = 'PGP4IMPO' and parametro = 'NUM_CARATTERI';
update a_selezioni set valore_default = 179 where voce_menu = 'PGP4SCON'and parametro = 'NUM_CARATTERI';

insert into a_guide_v (guida_v,sequenza,alias,lettera,titolo,voce_menu,voce_rif) 
values ('P_DOGI_Q','3','','R','Rettifica documenti','PGMADOGI','');   

delete from a_selezioni where voce_menu = 'PGP4INPD';   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_CASSA','PGP4INPD','2','    Cassa Previdenziale','5','U','N','','','','','');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_CESSATI_AL','PGP4INPD','8','    al','10','C','N','','','','','');   
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_CESSATI_DAL','PGP4INPD','7','  Solo cessati dal','10','C','N','','','','','');  
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_CI','PGP4INPD','4','Dipendente: Codice Individuale','8','N','N','','','RAIN','1','1');
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_CONTRATTO','PGP4INPD','3','     Contratto di Lavoro','4','U','N','%','','CONT','1','1');    
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_GESTIONE','PGP4INPD','1','   Codice della Gestione','4','U','N','%','','GEST','1','1');     
insert into a_selezioni (parametro,voce_menu,sequenza,descrizione,lunghezza,formato,obbligo,valore_default,dominio,alias,gruppo_alias,numero_fk) values ('P_TUTTI_CI','PGP4INPD','5','Elabora Tutti i Rapporti Indiv','1','U','N','','P_X','','','');   

update a_selezioni set valore_default = 228 where voce_menu = 'PGP4PRAT' and parametro = 'NUM_CARATTERI';
update a_catalogo_stampe set classe = 'A_C' where stampa = 'PGPLRE92';
update a_catalogo_stampe set classe = 'A_C'where stampa = 'PGPLIMPO';
delete from a_selezioni where voce_menu = 'PGP4RETR' and parametro in ('P_FISSE','P_ACCESSORIE','P_TUTTE');
update a_selezioni set sequenza = 1 where voce_menu = 'PGP4RETR' and parametro = 'P_DAL';
update a_selezioni set valore_default = 50 where voce_menu = 'PGP4RETR' and parametro = 'NUM_CARATTERI';
update a_selezioni set descrizione = ltrim(descrizione) where voce_menu = 'PGP4INPD';

-- Aggiornamento att. 5228 per new install
delete from a_passi_proc where voce_menu = 'PECCADPM';
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PECCADPM','1','Verifica Scadenza denuncia','Q','CHK_SCAD','','','N');   
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PECCADPM','2','Deuncia Mensile I.N.P.D.A.P.','Q','PECCADPM','','','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PECCADPM','3','Archiviazione economica INPDAP','Q','PECCAEDP','','','N');     
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PECCADPM','4','Verifica Presenza Segnalazioni','Q','CHK_APST','','','N');     
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PECCADPM','5','Verifica Presenza Errori','Q','CHK_ERR','','','N');
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PECCADPM','81','Stampa Segnalazioni','R','PECLADTM','','PECLADTM','N'); 
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PECCADPM','82','Cancellazione Appoggio Stampe','Q','ACACANAS','','','N');     
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PECCADPM','83','Verifica Presenza Errori','Q','CHK_ERR','','','N');     
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PECCADPM','91','Stampa Segnalazioni Anomalie','R','ACARAPPR','','PECCADPM','N');    
insert into a_passi_proc (voce_menu,passo,titolo,tipo,modulo,stringa,stampa,gruppo_ling) values ('PECCADPM','92','Cancellazione Errori','Q','ACACANRP','','','N');  

-- Aggiornamento att. 5883 per new install solo ruolo *
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_SOGI', 1, 'SOGI', 'R', NULL, NULL, 'Rettifica', NULL, NULL, NULL, 'PGMASOGI', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PGMASOGI', 'P00', 'ASOGI', NULL, NULL, 'Assegna Sostituzioni', NULL, NULL, 'A', 'F'
, 'PGMASOGI', NULL, NULL, NULL, NULL); 
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PGMRSOGI', 'P00', 'RSOGI', NULL, NULL, 'Elenco Sostituzioni', NULL, NULL, 'F', 'F'
, 'PGMRSOGI', NULL, NULL, 'P_SOGI', NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1000195, 1013708, 'PGMASOGI', 11, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1000195, 1013707, 'PGMRSOGI', 10, NULL); 

-- Aggiornamento att. 6293  per new install solo ruolo *

INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_IDOGE', 5, 'DOOR', 'P', NULL, NULL, 'Profilo', NULL, NULL, NULL, 'PDOIDOOL', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_DOOL', 1, 'DOOR', 'I', NULL, NULL, 'dett.Ind.', NULL, NULL, NULL, 'PDORDOOR', NULL
, NULL, NULL, NULL, NULL);
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_PEGI_F', 11, 'PEGI', 'E', NULL, NULL, 'pOsti esa', NULL, NULL, NULL, 'PDOADOES'
, NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_PESE', 14, 'PEGI', 'P', NULL, NULL, 'pOsti esa', NULL, NULL, NULL, 'PDOADOES', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PDOIDOOL', 'P00', 'IDOOL', NULL, NULL, 'Dotazione per Profilo Orario', NULL, NULL
, 'A', 'F', 'PDOIDOOL', NULL, 1, 'P_DOOL', NULL); 
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PDOADOES', 'P00', 'ADOES', NULL, NULL, 'Ricerca posti ad Esaurimento', NULL, NULL
, 'A', 'F', 'PDOADOES', NULL, 1, NULL, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1013507, 1013709, 'PDOIDOOL', 21, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1013507, 1013710, 'PDOADOES', 22, NULL); 
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P08058', 'Individuo gia presente tra i posti ad esaurimento', NULL, NULL, NULL); 
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P08057', 'L''individuo non appartiene ad alcun gruppo di Dotazione Organica', NULL
, NULL, NULL); 

-- non utilizzata
delete from a_voci_menu where voce_menu = 'PECARARP';
delete from a_passi_proc where voce_menu = 'PECARARP';
delete from a_menu where voce_menu = 'PECARARP';