delete a_errori where errore in ('P00156','P00154','P00155');

INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,PROPRIETA ) VALUES ('P00156', 'Note P.T. non indicate per DMA che sarà compilata in base alla posizione', NULL, NULL, NULL); 
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,PROPRIETA ) VALUES ('P00155', 'Periodo con riduzione oraria (non Part Time)', NULL, NULL, NULL); 
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,PROPRIETA ) VALUES ('P00154', 'Periodo in posizione Part Time senza indicazione delle riduzione oraria', NULL, NULL, NULL); 
