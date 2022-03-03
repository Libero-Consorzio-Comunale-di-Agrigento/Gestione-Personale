CREATE OR REPLACE VIEW PEGI_D 
(   ci
,   dogi_dal
,   dogi_al
,   dogi_del
,   dogi_descrizione
,   evento
,   evgi_descrizione
,   dogi_scd
,   sodo_descrizione
,   dogi_note
,   sede_del
,   numero_del
,   anno_del
,   deli_data
,   deli_note
,   numero_ese
,   data_ese
,   tipo_ese
,   dogi_gg
) AS SELECT
  dogi.ci                                  ci
, dogi.dal                                 dogi_dal
, dogi.al                                  dogi_al
, dogi.del                                 dogi_del
, dogi.descrizione                         dogi_descrizione
, dogi.evento                              evento
, decode
  ( instr(evgi.descrizione,'[')
  , null, null
        , 0   , evgi.descrizione
        , 1   , substr(evgi.descrizione,instr(evgi.descrizione,']')+1)
              , substr(evgi.descrizione,1,instr(evgi.descrizione,'[')-1)||
                substr(evgi.descrizione,instr(evgi.descrizione,']')+1)
  )                                        evgi_descrizione
, dogi.scd                                 dogi_scd
, decode
  ( instr(sodo.descrizione,'[')
  , null, null
        , 0   , sodo.descrizione
        , 1   , substr(sodo.descrizione,instr(sodo.descrizione,']')+1)
              , substr(sodo.descrizione,1,instr(sodo.descrizione,'[')-1)||
                substr(sodo.descrizione,instr(sodo.descrizione,']')+1)
  )                                        sodo_descrizione
, decode
  ( instr(dogi.note,'[')
  , null, null
        , 0   , dogi.note
        , 1   , substr(dogi.note,instr(dogi.note,']')+1)
              , substr(dogi.note,1,instr(dogi.note,'[')-1)||
                substr(dogi.note,instr(dogi.note,']')+1)
  )                                        dogi_note
, nvl(sepr.descrizione,dogi.sede_del)      sede_del
, dogi.numero_del                          numero_del
, dogi.anno_del                            anno_del
, deli.data                                deli_data
, deli.note                                deli_note
, deli.numero_ese                          numero_ese
, deli.data_ese                            data_ese
, deli.tipo_ese                            tipo_ese
, gp4gm.get_gg_certificato(trunc(dogi.dal)
                          ,trunc(least(nvl(dogi.al,to_date('3333333','j')),sysdate))
                          )       dogi_gg
  from sedi_provvedimento    sepr
     , delibere              deli
     , sottocodici_documento sodo
     , eventi_giuridici      evgi
     , documenti_giuridici   dogi
 where dogi.evento        = evgi.codice
   and dogi.evento        = sodo.evento
   and nvl(dogi.scd,' ')  = sodo.codice (+)
   and evgi.certificabile in ('SI','SP')
   and deli.sede    (+)   = nvl(dogi.sede_del,' ')
   and deli.numero  (+)   = nvl(dogi.numero_del,0)
   and deli.anno    (+)   = nvl(dogi.anno_del,0)
   and sepr.codice  (+)   = nvl(dogi.sede_del,' ')
/


