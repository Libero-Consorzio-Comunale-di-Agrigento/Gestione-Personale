DELETE A_SELEZIONI 
WHERE VOCE_MENU='PECLIMCE' 
AND PARAMETRO='P_DATA_REGISTRAZIONE';

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_DATA_REGISTRAZIONE', 'PECLIMCE', 1, 'Data Registrazione', NULL, NULL, 10, 'D', 'S'
, NULL, NULL, NULL, NULL, NULL); 

COMMIT;
