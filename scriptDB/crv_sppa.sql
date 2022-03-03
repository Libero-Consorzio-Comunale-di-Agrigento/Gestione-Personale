CREATE OR REPLACE VIEW stampa_prospetti_presenza
(
       prospetto
     , anno
     , mese
     , ci
     , ufficio
     , badge
     , sede
     , cartellino
     , gestione
     , matricola
     , cdc
     , posizione
     , ruolo
     , figura
     , attivita
     , contratto
     , cod_qualifica
     , qualifica
     , settore
     , funzionale
     , val_01
     , val_02
     , val_03
     , val_04
     , val_05
     , val_06
     , val_07
     , val_08
     , val_09
     , val_10
     , val_11
     , val_12
     , val_13
     , val_14
     , val_15
     , val_16
     , val_17
     , val_18
     , val_19
     , val_20
)
AS SELECT
       rppa.prospetto
     , mese.anno
     , mese.mese
     , pspa.ci
     , pspa.ufficio
     , null
     , nvl(evpa.sede,pspa.sede)
     , null
     , null
     , null
     , nvl(evpa.cdc,pspa.cdc)
     , pspa.posizione
     , null
     , pspa.figura
     , null
     , pspa.contratto
     , null
     , pspa.qualifica
     , pspa.settore
     , null
     , decode(rppa.sequenza,01,evpa.valore,null)
     , decode(rppa.sequenza,02,evpa.valore,null)
     , decode(rppa.sequenza,03,evpa.valore,null)
     , decode(rppa.sequenza,04,evpa.valore,null)
     , decode(rppa.sequenza,05,evpa.valore,null)
     , decode(rppa.sequenza,06,evpa.valore,null)
     , decode(rppa.sequenza,07,evpa.valore,null)
     , decode(rppa.sequenza,08,evpa.valore,null)
     , decode(rppa.sequenza,09,evpa.valore,null)
     , decode(rppa.sequenza,10,evpa.valore,null)
     , decode(rppa.sequenza,11,evpa.valore,null)
     , decode(rppa.sequenza,12,evpa.valore,null)
     , decode(rppa.sequenza,13,evpa.valore,null)
     , decode(rppa.sequenza,14,evpa.valore,null)
     , decode(rppa.sequenza,15,evpa.valore,null)
     , decode(rppa.sequenza,16,evpa.valore,null)
     , decode(rppa.sequenza,17,evpa.valore,null)
     , decode(rppa.sequenza,18,evpa.valore,null)
     , decode(rppa.sequenza,19,evpa.valore,null)
     , decode(rppa.sequenza,20,evpa.valore,null)
  from causali_evento              caev
     , eventi_presenza             evpa
     , mesi                        mese
     , periodi_servizio_presenza   pspa
     , righe_prospetto_presenza    rppa
     , prospetti_presenza          prpa
 where evpa.ci        = pspa.ci
   and evpa.dal between pspa.dal
                    and nvl(pspa.al,to_date('3333333','j'))
   and evpa.dal between add_months( mese.ini_mese
                                  , decode(caev.riferimento,'P',-1,0)
                                  )
                    and add_months( mese.fin_mese
                                  , decode(caev.riferimento,'P',-1,0)
                                  )
   and caev.codice    = evpa.causale
   and evpa.causale   = rppa.colonna
   and rppa.tipo      = 'CA'
   and rppa.prospetto = prpa.codice
   and prpa.rilevanza = 'S'
UNION SELECT
       rppa.prospetto
     , mese.anno
     , mese.mese
     , pspa.ci
     , pspa.ufficio
     , null
     , nvl(evpa.sede,pspa.sede)
     , null
     , null
     , null
     , nvl(evpa.cdc,pspa.cdc)
     , pspa.posizione
     , null
     , pspa.figura
     , null
     , pspa.contratto
     , null
     , pspa.qualifica
     , pspa.settore
     , null
     , decode(rppa.sequenza,01,evpa.valore,null)
     , decode(rppa.sequenza,02,evpa.valore,null)
     , decode(rppa.sequenza,03,evpa.valore,null)
     , decode(rppa.sequenza,04,evpa.valore,null)
     , decode(rppa.sequenza,05,evpa.valore,null)
     , decode(rppa.sequenza,06,evpa.valore,null)
     , decode(rppa.sequenza,07,evpa.valore,null)
     , decode(rppa.sequenza,08,evpa.valore,null)
     , decode(rppa.sequenza,09,evpa.valore,null)
     , decode(rppa.sequenza,10,evpa.valore,null)
     , decode(rppa.sequenza,11,evpa.valore,null)
     , decode(rppa.sequenza,12,evpa.valore,null)
     , decode(rppa.sequenza,13,evpa.valore,null)
     , decode(rppa.sequenza,14,evpa.valore,null)
     , decode(rppa.sequenza,15,evpa.valore,null)
     , decode(rppa.sequenza,16,evpa.valore,null)
     , decode(rppa.sequenza,17,evpa.valore,null)
     , decode(rppa.sequenza,18,evpa.valore,null)
     , decode(rppa.sequenza,19,evpa.valore,null)
     , decode(rppa.sequenza,20,evpa.valore,null)
  from causali_evento              caev
     , eventi_presenza             evpa
     , mesi                        mese
     , periodi_servizio_presenza   pspa
     , ripartizione_causali        rica
     , righe_prospetto_presenza    rppa
     , prospetti_presenza          prpa
 where evpa.ci        = pspa.ci
   and evpa.dal between pspa.dal
                    and nvl(pspa.al,to_date('3333333','j'))
   and evpa.dal between add_months( mese.ini_mese
                                  , decode(caev.riferimento,'P',-1,0)
                                  )
                    and add_months( mese.fin_mese
                                  , decode(caev.riferimento,'P',-1,0)
                                  )
   and caev.codice    = evpa.causale
   and evpa.causale   = rica.causale
   and rica.classe    = rppa.colonna
   and rppa.tipo      = 'CL'
   and rppa.prospetto = prpa.codice
   and prpa.rilevanza = 'S'
UNION SELECT
       rppa.prospetto
     , mese.anno
     , mese.mese
     , pspa.ci
     , pspa.ufficio
     , null
     , nvl(evpa.sede,pspa.sede)
     , null
     , null
     , null
     , nvl(evpa.cdc,pspa.cdc)
     , pspa.posizione
     , null
     , pspa.figura
     , null
     , pspa.contratto
     , null
     , pspa.qualifica
     , pspa.settore
     , null
     , decode(rppa.sequenza,01,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,02,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,03,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,04,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,05,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,06,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,07,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,08,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,09,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,10,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,11,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,12,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,13,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,14,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,15,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,16,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,17,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,18,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,19,evpa.valore*decode(toca.segno,'-',-1,1),null)
     , decode(rppa.sequenza,20,evpa.valore*decode(toca.segno,'-',-1,1),null)
     from causali_evento            caev
        , categorie_evento          ctev
        , sedi                      sedr
        , sedi                      sede
        , eventi_presenza           evpa
        , mesi                      mese
        , totalizzazione_causali    toca
        , periodi_servizio_presenza pspa
        , righe_prospetto_presenza  rppa
        , prospetti_presenza        prpa
    where evpa.ci              = pspa.ci
      and caev.codice          = evpa.causale
      and ctev.codice          = toca.categoria
      and evpa.causale         = toca.causale
      and nvl(evpa.motivo,' ') = nvl(toca.motivo,nvl(evpa.motivo,' '))
      and evpa.dal       between pspa.dal
                             and nvl(pspa.al,to_date('3333333','j'))
      and evpa.riferimento
                         between nvl(ctev.dal,to_date('2222222','j'))
                             and nvl(ctev.al ,to_date('3333333','j')) 
      and trunc(months_between(mese.fin_mese,evpa.dal))
                              <= nvl(toca.riferimento_mm,999)
      and evpa.dal            <= mese.fin_mese
      and sedr.numero (+)      = nvl(pspa.sede,0)
      and sede.numero (+)      = nvl(evpa.sede,0)
      and nvl(sede.codice,nvl(sedr.codice,' ')) 
                            like ctev.sede
      and nvl(evpa.cdc,nvl(pspa.cdc,' '))
                            like ctev.cdc
      and decode( ctev.opzione
                , 'M', to_char( add_months( evpa.dal
                                          , decode(caev.riferimento,'P',1,0) )
                              , 'YYYYMM' )
                , 'A', to_char( add_months( evpa.dal
                                          , decode(caev.riferimento,'P',1,0) )
                              , 'YYYY' )
                , 'T', to_char( mese.fin_mese, 'YYYY' )
                , 'P', to_char( add_months( evpa.dal
                                          , decode(caev.riferimento,'P',1,0) )
                              , 'YYYY' )
                     , null
                )
                               =
          decode( ctev.opzione
                , 'M', to_char( mese.fin_mese,'YYYYMM' )
                , 'A', to_char( mese.fin_mese,'YYYY' )
                , 'T', to_char( mese.fin_mese,'YYYY' )
                , 'P', to_char( to_number(to_char(mese.fin_mese,'YYYY') - 1) )
                     , null
                )
      and toca.categoria = rppa.colonna
      and rppa.tipo      = 'CT'
      and rppa.prospetto = prpa.codice
      and prpa.rilevanza = 'S'
;

