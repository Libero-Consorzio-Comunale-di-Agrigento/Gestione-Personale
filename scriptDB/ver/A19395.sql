/* NUOVA GUIDA ORIZZONTALE ESTMS */
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_STMS', 1, 'STMS', 'R', NULL, NULL, 'Rettifica', NULL, NULL, NULL, 'PECDSTMS', NULL
, NULL, NULL, NULL, NULL); 

/* NUOVA FORM PECESTMS */
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PECESTMS', 'P00', 'ESTMS', NULL, NULL, 'Elenco Modelli Stampa', NULL, NULL, 'F', 'F'
, 'PECESTMS', NULL, 1, 'P_STMS', NULL); 

/* ABILITAZIONE NUOVA from PECESTMS */
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1000352, 1013871, 'PECESTMS', 2, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'AMM', 1000352, 1013871, 'PECESTMS', 2, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'PEC', 1000352, 1013871, 'PECESTMS', 2, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'SVI', 1000352, 1013871, 'PECESTMS', 2, NULL); 

/* GUIDA P_CED6 */
delete from A_GUIDE_O where GUIDA_O = 'P_CED6';

INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_CED6', 1, 'PREN', 'P', NULL, NULL, 'Prenot.', NULL, NULL, NULL, 'ACAEPRPA', '*'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_CED6', 2, 'RIRE', 'M', NULL, NULL, 'Mese', NULL, NULL, NULL, 'PECRMERE', NULL, NULL
, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_CED6', 3, 'RAIN', 'I', NULL, NULL, 'Individuo', NULL, NULL, NULL, 'P00RANAG', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_CED6', 4, 'RECE', 'G', NULL, NULL, 'raGgrupp.', NULL, NULL, NULL, 'PECERECE', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_CED6', 5, 'STMS', 'D', NULL, NULL, 'moDello', NULL, NULL, NULL, 'PECESTMS', NULL
, NULL, NULL, NULL, NULL); 

/* GUIDA P_SMOR6 */
delete from A_GUIDE_O where GUIDA_O = 'P_SMOR6';

INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_SMOR6', 1, 'STMS', 'D', NULL, NULL, 'moDello', NULL, NULL, NULL, 'PECESTMS', NULL
, NULL, NULL, NULL, NULL);

/* PARAMETRI PECSCER6 */
delete from a_selezioni where voce_menu = 'PECSCER6';

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_PRG_CEDOLINO', 'PECSCER6', 0, 'Progressivo Temporaneo', NULL, NULL, 8, 'N', 'N'
, NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_ANNO_ELA', 'PECSCER6', 1, 'Elaborazione   : Anno', NULL, NULL, 4, 'N', 'N', NULL
, NULL, 'RIRE', 1, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_MENSILITA_ELA', 'PECSCER6', 2, '                Cod.Mensilita`', NULL, NULL, 4
, 'U', 'N', NULL, NULL, 'RIRE', 1, 2); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_RICHIESTA', 'PECSCER6', 3, '                 Tipo', NULL, NULL, 1, 'U', 'S', 'T'
, 'P_CERE_TIPO', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_1', 'PECSCER6', 4, 'Raggruppamento : 1)', NULL, NULL, 15, 'U', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_2', 'PECSCER6', 5, '                 2)', NULL, NULL, 15, 'U', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_3', 'PECSCER6', 6, '                 3)', NULL, NULL, 15, 'U', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FILTRO_4', 'PECSCER6', 7, '                 4)', NULL, NULL, 15, 'U', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_CI', 'PECSCER6', 8, 'Individuale    : Codice', NULL, NULL, 8, 'N', 'N', NULL, NULL
, 'RAIN', 0, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_GR_LING', 'PECSCER6', 9, 'Gr.Linguistico richiesto', NULL, NULL, 1, 'U', 'S', '%'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_NUM_STAMPA', 'PECSCER6', 10, 'Numero Stampa :', NULL, NULL, 8, 'N', 'N', NULL, NULL
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_TIPO_DESFORMAT', 'PECSCER6', 11, 'Tipo stampa', NULL, NULL, 4, 'U', 'S', 'PDF'
, 'P_SCER6', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FRONTE_RETRO', 'PECSCER6', 12, 'Stampa in Fronte/Retro', NULL, NULL, 2, 'U', 'N'
, NULL, 'P_SI_NO', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_MODELLO_STAMPA', 'PECSCER6', 13, 'Modello Stampa', NULL, NULL, 8, 'U', 'N', NULL
, NULL, 'STMS', NULL, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_INTERNA', 'PECSCER6', 14, 'Stampa Uso Interno', NULL, NULL, 1, 'U', 'N', 'X', 'P_X'
, NULL, NULL, NULL); 

/* PARAMETRI PECSMOR6*/
delete from a_selezioni where voce_menu = 'PECSMOR6';

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_STALIAS', 'PECSMOR6', 0, 'Directory Stampe', NULL, NULL, 20, 'U', 'N', 'P00SVI'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_TIPO_DESFORMAT', 'PECSMOR6', 1, 'Tipo stampa', NULL, NULL, 4, 'U', 'S', 'PDF', 'P_SCER6'
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_FRONTE_RETRO', 'PECSMOR6', 2, 'Stampa in Fronte/Retro', NULL, NULL, 2, 'U', 'N'
, NULL, 'P_SI_NO', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_MODELLO_STAMPA', 'PECSMOR6', 3, 'Modello Stampa', NULL, NULL, 8, 'U', 'N', NULL
, NULL, 'STMS', NULL, 1); 

