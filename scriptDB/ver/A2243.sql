update a_voci_menu
set modulo = 'ACAPARPR'
where voce_menu = 'PECCMOPR';


INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_CANCELLA', 'PECCMOPR', 1, 'Cancel. Dettaglio Individuale', NULL, NULL, 1, 'C', 'N'
, 'X', NULL, NULL, NULL, NULL); 
