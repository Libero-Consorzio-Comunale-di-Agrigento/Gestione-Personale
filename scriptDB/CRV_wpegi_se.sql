CREATE OR REPLACE VIEW WORD_PEGI_SE
(ci, rilevanza, assunzione, motivo_ass, cessazione, motivo_cess, data_non_lavoro, pegi_dal, pegi_al, qugi_dal, qugi_al, qugi_codice, qugi_descrizione, qugi_livello, qugi_note, figi_dal, figi_al, figi_codice, figi_descrizione, figi_note, figi_cert_att, figi_cert_set, evento, evgi_descrizione, evgi_certificabile, evgi_presso, presso, pegi_gestione, gest_nome, gest_note, sett_codice, sett_descrizione, sett1_codice, sett1_descrizione, sett2_codice, sett2_descrizione, sett3_codice, sett3_descrizione, sede_codice, sede_descrizione, pegi_posizione, posi_descrizione, posi_ruolo, posi_des_ruolo, pegi_tr, pegi_ore, pegi_note, ruol_descrizione, sede_del, numero_del, anno_del, deli_data, deli_note, numero_ese, data_ese, tipo_ese, deli_estremi, pegi_gg, note_p, ass_estremi, ass_note, cess_estremi, cess_note, pofi_descrizione)
AS
SELECT
  pegi.ci                                  ci
, pegi.rilevanza                           rilevanza
, pegi.data_assunzione                     assunzione
, evra.descrizione                         motivo_ass
, pegi.data_cessazione                     cessazione
, evrc.descrizione                         motivo_cess
, pegi.data_cessazione + 1                 data_non_lavoro
, pegi.dal                                 pegi_dal
, pegi.al                                  pegi_al
, qugi.dal                                 qugi_dal
, qugi.al                                  qugi_al
, qugi.codice                              qugi_codice
, qugi.descrizione                         qugi_descrizione
, qugi.livello                             qugi_livello
, replace(gp4aa.elimina_tag(qugi.note,'[',']')
         ,chr(10),' ')                     qugi_note
, figi.dal                                 figi_dal
, figi.al                                  figi_al
, figi.codice                              figi_codice
, figi.descrizione                         figi_descrizione
, replace(gp4aa.elimina_tag(figi.note,'[',']')
         ,chr(10),' ')                     figi_note
, figi.cert_att                            figi_cert_att
, figi.cert_set                            figi_cert_set 
, pegi.evento                              evento
, evgi.descrizione                         evgi_descrizione
, evgi.certificabile                       evgi_certificabile
, evgi.presso                              evgi_presso
, replace(DECODE(evgi.presso
        ,'NO',NULL
             ,' '||UPPER(gest.nome)||
              DECODE(gest.note
                    ,NULL,NULL,' '||gest.note)
        ),chr(10),' ')                                  presso
, pegi.gestione                            pegi_gestione
, gest.nome                                gest_nome
, replace(gp4aa.elimina_tag(gest.note,'[',']')
         ,chr(10),' ')                     gest_note
, sett.codice                              sett_codice
, sett.descrizione                         sett_descrizione
, sett1.codice                             sett1_codice
, sett1.descrizione                        sett1_descrizione
, sett2.codice                             sett2_codice
, sett2.descrizione                        sett2_descrizione
, sett3.codice                             sett3_codice
, sett3.descrizione                        sett3_descrizione
, sede.codice                              sede_codice
, sede.descrizione                         sede_descrizione
, pegi.posizione                           pegi_posizione
, posi.descrizione                         posi_descrizione
, posi.ruolo                               posi_ruolo
, decode(posi.ruolo,'SI', 'di ruolo','non di ruolo') posi_des_ruolo
, SUBSTR(pegi.tipo_rapporto,1,2)           pegi_tr
, pegi.ore                                 pegi_ore
, replace(gp4aa.elimina_tag(pegi.note,'[',']')
         ,chr(10),' ')                     pegi_note
, ruol.descrizione                         ruol_descrizione
, NVL(sepr.descrizione,pegi.sede_del)      sede_del
, pegi.numero_del                          numero_del
, pegi.anno_del                            anno_del
, gp4_deli.data_del(pegi.sede_del
                              ,pegi.numero_del
                              ,pegi.anno_del)  deli_data
, replace(gp4aa.elimina_tag(deli.note,'[',']')
         ,chr(10),' ')                     deli_note
, deli.numero_ese                          numero_ese
, deli.data_ese                            data_ese
, deli.tipo_ese                            tipo_ese
, substr(gp4_deli.estremi(pegi.sede_del
                              ,pegi.numero_del
                              ,pegi.anno_del),1,18)     deli_estremi
, TRUNC(MONTHS_BETWEEN( LAST_DAY(LEAST( NVL(pegi.al,TO_DATE('3333333','j'))
                                       ,NVL(qugi.al,TO_DATE('3333333','j'))
                                       ,SYSDATE) +1 )
                       ,LAST_DAY(GREATEST(pegi.dal,qugi.dal))
                      ))*30
  -LEAST(30,TO_NUMBER(TO_CHAR(GREATEST(pegi.dal,qugi.dal),'dd'))) + 1
  +LEAST(30,TO_NUMBER(TO_CHAR(LEAST( NVL(pegi.al,TO_DATE('3333333','j'))
                                    ,NVL(qugi.al,TO_DATE('3333333','j'))
                                    ,SYSDATE) + 1,'dd')) - 1)       pegi_gg
, decode(pegi.al,pegi.data_cessazione, replace(gp4aa.elimina_tag(pegi.note_p,'[',']'),chr(10),' '),null)
, decode(pegi.al,pegi.data_cessazione,substr(gp4_deli.estremi(pegi.sede_ass
                              ,pegi.numero_ass
                              ,pegi.anno_ass),1,18),null) ass_estremi
, decode(pegi.al,pegi.data_cessazione,replace(gp4aa.elimina_tag(deli_ass.note,'[',']')
         ,chr(10),' ') ,null) ass_note
, decode(pegi.al,pegi.data_cessazione,substr(gp4_deli.estremi(pegi.sede_cess
                              ,pegi.numero_cess
                              ,pegi.anno_cess),1,18),null) cess_estremi
, decode(pegi.al,pegi.data_cessazione,replace(gp4aa.elimina_tag(deli_cess.note,'[',']')
         ,chr(10),' ') ,null) cess_note
, pofi.descrizione            pofi_descrizione         
  FROM SEDI_PROVVEDIMENTO    sepr
     , DELIBERE              deli
     , DELIBERE              deli_ass
     , DELIBERE              deli_cess
     , RUOLI                 ruol
     , GESTIONI              gest
     , SETTORI               sett
     , SETTORI               sett1
     , SETTORI               sett2
     , SETTORI               sett3
     , SEDI                  sede
     , POSIZIONI             posi
     , EVENTI_GIURIDICI      evgi
     , EVENTI_RAPPORTO       evra
     , EVENTI_RAPPORTO       evrc
     , QUALIFICHE_GIURIDICHE qugi
     , FIGURE_GIURIDICHE     figi
     , WORD_PERIODI_GIURIDICI     pegi
     , ENTE                  ENTE
     , PROFILI_PROFESSIONALI POFI
 WHERE ENTE.ente_id       = 'ENTE'
   AND evra.codice    (+) = pegi.cod_assunzione
   AND evra.rilevanza (+) = 'I'
   AND evrc.codice    (+) = pegi.cod_cessazione
   AND evrc.rilevanza (+) = 'T'
   AND pegi.rilevanza    IN (SELECT 'S' FROM dual
                             UNION
                             SELECT 'E' FROM dual)
   AND pegi.evento        = evgi.codice
   AND pegi.certificabile IN ('SI','SP')
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
   AND ruol.codice        = qugi.ruolo
   AND deli.sede    (+)   = NVL(pegi.sede_del,' ')
   AND deli.numero  (+)   = NVL(pegi.numero_del,0)
   AND deli.anno    (+)   = NVL(pegi.anno_del,0)
   AND sepr.codice  (+)   = NVL(pegi.sede_del,' ')
   AND deli_ass.sede    (+)   = NVL(pegi.sede_ass,' ')
   AND deli_ass.numero  (+)   = NVL(pegi.numero_ass,0)
   AND deli_ass.anno    (+)   = NVL(pegi.anno_ass,0)
   AND deli_cess.sede    (+)   = NVL(pegi.sede_cess,' ')
   AND deli_cess.numero  (+)   = NVL(pegi.numero_cess,0)
   AND deli_cess.anno    (+)   = NVL(pegi.anno_cess,0)
   AND pofi.codice      (+)   = figi.profilo  
;
