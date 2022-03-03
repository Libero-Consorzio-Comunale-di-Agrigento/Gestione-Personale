CREATE OR REPLACE VIEW giorni_servizio_incentivo
(
     progetto
    ,scp
    ,ci
    ,anno
    ,mese
    ,ini_mese
    ,inizio
    ,g_dal
    ,g_al
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
    ,per_liq
    ,fattore
    ,assenza
    ,incide
    ,per_ret
    ,ore
    ,importo
)
AS SELECT
       asip.progetto                                   
     , apip.scp
     , asip.ci                                         
     , mesi.anno
     , mesi.mese
     , mesi.ini_mese
     , asip.dal inizio                                 
     , decode
       ( to_char
         ( greatest( aqip.dal                              
                   , aeip.dal                              
                   , nvl(trip.dal,to_date('2222222','j'))  
                   , nvl(quip.dal,to_date('2222222','j'))  
                   , qugi.dal                              
                   , pegi.dal                              
                   , pgin.dal
                   , pgpr.dal
                   , apip.dal                              
                   , asip.dal                              
                   ) 
         , 'yyyymm'
         )
       , to_char(mesi.ini_mese,'yyyymm')
         , to_number
           ( to_char
             ( greatest( aqip.dal                              
                       , aeip.dal                              
                       , nvl(trip.dal,to_date('2222222','j'))  
                       , nvl(quip.dal,to_date('2222222','j'))  
                       , qugi.dal                              
                       , pegi.dal                              
                       , pgin.dal
                       , pgpr.dal
                       , apip.dal                              
                       , asip.dal                              
                       ) 
             , 'dd'
             )
           )
         , to_number(null)
       ) g_dal
     , decode
       ( least
         ( nvl(aqip.al,to_date('3333333','j'))
         , nvl(aeip.al,to_date('3333333','j'))
         , nvl(trip.al,to_date('3333333','j'))
         , nvl(quip.al,to_date('3333333','j'))
         , nvl(qugi.al,to_date('3333333','j'))
         , nvl(pegi.al,to_date('3333333','j'))
         , nvl(pgin.al,to_date('3333333','j'))
         , nvl(pgpr.al,to_date('3333333','j'))
         , nvl(apip.al,to_date('3333333','j'))
         , nvl(asip.al,to_date('3333333','j'))
         )                                  
       , mesi.fin_mese, to_number(null)
         , decode
           ( to_char
             ( least
               ( nvl(aqip.al,to_date('3333333','j'))
               , nvl(aeip.al,to_date('3333333','j'))
               , nvl(trip.al,to_date('3333333','j'))
               , nvl(quip.al,to_date('3333333','j'))
               , nvl(qugi.al,to_date('3333333','j'))
               , nvl(pegi.al,to_date('3333333','j'))
               , nvl(pgin.al,to_date('3333333','j'))
               , nvl(pgpr.al,to_date('3333333','j'))
               , nvl(apip.al,to_date('3333333','j'))
               , nvl(asip.al,to_date('3333333','j'))
               )                                  
             , 'yyyymm'
             )
           , to_char(mesi.fin_mese,'yyyymm')
             , to_number
               ( to_char
                 ( least
                   ( nvl(aqip.al,to_date('3333333','j'))
                   , nvl(aeip.al,to_date('3333333','j'))
                   , nvl(trip.al,to_date('3333333','j'))
                   , nvl(quip.al,to_date('3333333','j'))
                   , nvl(qugi.al,to_date('3333333','j'))
                   , nvl(pegi.al,to_date('3333333','j'))
                   , nvl(pgin.al,to_date('3333333','j'))
                   , nvl(pgpr.al,to_date('3333333','j'))
                   , nvl(apip.al,to_date('3333333','j'))
                   , nvl(asip.al,to_date('3333333','j'))
                   )
                 , 'dd'
                 )
               )
             , to_number(null)                                
           )
       ) g_al                                            
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
     , decode(apip.valorizzazione,'D',100,apip.per_liq)
     , decode(pgin.rilevanza,'Q',1,-1) fattore
     , aste.codice assenza
     , aste.incide_gipe incide
     , aste.per_ret
     , nvl(asip.ore_ind,aqip.ore) ore                             
     , nvl(asip.importo,nvl(aqip.importo,nvl(trip.tetto,0))) importo
  from attribuzione_quote_incentivo  aqip,
       attribuzione_equipe_incentivo  aeip,
       tetti_retributivi_incentivo trip,
       qualifiche_incentivo  quip,
       qualifiche_giuridiche  qugi,
       astensioni aste,
       periodi_giuridici  pegi,
       periodi_giuridici  pgin,
       periodi_giuridici  pgpr,
       applicazioni_incentivo  apip,
       assegnazioni_incentivo  asip,
       mesi mesi
 where aqip.progetto = decode( apip.valorizzazione
                             , 'D', 'S1D'
                                  , apip.progetto
                             )
   and (    apip.valorizzazione  = 'I'
        and asip.dal       between aqip.dal
                               and nvl(aqip.al,to_date('3333333','j'))
        or  apip.valorizzazione != 'I'
        and aqip.dal <= least( nvl(aeip.al,to_date('3333333','j'))
                             , nvl(trip.al,to_date('3333333','j'))
                             , nvl(quip.al,to_date('3333333','j'))
                             , nvl(qugi.al,to_date('3333333','j'))
                             , nvl(pegi.al,to_date('3333333','j'))
                             , nvl(pgin.al,to_date('3333333','j'))
                             , nvl(pgpr.al,to_date('3333333','j'))
                             , nvl(apip.al,to_date('3333333','j'))
                             , nvl(asip.al,to_date('3333333','j'))
                             , mesi.fin_mese
                             )
        and nvl(aqip.al,to_date('3333333','j'))
                  >= greatest( aeip.dal
                             , nvl(quip.dal,to_date('2222222','j'))
                             , nvl(trip.dal,to_date('2222222','j'))
                             , qugi.dal
                             , pegi.dal
                             , pgin.dal
                             , pgpr.dal
                             , apip.dal
                             , asip.dal
                             , mesi.ini_mese
                             )
       )
   and (    aqip.equipe = '%'
        or  aqip.equipe = aeip.equipe
       )
   and (    aqip.gruppo = '%'
        or  aqip.gruppo = decode( apip.valorizzazione
                                , 'D', 'D'
                                     , nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
                                )
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
             and pgin.rilevanza != 'E'
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
                           ( least( nvl( peg2.al+1, mesi.ini_mese )
                                  , mesi.ini_mese
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
                                ( least( nvl( peg2.al+1, mesi.ini_mese)
                                       , mesi.ini_mese
                                       )
                                , 'dd'
                                )
                              )
                            ) - 1
                     ) / 30
                   , 0
                   )
              from periodi_giuridici peg2
             where peg2.dal      <= mesi.ini_mese
               and peg2.qualifica = pegi.qualifica
               and peg2.rilevanza = 'Q'
               and peg2.ci        = decode(aqip.mesi,0,0,pegi.ci)
           )
       )
   and aeip.gruppo = decode( apip.valorizzazione
                           , 'D', 'D'
                                , nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
                           )
   and (    aeip.settore = pegi.settore
        and aeip.sede    = nvl(pegi.sede,0)
        or  aeip.settore = 0
        and aeip.sede    = 0
        and not exists
           (select 'x'
              from attribuzione_equipe_incentivo
             where gruppo   = decode( apip.valorizzazione
                                    , 'D', 'D'
                                         , nvl(pegi.gruppo,nvl(quip.gruppo,'D'))
                                    )
               and settore  = pegi.settore
               and sede     = nvl(pegi.sede,0)
           )
       )
   and aeip.dal    <= least( nvl(trip.al,to_date('3333333','j'))
                           , nvl(quip.al,to_date('3333333','j'))
                           , nvl(qugi.al,to_date('3333333','j'))
                           , nvl(pegi.al,to_date('3333333','j'))
                           , nvl(pgin.al,to_date('3333333','j'))
                           , nvl(pgpr.al,to_date('3333333','j'))
                           , nvl(apip.al,to_date('3333333','j'))
                           , nvl(asip.al,to_date('3333333','j'))
                           , mesi.fin_mese
                           )
   and nvl(aeip.al,to_date('3333333','j'))
                   >= greatest( nvl(trip.dal,to_date('2222222','j'))
                              , nvl(quip.dal,to_date('2222222','j'))
                              , qugi.dal
                              , pegi.dal
                              , pgin.dal
                              , pgpr.dal
                              , apip.dal
                              , asip.dal
                              , mesi.ini_mese
                              )
   and trip.ci (+)         = pegi.ci
   and trip.rilevanza (+)  = pegi.rilevanza
   and trip.decorrenza (+) = pegi.dal
   and trip.dal (+)       <= nvl(pegi.al,to_date('3333333','j'))
   and nvl(trip.dal,to_date('2222222','j'))
                          <= least( nvl(quip.al,to_date('3333333','j'))
                                  , nvl(qugi.al,to_date('3333333','j'))
                                  , nvl(pegi.al,to_date('3333333','j'))
                                  , nvl(pgin.al,to_date('3333333','j'))
                                  , nvl(pgpr.al,to_date('3333333','j'))
                                  , nvl(apip.al,to_date('3333333','j'))
                                  , nvl(asip.al,to_date('3333333','j'))
                                  , mesi.fin_mese
                                  )
   and nvl(trip.al,to_date('3333333','j'))
                          >= greatest( nvl(quip.dal,to_date('2222222','j'))
                                     , qugi.dal
                                     , pegi.dal
                                     , pgin.dal
                                     , pgpr.dal
                                     , apip.dal
                                     , asip.dal
                                     , mesi.ini_mese
                                     )
   and quip.numero (+) = pegi.qualifica
   and quip.dal (+)   <= nvl(pegi.al,to_date('3333333','j'))
   and nvl(quip.dal,to_date('2222222','j'))
                      <= least( nvl(qugi.al,to_date('3333333','j'))
                              , nvl(pegi.al,to_date('3333333','j'))
                              , nvl(pgin.al,to_date('3333333','j'))
                              , nvl(pgpr.al,to_date('3333333','j'))
                              , nvl(apip.al,to_date('3333333','j'))
                              , nvl(asip.al,to_date('3333333','j'))
                              , mesi.fin_mese
                              )
   and nvl(quip.al,to_date('3333333','j'))
                      >= greatest( qugi.dal
                                 , pegi.dal
                                 , pgin.dal
                                 , pgpr.dal
                                 , apip.dal
                                 , asip.dal
                                 , mesi.ini_mese
                                 )
   and qugi.numero = pegi.qualifica
   and qugi.dal   <= least( nvl(pegi.al,to_date('3333333','j'))
                          , nvl(pgin.al,to_date('3333333','j'))
                          , nvl(pgpr.al,to_date('3333333','j'))
                          , nvl(apip.al,to_date('3333333','j'))
                          , nvl(asip.al,to_date('3333333','j'))
                          , mesi.fin_mese
                          )
   and nvl(qugi.al,to_date('3333333','j'))
                  >= greatest( pegi.dal
                             , pgin.dal
                             , pgpr.dal
                             , apip.dal
                             , asip.dal
                             , mesi.ini_mese
                             )
   and aste.codice(+)  = pgpr.assenza
   and pegi.rilevanza in ('S','E')
   and pegi.rilevanza != pgin.rilevanza
   and pegi.ci         = pgin.ci
   and pegi.dal       <= least( nvl(pgin.al,to_date('3333333','j'))
                              , nvl(pgpr.al,to_date('3333333','j'))
                              , nvl(apip.al,to_date('3333333','j'))
                              , nvl(asip.al,to_date('3333333','j'))
                              , mesi.fin_mese
                              )
   and nvl(pegi.al,to_date('3333333','j'))
                      >= greatest( pgin.dal
                                 , pgpr.dal
                                 , apip.dal
                                 , asip.dal
                                 , mesi.ini_mese
                                 )
   and pgin.rilevanza in ('Q','E')
   and pgin.ci         = pgpr.ci
   and pgin.dal       <= least( nvl(pgpr.al,to_date('3333333','j'))
                              , nvl(apip.al,to_date('3333333','j'))
                              , nvl(asip.al,to_date('3333333','j'))
                              , mesi.fin_mese
                              )
   and nvl(pgin.al,to_date('3333333','j'))
                      >= greatest( pgpr.dal
                                 , apip.dal
                                 , asip.dal
                                 , mesi.ini_mese
                                 )
   and pgpr.rilevanza in ('Q','A')
   and pgpr.ci         = asip.ci
   and pgpr.dal       <= least( nvl(apip.al,to_date('3333333','j'))
                              , nvl(asip.al,to_date('3333333','j'))
                              , mesi.fin_mese
                              )
   and nvl(pgpr.al,to_date('3333333','j'))
                      >= greatest( apip.dal
                                 , asip.dal
                                 , mesi.ini_mese
                                 )
   and apip.progetto = asip.progetto
   and apip.dal     <= least( nvl(asip.al,to_date('3333333','j'))
                            , mesi.fin_mese
                            )
   and nvl(apip.al,to_date('3333333','j'))
                    >= greatest( asip.dal
                               , mesi.ini_mese
                               )
   and asip.dal      <= mesi.fin_mese
   and nvl(asip.al,to_date('3333333','j'))
                     >= mesi.ini_mese
   and asip.data_agg != to_date('3333333','j')
;

