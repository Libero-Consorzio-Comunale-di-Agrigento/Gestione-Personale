delete from a_selezioni
where voce_menu = 'PECSDDRE' 
and parametro = 'P_SOSPENSIONE';

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_SOSPENSIONE', 'PECSDDRE', 5, 'Escludi Rate Sospese', NULL, NULL, 1, 'U'
, 'N', NULL, 'P_X', NULL, NULL, NULL); 

