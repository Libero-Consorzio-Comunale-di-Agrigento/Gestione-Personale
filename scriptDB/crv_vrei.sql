create or replace view vista_retribuzioni_inail
(anno, gestione, posizione, des_posizione, esenzione, tipo, retribuzione, parz_esente, tot_esente)
as
select anno
      ,gestione
      ,posizione_inail
      ,gp4_asin.get_descrizione(posizione_inail)
      ,esenzione
      ,tipo_ipn
      ,sum(imponibile) retribuzione
      ,sum(decode(gp4_alei.get_aliquota(esenzione, anno)
                 ,100
                 ,0
                 ,imponibile * gp4_alei.get_aliquota(esenzione, anno) / 100)) parz_esente
      ,sum(decode(gp4_alei.get_aliquota(esenzione, anno), 100, imponibile, 0)) tot_esente
  from retribuzioni_inail
 group by anno
         ,gestione
         ,posizione_inail
         ,esenzione
         ,tipo_ipn;

