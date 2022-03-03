INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'P_ORD', 'A', NULL, 'Alfabetico', NULL, NULL); 
INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'P_ORD', 'C', NULL, 'Cod.Ind.', NULL, NULL); 

INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_LADIC', 1, 'PREN', 'P', NULL, NULL, 'Prenot.', NULL, NULL, NULL, 'ACAEPRPA', '*'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_LADIC', 2, 'GRRA', 'G', NULL, NULL, 'Gruppi', NULL, NULL, NULL, 'PAMDGRRA', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_LADIC', 3, 'CLRA', 'R', NULL, NULL, 'Rapporti', NULL, NULL, NULL, 'PAMDCLRA', NULL
, NULL, NULL, NULL, NULL); 

INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_LADIR', 1, 'PREN', 'P', NULL, NULL, 'Prenot.', NULL, NULL, NULL, 'ACAEPRPA', '*'
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_LADIR', 2, 'GRRA', 'G', NULL, NULL, 'Gruppi', NULL, NULL, NULL, 'PAMDGRRA', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_LADIR', 3, 'CLRA', 'R', NULL, NULL, 'Rapporti', NULL, NULL, NULL, 'PAMDCLRA', NULL
, NULL, NULL, NULL, NULL); 

UPDATE A_VOCI_MENU SET GUIDA_O='P_LADIC'
WHERE  VOCE_MENU='PECLADIC';

UPDATE A_VOCI_MENU SET GUIDA_O='P_LADIR'
WHERE  VOCE_MENU='PECLADIR';

DELETE A_SELEZIONI WHERE VOCE_MENU='PECLADIC';

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_AL', 'PECLADIC', 9, '                      Al', NULL, NULL, 10, 'D', 'N', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_ANNO', 'PECLADIC', 1, 'Elaborazione: Anno', NULL, NULL, 4, 'N', 'N', NULL, NULL
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_DAL', 'PECLADIC', 8, 'Cessazione:  Dal', NULL, NULL, 10, 'D', 'N', NULL, NULL, NULL
, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_GRUPPO', 'PECLADIC', 5, 'Gruppo', NULL, NULL, 12, 'U', 'N', '%', NULL, 'GRRA', 1
, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_MENSILITA', 'PECLADIC', 2, '  Mensilita''', NULL, NULL, 4, 'U', 'N', NULL, NULL
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_NOMINATIVA', 'PECLADIC', 4, 'Elenco Nominativo:', NULL, NULL, 2, 'U', 'S', 'SI'
, 'P_SI_NO', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_ORDINAMENTO', 'PECLADIC', 7, 'Ordinamento per', NULL, NULL, 1, 'U', 'N', 'C', 'P_ORD'
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_RAPPORTO', 'PECLADIC', 6, 'Classe Rapporto', NULL, NULL, 4, 'U', 'N', '%', NULL
, 'CLRA', 1, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_TIPO', 'PECLADIC', 3, 'Tipo Elaborazione:', NULL, NULL, 1, 'U', 'S', 'T', 'P_LADIC'
, NULL, NULL, NULL); 

DELETE A_SELEZIONI WHERE VOCE_MENU='PECLADIR';

INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_AL', 'PECLADIR', 9, '                      Al', NULL, NULL, 10, 'D', 'N', NULL
, NULL, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_ANNO', 'PECLADIR', 1, 'Elaborazione: Anno', NULL, NULL, 4, 'N', 'N', NULL, NULL
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_DAL', 'PECLADIR', 8, 'Cessazione:  Dal', NULL, NULL, 10, 'D', 'N', NULL, NULL, NULL
, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_GRUPPO', 'PECLADIR', 5, 'Gruppo', NULL, NULL, 12, 'U', 'N', '%', NULL, 'GRRA', 1
, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_MENSILITA', 'PECLADIR', 2, '  Mensilita''', NULL, NULL, 4, 'U', 'N', NULL, NULL
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_NOMINATIVA', 'PECLADIR', 4, 'Elenco Nominativo:', NULL, NULL, 2, 'U', 'S', 'SI'
, 'P_SI_NO', NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_ORDINAMENTO', 'PECLADIR', 7, 'Ordinamento per', NULL, NULL, 1, 'U', 'N', 'C', 'P_ORD'
, NULL, NULL, NULL); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_RAPPORTO', 'PECLADIR', 6, 'Classe Rapporto', NULL, NULL, 4, 'U', 'N', '%', NULL
, 'CLRA', 1, 1); 
INSERT INTO A_SELEZIONI ( PARAMETRO, VOCE_MENU, SEQUENZA, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2, LUNGHEZZA, FORMATO, OBBLIGO, VALORE_DEFAULT, DOMINIO, ALIAS, GRUPPO_ALIAS,
NUMERO_FK ) VALUES ( 
'P_TIPO', 'PECLADIR', 3, 'Tipo Elaborazione:', NULL, NULL, 1, 'U', 'S', 'T', 'P_LADIC'
, NULL, NULL, NULL); 






