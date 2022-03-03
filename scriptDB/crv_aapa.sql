CREATE OR REPLACE VIEW assegna_automatismi_presenza
(
       ci
     , causale
     , motivo
     , dal
     , al
     , attribuzione
     , specie
     , gg_ratei
     , quantita
     , sede
     , cdc
     , condizione
     , stato_condizione
)
AS SELECT
       pspa.ci
     , aupa.causale
     , aupa.motivo
     , greatest( pspa.dal
               , nvl(aupa.dal,to_date('2222222','j'))
               )
     , decode( least( nvl(pspa.al,to_date('3333333','j'))
                    , nvl(aupa.al,to_date('3333333','j'))
                    )
             , to_date('3333333','j'), to_date(null)
               , least( nvl(pspa.al,to_date('3333333','j'))
                      , nvl(aupa.al,to_date('3333333','j'))
                      )
             )
     , aupa.attribuzione
     , aupa.specie
     , aupa.gg_ratei
     , aupa.quantita
     , aupa.sede
     , aupa.cdc
     , aupa.condizione
     , aupa.stato_condizione
  from riferimento_presenza      ripa
     , trattamenti_previdenziali trpr
     , rapporti_retributivi      rare
     , ripartizioni_funzionali   rifu
     , settori                   sett
     , qualifiche_giuridiche     qugi
     , qualifiche                qual
     , periodi_giuridici         pegi
     , rapporti_presenza         rapa
     , automatismi_presenza      aupa 
     , periodi_servizio_presenza pspa
 where ripa.ripa_id                     = 'RIPA'
   and rare.ci               (+)        = pspa.ci
   and trpr.codice           (+)        = rare.trattamento
   and rifu.settore          (+)        = pspa.settore
   and rifu.sede             (+)        = nvl(pspa.sede_cdc,0)
   and sett.numero           (+)        = pspa.settore
   and qugi.numero           (+)        = pspa.qualifica
   and qugi.dal              (+)        = pspa.dal_qualifica
   and qual.numero           (+)        = pspa.qualifica
   and pegi.ci               (+)        = pspa.ci
   and pegi.rilevanza        (+)        = pspa.rilevanza
   and pegi.dal              (+)        = pspa.dal_periodo
   and rapa.ci                          = pspa.ci
   and rapa.dal                         = pspa.dal_rapporto
   and aupa.attivo                      = 'SI' 
   and nvl(aupa.dal,to_date('2222222','j'))
                                       <= ripa.fin_mes
   and nvl(aupa.al ,to_date('3333333','j'))
                                       >= ripa.ini_mes 
   and (    aupa.automatismo           is null
        and aupa.stato_automatismo     is null
        or  aupa.stato_automatismo      = 'A'
        and nvl(aupa.automatismo,' ')   = nvl(rapa.automatismo,' ')
        or  aupa.stato_automatismo      = 'N'
        and nvl(aupa.automatismo,' ')  != nvl(rapa.automatismo,' ')
       )
   and nvl(aupa.ufficio,' ')            = nvl(pspa.ufficio,' ')
   and nvl(aupa.sede,0)                 = nvl(pspa.sede,0)
   and nvl(aupa.cdc,' ')                = nvl(rapa.cdc,nvl(rifu.cdc,' '))
   and nvl(aupa.fattore_produttivo,' ') = nvl(rapa.fattore_produttivo
                                             ,nvl(decode(pegi.tipo_rapporto
                                                        ,'TD',qual.fattore_td
                                                             ,qual.fattore
                                                        ),' '
                                                 )
                                             )
   and nvl(aupa.gestione,' ')           = nvl(sett.gestione,' ')
   and nvl(aupa.settore,0)              = nvl(pspa.settore,0)
   and nvl(aupa.funzionale,' ')         = nvl(rifu.funzionale,' ')
   and nvl(aupa.posizione,' ')          = nvl(pegi.posizione,' ')
   and nvl(aupa.ruolo,' ')              = nvl(qugi.ruolo,' ')
   and nvl(aupa.figura,0)               = nvl(pspa.figura,0)
   and nvl(aupa.attivita,' ')           = nvl(pegi.attivita,' ')
   and nvl(aupa.contratto,' ')          = nvl(pspa.contratto,' ')
   and nvl(aupa.qualifica,0)            = nvl(pspa.qualifica,0)
   and nvl(aupa.tipo_rapporto,' ')      = nvl(pegi.tipo_rapporto,' ')
   and nvl(aupa.ore,0)                  = nvl(pspa.ore,0)
   and nvl(aupa.gg_set,0)               = nvl(pspa.gg_set,0)
   and nvl(aupa.min_gg,0)               = nvl(pspa.min_gg,0)
   and nvl(aupa.assistenza,' ')         = nvl(rapa.assistenza
                                             ,nvl(trpr.assistenza,' ')
                                             )
   and not exists 
      (select 'x'        
         from eventi_automatici_presenza
        where ci              = pspa.ci
          and causale         = aupa.causale
          and nvl(motivo,' ') = nvl(aupa.motivo,' ')
          and nvl(dal,to_date('2222222','j'))
                             <= ripa.fin_mes                      
          and nvl(al,to_date('3333333','j'))
                             >= ripa.ini_mes                           
          and attivo          = 'SI'
      )
;
