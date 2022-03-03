INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'P_SUDD_1_4', '1', '4', 'Livello di Suddivisione settoriale', NULL, NULL);

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_APPR_LIVELLO', 'PDOSDOEF', 15, 'Liv. di Appr. per Assegnazione', NULL, NULL, 1
, 'N', 'N', NULL, 'P_SUDD_1_4', NULL, NULL, NULL); 


start crp_gp4_reuo.sql
start crv_dodi.sql
start crv_dofa.sql
start crv_dodu.sql
start crv_dofu.sql
start crv_dnfa.sql
start crv_dndi.sql
