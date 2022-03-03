update addizionale_irpef_comunale adic
   set al = ( select min(dal)-1
                from addizionale_irpef_comunale
               where dal > adic.dal
            )
where al is null
  and exists ( select 'x' 
                 from addizionale_irpef_comunale
                where dal > adic.dal
             )
/

start crf_rire_cambio_anno.sql

DECLARE
 P_fin_ela date;

BEGIN 
 BEGIN
   select fin_ela
     into P_fin_ela
     from riferimento_retribuzione
    where rire_id ='RIRE';
  END;

FOR CUR_RAGI IN 
( select ci
    from rapporti_giuridici ragi
) LOOP
  BEGIN
     update rapporti_giuridici ragi
        set ( dal, al, posizione, di_ruolo, contratto, qualifica, ruolo, livello
            , tipo_rapporto, ore, attivita, figura, gestione, settore, sede )
       = ( select max(pegi.dal)
                , max(pegi.al)
                , max(pegi.posizione)
                , max(posi.ruolo)
                , max(qugi.contratto)
                , max(pegi.qualifica)
                , max(qugi.ruolo)
                , max(qugi.livello)
                , max(pegi.tipo_rapporto)
                , max(pegi.ore)
                , max(pegi.attivita)
                , max(pegi.figura)
                , max(pegi.gestione)
                , max(pegi.settore)
                , max(pegi.sede)
             from periodi_giuridici pegi
                , qualifiche_giuridiche qugi
                , posizioni posi
            where posi.codice = pegi.posizione
              and qugi.numero (+)  = pegi.qualifica
              and least(nvl(pegi.al,to_date('3333333','j')),P_fin_ela)
                  between nvl(qugi.dal,to_date('2222222','j'))
                      and nvl(qugi.al ,to_date('3333333','j'))
              and pegi.ci = CUR_RAGI.ci
              and (pegi.dal,pegi.rilevanza) in (select max(dal)
                                                     , substr(max(to_char(dal,'yyyy/mm/dd')||pegi2.rilevanza),11,1)
                                                  from periodi_giuridici pegi2
                                                 where pegi2.ci = CUR_RAGI.ci
                                                   and pegi2.rilevanza in ('S','Q')
                                                   and pegi2.dal <= P_fin_ela
                                                )
       )
     where ci = CUR_RAGI.ci;
  commit;
  END;
  BEGIN
     update rapporti_giuridici ragi
        set ( dal, al, posizione, di_ruolo, contratto, qualifica, ruolo, livello
            , tipo_rapporto, ore, attivita, figura, gestione, settore, sede )
       = ( select pegi.dal
                , pegi.al
                , pegi.posizione
                , posi.ruolo
                , qugi.contratto
                , pegi.qualifica
                , qugi.ruolo
                , qugi.livello
                , pegi.tipo_rapporto
                , pegi.ore
                , pegi.attivita
                , pegi.figura
                , pegi.gestione
                , pegi.settore
                , pegi.sede
             from periodi_giuridici pegi
                , qualifiche_giuridiche qugi
                , posizioni posi
            where posi.codice  = pegi.posizione
              and qugi.numero  = pegi.qualifica
              and least(nvl(pegi.al,to_date('3333333','j')),P_fin_ela)
                  between qugi.dal and nvl(qugi.al,to_date('3333333','j'))
              and pegi.ci = CUR_RAGI.ci
              and pegi.rilevanza  = 'E'
              and pegi.dal  = ( select max(dal)
                                  from periodi_giuridici
                                 where ci  = CUR_RAGI.ci
                                   and rilevanza = 'E'
                                   and dal <= P_fin_ela
                              )
              and ( nvl(pegi.al,to_date('3333333','j')) >= nvl(ragi.al,to_date('3333333','j'))
                 or P_fin_ela between pegi.dal and nvl(pegi.al,to_date('3333333','j'))
                  )
          )
  where ragi.ci = CUR_RAGI.ci
    and exists (select 'x'
                  from periodi_giuridici
                 where ci  = CUR_RAGI.ci
                   and rilevanza = 'E'
                   and dal = (select max(dal)
                                from periodi_giuridici
                               where ci  = CUR_RAGI.ci
                                 and rilevanza = 'E'
                                 and dal <= P_fin_ela
                             )
                   and ( nvl(al,to_date('3333333','j')) >= nvl(ragi.al,to_date('3333333','j'))
                      or P_fin_ela between dal  and nvl(al,to_date('3333333','j'))
                       )
               );
  commit;
 END;
END LOOP;
END;
/