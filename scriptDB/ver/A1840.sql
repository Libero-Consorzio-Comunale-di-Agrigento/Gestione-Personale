-- Ridefinizione ALIAS nella guida orizzontale

DELETE 
  FROM A_GUIDE_O
 WHERE GUIDA_O = 'P_BIPR_S'
; 


INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_BIPR_S', 1, 'PREN', 'P', NULL, NULL, 'Prenot.', NULL, NULL, NULL, 'ACAEPRPA', '*'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_BIPR_S', 2, 'RIRE', 'V', NULL, NULL, 'Versione', NULL, NULL, NULL, 'PECRMEPR', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_BIPR_S', 3, 'GEST', 'D', NULL, NULL, 'Divisione', NULL, NULL, NULL, 'PGMEGEST'
, NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_BIPR_S', 4, 'GEST', 'S', NULL, NULL, 'Sezione', NULL, NULL, NULL, 'PGMEGEST', NULL
, NULL, NULL, NULL, NULL); 


--ridefinizione parametri della stampa PECLMOPR

DELETE 
  FROM A_SELEZIONI
 WHERE VOCE_MENU = 'PECLMOPR'
; 


INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_ANNO', 'PECLMOPR', 1, 'Elaborazione:   Anno', NULL, NULL, 4, 'N', 'N', NULL, NULL
, 'RIRE', 1, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_1', 'PECLMOPR', 3, 'Raggruppamento: Divisione', NULL, NULL, 4, 'U', 'S'
, '%', NULL, 'GEST', 1, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_2', 'PECLMOPR', 4, '                Sezione', NULL, NULL, 4, 'U', 'S', '%'
, NULL, 'GEST', 2, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_MENSILITA', 'PECLMOPR', 2, '                Versione', NULL, NULL, 4, 'U', 'N'
, NULL, NULL, 'RIRE', 1, 2);


--ridefinizione parametri della stampa PECSBIPR

DELETE 
  FROM A_SELEZIONI
 WHERE VOCE_MENU = 'PECSBIPR'
; 

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_ANNO', 'PECSBIPR', 1, 'Elaborazione  : Anno', NULL, NULL, 4, 'N', 'N', NULL, NULL
, 'RIRE', 1, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_1', 'PECSBIPR', 3, 'Raggruppamento: Divisione', NULL, NULL, 4, 'U', 'S'
, '%', NULL, 'GEST', 1, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_2', 'PECSBIPR', 4, '                Sezione', NULL, NULL, 4, 'U', 'S', '%'
, NULL, 'GEST', 2, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_MENSILITA', 'PECSBIPR', 2, '                Versione', NULL, NULL, 4, 'U', 'N'
, NULL, NULL, 'RIRE', 1, 2); 
 

