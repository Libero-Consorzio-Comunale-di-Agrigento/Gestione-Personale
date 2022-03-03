--Att. 16644 e 16646

delete from A_SELEZIONI where voce_menu = 'PECCREIN';

INSERT INTO A_SELEZIONI 
( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK ) 
VALUES ( 'P_ANNO', 'PECCREIN', 1, 'Anno', 4, 'N', 'N', NULL, NULL, NULL, NULL, NULL); 

INSERT INTO A_SELEZIONI 
( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK ) 
VALUES ( 'P_POS_INAIL', 'PECCREIN', 2, '              Posizione INAIL', 12, 'U', 'S', '%', NULL, NULL, NULL, NULL); 

INSERT INTO A_SELEZIONI 
( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK ) 
VALUES ( 'P_GESTIONE', 'PECCREIN', 3, '              Gestione', 4, 'U', 'S', '%', NULL, 'GEST', 1, 1); 

INSERT INTO A_SELEZIONI 
( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK ) 
VALUES ( 'P_TIPO', 'PECCREIN', 4, 'Tipo di calcolo', 1, 'U', 'N', 'C', 'CREIN_TIPO', NULL, NULL, NULL); 

INSERT INTO A_SELEZIONI 
( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK ) 
VALUES ( 'P_TIPO_ELAB', 'PECCREIN', 5, 'Tipo di elaborazione', 1, 'U', 'N', 'P', 'CREIN_TIPO_ELAB', NULL, NULL, NULL); 

INSERT INTO A_SELEZIONI 
( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS, NUMERO_FK ) 
VALUES ( 'P_CI', 'PECCREIN', 6, 'Cod.Ind.', 8, 'C', 'N', NULL, NULL, NULL, NULL, NULL); 


start crp_peccrein.sql