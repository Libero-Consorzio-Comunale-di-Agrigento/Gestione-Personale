CREATE OR REPLACE VIEW periodi_servizio_contabile 
(
     ci
    ,rilevanza
    ,inizio
    ,segmento
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
)
AS SELECT
       pese.ci
     , pese.rilevanza
     , pese.dal inizio
     , 'u'
     , greatest( pese.dal, nvl(pein.dal,to_date('2222222','j')) ) dal
     , decode( least( nvl(pese.al,to_date('3333333','j'))
                    , nvl(pein.al,to_date('3333333','j'))
                    )
             , to_date('3333333','j'), to_date(null)
               , least( nvl(pese.al,to_date('3333333','j'))
                      , nvl(pein.al,to_date('3333333','j'))
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
  from periodi_giuridici pese
     , periodi_giuridici pein
 where pese.rilevanza     = 'S'
   and pein.ci        (+) = pese.ci
   and pein.rilevanza (+) = 'E'
   and pein.dal       (+)<= nvl(pese.al,to_date('3333333','j'))
   and nvl(pein.al (+),to_date('3333333','j'))
                         >= pese.dal
UNION SELECT
       pese.ci
     , pese.rilevanza
     , pese.dal inizio
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
  from periodi_giuridici pein
     , periodi_giuridici pese
 where pese.rilevanza = 'S'
   and pein.ci        = pese.ci
   and pein.rilevanza = 'E'
   and pein.dal       = (select min(dal)
                           from periodi_giuridici
                          where ci        = pese.ci
                            and rilevanza = 'E'
                            and dal      <= nvl(pese.al,to_date('3333333','j'))
                            and nvl(al,to_date('3333333','j'))
                                         >= pese.dal
                        )
   and pein.dal      != pese.dal
UNION SELECT
       pein.ci
     , pein.rilevanza
     , pein.dal inizio
     , 'e'
     , pein.dal
     , pein.al
     , pein.evento
     , pein.posizione
     , pein.figura
     , pein.attivita
     , pein.qualifica
     , pein.tipo_rapporto
     , pein.ore
     , pein.gestione
     , pein.settore
     , pein.sede
  from periodi_giuridici pein
 where pein.rilevanza = 'E'
UNION SELECT
       pese.ci
     , pese.rilevanza
     , pese.dal inizio
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
  from periodi_giuridici pese
     , periodi_giuridici peia
 where peia.rilevanza = 'E'
   and pese.rilevanza = 'S'
   and pese.ci        = peia.ci
   and peia.dal      <= nvl(pese.al,to_date('3333333','j'))
   and nvl(peia.al,to_date('3333333','j'))
                     >= pese.dal
   and not exists 
      (select 'x'        
         from periodi_giuridici
        where ci        = pese.ci
          and rilevanza = 'E'
          and dal      <= nvl(pese.al,to_date('3333333','j'))
          and nvl(al,to_date('3333333','j'))
                       >= pese.dal
          and dal       > peia.dal
      )
   and nvl(peia.al,to_date('3333333','j'))
                       != nvl(pese.al,to_date('3333333','j'))
UNION SELECT
       pese.ci
     , pese.rilevanza
     , pese.dal inizio
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
  from periodi_giuridici peis
     , periodi_giuridici pese
     , periodi_giuridici peia
 where peia.rilevanza = 'E'
   and pese.rilevanza = 'S'
   and pese.ci        = peia.ci
   and peia.dal      <= nvl(pese.al,to_date('3333333','j'))
   and nvl(peia.al,to_date('3333333','j'))
                     >= pese.dal
   and peis.rilevanza = 'E'
   and peis.ci        = peia.ci
   and peis.dal       = (select min(dal)
                           from periodi_giuridici
                          where ci        = peia.ci
                            and rilevanza = 'E'
                            and dal      <= nvl(pese.al,to_date('3333333','j'))
                            and nvl(al,to_date('3333333','j'))
                                         >= pese.dal
                            and dal       > peia.dal
                        )
   and peia.al+1     != peis.dal
;
