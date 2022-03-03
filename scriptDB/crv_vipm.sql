create or replace view vista_pegi_mesi
(ci, anno, mese, dal, al, gestione, posizione, figura, qualifica, ruolo, settore, sede, ore, arretrato)
as
select pegi.ci
      ,mesi.anno
      ,mesi.mese
      ,greatest(mesi.ini_mese, pegi.dal)
      ,least(mesi.fin_mese, nvl(pegi.al, to_date(3333333, 'j')))
      ,pegi.gestione
      ,pegi.posizione
      ,pegi.figura
      ,pegi.qualifica
      ,gp4_qugi.get_ruolo(pegi.qualifica, pegi.dal)
      ,pegi.settore
      ,pegi.sede
      ,pegi.ore
      ,'C' arretrato
  from mesi              mesi
      ,periodi_giuridici pegi
 where pegi.dal <= mesi.fin_mese
   and nvl(pegi.al, to_date(3333333, 'j')) >= mesi.ini_mese
   and pegi.rilevanza = 'S'
union
select pere.ci
      ,pere.anno
      ,pere.mese
      ,least(greatest(mesi.ini_mese, pere.dal), least(mesi.fin_mese, nvl(pere.al, to_date(3333333, 'j'))))
      ,least(mesi.fin_mese, nvl(pere.al, to_date(3333333, 'j')))
      ,pere.gestione
      ,pere.posizione
      ,pere.figura
      ,pere.qualifica
      ,pere.ruolo
      ,pere.settore
      ,pere.sede
      ,pere.ore
      ,'A'
  from periodi_retributivi pere
      ,mesi
 where servizio = 'Q'
   and competenza = 'A'
   and mesi.anno = pere.anno
   and mesi.mese = pere.mese
   and not exists (select 'x'
          from mesi              mesi
              ,periodi_giuridici pegi
         where pegi.dal <= mesi.fin_mese
           and nvl(pegi.al, to_date(3333333, 'j')) >= mesi.ini_mese
           and pegi.rilevanza = 'S'
           and pegi.ci = pere.ci
           and mesi.anno = pere.anno
           and mesi.mese = pere.mese)
;
