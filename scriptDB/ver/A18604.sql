create table anag_ante_18604 
    as select * from anagrafici
;

alter table anagrafici disable all triggers;
alter table rapporti_individuali disable all triggers;

update anagrafici anag
   set tipo_soggetto = 'S'
 where exists (select 'x'
                 from unita_organizzative unor
                where  unor.ni = anag.ni
              )
   and tipo_soggetto='E'
   and nvl(ambiente_prop,'GP4') in ( 'GP4','P00')
;


update rapporti_individuali rain
   set tipo_ni = 'S'
 where tipo_ni = 'E'
   and ni in ( select ni 
                 from anagrafici
                where nvl(ambiente_prop,'GP4') in ( 'GP4','P00')
                  and tipo_soggetto = 'S'
              )
;

alter table anagrafici enable all triggers;
alter table rapporti_individuali enable all triggers;

update tipi_soggetto
   set descrizione = 'Soggetto'
 where tipo_soggetto='S';

start crp_gp4gm.sql
start crf_gp4gm.sql
start crf_set_tipo_soggetto.sql