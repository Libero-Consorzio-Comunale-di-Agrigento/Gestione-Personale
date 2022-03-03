CREATE OR REPLACE VIEW PEGI_A 
(   ci
,   rilevanza 
,   pegi_dal
,   pegi_al
,   evento
,   aste_descrizione
,   pegi_note
,   sede_del
,   numero_del
,   anno_del
,   deli_data
,   deli_note
,   numero_ese
,   data_ese
,   tipo_ese
,   pegi_gg
)
AS SELECT
   pegi.ci                                  ci
 , pegi.rilevanza                           rilevanza
 , pegi.dal                                 pegi_dal
 , pegi.al                                  pegi_al
 , pegi.assenza                             evento
 , decode
  ( instr(aste.descrizione,'[')
  , null, null
        , 0   , aste.descrizione
        , 1   , substr(aste.descrizione,instr(aste.descrizione,']')+1)
              , substr(aste.descrizione,1,instr(aste.descrizione,'[')-1)||
                substr(aste.descrizione,instr(aste.descrizione,']')+1)
  )                                         aste_descrizione
 , decode
   ( instr(pegi.note,'[')
   , null, null
         , 0   , pegi.note
         , 1   , substr(pegi.note,instr(pegi.note,']')+1)
               , substr(pegi.note,1,instr(pegi.note,'[')-1)||
                 substr(pegi.note,instr(pegi.note,']')+1)
   )                                        pegi_note
 , nvl(sepr.descrizione,pegi.sede_del)      sede_del
 , pegi.numero_del                          numero_del
 , pegi.anno_del                            anno_del
 , deli.data                                deli_data
 , deli.note                                deli_note
 , deli.numero_ese                          numero_ese
 , deli.data_ese                            data_ese
 , deli.tipo_ese                            tipo_ese
 , gp4gm.get_gg_certificato(trunc(pegi.dal)
                           ,trunc(least(nvl(pegi.al,to_date('3333333','j')),sysdate))
                           )       pegi_gg
   from sedi_provvedimento sepr
      , delibere           deli
      , astensioni         aste
      , periodi_giuridici  pegi
  where pegi.rilevanza     = 'A'
    and pegi.evento       in (select codice from eventi_giuridici
                               where rilevanza = 'A'
                                 and certificabile in ('SI','SP'))
    and pegi.assenza       = aste.codice
    and deli.sede    (+)   = nvl(pegi.sede_del,' ')
    and deli.numero  (+)   = nvl(pegi.numero_del,0)
    and deli.anno    (+)   = nvl(pegi.anno_del,0)
    and sepr.codice  (+)   = nvl(pegi.sede_del,' ')
/


