DELETE A_DOMINI_SELEZIONI WHERE DOMINIO='P_LNDMA_DET';

INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'P_LNDMA_DET', 'M', NULL, 'Raggruppato su base Mensile', NULL, NULL); 
INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'P_LNDMA_DET', 'P', NULL, 'Stampa Progressiva dei mesi', NULL, NULL); 
INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'P_LNDMA_DET', 'T', NULL, 'Tutti i record', NULL, NULL); 
