CREATE OR REPLACE FORCE VIEW vista_imputazioni_inail 
( anno
, mese
, divisione
, sezione
, gestione
, posizione_inail
, esenzione
, settore
, sede
, funzionale
, cdc
, ruolo
, contratto
, posizione
, figura
, qualifica
, ore
, di_ruolo
, ci
, tipo_ipn
, voce
, sub
, bilancio
, budget
, anno_rif
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
, premio
, imponibile
, riferimento
) AS                                                   
   SELECT mobi.anno
         ,mobi.mese
         ,mobi.divisione
         ,mobi.sezione
         ,mobi.gestione
         ,mobi.posizione_inail
         ,mobi.esenzione
         ,mobi.settore
         ,mobi.sede
         ,mobi.funzionale
         ,mobi.cdc
         ,mobi.ruolo
         ,mobi.contratto
         ,mobi.posizione
         ,mobi.figura
         ,mobi.qualifica
         ,mobi.ore
         ,mobi.di_ruolo
         ,mobi.ci
         ,mobi.tipo_ipn
         ,mobi.voce
         ,mobi.sub
         ,mobi.bilancio
         ,mobi.budget
         ,mobi.anno_rif
         ,mobi.arr
         ,DECODE (mobi.imputazione_delibera, 'SI', mobi.sede_del, NULL) sede_del
         ,DECODE (mobi.imputazione_delibera, 'SI', mobi.anno_del, NULL) anno_del
         ,DECODE (mobi.imputazione_delibera, 'SI', mobi.numero_del, NULL) numero_del
         ,DECODE (DECODE (mobi.imputazione_delibera
                         ,'SI', rdre.risorsa_intervento || rdre.capitolo || rdre.impegno
                           || rdre.sub_impegno
                         ,NULL
                         )
                 ,NULL, NVL (mobi.risorsa_intervento, '0')
                 ,NVL (rdre.risorsa_intervento, '0')
                 ) risorsa_intervento
         ,DECODE (DECODE (mobi.imputazione_delibera
                         ,'SI', rdre.risorsa_intervento || rdre.capitolo || rdre.impegno
                           || rdre.sub_impegno
                         ,NULL
                         )
                 ,NULL, NVL (mobi.capitolo, '0')
                 ,NVL (rdre.capitolo, '0')
                 ) capitolo
         ,DECODE (DECODE (mobi.imputazione_delibera
                         ,'SI', rdre.risorsa_intervento || rdre.capitolo || rdre.impegno
                           || rdre.sub_impegno
                         ,NULL
                         )
                 ,NULL, NVL (mobi.articolo, '0')
                 ,NVL (rdre.articolo, '0')
                 ) articolo
         ,DECODE (DECODE (mobi.imputazione_delibera
                         ,'SI', rdre.risorsa_intervento || rdre.capitolo || rdre.impegno
                           || rdre.sub_impegno
                         ,NULL
                         )
                 ,NULL, mobi.conto
                 ,rdre.conto
                 ) conto
         ,DECODE (DECODE (mobi.imputazione_delibera
                         ,'SI', rdre.risorsa_intervento || rdre.capitolo || rdre.impegno
                           || rdre.sub_impegno
                         ,NULL
                         )
                 ,NULL, mobi.impegno
                 ,rdre.impegno
                 ) impegno
         ,DECODE (DECODE (mobi.imputazione_delibera
                         ,'SI', rdre.risorsa_intervento || rdre.capitolo || rdre.impegno
                           || rdre.sub_impegno
                         ,NULL
                         )
                 ,NULL, mobi.anno_impegno
                 ,rdre.anno_impegno
                 ) anno_impegno
         ,DECODE (DECODE (mobi.imputazione_delibera
                         ,'SI', rdre.risorsa_intervento || rdre.capitolo || rdre.impegno
                           || rdre.sub_impegno
                         ,NULL
                         )
                 ,NULL, mobi.sub_impegno
                 ,rdre.sub_impegno
                 ) sub_impegno
         ,DECODE (DECODE (mobi.imputazione_delibera
                         ,'SI', rdre.risorsa_intervento || rdre.capitolo || rdre.impegno
                           || rdre.sub_impegno
                         ,NULL
                         )
                 ,NULL, mobi.anno_sub_impegno
                 ,rdre.anno_sub_impegno
                 ) anno_sub_impegno
         ,DECODE (DECODE (mobi.imputazione_delibera
                         ,'SI', rdre.risorsa_intervento||rdre.capitolo||rdre.impegno||rdre.codice_siope
                              ,NULL)
                 ,NULL, mobi.codice_siope
                      , rdre.codice_siope
                 ) codice_siope
         ,mobi.premio
         ,mobi.imponibile
         ,mobi.riferimento
     FROM righe_delibera_retributiva rdre
         , (SELECT cari.anno
                  ,cari.mese
                  ,DECODE (rico.divisione, '%', cari.gestione, rico.divisione) divisione
                  ,DECODE (rico.sezione, '%', cari.gestione, rico.sezione) sezione
                  ,cari.gestione
                  ,cari.posizione_inail
                  ,cari.esenzione
                  ,cari.settore
                  ,cari.sede
                  ,rifu.funzionale
                  ,rifu.cdc
                  ,cari.ruolo
                  ,gp4_qugi.get_contratto (cari.qualifica, cari.dal) contratto
                  ,cari.posizione
                  ,cari.figura
                  ,cari.qualifica
                  ,cari.ore
                  ,posi.di_ruolo
                  ,cari.ci
                  ,cari.tipo_ipn
                  ,RTRIM
                      (SUBSTR
                            (peccrein.get_voce_contributo (cari.posizione_inail
                                                          ,cari.gestione
                                                          ,gp4_qugi.get_contratto (cari.qualifica
                                                                                  ,cari.dal
                                                                                  )
                                                          ,cari.trattamento
                                                          ,cari.dal
                                                          )
                            ,1
                            ,10
                            )
                      ) voce
                  ,RTRIM
                      (SUBSTR
                            (peccrein.get_voce_contributo (cari.posizione_inail
                                                          ,cari.gestione
                                                          ,gp4_qugi.get_contratto (cari.qualifica
                                                                                  ,cari.dal
                                                                                  )
                                                          ,cari.trattamento
                                                          ,cari.dal
                                                          )
                            ,11
                            ,2
                            )
                      ) sub
                  ,cobi.codice bilancio
                  ,cobi.imputazione_delibera
                  ,DECODE (cobi.codice, covo.bilancio, covo.budget, cobi.budget) budget
                  ,TO_NUMBER (TO_CHAR (cari.dal, 'yyyy') ) anno_rif
                  ,TO_CHAR ('') arr                                                       --moco.arr
                  ,NVL (cari.sede_del, covo.sede_del) sede_del
                  ,NVL (cari.anno_del, covo.anno_del) anno_del
                  ,NVL (cari.numero_del, covo.numero_del) numero_del
                  ,'*' delibera                                   --nvl(moco.delibera, '*') delibera
                  ,DECODE (covo.risorsa_intervento || covo.capitolo || covo.impegno
                           || covo.sub_impegno
                          ,NULL, NVL (rico.risorsa_intervento, '0')
                          ,NVL (covo.risorsa_intervento, '0')
                          ) risorsa_intervento
                  ,DECODE (covo.risorsa_intervento || covo.capitolo || covo.impegno
                           || covo.sub_impegno
                          ,NULL, NVL (rico.capitolo, '0')
                          ,NVL (covo.capitolo, '0')
                          ) capitolo
                  ,DECODE (covo.risorsa_intervento || covo.capitolo || covo.impegno
                           || covo.sub_impegno
                          ,NULL, NVL (rico.articolo, '0')
                          ,NVL (covo.articolo, '0')
                          ) articolo
                  ,DECODE (covo.risorsa_intervento || covo.capitolo || covo.impegno
                           || covo.sub_impegno
                          ,NULL, rico.impegno
                          ,covo.impegno
                          ) impegno
                  ,DECODE (covo.risorsa_intervento || covo.capitolo || covo.impegno
                           || covo.sub_impegno
                          ,NULL, rico.anno_impegno
                          ,covo.anno_impegno
                          ) anno_impegno
                  ,DECODE (covo.risorsa_intervento || covo.capitolo || covo.impegno
                           || covo.sub_impegno
                          ,NULL, rico.sub_impegno
                          ,covo.sub_impegno
                          ) sub_impegno
                  ,DECODE (covo.risorsa_intervento || covo.capitolo || covo.impegno
                           || covo.sub_impegno
                          ,NULL, rico.anno_sub_impegno
                          ,covo.anno_sub_impegno
                          ) anno_sub_impegno
                  ,DECODE (covo.risorsa_intervento || covo.capitolo || covo.impegno
                           || covo.sub_impegno||covo.codice_siope
                          ,NULL, rico.codice_siope
                               ,covo.codice_siope
                          ) codice_siope
                  ,DECODE (covo.risorsa_intervento || covo.capitolo || covo.impegno
                           || covo.sub_impegno
                          ,NULL, rico.conto
                          ,covo.conto
                          ) conto
                  ,cari.premio
                  ,NVL (covo.istituto, NVL (rico.istituto, cobi.istituto) ) istituto
                  ,cari.imponibile imponibile
                  ,cari.dal riferimento
              FROM ripartizioni_contabili rico
                  ,posizioni posi
                  ,ripartizioni_funzionali rifu
                  ,mesi mese
                  ,codici_bilancio cobi
                  ,contabilita_voce covo
                  ,calcoli_retribuzioni_inail cari
             WHERE cobi.codice = NVL (rico.input_bilancio, covo.bilancio)
               AND NVL (cobi.imputazione_mensile, 'SI') = 'NO'
               AND covo.bilancio != '0'
               AND covo.voce =
                      RTRIM
                         (SUBSTR
                             (peccrein.get_voce_contributo (cari.posizione_inail
                                                           ,cari.gestione
                                                           ,gp4_qugi.get_contratto (cari.qualifica
                                                                                   ,cari.dal
                                                                                   )
                                                           ,cari.trattamento
                                                           ,cari.dal
                                                           )
                             ,1
                             ,10
                             )
                         )
               AND covo.sub =
                      RTRIM
                         (SUBSTR
                             (peccrein.get_voce_contributo (cari.posizione_inail
                                                           ,cari.gestione
                                                           ,gp4_qugi.get_contratto (cari.qualifica
                                                                                   ,cari.dal
                                                                                   )
                                                           ,cari.trattamento
                                                           ,cari.dal
                                                           )
                             ,11
                             ,2
                             )
                         )
               AND cari.dal BETWEEN NVL (covo.dal, TO_DATE (2222222, 'j') )
                                AND NVL (covo.al, TO_DATE (3333333, 'j') )
               AND rifu.settore(+) = cari.settore
               AND rifu.sede(+) = NVL (cari.sede, 0)
               AND posi.codice(+) = cari.posizione
               AND mese.anno = cari.anno
               AND mese.mese = cari.mese
               AND rico.chiave =
                      (SELECT MAX (chiave)
                         FROM ripartizioni_contabili
                        WHERE (   bilancio = covo.bilancio
                               OR bilancio = '%')
                          AND NVL (rifu.funzionale, ' ') LIKE funzionale
                          AND NVL (posi.di_ruolo, ' ') LIKE di_ruolo
                          AND NVL (cari.ruolo, ' ') LIKE ruolo
                          AND NVL (cari.gestione, ' ') LIKE gestione
                          AND NVL (cari.contratto, ' ') LIKE contratto) ) mobi
    WHERE rdre.sede(+) = mobi.sede_del
      AND rdre.anno(+) = mobi.anno_del
      AND rdre.numero(+) = mobi.numero_del
      AND rdre.tipo(+) = mobi.delibera
      AND rdre.bilancio(+) = mobi.bilancio
/