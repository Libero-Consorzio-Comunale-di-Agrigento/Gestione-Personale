CREATE OR REPLACE VIEW periodi_servizio_previdenza 
(
     ci
    ,rilevanza
    ,inizio
    ,segmento
    ,dal
    ,al
    ,evento
    ,assenza
    ,posizione
    ,figura
    ,attivita
    ,qualifica
    ,tipo_rapporto
    ,ore
    ,gestione
    ,settore
    ,sede
    ,note
)
AS SELECT
       pese.ci
     , pese.rilevanza
     , pese.dal inizio
     , 'u'
     , pese.dal dal
     , pese.al al
     , pese.evento
     , null
     , pese.posizione
     , pese.figura
     , pese.attivita
     , pese.qualifica
     , pese.tipo_rapporto
     , pese.ore
     , pese.gestione
     , pese.settore
     , pese.sede
     , pese.note
  from periodi_giuridici pese
 where pese.rilevanza     = 'S'
   and not exists(select 'x'
                    from periodi_giuridici pegi,
                         astensioni aste
                   where pegi.ci = pese.ci
                     and aste.codice = pegi.assenza
                     and aste.servizio_inpdap  = 'S'
                     and pegi.rilevanza = 'A'
                     and pegi.dal <= nvl(pese.al,to_date('3333333','j'))
                     and nvl(pegi.al,to_date('3333333','j'))
                                           >= pese.dal)
UNION SELECT
       pese.ci
     , pese.rilevanza
     , pese.dal inizio
     , 'i'
     , pese.dal
     , pein.dal-1 al
     , pese.evento
     , null
     , pese.posizione
     , pese.figura
     , pese.attivita
     , pese.qualifica
     , pese.tipo_rapporto
     , pese.ore
     , pese.gestione
     , pese.settore
     , pese.sede
     , pese.note
  from periodi_giuridici pein
     , periodi_giuridici pese
     , astensioni        aste
 where pese.rilevanza = 'S'
   and pein.ci        = pese.ci
   and pein.rilevanza = 'A'
   and pein.dal       = (select min(p.dal)
                           from periodi_giuridici p
                              , astensioni        a
                          where p.ci        = pese.ci
                            and p.rilevanza = 'A'
                            and p.dal    <= nvl(pese.al,to_date('3333333','j'))
                            and nvl(p.al,to_date('3333333','j'))
                                         >= pese.dal
                            and a.codice (+) = p.assenza
                            and a.servizio_inpdap  = 'S'
                        )
   and pein.dal      > pese.dal
   and aste.codice (+)= pein.assenza
   and aste.servizio_inpdap  = 'S'
UNION SELECT
       pein.ci
     , pein.rilevanza
     , pein.dal inizio
     , 'a'
     , greatest( pein.dal, pese.dal) dal
     , decode( least( nvl(pese.al,to_date('3333333','j'))
                    , nvl(pein.al,to_date('3333333','j'))
                    )
             , to_date('3333333','j'), to_date(null)
               , least( nvl(pese.al,to_date('3333333','j'))
                       ,nvl(pein.al,to_date('3333333','j'))
                      )
             ) al
     , pein.evento
     , pein.assenza
     , pese.posizione
     , pese.figura
     , pese.attivita
     , pese.qualifica
     , pese.tipo_rapporto
     , pese.ore
     , pese.gestione
     , pese.settore
     , pese.sede
     , pese.note
  from periodi_giuridici pein
     , astensioni        aste
     , periodi_giuridici pese
 where pein.rilevanza = 'A'
   and aste.codice (+)= pein.assenza
   and aste.servizio_inpdap  = 'S'
   and pein.ci = pese.ci
   and pese.rilevanza = 'S'
   and pein.dal <= nvl(pese.al,to_date('3333333','j')) 
   and nvl(pein.al,to_date('3333333','j')) >= pese.dal
UNION SELECT
       pese.ci
     , pese.rilevanza
     , pese.dal inizio
     , 'f'
     , peia.al+1 dal
     , pese.al          
     , pese.evento
     , null
     , pese.posizione
     , pese.figura
     , pese.attivita
     , pese.qualifica
     , pese.tipo_rapporto
     , pese.ore
     , pese.gestione
     , pese.settore
     , pese.sede
     , pese.note
  from periodi_giuridici pese
     , periodi_giuridici peia
     , astensioni        aste
 where peia.rilevanza = 'A'
   and pese.rilevanza = 'S'
   and pese.ci        = peia.ci
   and peia.dal      <= nvl(pese.al,to_date('3333333','j'))
   and nvl(peia.al,to_date('3333333','j'))
                     >= pese.dal
   and aste.codice (+)= peia.assenza
   and aste.servizio_inpdap  = 'S'
   and not exists 
      (select 'x'        
         from periodi_giuridici p
            , astensioni        a
        where p.ci        = pese.ci
          and p.rilevanza = 'A'
          and p.dal      <= nvl(pese.al,to_date('3333333','j'))
          and nvl(p.al,to_date('3333333','j'))
                       >= pese.dal
          and p.dal       > peia.dal
          and a.codice (+)= p.assenza
          and a.servizio_inpdap  = 'S'
      )
   and nvl(peia.al,to_date('3333333','j'))
                       < nvl(pese.al,to_date('3333333','j'))
UNION SELECT
       pese.ci
     , pese.rilevanza
     , pese.dal inizio
     ,'c'
     , peia.al+1 dal
     , peis.dal-1 al
     , pese.evento
     , null
     , pese.posizione
     , pese.figura
     , pese.attivita
     , pese.qualifica
     , pese.tipo_rapporto
     , pese.ore
     , pese.gestione
     , pese.settore
     , pese.sede
     , pese.note
  from periodi_giuridici peis
     , periodi_giuridici pese
     , periodi_giuridici peia
     , astensioni        asta
     , astensioni        asts
 where peia.rilevanza = 'A'
   and asta.codice (+)= peia.assenza
   and asta.servizio_inpdap  = 'S'
   and pese.rilevanza = 'S'
   and pese.ci        = peia.ci
   and peia.dal      <= nvl(pese.al,to_date('3333333','j'))
   and nvl(peia.al,to_date('3333333','j'))
                     >= pese.dal
   and peis.rilevanza = 'A'
   and asts.codice (+)= peis.assenza
   and asts.servizio_inpdap  = 'S'
   and peis.ci        = peia.ci
   and peis.dal       = (select min(p.dal)
                           from periodi_giuridici p
                              , astensioni        a
                          where p.ci        = peia.ci
                            and p.rilevanza = 'A'
                            and p.dal      <= nvl(pese.al,to_date('3333333','j'))
                            and nvl(p.al,to_date('3333333','j'))
                                         >= pese.dal
                            and p.dal       > peia.dal
                            and a.codice (+) = p.assenza
                            and a.servizio_inpdap  = 'S'
                        )
   and peia.al+1     != peis.dal
;
