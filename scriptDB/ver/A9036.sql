INSERT INTO A_DOMINI_SELEZIONI ( DOMINIO, VALORE_LOW, VALORE_HIGH, DESCRIZIONE, DESCRIZIONE_AL1,
DESCRIZIONE_AL2 ) VALUES ( 
'CREIN_TIPO_ELAB', 'S', NULL, 'Singolo Individuo', NULL, NULL); 

update a_voci_menu 
set guida_o = 'A_PARA'
where voce_menu = 'PECCREIN';

start crp_peccrein.sql
