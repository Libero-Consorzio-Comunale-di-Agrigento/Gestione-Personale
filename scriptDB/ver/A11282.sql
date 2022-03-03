INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'P_SMTT', 'D', NULL, 'Stampa Dettaglio + Totale', NULL, NULL); 
INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'P_SMTT', 'T', NULL, 'Stampa solo Totale Ente', NULL, NULL); 

update a_selezioni set dominio = 'P_SMTT' 
 where parametro = 'P_TOT' 
   and voce_menu in ('PECSMTT1','PECSMTT2','PECSMTT3'
                    ,'PECSMTT4','PECSMTT5','PECSMTT6'
                    ,'PECSMTT7','PECSMTT8','PECSMTT9'
                    ,'PECSMT11','PECSMT12','PECSMT13');
