create or replace view WORD_PERIODI_SE 
(CI, DAL, AL, RILEVANZA, EVENTO, QUALIFICA, FIGURA
,GESTIONE, SETTORE, SEDE, SEDE_DEL,NUMERO_DEL, ANNO_DEL
,TIPO_RAPPORTO, ORE, POSIZIONE, NOTE
,SEGMENTO,INIZIO)
as select pegi.ci, pegi.dal dal,pegi.al al,'S' rilevanza
        , pegi.evento
        , pegi.qualifica,pegi.figura
        , pegi.gestione,pegi.settore
        , pegi.sede,pegi.sede_del
        , pegi.numero_del,pegi.anno_del
        , pegi.tipo_rapporto, pegi.ore
        , pegi.posizione,pegi.note
        ,'u',pegi.dal 
     from periodi_giuridici pegi
    where rilevanza = 'S'
      and not exists(select 'x'
                       from periodi_giuridici pegi1
                      where pegi1.ci = pegi.ci
                        and pegi1.rilevanza = 'E'
                        and pegi.dal <= nvl(pegi1.al,to_date('3333333','j'))
                        and nvl(pegi.al,to_date('3333333','j')) >= pegi1.dal
                    )
    union
   select pegi_e.ci, pegi_s.dal dal ,pegi_e.dal-1 al,'E' rilevanza
        , pegi_e.evento
        , pegi_e.qualifica,pegi_e.figura
        , pegi_e.gestione,pegi_e.settore
        , pegi_e.sede,pegi_e.sede_del
        , pegi_e.numero_del,pegi_e.anno_del
        , pegi_e.tipo_rapporto, pegi_e.ore
        , pegi_e.posizione,pegi_e.note
         , 'i',pegi_s.dal
     from periodi_giuridici pegi_s
        , periodi_giuridici pegi_e
    where pegi_s.rilevanza = 'S'
      and pegi_e.rilevanza = 'E'
      and pegi_s.ci = pegi_e.ci
      and pegi_e.dal       = (select min(p.dal)
                           from periodi_giuridici p
                          where p.ci        = pegi_s.ci
                            and p.rilevanza = 'E'
                            and p.dal    <= nvl(pegi_s.al,to_date('3333333','j'))
                            and nvl(p.al,to_date('3333333','j'))
                                         >= pegi_s.dal
                        )
      and pegi_e.dal      > pegi_s.dal
    union
   select pegi_e.ci
        , greatest( pegi_e.dal, pegi_s.dal) dal
        , decode( least( nvl(pegi_s.al,to_date('3333333','j'))
                       , nvl(pegi_e.al,to_date('3333333','j'))
                       )
                , to_date('3333333','j'), to_date(null)
                                        , least( nvl(pegi_s.al,to_date('3333333','j'))
                                               , nvl(pegi_e.al,to_date('3333333','j'))
                                               )
                ) al
        ,'E' rilevanza
        , pegi_e.evento
        , pegi_e.qualifica,pegi_e.figura
        , pegi_e.gestione,pegi_e.settore
        , pegi_e.sede,pegi_e.sede_del
        , pegi_e.numero_del,pegi_e.anno_del
        , pegi_e.tipo_rapporto, pegi_e.ore
        , pegi_e.posizione,pegi_e.note
        , 'a', pegi_e.dal
     from periodi_giuridici pegi_s
        , periodi_giuridici pegi_e
    where pegi_s.rilevanza = 'S'
      and pegi_e.rilevanza = 'E'
      and pegi_s.ci = pegi_e.ci
      and pegi_e.dal <= nvl(pegi_s.al,to_date('3333333','j')) 
      and nvl(pegi_e.al,to_date('3333333','j')) >= pegi_s.dal
    union
   select pegi_s.ci, pegi_e.al +1 dal,pegi_s.al al
        , 'S' rilevanza
        , pegi_s.evento
        , pegi_s.qualifica,pegi_s.figura
        , pegi_s.gestione,pegi_s.settore
        , pegi_s.sede,pegi_s.sede_del
        , pegi_s.numero_del,pegi_s.anno_del
        , pegi_s.tipo_rapporto, pegi_s.ore
        , pegi_S.posizione,pegi_s.note
        , 'f',pegi_s.dal
     from periodi_giuridici pegi_s
        , periodi_giuridici pegi_e
    where pegi_s.rilevanza = 'S'
      and pegi_e.rilevanza = 'E'
      and pegi_s.ci = pegi_e.ci
      and pegi_s.dal <= nvl(pegi_e.al,to_date('3333333','j'))
      and nvl(pegi_s.al,to_date('3333333','j')) >= pegi_e.dal
      and not exists 
         (select 'x'        
            from periodi_giuridici p
           where p.ci        = pegi_s.ci
             and p.rilevanza = 'E'
             and p.dal      <= nvl(pegi_s.al,to_date('3333333','j'))
             and nvl(p.al,to_date('3333333','j'))
                            >= pegi_s.dal
             and p.dal       > pegi_e.dal
         )
      and nvl(pegi_e.al,to_date('3333333','j'))
                             < nvl(pegi_s.al,to_date('3333333','j'))
    union
   select pegi_s.ci
        , pegi_e.al+1 dal
        , pege.dal-1 al
        ,'S' rilevanza
        , pegi_s.evento
        , pegi_s.qualifica,pegi_s.figura
        , pegi_s.gestione,pegi_s.settore
        , pegi_s.sede,pegi_s.sede_del
        , pegi_s.numero_del,pegi_s.anno_del
        , pegi_s.tipo_rapporto, pegi_s.ore
        , pegi_S.posizione,pegi_s.note
        , 'c',pegi_s.dal
     from periodi_giuridici pegi_s
        , periodi_giuridici pegi_e
        , periodi_giuridici pege
    where pegi_s.rilevanza = 'S'
      and pegi_e.rilevanza = 'E'
      and pege.rilevanza   = 'E'
      and pege.ci          = pegi_e.ci
      and pegi_s.ci = pegi_e.ci
      and pegi_s.dal <= nvl(pegi_e.al,to_date('3333333','j'))
      and nvl(pegi_s.al,to_date('3333333','j')) >= pegi_e.dal
      and pege.dal       = (select min(p.dal)
                              from periodi_giuridici p
                             where p.ci        = pegi_e.ci
                               and p.rilevanza = 'E'
                               and p.dal      <= nvl(pegi_s.al,to_date('3333333','j'))
                               and nvl(p.al,to_date('3333333','j'))
                                              >= pegi_s.dal
                               and p.dal       > pegi_e.dal
                           )
      and pegi_e.al+1     != pege.dal
/