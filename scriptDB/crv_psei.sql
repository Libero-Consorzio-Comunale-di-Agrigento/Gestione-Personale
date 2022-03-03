CREATE OR REPLACE VIEW periodi_servizio_incarico  
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
    ,qualifica
    ,tipo_rapporto
    ,ore
    ,settore
    ,sede
    ,gruppo
)
AS SELECT
       pese.ci
     , pese.rilevanza
     , pese.dal inizio
     , 'u'
     , pese.dal
     , pese.al
     , pese.evento
     , pese.posizione
     , pese.figura
     , pese.qualifica
     , pese.tipo_rapporto
     , pese.ore
     , pese.settore
     , pese.sede
     , pese.gruppo
  from periodi_giuridici pese
 where pese.rilevanza     = 'S'
   and not exists 
      (select 'x'        
         from periodi_giuridici
        where ci        = pese.ci
          and rilevanza = 'E'
          and dal      <= nvl(pese.al,to_date('3333333','j'))
          and nvl(al,to_date('3333333','j'))
                       >= pese.dal
      )
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
     , pese.qualifica
     , pese.tipo_rapporto
     , pese.ore
     , pese.settore
     , pese.sede
     , pese.gruppo
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
     , pein.qualifica
     , pein.tipo_rapporto
     , pein.ore
     , pein.settore
     , pein.sede
     , pein.gruppo
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
     , pese.qualifica
     , pese.tipo_rapporto
     , pese.ore
     , pese.settore
     , pese.sede
     , pese.gruppo
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
     , pese.qualifica
     , pese.tipo_rapporto
     , pese.ore
     , pese.settore
     , pese.sede
     , pese.gruppo
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
