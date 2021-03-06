--INSERIMENTO NUOVA FORM PECAINAF
INSERT INTO A_VOCI_MENU ( VOCE_MENU, AMBIENTE, ACRONIMO, ACRONIMO_AL1, ACRONIMO_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, TIPO_VOCE, TIPO, MODULO, STRINGA, IMPORTANZA, GUIDA_O,
PROPRIETA ) VALUES ( 
'PECAINAF', 'P00', 'AINAF', NULL, NULL, 'Informazioni Addizionali Fiscali', NULL, NULL
, 'A', 'F', 'PECAINAF', NULL, 1, NULL, NULL);

INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', '*', 1004365, 1013828, 'PECAINAF', 99, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'AMM', 1004365, 1013828, 'PECAINAF', 99, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'PEC', 1004365, 1013828, 'PECAINAF', 99, NULL); 
INSERT INTO A_MENU ( APPLICAZIONE, RUOLO, PADRE, FIGLIO, VOCE_MENU, SEQUENZA,
STAMPANTE ) VALUES ( 
'GP4', 'SVI', 1004365, 1013828, 'PECAINAF', 99, NULL); 

INSERT INTO A_GUIDE_O ( GUIDA_O, SEQUENZA, ALIAS, LETTERA, LETTERA_AL1, LETTERA_AL2, TITOLO,
TITOLO_AL1, TITOLO_AL2, GUIDA_V, VOCE_MENU, VOCE_RIF, PROPRIETA, TITOLO_ESTESO, TITOLO_ESTESO_AL1,
TITOLO_ESTESO_AL2 ) VALUES ( 
'P_INEX', 8, 'INAF', 'I', NULL, NULL, 'Inf.add.f', NULL, NULL, NULL, 'PECAINAF', NULL
, NULL, NULL, NULL, NULL);

--Inserimento REF-CODES
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'1', NULL, NULL, 'INFORMAZIONI_ADD_FISCALI.TIPO_CARICO', 'Totalmente a Carico', 'CFG'
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'2', NULL, NULL, 'INFORMAZIONI_ADD_FISCALI.TIPO_CARICO', 'Parzialmente a Carico', 'CFG'
, NULL, NULL);

start crt_inaf.sql