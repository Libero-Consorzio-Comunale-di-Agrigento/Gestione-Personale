create or replace view vista_autoliquidazione
(anno, gestione, posizione, des_posizione, pat, voce_rischio, des_voce_rischio, percentuale_ponderazione, esenzione, tipo_ipn, retribuzione, retribuzione_parz_esente, retribuzione_tot_esente)
as
select trei.anno anno
      ,trei.gestione gestione
      ,trei.posizione_inail posizione
      ,gp4_asin.get_descrizione(trei.posizione_inail) des_posizione
      ,asin.posizione
      ,poin.voce_rischio voce
      ,gp4_vori.get_descrizione(poin.voce_rischio) des_voce
      ,max(poin.aliquota) percentuale_ponderazione
      ,trei.esenzione
      ,trei.tipo_ipn
      ,sum(trei.imponibile) * max(poin.aliquota) / 100
      ,sum(decode(gp4_alei.get_aliquota(trei.esenzione, trei.anno)
                 ,100
                 ,0
                 ,trei.imponibile * gp4_alei.get_aliquota(trei.esenzione, trei.anno) / 100)) *
       max(poin.aliquota) / 100
      ,sum(decode(gp4_alei.get_aliquota(trei.esenzione, trei.anno)
                 ,100
                 ,trei.imponibile
                 ,0)) * max(poin.aliquota) / 100
  from totali_retribuzioni_inail trei
      ,ponderazione_inail        poin
      ,assicurazioni_inail       asin
 where poin.posizione_inail = trei.posizione_inail
   and asin.codice          = trei.posizione_inail
   and poin.anno = trei.anno
   and exists (select 'x'
          from ponderazione_inail
         where posizione_inail = trei.posizione_inail
           and anno = trei.anno)
 group by trei.anno
         ,trei.gestione
         ,trei.posizione_inail
         ,asin.posizione
         ,poin.voce_rischio
         ,trei.esenzione
         ,trei.tipo_ipn
union
select anno
      ,gestione
      ,posizione_inail posizione
      ,gp4_asin.get_descrizione(trei.posizione_inail) des_posizione
      ,asin.posizione
      ,to_char(null)
      ,'Posizione non ponderata'
      ,to_number(null)
      ,trei.esenzione
      ,trei.tipo_ipn
      ,sum(trei.imponibile)
      ,sum(decode(gp4_alei.get_aliquota(esenzione, anno)
                 ,100
                 ,0
                 ,trei.imponibile * gp4_alei.get_aliquota(trei.esenzione, trei.anno) / 100))
      ,sum(decode(gp4_alei.get_aliquota(trei.esenzione, trei.anno)
                 ,100
                 ,trei.imponibile
                 ,0))
  from totali_retribuzioni_inail trei
      ,assicurazioni_inail       asin
 where not exists (select 'x'
          from ponderazione_inail
         where posizione_inail = trei.posizione_inail
           and anno = trei.anno)
   and asin.codice          = trei.posizione_inail
 group by anno
         ,gestione
         ,posizione_inail
         ,asin.posizione
         ,esenzione
         ,tipo_ipn
;

