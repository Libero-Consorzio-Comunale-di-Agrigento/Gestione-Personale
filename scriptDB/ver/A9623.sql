start crp_pecsmcud.sql
start crp_pecdtbfa.sql

--PXXSMCU4

DELETE
  FROM a_passi_proc
 WHERE voce_menu = 'PXXSMCU4';


INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PXXSMCU4', 1, 'Estrazione dati per Stampa CUD', NULL, NULL, 'Q', 'PECSMCUD', NULL
, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PXXSMCU4', 2, 'Lista Anomalie CUD', NULL, NULL, 'R', 'PECANCUD', NULL, 'PECANCUD'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PXXSMCU4', 3, 'Stampa Modulo Certificazione Redditi', NULL, NULL, 'R', 'PECSMCU4'
, NULL, 'PECSMCU4', 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PXXSMCU4', 4, 'Stampa Informativa CUD', NULL, NULL, 'R', 'PECSICU4', NULL, 'PECSICU4'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PXXSMCU4', 5, 'Stampa Allegato Annotazioni', NULL, NULL, 'R', 'PECALCUD', NULL, 'PECALCUD'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PXXSMCU4', 6, 'Stampa Lista Firme', NULL, NULL, 'R', 'PECLMCUD', NULL, 'PECLMCUD'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PXXSMCU4', 7, 'Stampa Etichette CUD', NULL, NULL, 'R', 'PECSECU3', NULL, 'PECSECU3'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PXXSMCU4', 8, 'Eliminazione registrazioni di lavoro', NULL, NULL, 'Q', 'ACACANAS'
, NULL, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PXXSMCU4', 9, 'Pulizia tabella tab_report_fine_anno', NULL, NULL, 'Q', 'PECDTBFA'
, NULL, NULL, 'N'); 
COMMIT;

-- PECSMCUD

DELETE
  FROM a_passi_proc
 WHERE voce_menu = 'PECSMCUD';


INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSMCUD', 1, 'Estrazione dati per Stampa CUD', NULL, NULL, 'Q', 'PECSMCUD', NULL
, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSMCUD', 2, 'Lista Anomalie CUD', NULL, NULL, 'R', 'PECANCUD', NULL, 'PECANCUD'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSMCUD', 3, 'Stampa Modulo Certificazione Redditi', NULL, NULL, 'R', 'PECSMCUD'
, NULL, 'PECSMCUD', 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSMCUD', 4, 'Stampa Allegato Annotazioni', NULL, NULL, 'R', 'PECALCUD', NULL, 'PECALCUD'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSMCUD', 5, 'Stampa Lista Firme', NULL, NULL, 'R', 'PECLMCUD', NULL, 'PECLMCUD'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSMCUD', 6, 'Stampa Etichette CUD', NULL, NULL, 'R', 'PECSECU3', NULL, 'PECSECU3'
, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSMCUD', 7, 'Eliminazione registrazioni di lavoro', NULL, NULL, 'Q', 'ACACANAS'
, NULL, NULL, 'N'); 
INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECSMCUD', 8, 'Pulizia tabella tab_report_fine_anno', NULL, NULL, 'Q', 'PECDTBFA'
, NULL, NULL, 'N'); 
COMMIT;

