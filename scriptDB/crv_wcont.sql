CREATE OR REPLACE VIEW WORD_CONTRATTI
( ci
, cognome 
, nome
, matricola
, sesso
, data_nas
, codice_fiscale
, cittadinanza
, comune_nas
, provincia_nas
, luogo_nas
, indirzzo_res
, comune_res
, provincia_res
, cap_res
, tel_res
, ind_presso
, ser_dal
, ser_al
, old_dal
, old_al
, old_contratto
, old_graduatoria
, new_dal
, new_al
, new_contratto
, new_graduatoria
, qugi_codice
, qugi_descrizione
, qugi_livello
, qugi_note
, figi_codice
, figi_descrizione
, figi_note
, evento
, evgi_descrizione
, presso
, pegi_gestione
, gest_nome
, gest_note
, sett_codice
, sett_descrizione
, sett1_codice
, sett1_descrizione
, sett2_codice
, sett2_descrizione
, sett3_codice
, sett3_descrizione
, sede_codice
, sede_descrizione
, pegi_posizione
, posi_descrizione
, posi_ruolo
, posi_tempO_determinato
, posi_part_time
, pegi_tr
, pegi_ore
, pegi_rapore
, pegi_note
, sede_del
, numero_del
, anno_del
, deli_data
, deli_note
, numero_ese
, data_ese
, tipo_ese
, deli_estremi
, pegi_mesi
) AS
SELECT
  pegi.ci                                              ci
, anag.cognome                                         cognome
, anag.nome                                            nome
, rare.matricola                                       matricola
, anag.sesso                                           sesso
, anag.data_nas                                        data_nas
, anag.codice_fiscale                                  codice_fiscale
, anag.cittadinanza                                    cittadinanza
, comu_n.descrizione                                   comune_nas
, comu_n.sigla_provincia                               provincia_nas
, anag.luogo_nas                                       luogo_nas
, anag.indirizzo_res                                   indirizzo_res
, comu_r.descrizione                                   comune_res
, comu_r.sigla_provincia                               provincia_res
, anag.cap_res                                         cap_res
, anag.tel_res                                         tel_res
, anag.presso                                          ind_presso
, pegi.dal                                             ser_dal
, pegi.al                                              ser_al
, pegi_p.dal                                           old_dal
, pegi_p.al                                            old_al
, vatg.valore                                          old_contratto
, vatg3.valore                                         old_graduatoria
, pegi_p2.dal                                          new_dal
, pegi_p2.al                                           new_al
, vatg2.valore                                         new_contratto
, vatg4.valore                                         new_graduatoria
, qugi.codice                                          qugi_codice
, qugi.descrizione||decode(pegi.ore,null,' ',' p.t.')  qugi_descrizione
, qugi.livello                                         qugi_livello
, replace(gp4aa.elimina_tag(qugi.note,'[',']')
         ,chr(10),' ')                                 qugi_note
, figi.codice                                          figi_codice
, figi.descrizione                                     figi_descrizione
, replace(gp4aa.elimina_tag(figi.note,'[',']')
         ,chr(10),' ')                                 figi_note
, pegi.evento                                          evento
, evgi.descrizione                                     evgi_descrizione
, replace(DECODE(evgi.presso
        ,'NO',NULL
             ,' '||UPPER(gest.nome)||
              DECODE(gest.note
                    ,NULL,NULL,' '||gest.note)
        ),chr(10),' ')                                 presso
, pegi.gestione                                        pegi_gestione
, gest.nome                                            gest_nome
, replace(gp4aa.elimina_tag(gest.note,'[',']')
         ,chr(10),' ')                                 gest_note
, sett.codice                                          sett_codice
, sett.descrizione                                     sett_descrizione
, sett1.codice                                         sett1_codice
, sett1.descrizione                                    sett1_descrizione
, sett2.codice                                         sett2_codice
, sett2.descrizione                                    sett2_descrizione
, sett3.codice                                         sett3_codice
, sett3.descrizione                                    sett3_descrizione
, sede.codice                                          sede_codice
, sede.descrizione                                     sede_descrizione
, pegi.posizione                                       pegi_posizione
, posi.descrizione                                     posi_descrizione
, posi.ruolo                                           posi_ruolo
, posi.tempO_determinato                               posi_tempO_determinato
, posi.part_time                           posi_part_time
, SUBSTR(pegi.tipo_rapporto,1,2)           pegi_tr
, pegi.ore                                 pegi_ore
, (nvl(pegi.ore,cont.ore_lavoro)/cont.ore_lavoro) pegi_rapore
, replace(gp4aa.elimina_tag(pegi.note,'[',']')
         ,chr(10),' ')                     pegi_note
, NVL(sepr.descrizione,pegi_p2.sede_del)      sede_del
, pegi_p2.numero_del                          numero_del
, pegi_p2.anno_del                            anno_del
, deli.data                                deli_data
, replace(gp4aa.elimina_tag(deli.note,'[',']')
         ,chr(10),' ')                     deli_note
, deli.numero_ese                          numero_ese
, deli.data_ese                            data_ese
, deli.tipo_ese                            tipo_ese
, substr(gp4_deli.estremi(pegi_p2.sede_del
                              ,pegi_p2.numero_del
                              ,pegi_p2.anno_del),1,18)     deli_estremi
, TRUNC(MONTHS_BETWEEN( nvl(pegi.al,TO_DATE('3333333','j'))
                      , pegi.dal))                         pegi_mesi
  FROM SEDI_PROVVEDIMENTO    sepr
     , DELIBERE              deli
     , GESTIONI              gest
     , SETTORI               sett
     , SETTORI               sett1
     , SETTORI               sett2
     , SETTORI               sett3
     , SEDI                  sede
     , POSIZIONI             posi
     , EVENTI_GIURIDICI      evgi
     , QUALIFICHE_GIURIDICHE qugi
     , FIGURE_GIURIDICHE     figi
     , ANAGRAFICI            ANAG
     , COMUNI                COMU_N
     , COMUNI                COMU_R
     , VISTA_ATTRIBUTI_GIURIDICI  VATG
     , VISTA_ATTRIBUTI_GIURIDICI  VATG2
     , VISTA_ATTRIBUTI_GIURIDICI  VATG3
     , VISTA_ATTRIBUTI_GIURIDICI  VATG4 
     , RAPPORTI_RETRIBUTIVI  rare
     , PERIODI_GIURIDICI     pegi_p
     , PERIODI_GIURIDICI     pegi_p2
     , PERIODI_GIURIDICI     pegi
     , contratti_storici      cont 
 WHERE pegi.rilevanza     = 'S'
   and pegi.dal           in
      (select max(s.dal) from periodi_giuridici s, periodi_giuridici p
        where s.ci = pegi.ci 
          and s.ci = p.ci
          and s.rilevanza = 'S'
          and p.rilevanza = 'P'
          and s.dal between p.dal and nvl(p.al,to_date('3333333','j'))   
        group by p.dal
      )
   and pegi.ci            = pegi_p2.ci
   and pegi_p2.rilevanza  = 'Q'
   and pegi.dal     between  pegi_p2.dal and nvl(pegi_p2.al,to_date('3333333','j'))
   and pegi_p.ci          (+) = pegi_p2.ci 
   and pegi_p.rilevanza   (+) = 'Q'        
   and pegi_p2.dal            = pegi_p.al  (+)  + 1
   and vatg.ci            (+) = pegi_p.ci
   and vatg.rilevanza     (+) = 'Q'
   and vatg.dal_pegi      (+) = pegi_p.dal
   and vatg.attributo     (+) = 'CONTRATTO_IND' 
   and vatg.variabile     (+) = 'NUMERO'
   and vatg.variabili     (+) = 'SI'
   and vatg2.ci           (+) = pegi_p2.ci
   and vatg2.rilevanza    (+) = 'Q'
   and vatg2.dal_pegi     (+) = pegi_p2.dal
   and vatg2.attributo    (+) = 'CONTRATTO_IND' 
   and vatg2.variabile    (+) = 'NUMERO'
   and vatg2.variabili    (+) = 'SI'
   and vatg3.ci            (+) = pegi_p.ci
   and vatg3.rilevanza     (+) = 'Q'
   and vatg3.dal_pegi      (+) = pegi_p.dal
   and vatg3.attributo     (+) = 'POS_GRADUATORIA' 
   and vatg3.variabile     (+) = 'POS_GRAD'
   and vatg3.variabili     (+) = 'SI'
   and vatg4.ci           (+) = pegi_p2.ci
   and vatg4.rilevanza    (+) = 'Q'
   and vatg4.dal_pegi     (+) = pegi_p2.dal
   and vatg4.attributo    (+) = 'POS_GRADUATORIA' 
   and vatg4.variabile    (+) = 'POS_GRAD'
   and vatg4.variabili    (+) = 'SI'
   AND pegi.evento        = evgi.codice
   AND evgi.certificabile IN ('SI','SP')
   AND pegi.posizione     = posi.codice
   AND pegi.qualifica     = qugi.numero
   AND pegi.dal          <= NVL(qugi.al,TO_DATE('3333333','j'))
   AND NVL(pegi.al,TO_DATE('3333333','j')) >= qugi.dal
   AND pegi.figura        = figi.numero
   AND pegi.dal          <= NVL(figi.al,TO_DATE('3333333','j'))
   AND NVL(pegi.al,TO_DATE('3333333','j')) >= figi.dal
   AND pegi.gestione      = gest.codice
   AND pegi.gestione      = gest.codice
   AND sett.numero        = pegi.settore
   AND sett1.numero (+)   = DECODE( sett.suddivisione
                                  , 1, sett.numero
                                     , sett.settore_a)
   AND sett2.numero (+)   = DECODE( sett.suddivisione
                                  , 2, sett.numero
                                     , sett.settore_b)
   AND sett3.numero (+)   = DECODE( sett.suddivisione
                                  , 3, sett.numero
                                     , sett.settore_c)
   AND sede.numero  (+)   = pegi.sede
   AND deli.sede    (+)   = NVL(pegi_p2.sede_del,' ')
   AND deli.numero  (+)   = NVL(pegi_p2.numero_del,0)
   AND deli.anno    (+)   = NVL(pegi_p2.anno_del,0)
   AND sepr.codice  (+)   = NVL(pegi_p2.sede_del,' ')
   AND rare.ci            = pegi.ci
   AND anag.ni            = 
      (select ni from rapporti_individuali
        where ci = pegi.ci )
   AND anag.al is null
   AND comu_n.cod_comune (+) = anag.comune_nas
   AND comu_n.cod_provincia (+) = anag.provincia_nas
   AND comu_r.cod_comune (+) = anag.comune_res
   AND comu_r.cod_provincia (+) = anag.provincia_res        
   and qugi.contratto = cont.contratto
   and pegi.dal between nvl(cont.dal,to_date('2222222','j')) 
                and     nvl(cont.al, to_date('3333333','j'))
/