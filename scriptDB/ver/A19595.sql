INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_DTAVA', 2, 'CONT', 'C', NULL, NULL, 'Contratti', NULL, NULL, NULL, 'PGMDCONT', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_DTAVA', 1, 'GEST', 'G', NULL, NULL, 'Gestioni', NULL, NULL, NULL, 'PGMDGEST', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_DTAVA', 3, 'QUGI', 'Q', NULL, NULL, 'Qualifica', NULL, NULL, NULL, 'PGMDQUAL', NULL
, NULL, NULL, NULL, NULL); 

delete A_VOCI_MENU where VOCE_MENU='PMTDTAVA';

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PMTDTAVA', 'P00', 'DTAVA', NULL, NULL, 'Dizionario Tabelle Valori', NULL, NULL, 'F'
, 'F', 'PMTDTAVA', NULL, 1, 'P_DTAVA', NULL); 