CREATE OR REPLACE VIEW pegi_p
(   ci
,   rilevanza 
,   pegi_dal
,   pegi_al
,   evento
,   evra_descrizione
,   pegi_note
,   sede_del
,   numero_del
,   anno_del
,   deli_data
,   deli_note
,   numero_ese
,   data_ese
,   tipo_ese
)
AS SELECT
  pegi.ci                                  ci
, pegi.rilevanza                           rilevanza
, pegi.dal                                 pegi_dal
, pegi.al                                  pegi_al
, pegi.posizione                           evento
, decode
  ( instr(evra.descrizione,'[')
  , null, null
        , 0   , evra.descrizione
        , 1   , substr(evra.descrizione,instr(evra.descrizione,']')+1)
              , substr(evra.descrizione,1,instr(evra.descrizione,'[')-1)||
                substr(evra.descrizione,instr(evra.descrizione,']')+1)
  )                                        evra_descrizione
, decode
  ( instr(pegi.note,'[')
  , null, null
        , 0   , pegi.note
        , 1   , substr(pegi.note,instr(pegi.note,']')+1)
              , substr(pegi.note,1,instr(pegi.note,'[')-1)||
                substr(pegi.note,instr(pegi.note,']')+1)
  )                                        pegi_note
, nvl(sepr.descrizione,pegi.sede_posto)    sede_del
, pegi.numero_posto                        numero_del
, pegi.anno_posto                          anno_del    
, deli.data                                deli_data
, deli.note                                deli_note
, deli.numero_ese                          numero_ese
, deli.data_ese                            data_ese
, deli.tipo_ese                            tipo_ese 
  from sedi_provvedimento sepr
     , delibere           deli
     , eventi_rapporto    evra
     , periodi_giuridici  pegi
 where pegi.rilevanza     = 'P'
   and pegi.posizione     = evra.codice
   and deli.sede    (+)   = nvl(pegi.sede_posto,' ')
   and deli.numero  (+)   = nvl(pegi.numero_posto,0)
   and deli.anno    (+)   = nvl(pegi.anno_posto,0)
   and sepr.codice  (+)   = nvl(pegi.sede_posto,' ')
;
