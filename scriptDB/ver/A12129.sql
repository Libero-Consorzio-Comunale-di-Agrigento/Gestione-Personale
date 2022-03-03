insert into a_errori
( errore, descrizione, descrizione_al1, descrizione_al2, proprieta )
values
( 'P05053','Impossibile inserire una mensilità precedente a quella attuale ','','','');

update a_voci_menu 
set tipo_voce = 'A'
where voce_menu = 'PECAVARD';
