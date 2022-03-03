create or replace view codici_stat_individuali as
select  rqst.statistica
       ,rqst.codice cod_stat
       ,rqst.sequenza
       ,rain.ni
       ,rain.ci
       ,pegi.dal
       ,pegi.al
       ,qugi.ruolo
       ,cost.contratto
       ,qugi.codice qualifica
       ,qugi.numero num_qualifica
       ,pegi.tipo_rapporto
       ,figi.profilo
       ,figi.posizione
       ,figi.codice figura
       ,figi.numero num_figura
       ,pegi.attivita
       ,posi.di_ruolo 
       ,posi.tempo_determinato 
       ,posi.contratto_formazione 
       ,posi.part_time
       ,pegi.ore 
       ,cost.ore_lavoro 
  from righe_qualifiche_statistiche rqst
     , posizioni                    posi
     , figure_giuridiche            figi
     , qualifiche_giuridiche        qugi
     , rapporti_individuali         rain
     , periodi_giuridici            pegi
     , contratti_storici     cost
 where rain.ci               = pegi.ci
   and rain.rapporto in
      (select codice from classi_rapporto
        where giuridico = 'SI'
          and presenza  = 'SI'
          and retributivo = 'SI'
      )
   and pegi.dal        between rain.dal and nvl(rain.al,pegi.dal)
   and pegi.rilevanza        = 'S'
   and qugi.numero           = pegi.qualifica
   and figi.numero           = pegi.figura
   and pegi.dal        between figi.dal and nvl(figi.al,pegi.dal)
   and pegi.dal        between qugi.dal and nvl(qugi.al,pegi.dal)
   and posi.codice           = pegi.posizione
   and cost.contratto = qugi.contratto||''
   and cost.dal <= nvl(pegi.al, to_date('3333333', 'j'))
   and nvl(cost.al, to_date('3333333', 'j')) >= pegi.dal 
   and nvl(rqst.qualifica,pegi.qualifica) = pegi.qualifica 
   and nvl(rqst.figura,pegi.figura) = pegi.figura 
   and nvl(rqst.RUOLO, nvl(qugi.RUOLO, ' ')) = nvl(qugi.RUOLO, ' ')
   and nvl(pegi.tipo_rapporto, 'NULL') = nvl(rqst.tipo_rapporto, nvl(pegi.tipo_rapporto, 'NULL'))
   and nvl(rqst.profilo_professionale,nvl(figi.profilo, ' ')) = nvl(figi.profilo, ' ')
   and nvl(rqst.posizione_funzionale,nvl(figi.posizione, ' ')) = nvl(figi.posizione, ' ')
   and nvl(rqst.attivita, nvl(pegi.attivita, ' ')) =nvl(pegi.attivita, ' ')
   and nvl(rqst.di_ruolo, posi.di_ruolo) =posi.di_ruolo
   and nvl(rqst.tempo_determinato,posi.tempo_determinato) =posi.tempo_determinato
   and nvl(rqst.formazione_lavoro, posi.contratto_formazione) =posi.contratto_formazione
   and nvl(rqst.part_time, posi.part_time) = posi.part_time
and nvl(rqst.ci,pegi.ci) = pegi.ci 
and not exists (select 'x' from righe_qualifiche_statistiche 
                 where statistica = rqst.statistica 
                   and codice != rqst.codice 
                   and ci = pegi.ci
               )
/
