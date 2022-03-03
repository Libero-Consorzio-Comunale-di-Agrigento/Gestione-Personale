delete from a_voci_menu 
where voce_menu = 'PECXCAFA';

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PECXCAFA', 'P00', 'XCAFA', NULL, NULL, 'Ricalcolo Carico Familiare', NULL, NULL, 'F'
, 'F', 'PECCCAFA', NULL, 1, NULL, NULL);

INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_CCAFA', 1, 'RAIN', 'I', NULL, NULL, 'Individui', NULL, NULL, NULL, 'P00RANAG', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_CCAFA', 2, 'GEST', 'G', NULL, NULL, 'Gestioni', NULL, NULL, NULL, 'PGMDGEST', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_CCAFA', 3, 'CLRA', 'R', NULL, NULL, 'Rapporti', NULL, NULL, NULL, 'PAMDCLRA', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_CCAFA', 4, 'GRRA', 'P', NULL, NULL, 'gruPi', NULL, NULL, NULL, 'PAMDGRRA', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_CCAFA', 5, 'PARA', 'N', NULL, NULL, 'preNot...', NULL, NULL, NULL, 'ACAEPRPA', '*'
, 'X', NULL, NULL, NULL);

delete from a_voci_menu 
where voce_menu = 'PECCCAFA';

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PECCCAFA', 'P00', 'CCAFA', NULL, NULL, 'Caricamento Automatico Carichi Familiari'
, NULL, NULL, 'F', 'D', 'ACAPARPR', NULL, 1, 'P_CCAFA', NULL); 

delete from a_passi_proc 
where voce_menu = 'PECCCAFA';

INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECCCAFA', 1, 'Caricamento Automatico Carichi Familiari', NULL, NULL, 'Q', 'PECCCAFA'
, NULL, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECCCAFA', 2, 'Stampa Dipendenti Trattati', NULL, NULL, 'R', 'PECSAPST', NULL, 'PECSAPST'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECCCAFA', 3, 'Pulizia appoggio stampe', NULL, NULL, 'Q', 'ACACANAS', NULL, NULL
, 'N'); 
insert into A_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('PECCCAFA', 4, 'Verifica presenza segnalazioni', null, null, 'Q', 'CHK_ERR', null, null, 'N');
insert into A_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('PECCCAFA', 91, 'Stampa Segnalazioni 770/SA', null, null, 'R', 'ACARAPPR', null, 'ACARAPPR', 'N');
insert into A_PASSI_PROC (VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA, STAMPA, GRUPPO_LING)
values ('PECCCAFA', 92, 'Pulizia segnalazioni errore', null, null, 'Q', 'ACACANRP', null, null, 'N');

delete from a_selezioni
where voce_menu = 'PECCCAFA';

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_ANNO', 'PECCCAFA', 1, 'Elaborazione:  Anno', NULL, NULL, 4, 'N', 'N', NULL, NULL
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_CI', 'PECCCAFA', 3, 'Singolo Individuo:  Codice', NULL, NULL, 8, 'N', 'N', NULL
, NULL, 'RAIN', 0, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_GESTIONE', 'PECCCAFA', 4, 'Gestione', NULL, NULL, 8, 'U', 'N', '%', NULL, 'GEST'
, 1, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_GRUPPO', 'PECCCAFA', 6, 'Gruppo', NULL, NULL, 12, 'U', 'N', '%', NULL, 'GRRA', 1
, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_MESE', 'PECCCAFA', 2, '                       Mese', NULL, NULL, 2, 'N', 'N', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_RAPPORTO', 'PECCCAFA', 5, 'Rapporto', NULL, NULL, 4, 'U', 'N', '%', NULL, 'CLRA'
, 1, 1);

update a_guide_v
   set voce_menu = 'PECXCAFA' 
 where voce_menu = 'PECCCAFA';
 
delete from a_menu 
 where voce_menu = 'PECCCAFA';
 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1000548, 1013855, 'PECCCAFA', 1, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'AMM', 1000548, 1013855, 'PECCCAFA', 1, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'SVI', 1000548, 1013855, 'PECCCAFA', 1, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'PEC', 1000548, 1013855, 'PECCCAFA', 1, NULL); 

delete from a_menu 
 where voce_menu = 'PECXCAFA';
 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1004365, 1013854, 'PECXCAFA', 91, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'AMM', 1004365, 1013854, 'PECXCAFA', 91, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'SVI', 1004365, 1013854, 'PECXCAFA', 91, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'PEC', 1004365, 1013854, 'PECXCAFA', 91, NULL); 

start crp_pecccafa.sql