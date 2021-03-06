delete from a_selezioni where voce_menu = 'PECSDEDI';

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_CI', 'PECSDEDI', 1, 'Codice Individuale............', NULL, NULL, 8, 'N', 'S', NULL
, NULL, 'RAIN', 1, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FIRMATARIO', 'PECSDEDI', 4, 'Firmatario....................', NULL, NULL, 8, 'N'
, 'N', NULL, NULL, 'RAIN', 2, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_MODELLO', 'PECSDEDI', 2, 'Modello Stampa................', NULL, NULL, 4, 'U', 'S'
, NULL, 'D_SDEDI', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_TELEFONO', 'PECSDEDI', 3, 'Numero di Telefono............', NULL, NULL, 16, 'U'
, 'N', NULL, NULL, NULL, NULL, NULL);
