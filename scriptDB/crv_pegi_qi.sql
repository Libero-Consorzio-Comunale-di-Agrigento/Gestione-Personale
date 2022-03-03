CREATE OR REPLACE VIEW PEGI_QI
(CI, RILEVANZA, dal, al, PEGI_DAL, PEGI_AL, FIGI_DAL, 
 FIGI_AL, FIGI_CODICE, FIGI_DESCRIZIONE, FIGI_NOTE, FIGI_CERT_ATT, 
 FIGI_CERT_SET, TIRA_DESCRIZIONE, TIRA_NOTE, PEGI_EVENTO, EVGI_DESCRIZIONE, 
 EVGI_CERTIFICABILE, EVGI_PRESSO, PRESSO, PEGI_GESTIONE, GEST_NOME, 
 GEST_NOTE, SETT_CODICE, SETT_DESCRIZIONE, SETT1_CODICE, SETT1_DESCRIZIONE, 
 SETT2_CODICE, SETT2_DESCRIZIONE, SETT3_CODICE, SETT3_DESCRIZIONE, PEGI_POSIZIONE, 
 POSI_DESCRIZIONE, POSI_RUOLO, POSI_TEMPO_DETERMINATO, POSI_PART_TIME, PEGI_TR, 
 PEGI_ORE, PEGI_NOTE, RUOL_DESCRIZIONE, PRPR_DESCRIZIONE, POFU_DESCRIZIONE, 
 ATTI_DESCRIZIONE, COST_ORE_LAVORO, SEDE_DEL, NUMERO_DEL, ANNO_DEL, DELI_DATA, 
 DELI_NOTE, NUMERO_ESE, DATA_ESE, TIPO_ESE, PEGI_GG,EVGI_CERT_SETT)
AS
SELECT
  pegi.ci                                  ci
, pegi.rilevanza                           rilevanza
, greatest(pegi.dal
          , figi.dal)                            dal
, least( nvl(pegi.al,to_date('3333333','j'))
       , nvl(figi.al,to_date('3333333','j')))    al
, pegi.dal                                 pegi_dal
, pegi.al                                  pegi_al
, figi.dal                                 figi_dal
, figi.al                                  figi_al
, figi.codice                              figi_codice
, figi.descrizione                         figi_descrizione
, decode( instr(figi.note,'[')
        , null, null
        , 0, figi.note
        , 1, substr(figi.note,instr(figi.note,']')+1,210)
           , substr(figi.note,1,instr(figi.note,'[')-1)||
            substr(figi.note,instr(figi.note,']')+1,210)
         )                                 figi_note
, figi.cert_att                            figi_cert_att
, figi.cert_set                            figi_cert_set
, decode(tira.stampa_certificato,'SI',decode( instr(tira.descrizione,'[')
                                            , null, null
                                            , 0   , tira.descrizione
                                            , 1   , substr(tira.descrizione,instr(tira.descrizione,']')+1)
                                                  , substr(tira.descrizione,1,instr(tira.descrizione,'[')-1)||
                                                    substr(tira.descrizione,instr(tira.descrizione,']')+1)
                                             )
                                     ,null)  tira_descrizione
, decode(tira.stampa_certificato,'SI',decode( instr(tira.note,'[')
							  , null, null
							     , 0, tira.note
							     , 1, substr(tira.note,instr(tira.note,']')+1,210)
							        , substr(tira.note,1,instr(tira.note,'[')-1)||
							          substr(tira.note,instr(tira.note,']')+1,210)
							   )
                                     ,null)   tira_note
, pegi.evento                              pegi_evento
, decode( instr(evgi.descrizione,'[')
        , null, null
        , 0   , evgi.descrizione
        , 1   , substr(evgi.descrizione,instr(evgi.descrizione,']')+1)
              , substr(evgi.descrizione,1,instr(evgi.descrizione,'[')-1)||
                substr(evgi.descrizione,instr(evgi.descrizione,']')+1)
  )                                        evgi_descrizione
, evgi.certificabile                       evgi_certificabile
, evgi.presso                              evgi_presso
, upper(gest.nome)||
  decode(gest.note
        ,null,null,' '||gest.note)         presso
, pegi.gestione                            pegi_gestione
, gest.nome                                gest_nome
, gest.note                                gest_note
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
, posi.tempo_determinato				   posi_tempo_determinato
, posi.part_time						   posi_part_time
, substr(pegi.tipo_rapporto,1,2)           pegi_tr
, pegi.ore                                 pegi_ore
, decode( instr(pegi.note,'[')
        , null, null
        , 0   , pegi.note
        , 1   , substr(pegi.note,instr(pegi.note,']')+1)
              , substr(pegi.note,1,instr(pegi.note,'[')-1)||
                substr(pegi.note,instr(pegi.note,']')+1)
        )                                  pegi_note
, ruol.descrizione                         ruol_descrizione
, prpr.descrizione                         prpr_descrizione
, pofu.descrizione                         pofu_descrizione
, atti.descrizione                         atti_descrizione
, cost.ore_lavoro                          cost_ore_lavoro
, nvl(sepr.descrizione,pegi.sede_del)      sede_del
, pegi.numero_del                          numero_del
, pegi.anno_del                            anno_del
, deli.data                                deli_data
, deli.note                                deli_note
, deli.numero_ese                          numero_ese
, deli.data_ese                            data_ese
, deli.tipo_ese                            tipo_ese
, gp4gm.get_gg_certificato(trunc(greatest(pegi.dal,figi.dal))
                          ,trunc(least( nvl(pegi.al,to_date('3333333','j'))
                                       ,nvl(figi.al,to_date('3333333','j'))
                                       ,sysdate))
                           )       pegi_gg
, evgi.cert_sett           evgi_cert_sett
  from sedi_provvedimento    sepr
     , ente                  ente
     , delibere              deli
     , ruoli                 ruol
     , contratti_storici     cost
     , gestioni              gest
     , attivita              atti
     , posizioni             posi
     , eventi_giuridici      evgi
     , profili_professionali prpr
     , posizioni_funzionali  pofu
     , settori               sett
     , settori               sett1
     , settori               sett2
     , settori               sett3
     , figure_giuridiche     figi
     , periodi_giuridici     pegi
     , tipi_rapporto         tira
 where ente.ente_id         = 'ENTE'
   and tira.codice      (+) = pegi.tipo_rapporto
   and pegi.rilevanza    in (select 'Q' from sys.dual
                              union
                             select 'I' from sys.dual)
   and pegi.evento        = evgi.codice
   and evgi.certificabile in ('SI','SP')
   and pegi.posizione     = posi.codice
   and pegi.figura        = figi.numero
   and pegi.dal          <= nvl(figi.al,to_date('3333333','j'))
   and nvl(pegi.al,to_date('3333333','j')) >= figi.dal
   and pegi.gestione      = gest.codice
   and ruol.codice        =
      (select max(ruolo) from qualifiche_giuridiche
        where numero = figi.qualifica
          and dal          <= nvl(figi.al,to_date('3333333','j'))
          and nvl(al,to_date('3333333','j')) >= figi.dal)
   and cost.contratto     =
      (select max(contratto) from qualifiche_giuridiche
        where numero = figi.qualifica
          and dal          <= nvl(figi.al,to_date('3333333','j'))
          and nvl(al,to_date('3333333','j')) >= figi.dal)
   and pegi.dal          <= nvl(cost.al,to_date('3333333','j'))
   and nvl(pegi.al,to_date('3333333','j')) >= cost.dal
   and prpr.codice  (+)   = nvl(figi.profilo,' ')
   and pofu.codice  (+)   = nvl(figi.posizione,' ')
   and pofu.profilo (+)   = nvl(figi.profilo,' ')
   and atti.codice  (+)   = nvl(pegi.attivita,' ')
   and sett.numero        = pegi.settore
   and sett1.numero (+)   = decode( sett.suddivisione
                                  , 1, sett.numero
                                     , sett.settore_a)
   and sett2.numero (+)   = decode( sett.suddivisione
                                  , 2, sett.numero
                                     , sett.settore_b)
   and sett3.numero (+)   = decode( sett.suddivisione
                                  , 3, sett.numero
                                     , sett.settore_c)
   and deli.sede    (+)   = nvl(pegi.sede_del,' ')
   and deli.numero  (+)   = nvl(pegi.numero_del,0)
   and deli.anno    (+)   = nvl(pegi.anno_del,0)
   and sepr.codice  (+)   = nvl(pegi.sede_del,' ')
/

