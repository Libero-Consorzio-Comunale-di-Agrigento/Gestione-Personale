start crf_rire_cambio_anno.sql

 insert into a_errori
 (errore,descrizione)
 values ('P05785','Attenzione: indicare una nota');

 insert into a_errori
 (errore,descrizione)
 values ('P05786','Anno e Mensilita'' obbligatori entrambi o entrambi nulli');

 insert into a_errori
 (errore,descrizione)
 values ('P05787','Mensilita'' obbligatoria se indicato l''anno');

 insert into a_errori
 (errore,descrizione)
 values ('P05791','L''anno non puo'' essere inferiore all''anno di riferimento');

 insert into a_errori
 (errore,descrizione)
 values ('P05784','Attenzione: calendario definito fino all''anno ');
