/* Eliminazione Vecchia Voce Menu PECCADDI */
delete from a_menu 
where voce_menu = 'PECCADDI';

delete from a_selezioni
where voce_menu = 'PECCADDI';

delete from a_passi_proc
where voce_menu = 'PECCADDI';

delete from a_voci_menu 
where voce_menu = 'PECCADDI';

/* Nuova Variabile di DESRE */
INSERT INTO ESTRAZIONE_VALORI_CONTABILI ( ESTRAZIONE, COLONNA, DAL, AL, DESCRIZIONE,
DESCRIZIONE_AL1, DESCRIZIONE_AL2, SEQUENZA, NOTE, MOLTIPLICA, ARROTONDA, DIVIDE, NOTE_AL1,
NOTE_AL2 ) VALUES ( 
'DISOCCUPAZIONE_INPS', 'VARIABILI',  TO_Date( '01/01/1940 12:00:00 AM', 'MM/DD/YYYY HH:MI:SS AM')
, NULL, NULL, NULL, NULL, 4, NULL, NULL, NULL, NULL, NULL, NULL);

start crp_PECCDS22.sql