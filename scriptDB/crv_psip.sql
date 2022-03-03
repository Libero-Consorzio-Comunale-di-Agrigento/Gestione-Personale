CREATE OR REPLACE VIEW periodi_servizio_incentivo
(
     progetto
    ,ci
    ,inizio
    ,dal
    ,al
    ,posizione
    ,ruolo
    ,livello
    ,contratto
    ,cod_qualifica
    ,qualifica
    ,tipo_rapporto
    ,sede
    ,settore
    ,rilevanza
    ,parte
    ,equipe
    ,gruppo
    ,prestazione
    ,ore
    ,ore_ind
    ,importo
    ,imp_ind
    ,aqip_rowid
)
AS SELECT
       asip.progetto                                   
     , asip.ci                                         
     , asip.dal inizio                                 
     , greatest( aqip.dal                              
               , aeip.dal                              
               , nvl(quip.dal,to_date('2222222','j'))  
               , qugi.dal                              
               , pegi.dal                              
               , apip.dal                              
               , asip.dal                              
               ) dal                                   
     , decode( least( nvl(aqip.al,to_date('3333333','j'))
                    , nvl(aeip.al,to_date('3333333','j'))
                    , nvl(quip.al,to_date('3333333','j'))
                    , nvl(qugi.al,to_date('3333333','j'))
                    , nvl(pegi.al,to_date('3333333','j'))
                    , nvl(apip.al,to_date('3333333','j'))
                    , nvl(asip.al,to_date('3333333','j'))
                    )                                  
             , to_date('3333333','j'), to_date(null)   
               , least( nvl(aqip.al,to_date('3333333','j'))
                      , nvl(aeip.al,to_date('3333333','j'))
                      , nvl(quip.al,to_date('3333333','j'))
                      , nvl(qugi.al,to_date('3333333','j'))
                      , nvl(pegi.al,to_date('3333333','j'))
                      , nvl(apip.al,to_date('3333333','j'))
                      , nvl(asip.al,to_date('3333333','j'))
                      )                                
       ) al                                            
     , pegi.posizione                                  
     , qugi.ruolo                                      
     , qugi.livello                                    
     , qugi.contratto                                  
     , qugi.codice cod_qualifica                       
     , pegi.qualifica                                  
     , pegi.tipo_rapporto                              
     , pegi.sede                                       
     , pegi.settore                                    
     , pegi.rilevanza                                  
     , apip.parte                                      
     , aeip.equipe                                     
     , nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
     , aqip.prestazione                                
     , nvl(aqip.ore,0) ore                             
     , asip.ore_ind                                    
     , aqip.importo                                    
     , asip.importo
     , aqip.rowid
FROM
    attribuzione_quote_incentivo  aqip,
    attribuzione_equipe_incentivo  aeip,
    qualifiche_incentivo  quip,
    qualifiche_giuridiche  qugi,
    periodi_giuridici  pegi,
    applicazioni_incentivo  apip,
    assegnazioni_incentivo  asip
 where aqip.progetto = apip.progetto
   and (    apip.valorizzazione  = 'I'
        and asip.dal       between aqip.dal
                               and nvl(aqip.al,to_date('3333333','j'))
        or  apip.valorizzazione != 'I'
        and aqip.dal <= least( nvl(aeip.al,to_date('3333333','j'))
                             , nvl(quip.al,to_date('3333333','j'))
                             , nvl(qugi.al,to_date('3333333','j'))
                             , nvl(pegi.al,to_date('3333333','j'))
                             , nvl(apip.al,to_date('3333333','j'))
                             , nvl(asip.al,to_date('3333333','j'))
                             )
        and nvl(aqip.al,to_date('3333333','j'))
                  >= greatest( aeip.dal
                             , nvl(quip.dal,to_date('2222222','j'))
                             , qugi.dal
                             , pegi.dal
                             , apip.dal
                             , asip.dal
                             )
       )
   and (    aqip.equipe = '%'
        or  aqip.equipe = aeip.equipe
       )
   and (    aqip.gruppo = '%'
        or  aqip.gruppo = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
       )
   and (    aqip.rapporto = '%'
        or  aqip.rapporto = (select rapporto
                               from rapporti_individuali
                              where ci = pegi.ci
                            )
       )
   and (    aqip.ruolo = '%'
        or  aqip.ruolo = (select ruolo
                            from posizioni
                           where codice = pegi.posizione
                         )
        and (    aqip.ruolo     != 'SI'
             or  aqip.ruolo      = 'SI'
             and pegi.rilevanza != 'E'
            )
       )
   and qugi.livello   like aqip.livello
   and qugi.contratto like aqip.contratto
   and qugi.codice    like aqip.qualifica
   and nvl(pegi.tipo_rapporto,' ') like aqip.tipo_rapporto
   and (    aqip.mesi  = 0
        or  aqip.mesi <=
           (select nvl
                   ( sum
                     ( trunc
                       ( months_between
                         ( last_day
                           ( least( nvl( peg2.al+1, riip.ini_mes )
                                  , riip.ini_mes
                                  )
                           )
                         , last_day(dal)
                         )
                       )
                     * 30
                     - least( 30
                            , to_number(to_char(peg2.dal,'dd'))
                            ) + 1
                     + least( 30
                            , to_number
                              ( to_char
                                ( least( nvl( peg2.al+1, riip.ini_mes)
                                       , riip.ini_mes
                                       )
                                , 'dd'
                                )
                              )
                            ) - 1
                     ) / 30
                   , 0
                   )
              from riferimento_incentivo riip
                 , periodi_giuridici     peg2
             where riip.riip_id   = 'RIIP'
               and peg2.dal      <= riip.ini_mes
               and peg2.qualifica = pegi.qualifica
               and peg2.rilevanza = 'Q'
               and peg2.ci        = decode(aqip.mesi,0,0,pegi.ci)
           )
       )
   and     aeip.gruppo  = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
   and (    aeip.settore = pegi.settore  
        and aeip.sede    = nvl(pegi.sede,0)
        or  aeip.settore = 0
        and aeip.sede    = 0
        and not exists
           (select 'x'
              from attribuzione_equipe_incentivo
             where gruppo       = nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
               and settore      = pegi.settore
               and sede         = nvl(pegi.sede,0)
           )
       )
   and aeip.dal         <= least( nvl(quip.al,to_date('3333333','j'))
                                , nvl(qugi.al,to_date('3333333','j'))
                                , nvl(pegi.al,to_date('3333333','j'))
                                , nvl(apip.al,to_date('3333333','j'))
                                , nvl(asip.al,to_date('3333333','j'))
                                )
   and nvl(aeip.al,to_date('3333333','j'))
                        >= greatest( nvl(quip.dal,to_date('2222222','j'))
                                   , qugi.dal
                                   , pegi.dal
                                   , apip.dal
                                   , asip.dal
                                   )
   and quip.numero (+) = pegi.qualifica
   and quip.dal (+)   <= nvl(pegi.al,to_date('3333333','j'))
   and nvl(quip.dal,to_date('2222222','j'))
                      <= least( nvl(qugi.al,to_date('3333333','j'))
                              , nvl(pegi.al,to_date('3333333','j'))
                              , nvl(apip.al,to_date('3333333','j'))
                              , nvl(asip.al,to_date('3333333','j'))
                              )
   and nvl(quip.al,to_date('3333333','j'))
                   >= greatest( qugi.dal
                              , pegi.dal
                              , apip.dal
                              , asip.dal
                              )
   and qugi.numero = pegi.qualifica
   and qugi.dal   <= least( nvl(pegi.al,to_date('3333333','j'))
                          , nvl(apip.al,to_date('3333333','j'))
                          , nvl(asip.al,to_date('3333333','j'))
                          )
   and nvl(qugi.al,to_date('3333333','j'))
               >= greatest( pegi.dal
                          , apip.dal
                          , asip.dal
                          )
   and pegi.rilevanza in ('S','E')
   and pegi.ci         = asip.ci
   and pegi.dal   <= least( nvl(apip.al,to_date('3333333','j'))
                          , nvl(asip.al,to_date('3333333','j'))
                          )
   and nvl(pegi.al,to_date('3333333','j'))
               >= greatest( apip.dal
                          , asip.dal
                          )
   and apip.progetto = asip.progetto
   and apip.dal     <= nvl(asip.al,to_date('3333333','j'))
   and nvl(apip.al,to_date('3333333','j'))
                    >= asip.dal
   and asip.data_agg != to_date('3333333','j')
;
