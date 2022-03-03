delete from a_menu where voce_menu = 'PECSETA3' and applicazione = 'GP4';
delete from a_menu where voce_menu = 'PECSETD3' and applicazione = 'GP4';

delete from a_selezioni where voce_menu = 'PECSETA3';
delete from a_selezioni where voce_menu = 'PECSETD3';

delete from a_passi_proc where voce_menu = 'PECSETA3';
delete from a_passi_proc where voce_menu = 'PECSETD3';

delete from a_voci_menu where voce_menu = 'PECSETA3';
delete from a_voci_menu where voce_menu = 'PECSETD3';

/* INSERIMENTO NUOVE VOCI */

delete from a_voci_menu where voce_menu in ('PECSETAN','PECSETDI');

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PECSETAN', 'P00', 'SETAN', NULL, NULL, 'Stampa Etichette Anagrafiche', NULL, NULL
, 'F', 'D', 'ACAPARPR', 'ANAGRAFICI', 1, 'P_CLRA_S', NULL);
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PECSETDI', 'P00', 'SETDI', NULL, NULL, 'Stampa Etichette Dipendenti', NULL, NULL
, 'F', 'D', 'ACAPARPR', 'ELENCO', 1, 'P_RIRE_S', NULL); 

delete from a_catalogo_stampe where stampa in ('PECSETA4','PECSETD4');

INSERT INTO A_CATALOGO_STAMPE ( STAMPA, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_PROPRIETA, TIPO_VISURA,
CLASSE, STAMPA_BLOCCATA, STAMPA_PROTETTA, SEQUENZIALE ) VALUES ( 
'PECSETA4', 'STAMPA ETICHETTE ANAGRAFICA', NULL, NULL, 'U', 'U', 'PDF', 'N', 'N', 'S'); 
INSERT INTO A_CATALOGO_STAMPE ( STAMPA, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_PROPRIETA, TIPO_VISURA,
CLASSE, STAMPA_BLOCCATA, STAMPA_PROTETTA, SEQUENZIALE ) VALUES ( 
'PECSETD4', 'STAMPA ETICHETTE DIPENDENTI', NULL, NULL, 'U', 'U', 'PDF', 'N', 'N', 'S'); 

delete from a_passi_proc where voce_menu in ('PECSETAN','PECSETDI');

INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSETAN', 1, 'Controllo Tipo Stampa', NULL, NULL, 'Q', 'P00UPDPP', NULL, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSETAN', 2, 'Etichette Anagrafiche', NULL, NULL, 'R', 'PECSETA3', NULL, 'PECSETA3'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSETAN', 3, 'Controllo Tipo Stampa', NULL, NULL, 'Q', 'P00UPDPP', NULL, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSETAN', 4, 'Etichette Anagrafiche', NULL, NULL, 'R', 'PECSETA4', NULL, 'PECSETA4'
, 'N');
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSETDI', 1, 'Controllo Tipo Stampa', NULL, NULL, 'Q', 'P00UPDPP', NULL, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSETDI', 2, 'Etichette Dipendenti', NULL, NULL, 'R', 'PECSETD3', NULL, 'PECSETD3'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSETDI', 3, 'Controllo Tipo Stampa', NULL, NULL, 'Q', 'P00UPDPP', NULL, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSETDI', 4, 'Etichette Dipendenti', NULL, NULL, 'R', 'PECSETD4', NULL, 'PECSETD4'
, 'N');

delete from a_domini_selezioni where dominio = 'P_SETXX';


INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'P_SETXX', 'A_D', NULL, 'Stampa Formto A3 (Aghi)', NULL, NULL); 
INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'P_SETXX', 'PDF', NULL, 'Stampa Formato A4 (PDF)', NULL, NULL);

delete from a_selezioni where voce_menu in ('PECSETAN','PECSETDI');

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_DOMICILIO', 'PECSETAN', 3, 'Domicilio      :', NULL, NULL, 1, 'U', 'N', NULL, 'P_X'
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_1', 'PECSETAN', 5, 'Raggruppamento : 1)', NULL, NULL, 15, 'U', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_2', 'PECSETAN', 6, '                 2)', NULL, NULL, 15, 'U', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_3', 'PECSETAN', 7, '                 3)', NULL, NULL, 15, 'U', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_4', 'PECSETAN', 8, '                 4)', NULL, NULL, 15, 'U', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_RAPPORTO', 'PECSETAN', 1, 'Collettivita`  : Rapporto', NULL, NULL, 4, 'U', 'S'
, '%', NULL, 'CLRA', 0, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_RIFERIMENTO', 'PECSETAN', 2, '                 Riferimento', NULL, NULL, 10, 'D'
, 'S', NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_TIPO_DESFORMAT', 'PECSETAN', 4, 'Tipo Stampa :', NULL, NULL, 4, 'U', 'S', NULL
, 'P_SETXX', NULL, NULL, NULL);
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_ANNO', 'PECSETDI', 1, 'Elaborazione   : Anno', NULL, NULL, 4, 'N', 'N', NULL, NULL
, 'RIRE', 1, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_1', 'PECSETDI', 4, 'Raggruppamento : 1)', NULL, NULL, 15, 'U', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_2', 'PECSETDI', 5, '                 2)', NULL, NULL, 15, 'U', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_3', 'PECSETDI', 6, '                 3)', NULL, NULL, 15, 'U', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_4', 'PECSETDI', 7, '                 4)', NULL, NULL, 15, 'U', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_MENSILITA', 'PECSETDI', 2, '                 Mensilita`', NULL, NULL, 4, 'U', 'N'
, NULL, NULL, 'RIRE', 1, 2); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_TIPO_DESFORMAT', 'PECSETDI', 3, 'Tipo Stampa :', NULL, NULL, 4, 'U', 'S', NULL
, 'P_SETXX', NULL, NULL, NULL); 

INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1000508, 1013904, 'PECSETAN', 4, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'AMM', 1000508, 1013904, 'PECSETAN', 4, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'PEC', 1000508, 1013904, 'PECSETAN', 4, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'SVI', 1000508, 1013904, 'PECSETAN', 4, NULL); 

INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1000554, 1013905, 'PECSETDI', 2, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'AMM', 1000554, 1013905, 'PECSETDI', 2, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'SVI', 1000554, 1013905, 'PECSETDI', 2, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'PEC', 1000554, 1013905, 'PECSETDI', 2, NULL); 

start crp_p00updpp.sql