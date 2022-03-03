start crp_pgpcprat.sql
start crp_pgpcqual.sql
start crp_pgpcvoci.sql
start crp_pgpcimpo.sql

INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P04092', 'Manca definizione Voce per Pensioni S7', NULL, NULL, NULL); 
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P04091', 'Manca definizione Qualifica per Pensioni S7', NULL, NULL, NULL); 


DELETE FROM A_VOCI_MENU WHERE VOCE_MENU    ='PGP4PRAT';
DELETE FROM A_CATALOGO_STAMPE WHERE STAMPA ='PGP4PRAT';
DELETE FROM A_SELEZIONI WHERE VOCE_MENU    ='PGP4PRAT';
DELETE FROM A_PASSI_PROC WHERE VOCE_MENU   ='PGP4PRAT';
DELETE FROM A_MENU WHERE VOCE_MENU         ='PGP4PRAT';

DELETE FROM A_VOCI_MENU WHERE VOCE_MENU    ='PGPCPRAT';
DELETE FROM A_CATALOGO_STAMPE WHERE STAMPA ='PGPCPRAT';
DELETE FROM A_SELEZIONI WHERE VOCE_MENU    ='PGPCPRAT';
DELETE FROM A_PASSI_PROC WHERE VOCE_MENU   ='PGPCPRAT';
DELETE FROM A_MENU WHERE VOCE_MENU         ='PGPCPRAT';

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PGPCPRAT', 'P00', 'CPRAT', NULL, NULL, 'Creazione File Pratiche', NULL, NULL, 'F'
, 'D', NULL, NULL, 1, NULL, NULL); 

INSERT INTO A_CATALOGO_STAMPE ( STAMPA, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_PROPRIETA, TIPO_VISURA,
CLASSE, STAMPA_BLOCCATA, STAMPA_PROTETTA, SEQUENZIALE ) VALUES ( 
'PGPCPRAT', 'SEGNALAZIONI QUALIFICHE S7', NULL, NULL, 'U', 'U', 'A_C', 'N', 'N'
, 'S'); 

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'NUM_CARATTERI', 'PGPCPRAT', 0, 'Caratteri per substring', NULL, NULL, 4, 'C', 'S'
, '228', NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'SE_SUBSTR', 'PGPCPRAT', 0, 'Abilita substring', NULL, NULL, 2, 'C', 'S', 'SI', NULL
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'SE_UPPER', 'PGPCPRAT', 0, 'Abilita upper', NULL, NULL, 2, 'C', 'S', 'SI', NULL, NULL
, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'TXTFILE', 'PGPCPRAT', 0, 'Nome TXT da produrre', NULL, NULL, 80, 'C', 'S', 'Pratich2.txt'
, NULL, NULL, NULL, NULL); 

INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCPRAT', 1, 'Creazione file Pratiche', NULL, NULL, 'Q', 'PGPCPRAT', NULL, NULL
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCPRAT', 91, 'Errori di Elaborazione', NULL, NULL, 'R', 'ACARAPPR', NULL, 'PGPCPRAT'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCPRAT', 92, 'Cancellazione errori', NULL, NULL, 'Q', 'ACACANRP', NULL, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCPRAT', 93, 'Creazione file Pratiche', NULL, NULL, 'R', 'SI4V3WAS', NULL, NULL
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCPRAT', 94, 'Lista Pratiche Esportate', NULL, NULL, 'R', 'PGPLPRAT', NULL, 'PGPLPRAT'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCPRAT', 95, 'Cancellazione appoggio stampe', NULL, NULL, 'Q', 'ACACANAS', NULL, NULL
, 'N'); 


INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1012552, 1012555, 'PGPCPRAT', 3, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'AMM', 1012552, 1012555, 'PGPCPRAT', 3, NULL); 

INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P04092', 'Manca definizione Voce per Pensioni S7', NULL, NULL, NULL); 
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P04091', 'Manca definizione Qualifica per Pensioni S7', NULL, NULL, NULL); 

DELETE FROM A_VOCI_MENU WHERE VOCE_MENU    ='PGP4QUAL';
DELETE FROM A_CATALOGO_STAMPE WHERE STAMPA ='PGP4QUAL';
DELETE FROM A_SELEZIONI WHERE VOCE_MENU    ='PGP4QUAL';
DELETE FROM A_PASSI_PROC WHERE VOCE_MENU   ='PGP4QUAL';
DELETE FROM A_MENU WHERE VOCE_MENU         ='PGP4QUAL';

DELETE FROM A_VOCI_MENU WHERE VOCE_MENU    ='PGPCQUAL';
DELETE FROM A_CATALOGO_STAMPE WHERE STAMPA ='PGPCQUAL';
DELETE FROM A_SELEZIONI WHERE VOCE_MENU    ='PGPCQUAL';
DELETE FROM A_PASSI_PROC WHERE VOCE_MENU   ='PGPCQUAL';
DELETE FROM A_MENU WHERE VOCE_MENU         ='PGPCQUAL';

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PGPCQUAL', 'P00', 'CQUAL', NULL, NULL, 'Creazione File Qualifiche Ente', NULL, NULL
, 'F', 'D', 'ACAPARPR', NULL, 1, NULL, NULL); 

INSERT INTO A_CATALOGO_STAMPE ( STAMPA, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_PROPRIETA, TIPO_VISURA,
CLASSE, STAMPA_BLOCCATA, STAMPA_PROTETTA, SEQUENZIALE ) VALUES ( 
'PGPCQUAL', 'SEGNALAZIONI QUALIFICHE S7', NULL, NULL, 'U', 'U', 'A_C', 'N', 'N', 'S'); 

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'NUM_CARATTERI', 'PGPCQUAL', 0, 'Caratteri per substring', NULL, NULL, 4, 'C', 'S'
, '122', NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_GESTIONE', 'PGPCQUAL', 1, 'Codice della Gestione', NULL, NULL, 4, 'U', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'SE_SUBSTR', 'PGPCQUAL', 0, 'Abilita substring', NULL, NULL, 2, 'C', 'S', 'SI', NULL
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'SE_UPPER', 'PGPCQUAL', 0, 'Abilita upper', NULL, NULL, 2, 'C', 'S', 'SI', NULL, NULL
, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'TXTFILE', 'PGPCQUAL', 0, 'Nome TXT da produrre', NULL, NULL, 80, 'C', 'S', 'Qualifi2.txt'
, NULL, NULL, NULL, NULL); 

INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCQUAL', 1, 'Creazione file Qualifiche Ente', NULL, NULL, 'Q', 'PGPCQUAL', NULL
, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCQUAL', 91, 'Errori di Elaborazione', NULL, NULL, 'R', 'ACARAPPR', NULL, 'PGPCQUAL'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCQUAL', 92, 'Cancellazione errori', NULL, NULL, 'Q', 'ACACANRP', NULL, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCQUAL', 93, 'Creazione file Qualifiche Ente', NULL, NULL, 'R', 'SI4V3WAS', NULL
, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCQUAL', 94, 'Lista qualifiche ente esportate', NULL, NULL, 'R', 'PGPLQUAL', NULL
, 'PGPLQUAL', 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCQUAL', 95, 'Cancellazione appoggio stampe', NULL, NULL, 'Q', 'ACACANAS', NULL
, NULL, 'N'); 

INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1012552, 1012560, 'PGPCQUAL', 8, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'AMM', 1012552, 1012560, 'PGPCQUAL', 8, NULL); 

DELETE FROM A_VOCI_MENU WHERE VOCE_MENU    ='PGP4VOCI';
DELETE FROM A_CATALOGO_STAMPE WHERE STAMPA ='PGP4VOCI';
DELETE FROM A_SELEZIONI WHERE VOCE_MENU    ='PGP4VOCI';
DELETE FROM A_PASSI_PROC WHERE VOCE_MENU   ='PGP4VOCI';
DELETE FROM A_MENU WHERE VOCE_MENU         ='PGP4VOCI';

DELETE FROM A_VOCI_MENU WHERE VOCE_MENU    ='PGPCVOCI';
DELETE FROM A_CATALOGO_STAMPE WHERE STAMPA ='PGPCVOCI';
DELETE FROM A_SELEZIONI WHERE VOCE_MENU    ='PGPCVOCI';
DELETE FROM A_PASSI_PROC WHERE VOCE_MENU   ='PGPCVOCI';
DELETE FROM A_MENU WHERE VOCE_MENU         ='PGPCVOCI';

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PGPCVOCI', 'P00', 'CVOCI', NULL, NULL, 'Creazione File Voci Emolumenti', NULL, NULL
, 'F', 'D', 'ACAPARPR', NULL, 1, NULL, NULL); 

INSERT INTO A_CATALOGO_STAMPE ( STAMPA, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_PROPRIETA, TIPO_VISURA,
CLASSE, STAMPA_BLOCCATA, STAMPA_PROTETTA, SEQUENZIALE ) VALUES ( 
'PGPCVOCI', 'SEGNALAZIONI VOCI S7', NULL, NULL, 'U', 'U', 'A_C', 'N', 'N', 'S'); 

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'NUM_CARATTERI', 'PGPCVOCI', 0, 'Caratteri per substring', NULL, NULL, 4, 'C', 'S'
, '110', NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_GESTIONE', 'PGPCVOCI', 1, 'Codice della Gestione', NULL, NULL, 4, 'C', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'SE_SUBSTR', 'PGPCVOCI', 0, 'Abilita substring', NULL, NULL, 2, 'C', 'S', 'SI', NULL
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'SE_UPPER', 'PGPCVOCI', 0, 'Abilita upper', NULL, NULL, 2, 'C', 'S', 'SI', NULL, NULL
, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'TXTFILE', 'PGPCVOCI', 0, 'Nome TXT da produrre', NULL, NULL, 80, 'C', 'S', 'VociEmo2.txt'
, NULL, NULL, NULL, NULL); 

INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCVOCI', 1, 'Creazione file Voci Emolumenti', NULL, NULL, 'Q', 'PGPCVOCI', NULL
, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCVOCI', 91, 'Errori di Elaborazione', NULL, NULL, 'R', 'ACARAPPR', NULL, 'PGPCVOCI'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCVOCI', 92, 'Cancellazione errori', NULL, NULL, 'Q', 'ACACANRP', NULL, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCVOCI', 93, 'Creazione file Voci Emolumenti', NULL, NULL, 'R', 'SI4V3WAS', NULL
, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCVOCI', 94, 'Lista Voci emolumenti esportate', NULL, NULL, 'R', 'PGPLVOCI', NULL
, 'PGPLVOCI', 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCVOCI', 95, 'Cancellazione appoggio stampe', NULL, NULL, 'Q', 'ACACANAS', NULL
, NULL, 'N'); 

INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1012552, 1012559, 'PGPCVOCI', 7, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'AMM', 1012552, 1012559, 'PGPCVOCI', 7, NULL); 

DELETE FROM A_VOCI_MENU WHERE VOCE_MENU    ='PGP4IMPO';
DELETE FROM A_CATALOGO_STAMPE WHERE STAMPA ='PGP4IMPO';
DELETE FROM A_SELEZIONI WHERE VOCE_MENU    ='PGP4IMPO';
DELETE FROM A_PASSI_PROC WHERE VOCE_MENU   ='PGP4IMPO';
DELETE FROM A_MENU WHERE VOCE_MENU         ='PGP4IMPO';

DELETE FROM A_VOCI_MENU WHERE VOCE_MENU    ='PGPCIMPO';
DELETE FROM A_CATALOGO_STAMPE WHERE STAMPA ='PGPCIMPO';
DELETE FROM A_SELEZIONI WHERE VOCE_MENU    ='PGPCIMPO';
DELETE FROM A_PASSI_PROC WHERE VOCE_MENU   ='PGPCIMPO';
DELETE FROM A_MENU WHERE VOCE_MENU         ='PGPCIMPO';

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PGPCIMPO', 'P00', 'CIMPO', NULL, NULL, 'Produzione file Importi', NULL, NULL, 'F'
, 'D', 'ACAPARPR', NULL, 1, NULL, NULL); 

INSERT INTO A_CATALOGO_STAMPE ( STAMPA, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO_PROPRIETA, TIPO_VISURA,
CLASSE, STAMPA_BLOCCATA, STAMPA_PROTETTA, SEQUENZIALE ) VALUES ( 
'PGPCIMPO', 'SEGNALAZIONI VOCI S7', NULL, NULL, 'U', 'U', 'A_C', 'N', 'N', 'S'); 

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'NUM_CARATTERI', 'PGPCIMPO', 0, 'Caratteri per substring', NULL, NULL, 4, 'C', 'S'
, '70', NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_ACCESSORIE', 'PGPCIMPO', 2, '                    Accessorie', NULL, NULL, 1, 'U'
, 'N', NULL, 'P_X', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_DAL', 'PGPCIMPO', 4, 'Dal .........................', NULL, NULL, 10, 'U', 'N'
, NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FISSE', 'PGPCIMPO', 1, 'Competenze ............. Fisse', NULL, NULL, 1, 'U', 'N'
, NULL, 'P_X', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_TUTTE', 'PGPCIMPO', 3, '                      Entrambe', NULL, NULL, 1, 'U', 'N'
, 'X', 'P_X', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'SE_SUBSTR', 'PGPCIMPO', 0, 'Abilita substring', NULL, NULL, 2, 'C', 'S', 'SI', NULL
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'SE_UPPER', 'PGPCIMPO', 0, 'Abilita upper', NULL, NULL, 2, 'C', 'S', 'SI', NULL, NULL
, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'TXTFILE', 'PGPCIMPO', 0, 'Nome TXT da produrre', NULL, NULL, 80, 'C', 'S', 'Importi.txt'
, NULL, NULL, NULL, NULL); 

INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCIMPO', 1, 'Creazione File Importi', NULL, NULL, 'Q', 'PGPCIMPO', NULL, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCIMPO', 91, 'Errori di Elaborazione', NULL, NULL, 'R', 'ACARAPPR', NULL, 'PGPCIMPO'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCIMPO', 92, 'Cancellazione errori', NULL, NULL, 'Q', 'ACACANRP', NULL, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCIMPO', 93, 'Creazione file Importi', NULL, NULL, 'R', 'SI4V3WAS', NULL, NULL
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCIMPO', 94, 'Lista Importi Retribuzioni esportati', NULL, NULL, 'R', 'PGPLIMPO'
, NULL, 'PGPLIMPO', 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PGPCIMPO', 95, 'Cancellazione appoggio stampe', NULL, NULL, 'Q', 'ACACANAS', NULL
, NULL, 'N'); 

INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1012552, 1013050, 'PGPCIMPO', 10, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'AMM', 1012552, 1013050, 'PGPCIMPO', 10, NULL); 






























