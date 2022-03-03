CREATE OR REPLACE VIEW periodi_tetti_incentivo
(
 rilevanza
,dal
,al
,decorrenza
,cod_qualifica
,qualifica
,dal_qualifica
,dal_qualifica_incentivo
,tipo_rapporto
,ruolo
,ci
)
AS
   select  pegi.rilevanza
          ,greatest(quip.dal,pegi.dal)
          ,quip.al+1
          ,pegi.dal
          ,qugi.codice
          ,qugi.numero
          ,qugi.dal
          ,quip.dal
          ,pegi.tipo_rapporto
          ,posi.ruolo
          ,rain.ci
     from  posizioni             posi
          ,qualifiche_giuridiche qugi
          ,qualifiche_incentivo  quip
          ,periodi_giuridici     pegi
          ,rapporti_individuali  rain
    where  qugi.numero                = pegi.qualifica
      and  qugi.dal                   <= nvl(pegi.al,to_date('3333333','j'))
      and  nvl(qugi.al,to_date('3333333','j'))
                                      >= pegi.dal
      and  quip.numero                 = qugi.numero
      and  quip.al               between pegi.dal
                                     and nvl(pegi.al,to_date('3333333','j'))
      and  quip.dal = (select max(qui2.dal)
                         from qualifiche_incentivo qui2
                        where qui2.numero = quip.numero
                          and qui2.dal    < quip.dal
                      )
      and  posi.codice                 = pegi.posizione
      and  pegi.rilevanza             in ('S','E')
      and  pegi.ci                     = rain.ci
   union
   select  pegi.rilevanza
          ,quip.dal-1
          ,decode(least(nvl(pegi.al,to_date('3333333','j'))
                       ,nvl(quip.al,to_date('3333333','j'))
                       )
                       ,to_date('3333333','j'),to_date(null)
                 ,least(nvl(pegi.al,to_date('3333333','j'))
                       ,nvl(quip.al,to_date('3333333','j'))
                       )
                 )
          ,pegi.dal
          ,qugi.codice
          ,qugi.numero
          ,qugi.dal
          ,quip.dal
          ,pegi.tipo_rapporto
          ,posi.ruolo
          ,rain.ci
     from  posizioni             posi
          ,qualifiche_giuridiche qugi
          ,qualifiche_incentivo  quip
          ,periodi_giuridici     pegi
          ,rapporti_individuali  rain
    where  qugi.numero                = pegi.qualifica
      and  qugi.dal                   <= nvl(pegi.al,to_date('3333333','j'))
      and  nvl(qugi.al,to_date('3333333','j'))
                                      >= pegi.dal
      and  quip.numero                 = qugi.numero
      and  quip.dal              between pegi.dal
                                     and nvl(pegi.al,to_date('3333333','j'))
      and  quip.dal = (select min(qui2.dal)
                         from qualifiche_incentivo qui2
                        where qui2.numero = quip.numero
                          and qui2.dal    > quip.dal
                      )
      and  posi.codice                 = pegi.posizione
      and  pegi.rilevanza             in ('S','E')
      and  pegi.ci                     = rain.ci
   union
   select  pegi.rilevanza
          ,greatest(quip.dal,pegi.dal)
          ,decode(least(nvl(pegi.al,to_date('3333333','j'))
                       ,nvl(quip.al,to_date('3333333','j'))
                       )
                 ,to_date('3333333','j'),to_date(null)
                 ,least(nvl(pegi.al,to_date('3333333','j'))
                       ,nvl(quip.al,to_date('3333333','j'))
                       )
                 )
          ,pegi.dal
          ,qugi.codice
          ,qugi.numero
          ,qugi.dal
          ,quip.dal
          ,pegi.tipo_rapporto
          ,posi.ruolo
          ,rain.ci
     from  posizioni             posi
          ,qualifiche_giuridiche qugi
          ,qualifiche_incentivo  quip
          ,periodi_giuridici     pegi
          ,rapporti_individuali  rain
    where  qugi.numero                = pegi.qualifica
      and  qugi.dal                   <= nvl(pegi.al,to_date('3333333','j'))
      and  nvl(qugi.al,to_date('3333333','j'))
                                      >= pegi.dal
      and  quip.numero                 = qugi.numero
      and  quip.dal                   <= nvl(pegi.al,to_date('3333333','j'))
      and  nvl(quip.al,to_date('3333333','j'))
                                      >= pegi.dal
      and  posi.codice                 = pegi.posizione
      and  pegi.rilevanza             in ('S','E')
      and  pegi.ci                     = rain.ci
   union
   select  pegi.rilevanza
          ,pegi.dal
          ,pegi.al
          ,pegi.dal
          ,qugi.codice
          ,qugi.numero
          ,qugi.dal
          ,to_date(null)
          ,pegi.tipo_rapporto
          ,posi.ruolo
          ,rain.ci
     from  posizioni             posi
          ,qualifiche_giuridiche qugi
          ,periodi_giuridici     pegi
          ,rapporti_individuali  rain
    where  qugi.numero                = pegi.qualifica
      and  qugi.dal                   <= nvl(pegi.al,to_date('3333333','j'))
      and  nvl(qugi.al,to_date('3333333','j'))
                                      >= pegi.dal
      and  not exists
          (select 'x'
             from qualifiche_incentivo quip
            where quip.numero          = qugi.numero
              and quip.dal            <= nvl(pegi.al,to_date('3333333','j'))
              and nvl(quip.al,to_date('3333333','j'))
                                      >= pegi.dal
          )
      and  posi.codice                 = pegi.posizione
      and  pegi.rilevanza             in ('S','E')
      and  pegi.ci                     = rain.ci
;
