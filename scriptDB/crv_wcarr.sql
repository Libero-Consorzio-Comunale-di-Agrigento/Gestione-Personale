CREATE OR REPLACE FORCE VIEW WORD_CARRIERA ( CI, 
RILEVANZA, DATA_ASSUNZIONE, MOTIVO_ASS, DATA_CESSAZIONE, MOTIVO_CESS,
DATA_NON_LAVORO, PEGI_DAL, PEGI_AL,
QUGI_DAL, QUGI_AL, QUGI_CODICE, QUGI_DESCRIZIONE, QUGI_LIVELLO, 
QUGI_NOTE, FIGI_DAL, FIGI_AL, FIGI_CODICE, 
FIGI_DESCRIZIONE, FIGI_NOTE, FIGI_CERT_ATT, FIGI_CERT_SET, 
EVENTO, EVGI_DESCRIZIONE, EVGI_CERTIFICABILE, EVGI_PRESSO, 
PRESSO, PEGI_GESTIONE, GEST_NOME, GEST_NOTE, 
SETT_CODICE, SETT_DESCRIZIONE, SETT1_CODICE, SETT1_DESCRIZIONE, 
SETT2_CODICE, SETT2_DESCRIZIONE, SETT3_CODICE, SETT3_DESCRIZIONE, 
SEDE_CODICE, SEDE_DESCRIZIONE, PEGI_POSIZIONE, POSI_DESCRIZIONE, 
POSI_RUOLO, POSI_DES_RUOLO, POSI_TEMPo_DETERMINATO, POSI_PART_TIME, 
PEGI_TR, PEGI_ORE, PEGI_NOTE, RUOL_DESCRIZIONE, SEDE_DEL, NUMERO_DEL, ANNO_DEL, 
DELI_DATA, DELI_NOTE, NUMERO_ESE, DATA_ESE, 
TIPO_ESE, DELI_ESTREMI, PEGI_ANNI, PEGI_MESI, PEGI_GIORNI, PEGI_GG,
NOTE_P, ASS_ESTREMI, ASS_NOTE, CESS_ESTREMI, CESS_NOTE
) AS SELECT   
  pegi.ci                                  ci   
, pegi.rilevanza                           rilevanza   
, pegi.data_assunzione                     data_assuzione
, evra.descrizione                         motivo_ass
, pegi.data_cessazione                     data_cessazione
, evrc.descrizione                         motivo_cess
, pegi.data_cessazione + 1                 data_non_lavoro
, pegi.dal                                 pegi_dal   
, Periodo.get_ultimo ('WORD_PERIODI_GIURIDICI','DAL','AL',   
                      pegi.al,'#to_char(DATA_ASSUNZIONE)#CERTIFICABILE#POSIZIONE#FIGURA#QUALIFICA#ORE#RILEVANZA#CI#',
                      '#'||to_char(pegi.data_assunzione)||'#'||pegi.certificabile||'#'||pegi.posizione||'#'||pegi.figura|| '#' ||pegi.qualifica||'#'||pegi.ore||
                      '#'||pegi.rilevanza||'#'||pegi.ci||'#')   
					   pegi_al   
, qugi.dal                                 qugi_dal   
, qugi.al                                  qugi_al   
, qugi.codice                              qugi_codice   
, qugi.descrizione||decode(pegi.ore,null,' ',' p.t.')
                                           qugi_descrizione   
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
        ),chr(10),' ')                     presso   
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
, posi.tempO_determinato                   posi_tempO_determinato   
, posi.part_time                           posi_part_time
, SUBSTR(pegi.tipo_rapporto,1,2)           pegi_tr   
, pegi.ore                                 pegi_ore   
, replace
  (gp4aa.elimina_tag
   (gp4_pegi.get_note_concatenate
    (pegi.ci
    ,pegi.rilevanza
    ,pegi.dal
    ,Periodo.get_ultimo 
     ('WORD_PERIODI_GIURIDICI'
     ,'DAL'
     ,'AL'
     , pegi.al
     , '#to_char(DATA_ASSUNZIONE)#CERTIFICABILE#POSIZIONE#FIGURA#QUALIFICA#ORE#RILEVANZA#CI#'
     , '#'||to_char(pegi.data_assunzione)||'#'||pegi.certificabile||'#'||pegi.posizione||'#'||pegi.figura|| 
       '#'||pegi.qualifica||'#'||pegi.ore||'#'||pegi.rilevanza||'#'||pegi.ci||'#'
     )
   )
   ,'[',']')
  ,chr(10),' ')                            pegi_note   
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
, TO_CHAR(TRUNC(gp4gm.get_gg_certificato(GREATEST(pegi.dal,qugi.dal)
                                        ,LEAST( NVL(Periodo.get_ultimo ('WORD_PERIODI_GIURIDICI','DAL','AL',   
                                                                        pegi.al,'#to_char(DATA_ASSUNZIONE)#CERTIFICABILE#POSIZIONE#FIGURA#QUALIFICA#ORE#RILEVANZA#CI#',
                                                                        '#'||to_char(pegi.data_assunzione)||'#'||pegi.certificabile||'#'||pegi.posizione||'#'||pegi.figura|| '#' ||pegi.qualifica||'#'||pegi.ore||
                                                                        '#'||pegi.rilevanza||'#'||pegi.ci||'#')   ,TO_DATE('3333333','j'))   
                                               ,NVL(qugi.al,TO_DATE('3333333','j'))   
                                               ,SYSDATE)
                                        )/360))                          pegi_anni 
, TO_CHAR(TRUNC((gp4gm.get_gg_certificato(GREATEST(pegi.dal,qugi.dal)
                                         ,LEAST( NVL(Periodo.get_ultimo ('WORD_PERIODI_GIURIDICI','DAL','AL',   
                                                                         pegi.al,'#to_char(DATA_ASSUNZIONE)#CERTIFICABILE#POSIZIONE#FIGURA#QUALIFICA#ORE#RILEVANZA#CI#',
                                                                         '#'||to_char(pegi.data_assunzione)||'#'||pegi.certificabile||'#'||pegi.posizione||'#'||pegi.figura|| '#' ||pegi.qualifica||'#'||pegi.ore||
                                                                         '#'||pegi.rilevanza||'#'||pegi.ci||'#')   ,TO_DATE('3333333','j'))   
                                                ,NVL(qugi.al,TO_DATE('3333333','j'))   
                                                ,SYSDATE)
                                        )-TRUNC(gp4gm.get_gg_certificato(GREATEST(pegi.dal,qugi.dal)
                                        ,LEAST( NVL(Periodo.get_ultimo ('WORD_PERIODI_GIURIDICI','DAL','AL',   
                                                                        pegi.al,'#to_char(DATA_ASSUNZIONE)#CERTIFICABILE#POSIZIONE#FIGURA#QUALIFICA#ORE#RILEVANZA#CI#',
                                                                        '#'||to_char(pegi.data_assunzione)||'#'||pegi.certificabile||'#'||pegi.posizione||'#'||pegi.figura|| '#' ||pegi.qualifica||'#'||pegi.ore||
                                                                        '#'||pegi.rilevanza||'#'||pegi.ci||'#')   ,TO_DATE('3333333','j'))   
                                               ,NVL(qugi.al,TO_DATE('3333333','j'))   
                                               ,SYSDATE)
                                        )/360)*360)/30))                  pegi_mesi                                                        
, TO_CHAR((gp4gm.get_gg_certificato(GREATEST(pegi.dal,qugi.dal)
                                   ,LEAST( NVL(Periodo.get_ultimo ('WORD_PERIODI_GIURIDICI','DAL','AL',   
                                                                   pegi.al,'#to_char(DATA_ASSUNZIONE)#CERTIFICABILE#POSIZIONE#FIGURA#QUALIFICA#ORE#RILEVANZA#CI#',
                                                                   '#'||to_char(pegi.data_assunzione)||'#'||pegi.certificabile||'#'||pegi.posizione||'#'||pegi.figura|| '#' ||pegi.qualifica||'#'||pegi.ore||
                                                                   '#'||pegi.rilevanza||'#'||pegi.ci||'#')   ,TO_DATE('3333333','j'))   
                                          ,NVL(qugi.al,TO_DATE('3333333','j'))   
                                          ,SYSDATE)
                                        )
           -TRUNC(gp4gm.get_gg_certificato(GREATEST(pegi.dal,qugi.dal)
                                          ,LEAST( NVL(Periodo.get_ultimo ('WORD_PERIODI_GIURIDICI','DAL','AL',   
                                                                          pegi.al,'#to_char(DATA_ASSUNZIONE)#CERTIFICABILE#POSIZIONE#FIGURA#QUALIFICA#ORE#RILEVANZA#CI#',
                                                                          '#'||to_char(pegi.data_assunzione)||'#'||pegi.certificabile||'#'||pegi.posizione||'#'||pegi.figura|| '#' ||pegi.qualifica||'#'||pegi.ore||
                                                                          '#'||pegi.rilevanza||'#'||pegi.ci||'#')   ,TO_DATE('3333333','j'))   
                                                 ,NVL(qugi.al,TO_DATE('3333333','j'))   
                                                 ,SYSDATE)
                                        )/360)*360
           -TRUNC((gp4gm.get_gg_certificato(GREATEST(pegi.dal,qugi.dal)
                                           ,LEAST( NVL(Periodo.get_ultimo ('WORD_PERIODI_GIURIDICI','DAL','AL',   
                                                                           pegi.al,'#to_char(DATA_ASSUNZIONE)#CERTIFICABILE#POSIZIONE#FIGURA#QUALIFICA#ORE#RILEVANZA#CI#',
                                                                           '#'||to_char(pegi.data_assunzione)||'#'||pegi.certificabile||'#'||pegi.posizione||'#'||pegi.figura|| '#' ||pegi.qualifica||'#'||pegi.ore||
                                                                           '#'||pegi.rilevanza||'#'||pegi.ci||'#')   ,TO_DATE('3333333','j'))   
                                                  ,NVL(qugi.al,TO_DATE('3333333','j'))   
                                                  ,SYSDATE)
                                        )
           -TRUNC(gp4gm.get_gg_certificato(GREATEST(pegi.dal,qugi.dal)
                                          ,LEAST( NVL(Periodo.get_ultimo ('WORD_PERIODI_GIURIDICI','DAL','AL',   
                                                                          pegi.al,'#to_char(DATA_ASSUNZIONE)#CERTIFICABILE#POSIZIONE#FIGURA#QUALIFICA#ORE#RILEVANZA#CI#',
                                                                          '#'||to_char(pegi.data_assunzione)||'#'||pegi.certificabile||'#'||pegi.posizione||'#'||pegi.figura|| '#' ||pegi.qualifica||'#'||pegi.ore||
                                                                          '#'||pegi.rilevanza||'#'||pegi.ci||'#')   ,TO_DATE('3333333','j'))   
                                                 ,NVL(qugi.al,TO_DATE('3333333','j'))   
                                                 ,SYSDATE)
                                          )/360)*360)/30)
           *30))                                                    pegi_giorni
, gp4gm.get_gg_certificato(GREATEST(pegi.dal,qugi.dal)
                          ,LEAST( NVL(Periodo.get_ultimo ('WORD_PERIODI_GIURIDICI','DAL','AL',   
                                                          pegi.al,'#to_char(DATA_ASSUNZIONE)#CERTIFICABILE#POSIZIONE#FIGURA#QUALIFICA#ORE#RILEVANZA#CI#',
                                                          '#'||to_char(pegi.data_assunzione)||'#'||pegi.certificabile||'#'||pegi.posizione||'#'||pegi.figura|| '#' ||pegi.qualifica||'#'||pegi.ore||
                                                          '#'||pegi.rilevanza||'#'||pegi.ci||'#')   ,TO_DATE('3333333','j'))   
                                 ,NVL(qugi.al,TO_DATE('3333333','j'))   
                                 ,SYSDATE)
                          )                                         pegi_gg 
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
     , EVENTI_RAPPORTO       EVRA
     , EVENTI_RAPPORTO       EVRC
     , QUALIFICHE_GIURIDICHE qugi   
     , FIGURE_GIURIDICHE     figi   
     , WORD_PERIODI_GIURIDICI     pegi   
     , ENTE                  ENTE   
 WHERE ENTE.ente_id       = 'ENTE'   
   AND pegi.rilevanza    IN (SELECT 'S' FROM dual   
                             UNION   
                             SELECT 'E' FROM dual)   
   AND pegi.evento        = evgi.codice   
   AND evgi.certificabile IN ('SI','SP')   
   AND evra.codice    (+)    = pegi.cod_assunzione
   AND evra.rilevanza (+)    = 'I'
   AND evrc.codice    (+)    = pegi.cod_cessazione
   AND evrc.rilevanza (+)    = 'T'
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
   AND periodo.is_primo ('WORD_PERIODI_GIURIDICI','AL',   
                         pegi.dal,'#to_char(DATA_ASSUNZIONE)#CERTIFICABILE#POSIZIONE#FIGURA#QUALIFICA#ORE#RILEVANZA#CI#',
                         '#'||to_char(pegi.data_assunzione)||'#'||pegi.certificabile||'#'||pegi.posizione||'#'||pegi.figura||
                         '#' ||pegi.qualifica||'#'||pegi.ore||
                         '#'||pegi.rilevanza||'#'||pegi.ci||'#')=1
/
