delete from a_voci_menu where voce_menu in ('PECDASF6'); 

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PECDASF6', 'P00', 'DASF6', NULL, NULL, 'Assegni Familiari', NULL, NULL, 'F', 'F'
, 'PECDASF6', NULL, 1, NULL, NULL); 

delete from a_menu where voce_menu in ('PECDASF6') AND APPLICAZIONE = 'GP4';

INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1000351, 1013726, 'PECDASF6', 92, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'AMM', 1000351, 1013726, 'PECDASF6', 92, NULL); 


