CREATE OR REPLACE VIEW PEGI_SE 
(CI, RILEVANZA, dal, al, PEGI_DAL, PEGI_AL, QUGI_DAL, 
 QUGI_AL, QUGI_CODICE, QUGI_DESCRIZIONE, QUGI_NOTE, TIRA_DESCRIZIONE, 
 TIRA_NOTE, EVENTO, EVGI_DESCRIZIONE, EVGI_CERTIFICABILE, EVGI_PRESSO, 
 PRESSO, PEGI_GESTIONE, GEST_NOME, GEST_NOTE, SETT_CODICE, 
 SETT_DESCRIZIONE, SETT1_CODICE, SETT1_DESCRIZIONE, SETT2_CODICE, SETT2_DESCRIZIONE, 
 SETT3_CODICE, SETT3_DESCRIZIONE, PEGI_POSIZIONE, POSI_DESCRIZIONE, POSI_RUOLO, 
 POSI_TEMPO_DETERMINATO, POSI_PART_TIME, PEGI_TR, PEGI_ORE, PEGI_NOTE, 
 RUOL_DESCRIZIONE, SEDE_DEL, NUMERO_DEL, ANNO_DEL, DELI_DATA, 
 DELI_NOTE, NUMERO_ESE, DATA_ESE, TIPO_ESE, PEGI_GG,EVGI_CERT_SETT)
AS
SELECT
  pegi.ci                                  ci
, pegi.rilevanza                           rilevanza
, greatest(pegi.dal
          , qugi.dal)                      dal
, least( nvl(pegi.al,to_date('3333333','j'))
       , nvl(qugi.al,to_date('3333333','j')))   al
, pegi.dal                                 pegi_dal
, pegi.al                                  pegi_al
, qugi.dal                                 qugi_dal
, qugi.al                                  qugi_al
, qugi.codice                              qugi_codice
, qugi.descrizione                         qugi_descrizione
, decode( instr(qugi.note,'[')
        , null, null
        , 0, qugi.note
        , 1, substr(qugi.note,instr(qugi.note,']')+1,210)
           , substr(qugi.note,1,instr(qugi.note,'[')-1)||
             substr(qugi.note,instr(qugi.note,']')+1,210)
        )                                  qugi_note
, decode(tira.stampa_certificato,'SI',decode( instr(tira.descrizione,'[')
                                            , null, null
                                            , 0   , tira.descrizione
                                            , 1   , substr(tira.descrizione,instr(tira.descrizione,']')+1)
                                                  , substr(tira.descrizione,1,instr(tira.descrizione,'[')-1)||
                                                    substr(tira.descrizione,instr(tira.descrizione,']')+1)
                                             )
                                     ,null) tira_descrizione
, decode(tira.stampa_certificato,'SI',decode( instr(tira.note,'[')
							  , null, null
							     , 0, tira.note
							     , 1, substr(tira.note,instr(tira.note,']')+1,210)
							        , substr(tira.note,1,instr(tira.note,'[')-1)||
							          substr(tira.note,instr(tira.note,']')+1,210)
							   )
                                     ,null) tira_note
, pegi.evento                               evento
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
, nvl(sepr.descrizione,pegi.sede_del)      sede_del
, pegi.numero_del                          numero_del
, pegi.anno_del                            anno_del
, deli.data                                deli_data
, deli.note                                deli_note
, deli.numero_ese                          numero_ese
, deli.data_ese                            data_ese
, deli.tipo_ese                            tipo_ese
, gp4gm.get_gg_certificato(trunc(greatest(pegi.dal,qugi.dal))
                          ,trunc(least( nvl(pegi.al,to_date('3333333','j'))
                                       ,nvl(qugi.al,to_date('3333333','j'))
                                       ,sysdate))
                           )       pegi_gg
, evgi.cert_sett    evgi_cert_sett
  from sedi_provvedimento    sepr
     , delibere              deli
     , ruoli                 ruol
     , gestioni              gest
     , settori               sett
     , settori               sett1
     , settori               sett2
     , settori               sett3
     , posizioni             posi
     , eventi_giuridici      evgi
     , qualifiche_giuridiche qugi
     , periodi_giuridici     pegi
     , ente                  ente
	 , tipi_rapporto         tira
 where ente.ente_id       = 'ENTE'
   and tira.codice    (+) = pegi.tipo_rapporto
   and pegi.rilevanza    in (select 'S' from dual
                             union
                             select 'E' from dual)
   and pegi.evento        = evgi.codice
   and evgi.certificabile in ('SI','SP')
--  and evgi.rilevanza     = 'S'
   and pegi.posizione     = posi.codice
   and pegi.qualifica     = qugi.numero
   and pegi.dal          <= nvl(qugi.al,to_date('3333333','j'))
   and nvl(pegi.al,to_date('3333333','j')) >= qugi.dal
   and pegi.gestione      = gest.codice
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
   and ruol.codice        = qugi.ruolo
   and deli.sede    (+)   = nvl(pegi.sede_del,' ')
   and deli.numero  (+)   = nvl(pegi.numero_del,0)
   and deli.anno    (+)   = nvl(pegi.anno_del,0)
   and sepr.codice  (+)   = nvl(pegi.sede_del,' ')
/


