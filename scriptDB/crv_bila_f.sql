create or replace view bilancio
     ( divisione
     , esercizio
     , e_s
     , capitolo
     , articolo
     , gestione
     , sede_del
     , anno_del
     , numero_del
     , impegno
     , sub
     , funzionale
     , soggetto
     ) as
select divisione
     , esercizio
     , e_s
     , capitolo
     , articolo
     , gestione
     , sede_del
     , anno_del
     , numero_del
     , impegno
     , sub
     , funzionale
     , soggetto
  from f_bilancio
/ 
