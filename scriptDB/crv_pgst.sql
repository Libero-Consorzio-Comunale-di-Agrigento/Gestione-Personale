CREATE OR REPLACE VIEW PERIODI_SENZA_TETTI
(
ci,cognome,nome,rilevanza,dal,al,posizione,contratto,qualifica,tipo_rapporto,
inizio,fine
)
AS
select rain.ci,rain.cognome,rain.nome,pegi.rilevanza,pegi.dal,pegi.al,
       pegi.posizione,qugi.contratto,qugi.codice,pegi.tipo_rapporto,
       pegi.dal,trip.dal-1
  from qualifiche_giuridiche       qugi
      ,tetti_retributivi_incentivo trip
      ,rapporti_individuali        rain
      ,periodi_giuridici           pegi
      ,riferimento_incentivo       riip
 where riip.riip_id                = 'RIIP'
   and rain.ci                     = pegi.ci
   and pegi.rilevanza             in ('S','E')
   and exists
       (select 1
          from assegnazioni_incentivo asip
         where asip.dal           <= nvl(pegi.al,to_date('3333333','j'))
           and nvl(asip.al,to_date('3333333','j'))
                                  >= pegi.dal
           and asip.ci             = pegi.ci
           and asip.dal           <= riip.fin_mes
           and asip.data_agg      != to_date('3333333','j')
           and exists
               (select 1
                  from attribuzione_quote_incentivo aqip
                 where aqip.progetto
                                   = asip.progetto
                   and aqip.dal   <= nvl(asip.al,to_date('3333333','j'))
                   and nvl(aqip.al,to_date('3333333','j'))
                                  >= asip.dal
                   and aqip.prestazione
                                   = 'E'      
               )
       )
   and least(nvl(pegi.al,to_date('3333333','j')),riip.fin_mes)
                             between qugi.dal
                                 and nvl(qugi.al,to_date('3333333','j'))
   and qugi.numero                 = pegi.qualifica
   and trip.ci                     = pegi.ci
   and trip.rilevanza              = pegi.rilevanza
   and trip.decorrenza             = pegi.dal
   and trip.dal                    =
       (select min(tri2.dal)
          from tetti_retributivi_incentivo tri2
         where tri2.ci             = trip.ci
           and tri2.rilevanza      = trip.rilevanza
           and tri2.decorrenza     = trip.decorrenza
           and tri2.dal           <= nvl(pegi.al,to_date('3333333','j'))
           and nvl(tri2.al,to_date('3333333','j'))
                                  >= pegi.dal
       )
   and trip.dal                    > pegi.dal
 union
select rain.ci,rain.cognome,rain.nome,pegi.rilevanza,pegi.dal,pegi.al,
       pegi.posizione,qugi.contratto,qugi.codice,pegi.tipo_rapporto,
       trip.al+1,pegi.al
  from qualifiche_giuridiche       qugi
      ,tetti_retributivi_incentivo trip
      ,rapporti_individuali        rain
      ,periodi_giuridici           pegi
      ,riferimento_incentivo       riip
 where riip.riip_id                = 'RIIP'
   and rain.ci                     = pegi.ci
   and pegi.rilevanza             in ('S','E')
   and exists
       (select 1
          from assegnazioni_incentivo asip
         where asip.dal           <= nvl(pegi.al,to_date('3333333','j'))
           and nvl(asip.al,to_date('3333333','j'))
                                  >= pegi.dal
           and asip.ci             = pegi.ci
           and asip.dal           <= riip.fin_mes
           and asip.data_agg      != to_date('3333333','j')
           and exists
               (select 1
                  from attribuzione_quote_incentivo aqip
                 where aqip.progetto
                                   = asip.progetto
                   and aqip.dal   <= nvl(asip.al,to_date('3333333','j'))
                   and nvl(aqip.al,to_date('3333333','j'))
                                  >= asip.dal
                   and aqip.prestazione
                                   = 'E'      
               )
       )
   and least(nvl(pegi.al,to_date('3333333','j')),riip.fin_mes)
                             between qugi.dal
                                 and nvl(qugi.al,to_date('3333333','j'))
   and qugi.numero                 = pegi.qualifica
   and trip.ci                     = pegi.ci
   and trip.rilevanza              = pegi.rilevanza
   and trip.decorrenza             = pegi.dal
   and trip.dal                     =
       (select max(tri2.dal)
          from tetti_retributivi_incentivo tri2
         where tri2.ci             = trip.ci
           and tri2.rilevanza      = trip.rilevanza
           and tri2.decorrenza     = trip.decorrenza
           and tri2.dal           <= nvl(pegi.al,to_date('3333333','j'))
           and nvl(tri2.al,to_date('3333333','j'))
                                  >= pegi.dal
       )
   and trip.al                     < nvl(pegi.al,to_date('3333333','j'))
 union
select rain.ci,rain.cognome,rain.nome,pegi.rilevanza,pegi.dal,pegi.al,
       pegi.posizione,qugi.contratto,qugi.codice,pegi.tipo_rapporto,
       pegi.dal,pegi.al
  from qualifiche_giuridiche       qugi
      ,rapporti_individuali        rain
      ,periodi_giuridici           pegi
      ,riferimento_incentivo       riip
 where riip.riip_id                = 'RIIP'
   and rain.ci                     = pegi.ci
   and pegi.rilevanza             in ('S','E')
   and exists
       (select 1
          from assegnazioni_incentivo asip
         where asip.dal           <= nvl(pegi.al,to_date('3333333','j'))
           and nvl(asip.al,to_date('3333333','j'))
                                  >= pegi.dal
           and asip.ci             = pegi.ci
           and asip.dal           <= riip.fin_mes
           and asip.data_agg      != to_date('3333333','j')
           and exists
               (select 1
                  from attribuzione_quote_incentivo aqip
                 where aqip.progetto
                                   = asip.progetto
                   and aqip.dal   <= nvl(asip.al,to_date('3333333','j'))
                   and nvl(aqip.al,to_date('3333333','j'))
                                  >= asip.dal
                   and aqip.prestazione
                                   = 'E'      
               )
       )
   and least(nvl(pegi.al,to_date('3333333','j')),riip.fin_mes)
                             between qugi.dal
                                 and nvl(qugi.al,to_date('3333333','j'))
   and qugi.numero                 = pegi.qualifica
   and not exists
       (select 1
          from tetti_retributivi_incentivo tri2
         where tri2.ci             = pegi.ci
           and tri2.rilevanza      = pegi.rilevanza
           and tri2.decorrenza     = pegi.dal
           and tri2.dal           <= nvl(pegi.al,to_date('3333333','j'))
           and nvl(tri2.al,to_date('3333333','j'))
                                  >= pegi.dal
       )
;
