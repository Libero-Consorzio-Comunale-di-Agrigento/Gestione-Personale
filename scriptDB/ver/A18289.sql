create table tipe_ante_18289
as select * from titoli_personali;

create table anag_ante_18289
as select ni, dal, titolo from anagrafici;

insert into TIPI_TITOLO
( TITOLO, DESCRIZIONE )
select SEQUENZA
     , max(TITOLO)
  from titoli_personali tipe
 where not exists ( select 'x'
                      from tipi_titolo
                     where titolo = to_char(tipe.sequenza)
                  )
group by SEQUENZA
;

insert into a_errori ( errore, descrizione )
values ( 'P01012', 'Titolo non codificato')
;

alter table anagrafici disable all triggers;

create table anag_prima_della_18289
    as select * from anagrafici;

update anagrafici anag
   set titolo = ( select sequenza 
                    from titoli_personali
                   where titolo = anag.titolo
                )
 where titolo is not null
   and exists ( select 'x'
                    from titoli_personali
                   where titolo = anag.titolo
                )
;

alter table anagrafici enable all triggers;

drop table titoli_personali;

-- cancellazione dalle tabelle di controllo indici
DELETE FROM SIA_DEFAULT_INDICI WHERE TABLE_NAME = 'TITOLI_PERSONALI';
DELETE FROM SIA_DEFAULT_INDICI_COL WHERE TABLE_NAME = 'TITOLI_PERSONALI';

start crv_tipe.sql

-- cancellazione della PAMDTIPE da menu e abilitazione solo da menu funzioni 
-- utilizzata solo in versione WIN

delete from a_voci_menu where voce_menu = 'PAMDTIPE';
delete from a_menu where voce_menu = 'PAMDTIPE';

insert into a_voci_menu (voce_menu,ambiente,acronimo,titolo,tipo_voce,tipo,modulo,stringa,importanza,guida_o)
values ('PAMDTIPE','P00','DTIPE','Dizionario dei Titoli Onorifici','A','F','PAMDTIPE','',1,'');

insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','*','1004367','1013876','PAMDTIPE','11','');
insert into a_menu (applicazione,ruolo,padre,figlio,voce_menu,sequenza,stampante) 
values ('GP4','AMM','1004367','1013876','PAMDTIPE','11','');
