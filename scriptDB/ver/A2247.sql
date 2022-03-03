INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_DCLBU', 1, 'CLBU', '1', NULL, NULL, 'Budget', NULL, NULL, NULL, 'PECDCLBU', NULL
, NULL, NULL, NULL, NULL); 

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PECCPRAG', 'P00', 'CPRAG', NULL, NULL, 'Gestione delle Previsioni Aggiuntive', NULL
, NULL, 'F', 'D', 'ACAPARPR', NULL, 1, 'P_DCLBU', NULL); 

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_BUDGET', 'PECCPRAG', 3, 'Codice Budget da cancellare', NULL, NULL, 4, 'U', 'N'
, NULL, NULL, 'CLBU', 1, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_CI', 'PECCPRAG', 1, 'Codice Ind. della Previsione', NULL, NULL, 8, 'N', 'N', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_TIPO', 'PECCPRAG', 2, 'Cancel. Previsioni Aggiuntive', NULL, NULL, 1, 'U', 'N'
, NULL, 'P_X', NULL, NULL, NULL); 

INSERT INTO A_PASSI_PROC ( VOCE_MENU, PASSO, TITOLO, TITOLO_AL1, TITOLO_AL2, TIPO, MODULO, STRINGA,
STAMPA, GRUPPO_LING ) VALUES ( 
'PECCPRAG', 1, 'Gestione delle Previsioni Aggiuntive', NULL, NULL, 'Q', 'PECCPRAG'
, NULL, NULL, 'N'); 

INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1002513, 1013607, 'PECCPRAG', 12, NULL); 

INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'XXXXXX', 'Il ci selezionato non puo essere cancellato', NULL, NULL, NULL); 