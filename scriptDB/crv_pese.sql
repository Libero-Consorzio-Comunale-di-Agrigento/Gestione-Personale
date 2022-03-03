CREATE OR REPLACE FORCE VIEW periodi_servizio
(
     ci
    ,rilevanza
    ,inizio
    ,segmento
    ,segmento_assenza
    ,dal
    ,al
    ,evento
    ,posizione
    ,figura
    ,attivita
    ,qualifica
    ,tipo_rapporto
    ,ore
    ,gestione
    ,settore
    ,sede
    ,assenza
)
AS SELECT
       pese.ci
     , pese.rilevanza
     , pese.dal inizio
     , pese.segmento
     , 'u'
     , greatest( pese.dal, nvl(peas.dal,to_date('2222222','j')) ) dal
     , decode( least( nvl(pese.al,to_date('3333333','j'))
                    , nvl(peas.al,to_date('3333333','j'))
                    )
             , to_date('3333333','j'), to_date(null)
               , least( nvl(pese.al,to_date('3333333','j'))
                      , nvl(peas.al,to_date('3333333','j'))
                      )
             ) al
     , pese.evento
     , pese.posizione
     , pese.figura
     , pese.attivita
     , pese.qualifica
     , pese.tipo_rapporto
     , pese.ore
     , pese.gestione
     , pese.settore
     , pese.sede
     , peas.assenza
  from periodi_servizio_contabile pese
     , ( select *
           from periodi_giuridici pegi
              , astensioni aste
          where pegi.rilevanza = 'A'
            and aste.codice    = pegi.assenza
            and aste.servizio_inpdap = 'S') peas
 where peas.ci        (+) = pese.ci
   and peas.dal       (+)<= nvl(pese.al,to_date('3333333','j'))
   and nvl(peas.al (+),to_date('3333333','j'))
                         >= pese.dal
UNION SELECT
       pese.ci
     , pese.rilevanza
     , pese.dal inizio
     , pese.segmento
     , 'i'
     , pese.dal
     , pein.dal-1 al
     , pese.evento
     , pese.posizione
     , pese.figura
     , pese.attivita
     , pese.qualifica
     , pese.tipo_rapporto
     , pese.ore
     , pese.gestione
     , pese.settore
     , pese.sede
     , null
  from periodi_servizio_contabile pese
     , periodi_giuridici pein
     , astensioni aste
 where pein.ci        = pese.ci
   and pein.rilevanza = 'A'
   and aste.codice    = pein.assenza
   and aste.servizio_inpdap = 'S'
   and pein.dal       = (select min(dal)
                           from periodi_giuridici
                              , astensioni
                          where ci        = pese.ci
                            and rilevanza = 'A'
                            and codice    = assenza
                            and servizio_inpdap = 'S'
                            and dal      <= nvl(pese.al,to_date('3333333','j'))
                            and dal      > pese.dal
                            and nvl(al,to_date('3333333','j'))
                                         >= pese.dal
                        )
   and not exists 
      (select 'x'        
         from periodi_giuridici
            , astensioni
        where ci        = pese.ci
          and rilevanza = 'A'
          and codice    = assenza
          and servizio_inpdap = 'S'
          and pese.dal between dal and nvl(al,to_date('3333333','j'))
      )
UNION SELECT
       pese.ci
     , pese.rilevanza
     , pese.dal inizio
     , pese.segmento
     , 'f'
     , peia.al+1 dal
     , pese.al          
     , pese.evento
     , pese.posizione
     , pese.figura
     , pese.attivita
     , pese.qualifica
     , pese.tipo_rapporto
     , pese.ore
     , pese.gestione
     , pese.settore
     , pese.sede
     , null
  from periodi_servizio_contabile pese
     , periodi_giuridici peia
     , astensioni aste
 where peia.rilevanza = 'A'
   and pese.ci        = peia.ci
   and aste.codice    = peia.assenza
   and aste.servizio_inpdap = 'S'
   and peia.dal       = (select max(dal)
                           from periodi_giuridici
                              , astensioni
                          where ci        = pese.ci
                            and rilevanza = 'A'
                            and codice    = assenza
                            and servizio_inpdap = 'S'
                            and dal      <= nvl(pese.al,to_date('3333333','j'))
                            and nvl(al,to_date('3333333','j'))
                                         >= pese.dal
                            and nvl(al,to_date('3333333','j'))
                                         < nvl(pese.al,to_date('3333333','j'))
                        )
   and not exists 
      (select 'x'        
         from periodi_giuridici
            , astensioni
        where ci        = pese.ci
          and rilevanza = 'A'
          and codice    = assenza
          and servizio_inpdap = 'S'
          and nvl(pese.al,to_date('3333333','j')) 
                  between dal and nvl(al,to_date('3333333','j'))
      )
UNION SELECT
       pese.ci
     , pese.rilevanza
     , pese.dal inizio
     , pese.segmento
     ,'c'
     , peia.al+1 dal
     , peis.dal-1 al
     , pese.evento
     , pese.posizione
     , pese.figura
     , pese.attivita
     , pese.qualifica
     , pese.tipo_rapporto
     , pese.ore
     , pese.gestione
     , pese.settore
     , pese.sede
     , null
  from periodi_servizio_contabile pese
     , periodi_giuridici peis
     , periodi_giuridici peia
     , astensioni asis
     , astensioni asia
 where peia.rilevanza = 'A'
   and pese.ci        = peia.ci
   and peia.dal      <= nvl(pese.al,to_date('3333333','j'))
   and nvl(peia.al,to_date('3333333','j'))
                     >= pese.dal
   and peis.rilevanza = 'A'
   and peis.ci        = peia.ci
   and asis.codice    = peis.assenza
   and asis.servizio_inpdap = 'S'
   and asia.codice    = peia.assenza
   and asia.servizio_inpdap = 'S'
   and peis.dal       = (select min(dal)
                           from periodi_giuridici
                              , astensioni
                          where ci        = peia.ci
                            and rilevanza = 'A'
                            and codice    = assenza
                            and servizio_inpdap = 'S'
                            and dal      <= nvl(pese.al,to_date('3333333','j'))
                            and nvl(al,to_date('3333333','j'))
                                         >= pese.dal
                            and dal       > peia.dal
                        )
   and peia.al+1     != peis.dal
;
