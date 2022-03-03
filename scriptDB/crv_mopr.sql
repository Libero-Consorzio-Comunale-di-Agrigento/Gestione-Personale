CREATE OR REPLACE VIEW movimenti_previsione
(
     ci
    ,anno
    ,mese
    ,mensilita
    ,divisione
    ,sezione
    ,gestione
    ,settore
    ,sede
    ,funzionale
    ,cdc
    ,ruolo
    ,di_ruolo
    ,contratto
    ,qualifica
    ,tipo_rapporto
    ,ore
    ,trattamento
    ,figura
    ,attivita
    ,bilancio
    ,budget
    ,riferimento
    ,arr
    ,sede_del
    ,anno_del
    ,numero_del
    ,risorsa_intervento
    ,capitolo
    ,articolo
    ,impegno
    ,anno_impegno
    ,sub_impegno
    ,anno_sub_impegno
    ,conto
    ,importo
    ,istituto
    ,imponibile
    ,quantita
    ,nr_voci
    ,codice_siope
)
AS SELECT
       mocp.ci                                         
     , mocp.anno                                       
     , mocp.mese                                       
     , mocp.mensilita                                  
     , decode(rico.divisione,'%',perp.gestione,rico.divisione)
     , decode(rico.sezione,'%',perp.gestione,rico.sezione)
     , perp.gestione                                   
     , nvl(mocp.settore,perp.settore)                                    
     , decode(mocp.settore,'',perp.sede,mocp.sede)
     , decode(mocp.settore,'',rif2.funzionale,rifu.funzionale)
     , decode(mocp.settore,'',rif2.cdc,rifu.cdc)
     , perp.ruolo                                      
     , posi.di_ruolo                                   
     , perp.contratto                                  
     , perp.qualifica                                  
     , perp.tipo_rapporto                              
     , perp.ore                                        
     , perp.trattamento                                
     , perp.figura                                     
     , perp.attivita                                   
     , cobi.codice                                     
     , decode( cobi.codice                             
             , mocp.bilancio, mocp.budget              
                            , cobi.budget              
             )                                         
     , mocp.riferimento                                
     , mocp.arr                           
     , nvl(mocp.sede_del, perp.sede_del)               
     , nvl(mocp.anno_del, perp.anno_del)               
     , nvl(mocp.numero_del, perp.numero_del)
     , decode                                          
       ( cobi.codice                                   
       , mocp.bilancio, decode                         
                        ( mocp.risorsa_intervento                
                        , null, nvl(rico.risorsa_intervento,'0') 
                              , mocp.risorsa_intervento          
                        )                              
                      , nvl(rico.risorsa_intervento,'0')         
       )             
     , decode                                          
       ( cobi.codice                                   
       , mocp.bilancio, decode                         
                        ( mocp.capitolo                
                        , null, nvl(rico.capitolo,'0') 
                              , mocp.capitolo          
                        )                              
                      , nvl(rico.capitolo,'0')         
       )                                               
     , decode                                          
       ( cobi.codice                                   
       , mocp.bilancio, decode                         
                        ( mocp.articolo               
                        , null, nvl(rico.articolo,'0') 
                              , nvl(mocp.articolo,'0') 
                        )                              
                      , nvl(rico.articolo,'0')         
       )
     , decode                                          
       ( cobi.codice                                   
       , mocp.bilancio, decode                         
                        ( mocp.impegno
                        , null, rico.impegno
                              , mocp.impegno
                        )                              
                      , rico.impegno        
       )
     , decode                                          
       ( cobi.codice                                   
       , mocp.bilancio, decode                         
                        ( mocp.anno_impegno
                        , null, rico.anno_impegno
                              , mocp.anno_impegno
                        )                              
                      , rico.anno_impegno        
       )
     , decode                                          
       ( cobi.codice                                   
       , mocp.bilancio, decode                         
                        ( mocp.sub_impegno
                        , null, rico.sub_impegno
                              , mocp.sub_impegno
                        )                              
                      , rico.sub_impegno        
       )
     , decode                                          
       ( cobi.codice                                   
       , mocp.bilancio, decode                         
                        ( mocp.anno_sub_impegno
                        , null, rico.anno_sub_impegno
                              , mocp.anno_sub_impegno
                        )                              
                      , rico.anno_sub_impegno        
       ) 
     , decode( rico.arr 
             , 'P', nvl( decode ( cobi.codice
                                , mocp.bilancio, decode(mocp.RISORSA_INTERVENTO||mocp.CAPITOLO||mocp.IMPEGNO||mocp.SUB_IMPEGNO
                                                       , null, rico.conto
                                                             , mocp.conto
                                                       )
                                               , rico.conto 
                         ) 
                       , decode( least( to_char(mocp.riferimento,'yyyy'), mocp.anno) 
                                      , mocp.anno, 'AP' 
                                                 , substr(to_char(mocp.riferimento,'yy'),1,2) 
                               ) 
                       ) 
              , 'S', nvl( decode ( cobi.codice
                                 , mocp.bilancio, decode(mocp.RISORSA_INTERVENTO||mocp.CAPITOLO||mocp.IMPEGNO||mocp.SUB_IMPEGNO
                                                       , null, rico.conto
                                                             , mocp.conto
                                                        )
                                               , rico.conto 
                                )
                       , decode( least( to_char(mocp.riferimento,'yyyy') , mocp.anno ) 
                                      , mocp.anno, 'AP' , substr(to_char(mocp.riferimento,'yy'),1,2)
                                ) 
                       )
                   , decode
                     ( cobi.codice
                     , mocp.bilancio, decode(mocp.RISORSA_INTERVENTO||mocp.CAPITOLO||mocp.IMPEGNO||mocp.SUB_IMPEGNO
                                            , null, rico.conto
                                                  , mocp.conto
                                            )
                                    , rico.conto
                     )
              )                                                         conto
     , e_round( decode( rico.arr                                                
                    , 'C', nvl(mocp.imp,0) - nvl(mocp.ipn_p,0)
                    , 'A', nvl(mocp.imp,0) - nvl(mocp.ipn_p,0) 
                    , 'P', decode( mocp.arr, 'P', 0 , nvl(mocp.imp,0) - nvl(mocp.ipn_p,0) )
                    , 'S', decode( mocp.arr, 'P', nvl(mocp.imp,0), nvl(mocp.ipn_p,0) )
                         , nvl(mocp.imp,0)  
                    ) 
            * decode(sign(perp.rap_ore),-1,-1,1)       
            / nvl(perp.intero,1)                       
            * nvl(perp.quota,1)                        
            * decode(rico.input_segno,'-',-1,1)        
            , 'I')                                                     importo
     , cobi.istituto
     , e_round( decode( mocp.ipn_p
                      , null, 0
                            , decode( rico.arr
                                     , 'C', nvl(mocp.tar,0) - nvl(mocp.ipn_eap,0)
                                     , 'A', nvl(mocp.tar,0) - nvl(mocp.ipn_eap,0) 
                                     , 'P', nvl(mocp.tar,0) - nvl(mocp.ipn_eap,0) 
                                     , 'S', nvl(mocp.ipn_eap,0) 
                                          , nvl(mocp.tar,0)
                                  )
                    )
            * decode(sign(perp.rap_ore),-1,-1,1)
            / nvl(perp.intero,1)
            * nvl(perp.quota,1)
            * decode(rico.input_segno,'-',-1,1)
            , 'I') * decode(cobi.codice,mocp.bilancio,1,0)             imponibile
     , e_round( decode( rico.arr
                    , 'P', 0
                         , nvl(mocp.qta,0)
                    )        
            * decode(sign(perp.rap_ore),-1,-1,1)       
            / nvl(perp.intero,1)                       
            * nvl(perp.quota,1)                        
            * decode(rico.input_segno,'-',-1,1)        
            , 'I')                                              quantita   
     , 1             
     , decode                                          
       ( cobi.codice                                   
       , mocp.bilancio, decode                         
                        ( mocp.codice_siope                
                        , null, rico.codice_siope
                              , mocp.codice_siope        
                        )                              
                      , rico.codice_siope
       )                                                                         
FROM
    ripartizioni_contabili  rico,
    posizioni  posi,
    ripartizioni_funzionali  rifu,
    ripartizioni_funzionali  rif2,
    periodi_retributivi_bp  perp,
    codici_bilancio  cobi,
    mesi  mese,
    movimenti_contabili_previsione  mocp
 where cobi.codice      = nvl(rico.input_bilancio, mocp.bilancio)
   and cobi.budget is not null
   and rifu.settore (+) = mocp.settore
   and rifu.sede    (+) = nvl(mocp.sede,0)
   and rif2.settore (+) = perp.settore
   and rif2.sede    (+) = nvl(perp.sede,0)
   and posi.codice  (+) = perp.posizione
   and perp.ci          = mocp.ci
   and perp.periodo     = last_day(to_date( to_char(mocp.anno)||
                                            to_char(mocp.mese)
                                          , 'yyyymm'
                                          )
                                  )
   and perp.competenza in ('D','C','A')
   and mocp.riferimento between perp.dal and perp.al
   and nvl(mocp.imp,0) + nvl(mocp.ipn_p,0) != 0
   and mese.anno = decode
                   ( mocp.arr||to_char(mocp.ipn_p)
                   , null, mocp.anno
                         , to_number(to_char(mocp.riferimento,'yyyy'))
                   )
   and (    mese.mese = 1
        or (    nvl(mocp.ipn_p,0) != 0
            and mese.mese = 2
           )
       )
   and rico.chiave =
      (select max(chiave)
         from ripartizioni_contabili
        where (   bilancio = mocp.bilancio
               or bilancio = '%'
              )
          and (   decode( mese.anno
                        , mocp.anno, decode( mese.mese
                                           , 1, decode( mocp.mese
                                                       , to_number(to_char(mocp.riferimento,'mm')), 'C'
                                                                                                  , 'A'
                                                       ) 
                                              , decode(arr, '%', null, 'S')
                                           )
                                   , decode( mese.mese
                                            , 1, decode( mocp.arr, 'P', 'S', 'P')
                                               , decode(arr, '%', null, 'S') 
                                            )
                        ) like arr
               or  mese.anno != mocp.anno 
               and mese.mese != 2
               and to_char( mocp.anno
                          - to_number(to_char(mocp.riferimento,'yyyy'))
                          )                = arr
              ) 
          and nvl(rifu.funzionale,nvl(rif2.funzionale,' ')) 
                                       like funzionale
          and nvl(posi.di_ruolo  ,' ') like di_ruolo
          and nvl(perp.ruolo     ,' ') like ruolo
          and nvl(perp.contratto ,' ') like contratto
          and nvl(perp.gestione  ,' ') like gestione
      )
;
