INSERT INTO A_GUIDE_V ( GUIDA_V, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, VOCE_MENU, VOCE_RIF, PROPRIETA ) VALUES ( 
'P_DER6', 1, NULL, 'E', NULL, NULL, 'Elenco', NULL, NULL, 'PECEVARD', NULL, NULL); 


DELETE A_GUIDE_O WHERE GUIDA_O='P_DER6';

INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,TITOLO_ESTESO_AL2 ) 
VALUES ('P_DER6', 1, 'DELI', 'D', NULL, NULL, 'Delibere', NULL, NULL, 'P_DEL6', NULL, NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,TITOLO_ESTESO_AL2 ) 
VALUES ('P_DER6', 2, 'CLDE', 'T', NULL, NULL, 'Tipi del.', NULL, NULL, NULL, 'PECDCLDE', NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,TITOLO_ESTESO_AL2 ) 
VALUES ('P_DER6', 3, 'MENS', 'M', NULL, NULL, 'Mensilita', NULL, NULL, NULL, 'PECDMENS', NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,TITOLO_ESTESO_AL2 ) 
VALUES ('P_DER6', 4, 'VOCO', 'V', NULL, NULL, 'Voci', NULL, NULL, 'P_VOCO', NULL, NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,TITOLO_ESTESO_AL2 ) 
VALUES ('P_DER6', 5, 'COBI', 'C', NULL, NULL, 'Cod.bil.', NULL, NULL, NULL, 'PECDCOBI', NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,TITOLO_ESTESO_AL2 ) 
VALUES ('P_DER6', 6, 'RAIN', 'I', NULL, NULL, 'Individui', NULL, NULL, NULL, 'P00RANAG', NULL, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,TITOLO_ESTESO_AL2 ) 
VALUES ('P_DER6', 7, 'VARD', 'R', NULL, NULL, 'vaRiabili', NULL, NULL, 'P_DER6', NULL, NULL, NULL, NULL, NULL, NULL); 


