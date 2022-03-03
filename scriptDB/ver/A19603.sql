DELETE A_GUIDE_O WHERE GUIDA_O='P_CGLUF';

INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_CGLUF', 1, 'RIRI', 'R', NULL, NULL, 'Richieste', NULL, NULL, NULL, 'PMTIRICH', NULL
, NULL, NULL, NULL, NULL); 

DELETE A_VOCI_MENU WHERE VOCE_MENU='PMTCGLUF';

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PMTCGLUF', 'P00', 'CGLUF', NULL, NULL, 'Controllo Globale Ufficio', NULL, NULL, 'F'
, 'F', 'PMTCGLUF', NULL, 1, 'P_CGLUF', NULL); 

INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P00238', 'Fine Selezione Globale dei record', NULL, NULL, NULL); 
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P00237', 'Inizio Selezione Globale dei record', NULL, NULL, NULL); 
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P00236', 'Fine Controllo Globale dei record selezionati', NULL, NULL, NULL); 
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P00235', 'Inizio Controllo Globale dei record selezionati', NULL, NULL, NULL); 

