CREATE OR REPLACE FORCE VIEW movimenti_bilancio
( anno
, mese
, mensilita
, divisione
, sezione
, gestione
, settore
, sede
, funzionale
, cdc
, ruolo
, contratto
, posizione
, figura
, attivita
, qualifica
, tipo_rapporto
, ore
, di_ruolo
, ci
, voce
, sub
, bilancio
, budget
, anno_rif
, anno_comp
, arr
, sede_del
, anno_del
, numero_del
, risorsa_intervento
, capitolo
, articolo
, conto
, impegno
, anno_impegno
, sub_impegno
, anno_sub_impegno
, codice_siope
, importo
, istituto
, imponibile
, quantita
, nr_voci
, riferimento
, tassazione
) AS select mobi.anno
          , mobi.mese 
          , mobi.mensilita 
          , mobi.divisione 
          , mobi.sezione 
          , mobi.gestione 
          , mobi.settore 
          , mobi.sede 
          , mobi.funzionale 
          , mobi.cdc 
          , mobi.ruolo 
          , mobi.contratto 
          , mobi.posizione 
          , mobi.figura 
          , mobi.attivita 
          , mobi.qualifica 
          , mobi.tipo_rapporto 
          , mobi.ore 
          , mobi.di_ruolo 
          , mobi.ci 
          , mobi.voce 
          , mobi.sub 
          , mobi.bilancio 
          , mobi.budget 
          , mobi.anno_rif 
          , mobi.anno_comp
          , mobi.arr 
          , decode(mobi.imputazione_delibera,'SI', mobi.sede_del, null) sede_del 
          , decode(mobi.imputazione_delibera,'SI', mobi.anno_del, null) anno_del 
          , decode(mobi.imputazione_delibera,'SI', mobi.numero_del, null) numero_del 
          , decode( decode( mobi.imputazione_delibera 
                          , 'SI' , rdre.risorsa_intervento||rdre.capitolo||rdre.impegno||rdre.sub_impegno 
                                 , null 
                          ) 
                  , null, nvl(mobi.risorsa_intervento,'0') 
                        , nvl(rdre.risorsa_intervento,'0') 
                  ) risorsa_intervento 
          , decode( decode( mobi.imputazione_delibera 
                          , 'SI' , rdre.risorsa_intervento||rdre.capitolo||rdre.impegno||rdre.sub_impegno 
                                  , null 
                          ) 
                 , null, nvl(mobi.capitolo,'0') 
                        , nvl(rdre.capitolo,'0') 
                  ) capitolo 
          , decode( decode( mobi.imputazione_delibera 
                          , 'SI' , rdre.risorsa_intervento||rdre.capitolo||rdre.impegno||rdre.sub_impegno 
                                 , null 
                          ) 
                  , null, nvl(mobi.articolo,'0') 
                        , nvl(rdre.articolo,'0') 
                  ) articolo 
          , decode( decode( mobi.imputazione_delibera 
                          , 'SI' , rdre.risorsa_intervento||rdre.capitolo||rdre.impegno||rdre.sub_impegno 
                                  , null 
                          ) 
                  , null, mobi.conto 
                        , rdre.conto 
                  ) conto 
          , decode( decode( mobi.imputazione_delibera 
                          , 'SI' , rdre.risorsa_intervento||rdre.capitolo||rdre.impegno||rdre.sub_impegno 
                                 , null 
                          ) 
                  , null, mobi.impegno 
                        , rdre.impegno 
                  ) impegno 
          , decode( decode( mobi.imputazione_delibera 
                          , 'SI' , rdre.risorsa_intervento||rdre.capitolo||rdre.impegno||rdre.sub_impegno 
                                 , null 
                          ) 
                  , null, mobi.anno_impegno 
                        , rdre.anno_impegno 
                  ) anno_impegno 
          , decode( decode( mobi.imputazione_delibera 
                          , 'SI' , rdre.risorsa_intervento||rdre.capitolo||rdre.impegno||rdre.sub_impegno 
                                 , null 
                          ) 
                  , null, mobi.sub_impegno 
                        , rdre.sub_impegno 
                  ) sub_impegno 
          , decode( decode( mobi.imputazione_delibera 
                          , 'SI' , rdre.risorsa_intervento||rdre.capitolo||rdre.impegno||rdre.sub_impegno 
                                 , null 
                          ) 
                  , null, mobi.anno_sub_impegno 
                        , rdre.anno_sub_impegno 
                  ) anno_sub_impegno 
          , decode( decode( mobi.imputazione_delibera 
                          , 'SI' , rdre.risorsa_intervento||rdre.capitolo||rdre.impegno||rdre.sub_impegno 
                                 , null 
                          ) 
                  , null, mobi.codice_siope
                        , decode( mobi.tassazione
                                , 'C', rdre.codice_siope
                                , 'A', nvl(rdre.codice_siope_c,rdre.codice_siope)
                                , 'S', nvl(rdre.codice_siope_s,rdre.codice_siope)
                                , 'P', nvl(rdre.codice_siope_p,rdre.codice_siope)
                                     , rdre.codice_siope
                                )
                  ) codice_siope 
          , mobi.importo 
          , mobi.istituto 
          , mobi.imponibile 
          , mobi.quantita 
          , mobi.nr_voci 
          , mobi.riferimento 
          , mobi.tassazione
  from righe_delibera_retributiva rdre 
     ,(select 
       moco.anno 
     , moco.mese 
     , moco.mensilita 
     , decode(rico.divisione,'%',pere.gestione,rico.divisione) divisione 
     , decode(rico.sezione,'%',pere.gestione,rico.sezione) sezione 
     , pere.gestione 
     , pere.settore 
     , pere.sede 
     , rifu.funzionale 
     , rifu.cdc 
     , pere.ruolo 
     , pere.contratto 
     , pere.posizione 
     , pere.figura 
     , pere.attivita 
     , pere.qualifica 
     , pere.tipo_rapporto 
     , pere.ore 
     , posi.di_ruolo 
     , moco.ci 
     , moco.voce 
     , moco.sub 
     , cobi.codice bilancio 
     , cobi.imputazione_delibera 
     , decode(cobi.codice,covo.bilancio,covo.budget,cobi.budget) budget 
     , to_number(to_char(moco.riferimento,'yyyy')) anno_rif 
     , to_number(to_char(moco.competenza,'yyyy')) anno_comp
     , moco.arr 
     , nvl(moco.sede_del,   nvl(covo.sede_del,   pere.sede_del)) sede_del 
     , nvl(moco.anno_del,   nvl(covo.anno_del,   pere.anno_del)) anno_del 
     , nvl(moco.numero_del, nvl(covo.numero_del, pere.numero_del)) numero_del 
     , nvl(moco.delibera,   decode(covo.sede_del, null, nvl(pere.delibera,'*'), '*')) delibera 
     , decode 
       ( cobi.codice 
       , decode(moco.input,'D',cobi.codice,covo.bilancio) 
         , decode 
           ( moco.risorsa_intervento||moco.capitolo||moco.impegno||moco.sub_impegno 
           , null 
             , decode 
               ( covo.risorsa_intervento||covo.capitolo||covo.impegno||covo.sub_impegno 
               , null, nvl(rico.risorsa_intervento,'0') 
                     , nvl(covo.risorsa_intervento,'0') 
               ) 
             , nvl(moco.risorsa_intervento,'0') 
           ) 
         , nvl(rico.risorsa_intervento,'0') 
       ) risorsa_intervento 
     , decode 
       ( cobi.codice 
       , decode(moco.input,'D',cobi.codice,covo.bilancio) 
         , decode 
           ( moco.risorsa_intervento||moco.capitolo||moco.impegno||moco.sub_impegno 
           , null 
             , decode 
               ( covo.risorsa_intervento||covo.capitolo||covo.impegno||covo.sub_impegno 
               , null, nvl(rico.capitolo,'0') 
                     , nvl(covo.capitolo,'0') 
               ) 
             , nvl(moco.capitolo,'0') 
           ) 
         , nvl(rico.capitolo,'0') 
       ) capitolo 
     , decode 
       ( cobi.codice 
       , decode(moco.input,'D',cobi.codice,covo.bilancio) 
         , decode 
           ( moco.risorsa_intervento||moco.capitolo||moco.impegno||moco.sub_impegno 
           , null 
             , decode 
               ( covo.risorsa_intervento||covo.capitolo||covo.impegno||covo.sub_impegno 
               , null, nvl(rico.articolo,'0') 
                     , nvl(covo.articolo,'0') 
               ) 
             , nvl(moco.articolo,'0') 
           ) 
         , nvl(rico.articolo,'0') 
       ) articolo 
     , decode 
       ( cobi.codice 
       , decode(moco.input,'D',cobi.codice,covo.bilancio) 
         , decode 
           ( moco.risorsa_intervento||moco.capitolo||moco.impegno||moco.sub_impegno 
           , null 
             , decode 
               ( covo.risorsa_intervento||covo.capitolo||covo.impegno||covo.sub_impegno 
               , null, rico.impegno 
                     , covo.impegno 
               ) 
             , moco.impegno 
           ) 
         , rico.impegno 
       ) impegno 
     , decode 
       ( cobi.codice 
       , decode(moco.input,'D',cobi.codice,covo.bilancio) 
         , decode 
           ( moco.risorsa_intervento||moco.capitolo||moco.impegno||moco.sub_impegno 
           , null 
             , decode 
               ( covo.risorsa_intervento||covo.capitolo||covo.impegno||covo.sub_impegno 
               , null, rico.anno_impegno 
                     , covo.anno_impegno 
               ) 
             , moco.anno_impegno 
           ) 
         , rico.anno_impegno 
       ) anno_impegno 
     , decode 
       ( cobi.codice 
       , decode(moco.input,'D',cobi.codice,covo.bilancio) 
         , decode 
           ( moco.risorsa_intervento||moco.capitolo||moco.impegno||moco.sub_impegno 
           , null 
             , decode 
               ( covo.risorsa_intervento||covo.capitolo||covo.impegno||covo.sub_impegno 
               , null, rico.sub_impegno 
                     , covo.sub_impegno 
               ) 
             , moco.sub_impegno 
           ) 
         , rico.sub_impegno 
       ) sub_impegno 
     , decode 
       ( cobi.codice 
       , decode(moco.input,'D',cobi.codice,covo.bilancio) 
         , decode 
           ( moco.risorsa_intervento||moco.capitolo||moco.impegno||moco.sub_impegno 
           , null 
             , decode 
               ( covo.risorsa_intervento||covo.capitolo||covo.impegno||covo.sub_impegno 
               , null, rico.anno_sub_impegno 
                     , covo.anno_sub_impegno 
               ) 
             , moco.anno_sub_impegno 
           ) 
         , rico.anno_sub_impegno 
       ) anno_sub_impegno 
     , decode 
       ( cobi.codice 
       , decode(moco.input,'D',cobi.codice,covo.bilancio) 
         , decode 
           ( moco.risorsa_intervento||moco.capitolo||moco.impegno||moco.sub_impegno 
           , null 
             , decode 
               ( covo.risorsa_intervento||covo.capitolo||covo.impegno||covo.sub_impegno 
               , null, rico.codice_siope
                     , covo.codice_siope 
               ) 
             , moco.codice_siope
           ) 
         , rico.codice_siope
       ) codice_siope
     , decode( rico.arr 
             , 'P', nvl( decode 
                         ( cobi.codice 
                         , decode(moco.input,'D',cobi.codice,covo.bilancio) 
                           , decode 
                             ( moco.risorsa_intervento||moco.capitolo||moco.impegno||moco.sub_impegno 
                             , null 
                               , decode 
                                 ( covo.risorsa_intervento||covo.capitolo||covo.impegno||covo.sub_impegno 
                                 , null, rico.conto 
                                       , covo.conto 
                                 ) 
                               , moco.conto 
                             ) 
                           , rico.conto 
                         ) 
                       , decode( least( to_char(moco.riferimento,'yyyy') 
                                      , moco.anno 
                                      ) 
                               , moco.anno, 'AP' 
                                          , substr(to_char(moco.riferimento,'yy'),1,2) 
                               ) 
                       ) 
              , 'S', nvl( decode 
                         ( cobi.codice 
                         , decode(moco.input,'D',cobi.codice,covo.bilancio) 
                           , decode 
                             ( moco.risorsa_intervento||moco.capitolo||moco.impegno||moco.sub_impegno 
                             , null 
                               , decode 
                                 ( covo.risorsa_intervento||covo.capitolo||covo.impegno||covo.sub_impegno 
                                 , null, rico.conto 
                                       , covo.conto 
                                 ) 
                               , moco.conto 
                             ) 
                           , rico.conto 
                         ) 
                       , decode( least( to_char(moco.riferimento,'yyyy') 
                                      , moco.anno 
                                      ) 
                               , moco.anno, 'AP' 
                                          , substr(to_char(moco.riferimento,'yy'),1,2) 
                               ) 
                       ) 
                  , decode 
                    ( cobi.codice 
                    , decode(moco.input,'D',cobi.codice,covo.bilancio) 
                      , decode 
                        ( moco.risorsa_intervento||moco.capitolo||moco.impegno||moco.sub_impegno 
                        , null 
                          , decode 
                            ( covo.risorsa_intervento||covo.capitolo||covo.impegno||covo.sub_impegno 
                            , null, rico.conto 
                                  , covo.conto 
                            ) 
                          , moco.conto 
                        ) 
                      , rico.conto 
                    ) 
             ) conto 
     , e_round( decode( rico.arr 
                    , 'C', nvl(moco.imp,0) - nvl(moco.ipn_p,0) 
                    , 'A', nvl(moco.imp,0) - nvl(moco.ipn_p,0) 
                    , 'P', decode( moco.arr, 'P', 0              , nvl(moco.imp,0) - nvl(moco.ipn_p,0) )
                    , 'S', decode( moco.arr, 'P', nvl(moco.imp,0), nvl(moco.ipn_p,0) )
                         , nvl(moco.imp,0)  
                    ) 
            * decode(sign(pere.rap_ore),-1,-1,1) 
            * decode(pere.competenza,'P',-1,1) 
            * decode( nvl(pere.intero,1) 
                    ,0 , 1 
                       , nvl(pere.quota,1) / nvl(pere.intero,1) 
                    ) 
            * decode(rico.input_segno,'-',-1,1) 
            ,'I') importo 
     , decode( cobi.codice 
             , decode(moco.input,'D',cobi.codice,covo.bilancio) 
               , nvl(inre.istituto,nvl(covo.istituto, nvl(rico.istituto,cobi.istituto))) 
                 , nvl(rico.istituto,cobi.istituto) 
             ) istituto 
     , e_round( decode( moco.ipn_p 
                    , null, 0 
                          , decode( rico.arr 
                                  , 'C', nvl(moco.tar,0) - nvl(moco.ipn_eap,0) 
                                  , 'A', nvl(moco.tar,0) - nvl(moco.ipn_eap,0) 
                                  , 'P', nvl(moco.tar,0) - nvl(moco.ipn_eap,0) 
                                  , 'S', nvl(moco.ipn_eap,0) 
                                       , nvl(moco.tar,0) 
                                  ) 
                    ) 
            * decode(sign(pere.rap_ore),-1,-1,1) 
            * decode(pere.competenza,'P',-1,1) 
            * decode( nvl(pere.intero,1) 
                    ,0 , 1 
                       , nvl(pere.quota,1) / nvl(pere.intero,1) 
                    ) 
            * decode(rico.input_segno,'-',-1,1) 
            ,'I') * decode(cobi.codice,covo.bilancio,1,0) imponibile 
     , e_round( decode( rico.arr 
                    , 'P', 0 
                         , nvl(moco.qta,0) 
                    ) 
            * decode(sign(pere.rap_ore),-1,-1,1) 
            * decode(pere.competenza,'P',-1,1) 
            * decode( nvl(pere.intero,1) 
                    ,0 , 1 
                       , nvl(pere.quota,1) / nvl(pere.intero,1) 
                    ) 
            * decode(rico.input_segno,'-',-1,1) 
            ,'I') quantita 
     , 1 nr_voci 
     , moco.riferimento 
     , rico.arr tassazione
  from ripartizioni_contabili     rico 
     , posizioni                  posi 
     , ripartizioni_funzionali    rifu 
     , periodi_retributivi        pere 
     , mesi                       mese 
     , informazioni_retributive   inre 
     , codici_bilancio            cobi 
     , contabilita_voce           covo 
     , movimenti_contabili        moco 
 where cobi.codice      = nvl(rico.input_bilancio, covo.bilancio) 
   and nvl(cobi.imputazione_mensile,'SI') = 'SI' 
   and covo.bilancio   != '0' 
   and covo.voce        = moco.voce 
   and covo.sub         = moco.sub 
   and moco.riferimento between nvl(covo.dal, to_date(2222222,'j')) 
                            and nvl(covo.al , to_date(3333333,'j')) 
   and inre.voce (+)    = moco.voce 
   and inre.sub (+)||'' = moco.sub 
   and inre.ci (+)      = moco.ci 
   and nvl(inre.tipo(+),'R') = 'R' 
   and rifu.settore (+) = pere.settore 
   and rifu.sede    (+) = nvl(pere.sede,0) 
   and posi.codice  (+) = pere.posizione 
   and pere.ci          = moco.ci 
   and pere.periodo     = 
      (select nvl(max(periodo), last_day(to_date(to_char(nvl(moco.mese,12))||'/'||to_char(moco.anno),'mm/yyyy'))) 
	   from periodi_retributivi 
	  where ci       = moco.ci 
          and periodo >= moco.riferimento 
          and periodo <= last_day(to_date(to_char(nvl(moco.mese,12))||'/'||to_char(moco.anno), 'mm/yyyy')) 
          and to_number(to_char(al,'yyyymm')) = to_number(to_char(moco.riferimento,'yyyymm')) 
          and nvl(tipo,' ') not in ('R','F') 
          and moco.delibera is not null 
      ) 
   and (    moco.input       = upper(moco.input) 
        and pere.competenza in ('D','C','A') 
        or  moco.input      != upper(moco.input) 
        and pere.competenza in ('P','D') 
        or  moco.input      != upper(moco.input) 
        and pere.competenza in ('C','A') 
        and not exists 
           (select 'x' from periodi_retributivi 
             where periodo          = pere.periodo 
               and ci               = pere.ci 
               and competenza       = 'P' 
               and moco.riferimento between dal and al) 
        or  moco.input       = upper(moco.input) 
        and pere.competenza  = 'P'
        and not exists 
           (select 'x' from periodi_retributivi 
             where periodo          = pere.periodo 
               and ci               = pere.ci 
               and competenza      in ('C','A')  
               and moco.riferimento between dal and al) 
       ) 
   and moco.riferimento between pere.dal and pere.al 
   and mese.anno = decode 
                   ( moco.arr||to_char(moco.ipn_p) 
                   , null, moco.anno 
                         , to_number(to_char(moco.riferimento,'yyyy')) 
                   ) 
   and (    mese.mese = 1 
        or (      nvl(moco.ipn_p,0) != 0 
            and mese.mese = 2 
           ) 
       ) 
   and moco.mensilita != '*AP' 
   and rico.chiave = 
      (select max(chiave) 
         from ripartizioni_contabili 
        where (   bilancio = covo.bilancio 
               or bilancio = '%' 
              ) 
          and (    decode( mese.anno 
                         , moco.anno, decode( mese.mese 
                                            , 1, decode( moco.mese
                                                       , to_number(to_char(moco.riferimento,'mm')), 'C'
                                                                                                  , 'A'
                                                       ) 
                                               , decode(arr, '%', null, 'S') 
                                            ) 
                                    , decode( mese.mese
                                            , 1, decode( moco.arr, 'P', 'S', 'P')
                                               , decode(arr, '%', null, 'S') 
                                            )
                         ) like arr 
               or  mese.anno != moco.anno 
               and mese.mese != 2
               and to_char( moco.anno 
                         - to_number(to_char(moco.riferimento,'yyyy')) 
                         )    = arr 
              ) 
          and nvl(rifu.funzionale,' ') like funzionale 
          and nvl(posi.di_ruolo  ,' ') like di_ruolo 
          and nvl(pere.ruolo     ,' ') like ruolo
          and nvl(pere.contratto ,' ') like contratto
          and nvl(pere.gestione  ,' ') like gestione 
      ) 
       ) mobi 
 where rdre.sede (+)     = mobi.sede_del 
   and rdre.anno (+)     = mobi.anno_del 
   and rdre.numero (+)   = mobi.numero_del 
   and rdre.tipo (+)     = mobi.delibera 
   and rdre.bilancio (+) = mobi.bilancio
;