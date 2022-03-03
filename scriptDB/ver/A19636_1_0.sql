DELETE A_ERRORI WHERE ERRORE IN ('P05716','P05717');



INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P05716', 'Il Codice Regione va indicato in Presenza di Addizionale Regionale', NULL
, NULL, 'B'); 
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P05717', 'L''addizionale Regionale va indicata in Presenza di Codice Regionale', NULL
, NULL, 'B'); 
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P05753', 'Il Codice Comune va indicato in Presenza di Addizionale Comunale', NULL
, NULL, 'B'); 
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P05754', 'L''addizionale Comunale va indicata in Presenza di Codice Comunale', NULL
, NULL, 'B'); 

 

