INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_AATGI', 1, 'UNO', 'G', NULL, NULL, 'r.att.Giu', NULL, NULL, NULL, 'PGMRATGI', NULL
, NULL, NULL, NULL, NULL); 

DELETE A_VOCI_MENU WHERE VOCE_MENU='PGMAATGI';

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PGMAATGI', 'P00', 'AATGI', NULL, NULL, 'Aggiornamento Attributi Giuridici', NULL
, NULL, 'F', 'F', 'PGMAATGI', NULL, 1, 'P_AATGI', NULL); 

