DELETE FROM A_SELEZIONI WHERE VOCE_MENU = 'PECCO1MD'
;

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) 
VALUES ( 'P_TIPO_DENUNCIA', 'PECCO1MD', 0, 'Tipo Denuncia', NULL, NULL, 10, 'U', 'N', '770'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) 
VALUES ( 'P_ANNO', 'PECCO1MD', 1, 'Anno di Elaborazione:', NULL, NULL, 4, 'N', 'N', NULL, NULL
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) 
VALUES ( 'P_GESTIONE', 'PECCO1MD', 2, 'Gestione:', NULL, NULL, 4, 'U', 'S', '%', NULL, 'GEST'
, 1, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) 
VALUES ( 'P_TIPO', 'PECCO1MD', 3, 'Archiviazione: Tipo', NULL, NULL, 1, 'U', 'S', 'P', 'P_CARCP'
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) 
VALUES ( 'P_GENNAIO', 'PECCO1MD', 4, 'Competenza', NULL, NULL, 1, 'U', 'N', NULL, 'P_X', NULL
, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) 
VALUES ( 'P_DAL', 'PECCO1MD', 5, 'Periodo cessazione: Dal', NULL, NULL, 10, 'D', 'N', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) 
VALUES ( 'P_AL', 'PECCO1MD', 6, 'Al', NULL, NULL, 10, 'D', 'N', NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) 
VALUES ( 'P_RUOLO', 'PECCO1MD', 7, 'Solo Personale non di Ruolo:', NULL, NULL, 1, 'U', 'N'
, 'X', 'P_X', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) 
VALUES ( 'P_INCARICO', 'PECCO1MD', 8, 'Periodi di Incarico:', NULL, NULL, 1, 'U', 'N', NULL
, 'P_X', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) 
VALUES ( 'P_CI', 'PECCO1MD', 9, 'Singolo Individuo : Codice', NULL, NULL, 8, 'N', 'N', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) 
VALUES ( 'P_TIPO_GG', 'PECCO1MD', 10, 'Tipo Giorni:', NULL, NULL, 1, 'U', 'S', 'I', 'P_TIPO_GG'
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) 
VALUES ( 'P_RETRIBUZIONE', 'PECCO1MD', 11, 'Calcolo Retribuzione Ridotta', NULL, NULL, 1, 'U'
, 'S', 'F', 'P_RETRIBUZIONE', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) 
VALUES ( 'P_ASSESTAMENTO', 'PECCO1MD', 12, 'Assestamento dati Quadro D', NULL, NULL, 1, 'U'
, 'N', 'X', 'P_X', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) 
VALUES ( 'P_SPEZZA', 'PECCO1MD', 13, 'Assestamento Arr. AP', NULL, NULL, 1, 'U', 'N', NULL
, 'P_X', NULL, NULL, NULL); 
COMMIT;

update a_voci_menu set guida_o = 'A_PARA'
where voce_menu = 'PECCO1MD';

start crp_peccao1m.sql
start crp_pecco1md.sql