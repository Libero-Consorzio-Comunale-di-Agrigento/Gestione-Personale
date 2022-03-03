delete from CASELLE_FISCALI
where anno = 2004
and sequenza = 129
and tipo_dichiarazione = 'S'
/
INSERT INTO CASELLE_FISCALI ( ANNO, TIPO_DICHIARAZIONE, SEQUENZA, DESCRIZIONE, TIPO_CASELLA,CASELLA_DETT )
values ( 2004, 'S', 129, 'Casella 132 TFR', 'T', NULL); 

COMMIT;

