-- Attività 13005
INSERT INTO A_ERRORI ( ERRORE, DESCRIZIONE, DESCRIZIONE_AL1, DESCRIZIONE_AL2,
PROPRIETA ) VALUES ( 
'P00150', 'Valore non numerico', NULL, NULL, NULL)
/
alter table variabili_attributo
add valore_default varchar2(30)
/
