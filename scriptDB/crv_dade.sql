create or replace view
differenze_accredito_emens as 
 select seie.ci
      , seie.anno
      , seie.mese
      , seie.dal_emens
      , seie.id_settimana
      , greatest(evpa.dal, seie.dal)  dal
      , least(evpa.al, seie.al) al
      , prpr.codice     codice_evento
      , caev.codice
      , (least(evpa.al, seie.al)-greatest(evpa.dal, seie.dal))+1 giorni
      , sum ( vaev.tar ) * (least (evpa.al, seie.al)-greatest(evpa.dal, seie.dal)+1 ) differenza1
      , to_number(null) differenza2
      , to_number(null) differenza3
      , to_number(null) differenza4
      , to_number(null) differenza5
      , to_number(null) differenza6
      , to_number(null) differenza7
   from EVENTI_PRESENZA           evpa
      , causali_evento            caev
      , prospetti_presenza        prpr
      , righe_prospetto_presenza  rppa
      , valori_evento             vaev
      , settimane_emens           seie
   WHERE evpa.input      = 'V'
     AND evpa.ci         = seie.ci
     AND seie.dal       <= evpa.al
     AND seie.al        >= evpa.dal
     and evpa.causale    = caev.codice
     and caev.codice     = rppa.colonna
     and rppa.prospetto  = prpr.codice
     and evpa.ci         = vaev.ci
     and evpa.evento     = vaev.evento
     and seie.codice_evento1 = prpr.codice
     and prpr.note like '%EMENS%'
     and ( vaev.voce, vaev.sub ) in ( select voce, sub
                                        from estrazione_righe_contabili
                                       where estrazione = 'DENUNCIA_EMENS'
                                         and colonna = 'MALATTIE'
                                         and last_day(to_date(lpad(seie.mese,2,'0')||seie.anno,'mmyyyy'))
                                             between dal and nvl(al, to_date('3333333','j'))
                                    ) 
group by seie.ci
      , seie.anno
       , seie.mese
       , seie.dal_emens
       , seie.id_settimana
       , prpr.codice
       , caev.codice
       , greatest(evpa.dal, seie.dal) 
       , least(evpa.al, seie.al)
union
-- seconda differenza
 select seie.ci
      , seie.anno
      , seie.mese
      , seie.dal_emens
      , seie.id_settimana
      , greatest(evpa.dal, seie.dal)  dal
      , least(evpa.al, seie.al) al
      , prpr.codice     codice_evento
      , caev.codice
      , (least(evpa.al, seie.al)-greatest(evpa.dal, seie.dal))+1 giorni
      , to_number(null) differenza1
      , sum ( vaev.tar ) * (least (evpa.al, seie.al)-greatest(evpa.dal, seie.dal)+1 ) differenza2
      , to_number(null) differenza3
      , to_number(null) differenza4
      , to_number(null) differenza5
      , to_number(null) differenza6
      , to_number(null) differenza7
   from EVENTI_PRESENZA           evpa
      , causali_evento            caev
      , prospetti_presenza        prpr
      , righe_prospetto_presenza  rppa
      , valori_evento             vaev
      , settimane_emens           seie
   WHERE evpa.input      = 'V'
     AND evpa.ci         = seie.ci
     AND seie.dal       <= evpa.al
     AND seie.al        >= evpa.dal
     and evpa.causale    = caev.codice
     and caev.codice     = rppa.colonna
     and rppa.prospetto  = prpr.codice
     and evpa.ci         = vaev.ci
     and evpa.evento     = vaev.evento
     and seie.codice_evento2 = prpr.codice
     and prpr.note like '%EMENS%'
     and ( vaev.voce, vaev.sub ) in ( select voce, sub
                                        from estrazione_righe_contabili
                                       where estrazione = 'DENUNCIA_EMENS'
                                         and colonna = 'MALATTIE'
                                         and last_day(to_date(lpad(seie.mese,2,'0')||seie.anno,'mmyyyy'))
                                             between dal and nvl(al, to_date('3333333','j'))
                                    ) 
group by seie.ci
      , seie.anno
       , seie.mese
       , seie.dal_emens
       , seie.id_settimana
       , prpr.codice
       , caev.codice
       , greatest(evpa.dal, seie.dal) 
       , least(evpa.al, seie.al)
union
-- terza differenza
 select seie.ci
      , seie.anno
      , seie.mese
      , seie.dal_emens
      , seie.id_settimana
      , greatest(evpa.dal, seie.dal)  dal
      , least(evpa.al, seie.al) al
      , prpr.codice     codice_evento
      , caev.codice
      , (least(evpa.al, seie.al)-greatest(evpa.dal, seie.dal))+1 giorni
      , to_number(null) differenza1
      , to_number(null) differenza2
      , sum ( vaev.tar ) * (least (evpa.al, seie.al)-greatest(evpa.dal, seie.dal)+1 ) differenza3
      , to_number(null) differenza4
      , to_number(null) differenza5
      , to_number(null) differenza6
      , to_number(null) differenza7
   from EVENTI_PRESENZA           evpa
      , causali_evento            caev
      , prospetti_presenza        prpr
      , righe_prospetto_presenza  rppa
      , valori_evento             vaev
      , settimane_emens           seie
   WHERE evpa.input      = 'V'
     AND evpa.ci         = seie.ci
     AND seie.dal       <= evpa.al
     AND seie.al        >= evpa.dal
     and evpa.causale    = caev.codice
     and caev.codice     = rppa.colonna
     and rppa.prospetto  = prpr.codice
     and evpa.ci         = vaev.ci
     and evpa.evento     = vaev.evento
     and seie.codice_evento3 = prpr.codice
     and prpr.note like '%EMENS%'
     and ( vaev.voce, vaev.sub ) in ( select voce, sub
                                        from estrazione_righe_contabili
                                       where estrazione = 'DENUNCIA_EMENS'
                                         and colonna = 'MALATTIE'
                                         and last_day(to_date(lpad(seie.mese,2,'0')||seie.anno,'mmyyyy'))
                                             between dal and nvl(al, to_date('3333333','j'))
                                    ) 
group by seie.ci
      , seie.anno
       , seie.mese
       , seie.dal_emens
       , seie.id_settimana
       , prpr.codice
       , caev.codice
       , greatest(evpa.dal, seie.dal) 
       , least(evpa.al, seie.al)
union
-- quarta differenza
 select seie.ci
      , seie.anno
      , seie.mese
      , seie.dal_emens
      , seie.id_settimana
      , greatest(evpa.dal, seie.dal)  dal
      , least(evpa.al, seie.al) al
      , prpr.codice     codice_evento
      , caev.codice
      , (least(evpa.al, seie.al)-greatest(evpa.dal, seie.dal))+1 giorni
      , to_number(null) differenza1
      , to_number(null) differenza2
      , to_number(null) differenza3
      , sum ( vaev.tar ) * (least (evpa.al, seie.al)-greatest(evpa.dal, seie.dal)+1 ) differenza4
      , to_number(null) differenza5
      , to_number(null) differenza6
      , to_number(null) differenza7
   from EVENTI_PRESENZA           evpa
      , causali_evento            caev
      , prospetti_presenza        prpr
      , righe_prospetto_presenza  rppa
      , valori_evento             vaev
      , settimane_emens           seie
   WHERE evpa.input      = 'V'
     AND evpa.ci         = seie.ci
     AND seie.dal       <= evpa.al
     AND seie.al        >= evpa.dal
     and evpa.causale    = caev.codice
     and caev.codice     = rppa.colonna
     and rppa.prospetto  = prpr.codice
     and evpa.ci         = vaev.ci
     and evpa.evento     = vaev.evento
     and seie.codice_evento4 = prpr.codice
     and prpr.note like '%EMENS%'
     and ( vaev.voce, vaev.sub ) in ( select voce, sub
                                        from estrazione_righe_contabili
                                       where estrazione = 'DENUNCIA_EMENS'
                                         and colonna = 'MALATTIE'
                                         and last_day(to_date(lpad(seie.mese,2,'0')||seie.anno,'mmyyyy'))
                                             between dal and nvl(al, to_date('3333333','j'))
                                    ) 
group by seie.ci
      , seie.anno
       , seie.mese
       , seie.dal_emens
       , seie.id_settimana
       , prpr.codice
       , caev.codice
       , greatest(evpa.dal, seie.dal) 
       , least(evpa.al, seie.al)
union
-- quinta differenza
 select seie.ci
      , seie.anno
      , seie.mese
      , seie.dal_emens
      , seie.id_settimana
      , greatest(evpa.dal, seie.dal)  dal
      , least(evpa.al, seie.al) al
      , prpr.codice     codice_evento
      , caev.codice
      , (least(evpa.al, seie.al)-greatest(evpa.dal, seie.dal))+1 giorni
      , to_number(null) differenza1
      , to_number(null) differenza2
      , to_number(null) differenza3
      , to_number(null) differenza4
      , sum ( vaev.tar ) * (least (evpa.al, seie.al)-greatest(evpa.dal, seie.dal)+1 ) differenza5
      , to_number(null) differenza6
      , to_number(null) differenza7
   from EVENTI_PRESENZA           evpa
      , causali_evento            caev
      , prospetti_presenza        prpr
      , righe_prospetto_presenza  rppa
      , valori_evento             vaev
      , settimane_emens           seie
   WHERE evpa.input      = 'V'
     AND evpa.ci         = seie.ci
     AND seie.dal       <= evpa.al
     AND seie.al        >= evpa.dal
     and evpa.causale    = caev.codice
     and caev.codice     = rppa.colonna
     and rppa.prospetto  = prpr.codice
     and evpa.ci         = vaev.ci
     and evpa.evento     = vaev.evento
     and seie.codice_evento5 = prpr.codice
     and prpr.note like '%EMENS%'
     and ( vaev.voce, vaev.sub ) in ( select voce, sub
                                        from estrazione_righe_contabili
                                       where estrazione = 'DENUNCIA_EMENS'
                                         and colonna = 'MALATTIE'
                                         and last_day(to_date(lpad(seie.mese,2,'0')||seie.anno,'mmyyyy'))
                                             between dal and nvl(al, to_date('3333333','j'))
                                    ) 
group by seie.ci
      , seie.anno
       , seie.mese
       , seie.dal_emens
       , seie.id_settimana
       , prpr.codice
       , caev.codice
       , greatest(evpa.dal, seie.dal) 
       , least(evpa.al, seie.al)
union
-- sesta differenza
 select seie.ci
      , seie.anno
      , seie.mese
      , seie.dal_emens
      , seie.id_settimana
      , greatest(evpa.dal, seie.dal)  dal
      , least(evpa.al, seie.al) al
      , prpr.codice     codice_evento
      , caev.codice
      , (least(evpa.al, seie.al)-greatest(evpa.dal, seie.dal))+1 giorni
      , to_number(null) differenza1
      , to_number(null) differenza2
      , to_number(null) differenza3
      , to_number(null) differenza4
      , to_number(null) differenza5
      , sum ( vaev.tar ) * (least (evpa.al, seie.al)-greatest(evpa.dal, seie.dal)+1 ) differenza6
      , to_number(null) differenza7
   from EVENTI_PRESENZA           evpa
      , causali_evento            caev
      , prospetti_presenza        prpr
      , righe_prospetto_presenza  rppa
      , valori_evento             vaev
      , settimane_emens           seie
   WHERE evpa.input      = 'V'
     AND evpa.ci         = seie.ci
     AND seie.dal       <= evpa.al
     AND seie.al        >= evpa.dal
     and evpa.causale    = caev.codice
     and caev.codice     = rppa.colonna
     and rppa.prospetto  = prpr.codice
     and evpa.ci         = vaev.ci
     and evpa.evento     = vaev.evento
     and seie.codice_evento6 = prpr.codice
     and prpr.note like '%EMENS%'
     and ( vaev.voce, vaev.sub ) in ( select voce, sub
                                        from estrazione_righe_contabili
                                       where estrazione = 'DENUNCIA_EMENS'
                                         and colonna = 'MALATTIE'
                                         and last_day(to_date(lpad(seie.mese,2,'0')||seie.anno,'mmyyyy'))
                                             between dal and nvl(al, to_date('3333333','j'))
                                    ) 
group by seie.ci
      , seie.anno
       , seie.mese
       , seie.dal_emens
       , seie.id_settimana
       , prpr.codice
       , caev.codice
       , greatest(evpa.dal, seie.dal) 
       , least(evpa.al, seie.al)
union
-- settima differenza
 select seie.ci
      , seie.anno
      , seie.mese
      , seie.dal_emens
      , seie.id_settimana
      , greatest(evpa.dal, seie.dal)  dal
      , least(evpa.al, seie.al) al
      , prpr.codice     codice_evento
      , caev.codice
      , (least(evpa.al, seie.al)-greatest(evpa.dal, seie.dal))+1 giorni
      , to_number(null) differenza1
      , to_number(null) differenza2
      , to_number(null) differenza3
      , to_number(null) differenza4
      , to_number(null) differenza5
      , to_number(null) differenza6
      , sum ( vaev.tar ) * (least (evpa.al, seie.al)-greatest(evpa.dal, seie.dal)+1 ) differenza7
   from EVENTI_PRESENZA           evpa
      , causali_evento            caev
      , prospetti_presenza        prpr
      , righe_prospetto_presenza  rppa
      , valori_evento             vaev
      , settimane_emens           seie
   WHERE evpa.input      = 'V'
     AND evpa.ci         = seie.ci
     AND seie.dal       <= evpa.al
     AND seie.al        >= evpa.dal
     and evpa.causale    = caev.codice
     and caev.codice     = rppa.colonna
     and rppa.prospetto  = prpr.codice
     and evpa.ci         = vaev.ci
     and evpa.evento     = vaev.evento
     and prpr.note like '%EMENS%'
     and ( vaev.voce, vaev.sub ) in ( select voce, sub
                                        from estrazione_righe_contabili
                                       where estrazione = 'DENUNCIA_EMENS'
                                         and colonna = 'MALATTIE'
                                         and last_day(to_date(lpad(seie.mese,2,'0')||seie.anno,'mmyyyy'))
                                             between dal and nvl(al, to_date('3333333','j'))
                                    ) 
     and seie.codice_evento7 = prpr.codice
group by seie.ci
      , seie.anno
       , seie.mese
       , seie.dal_emens
       , seie.id_settimana
       , prpr.codice
       , caev.codice
       , greatest(evpa.dal, seie.dal) 
       , least(evpa.al, seie.al)

/