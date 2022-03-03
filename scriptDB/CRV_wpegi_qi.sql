CREATE OR REPLACE VIEW WORD_PEGI_QI ( CI, 
RILEVANZA, PEGI_DAL, PEGI_AL, FIGI_DAL, 
FIGI_AL, FIGI_CODICE, FIGI_DESCRIZIONE, FIGI_NOTE, 
FIGI_CERT_ATT, FIGI_CERT_SET, PEGI_EVENTO, EVGI_DESCRIZIONE, 
EVGI_CERTIFICABILE, EVGI_PRESSO, PRESSO, PEGI_GESTIONE, 
GEST_NOME, GEST_NOTE, SETT_CODICE, SETT_DESCRIZIONE, 
SETT1_CODICE, SETT1_DESCRIZIONE, SETT2_CODICE, SETT2_DESCRIZIONE, 
SETT3_CODICE, SETT3_DESCRIZIONE, PEGI_POSIZIONE, POSI_DESCRIZIONE, 
POSI_RUOLO, PEGI_TR, PEGI_ORE, PEGI_NOTE, 
RUOL_DESCRIZIONE, PRPR_DESCRIZIONE, POFU_DESCRIZIONE, ATTI_DESCRIZIONE, 
SEDE_DEL, NUMERO_DEL, ANNO_DEL, DELI_DATA, 
DELI_NOTE, NUMERO_ESE, DATA_ESE, TIPO_ESE, DELI_ESTREMI,
PEGI_GG ) AS SELECT 
  pegi.ci                                  ci 
, pegi.rilevanza                           rilevanza 
, pegi.dal                                 pegi_dal 
, pegi.al                                  pegi_al 
, figi.dal                                 figi_dal 
, figi.al                                  figi_al 
, figi.codice                              figi_codice 
, figi.descrizione                         figi_descrizione 
, replace(gp4aa.elimina_tag(figi.note,'[',']')
         ,chr(10),' ')                     figi_note 
, figi.cert_att                            figi_cert_att 
, figi.cert_set                            figi_cert_set 
, pegi.evento                              pegi_evento 
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
, pegi.posizione                           pegi_posizione 
, posi.descrizione                         posi_descrizione 
, posi.ruolo                               posi_ruolo 
, SUBSTR(pegi.tipo_rapporto,1,2)           pegi_tr 
, pegi.ore                                 pegi_ore 
, replace(gp4aa.elimina_tag(pegi.note,'[',']')
         ,chr(10),' ')                     pegi_note 
, ruol.descrizione                         ruol_descrizione 
, prpr.descrizione                         prpr_descrizione 
, pofu.descrizione                         pofu_descrizione 
, atti.descrizione                         atti_descrizione 
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
                                       ,NVL(figi.al,TO_DATE('3333333','j')) 
                                       ,SYSDATE) +1 ) 
                       ,LAST_DAY(GREATEST(pegi.dal,figi.dal)) 
                      ))*30 
  -LEAST(30,TO_NUMBER(TO_CHAR(GREATEST(pegi.dal,figi.dal),'dd'))) + 1 
  +LEAST(30,TO_NUMBER(TO_CHAR(LEAST( NVL(pegi.al,TO_DATE('3333333','j')) 
                                    ,NVL(figi.al,TO_DATE('3333333','j')) 
                                    ,SYSDATE) + 1,'dd')) - 1)       pegi_gg 
  FROM SEDI_PROVVEDIMENTO    sepr 
     , ENTE                  ENTE 
     , DELIBERE              deli 
     , RUOLI                 ruol 
     , GESTIONI              gest 
     , ATTIVITA              atti 
     , POSIZIONI             posi 
     , EVENTI_GIURIDICI      evgi 
     , PROFILI_PROFESSIONALI prpr 
     , POSIZIONI_FUNZIONALI  pofu 
     , SETTORI               sett 
     , SETTORI               sett1 
     , SETTORI               sett2 
     , SETTORI               sett3 
     , FIGURE_GIURIDICHE     figi 
     , PERIODI_GIURIDICI     pegi 
 WHERE ENTE.ente_id         = 'ENTE' 
   AND pegi.rilevanza    IN (SELECT 'Q' FROM sys.dual 
                              UNION 
                             SELECT 'I' FROM sys.dual) 
   AND pegi.evento        = evgi.codice 
   AND evgi.certificabile IN ('SI','SP') 
   AND substr(pegi.evento,length(pegi.evento)) != wpegi_qi_evento
   AND pegi.posizione     = posi.codice 
   AND pegi.figura        = figi.numero 
   AND pegi.dal          <= NVL(figi.al,TO_DATE('3333333','j')) 
   AND NVL(pegi.al,TO_DATE('3333333','j')) >= figi.dal 
   AND pegi.gestione      = gest.codice 
   AND ruol.codice        = 
      (SELECT MAX(ruolo) FROM QUALIFICHE_GIURIDICHE 
        WHERE numero = figi.qualifica 
          AND dal          <= NVL(figi.al,TO_DATE('3333333','j')) 
          AND NVL(al,TO_DATE('3333333','j')) >= figi.dal) 
   AND prpr.codice  (+)   = NVL(figi.profilo,' ') 
   AND pofu.codice  (+)   = NVL(figi.posizione,' ') 
   AND pofu.profilo (+)   = NVL(figi.profilo,' ') 
   AND atti.codice  (+)   = NVL(pegi.ATTIVITA,' ') 
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
   AND deli.sede    (+)   = NVL(pegi.sede_del,' ') 
   AND deli.numero  (+)   = NVL(pegi.numero_del,0) 
   AND deli.anno    (+)   = NVL(pegi.anno_del,0) 
   AND sepr.codice  (+)   = NVL(pegi.sede_del,' ')
/