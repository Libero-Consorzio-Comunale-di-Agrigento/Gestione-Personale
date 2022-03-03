-- aggiornamento su anagrafici tipo_soggetto null
alter table anagrafici disable all triggers;

update anagrafici 
   set tipo_soggetto = decode(nome, null, 'E', 'I')
 where tipo_soggetto is null
;

alter table anagrafici enable all triggers;

-- aggiornamento su rapporti_individuali per tipo_ni null
alter table rapporti_individuali disable all triggers;

update  rapporti_individuali 
   set tipo_ni = decode(nome, null, 'E', 'I')
 where tipo_ni is null
;

alter table  rapporti_individuali enable all triggers;

start crf_set_tipo_soggetto.sql