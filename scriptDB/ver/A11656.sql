INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_DATA_AGG', 'PECLINRE', 1, 'Data Aggiornamento', NULL, NULL, 10, 'D', 'N', NULL
, NULL, NULL, NULL, NULL); 
update a_voci_menu set MODULO = 'ACAPARPR' where voce_menu = 'PECLINRE';