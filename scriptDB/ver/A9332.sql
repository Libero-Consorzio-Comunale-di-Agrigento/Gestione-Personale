DELETE 
  FROM a_voci_menu
 WHERE voce_menu = 'PECDDECF';

INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PECDDECF', 'P00', 'DDECF', NULL, NULL, 'Deduzione Fiscale per Carico Familiare'
, NULL, NULL, 'F', 'F', 'PECDDECF', NULL, 1, 'P_DECF', NULL); 

DELETE 
  FROM a_guide_o
 WHERE guida_o = 'P_DECF'
   AND sequenza = 2;

INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_DECF', 2, 'DEFI', 'A', NULL, NULL, 'Alt.dedu.', NULL, NULL, NULL, 'PECDDEFI', NULL
, NULL, NULL, NULL, NULL); 

