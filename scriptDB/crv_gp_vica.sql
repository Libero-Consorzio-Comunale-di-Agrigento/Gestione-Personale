CREATE OR REPLACE VIEW VISTA_CARRIERE AS
SELECT
  rain.ci ci
, rain.ni
, rain.cognome
, rain.nome
, pegi.rilevanza
, pegi.posizione
, posi.descrizione des_posizione
, pegi.dal del
, pegi.dal
, pegi.al
, pegi.evento
, evgi.descrizione des_evento
, evra.descrizione des_rapporto
, pegi.assenza tipo
, aste.descrizione des_tipo   
, pegi.figura
, figi.descrizione des_figura
, pegi.tipo_rapporto
, nvl(pegi.ore,cost.ore_lavoro) ore
, pegi.attivita
, atti.descrizione des_attivita
, pegi.qualifica
, qugi.descrizione des_qualifica
, qugi.livello
, pegi.gestione
, pegi.settore
, pegi.sede
, pegi.gruppo
, pegi.sede_del
, pegi.anno_del
, pegi.numero_del
, pegi.sede_posto
, pegi.anno_posto
, pegi.numero_posto
, pegi.posto
, pegi.sostituto
, pegi.confermato
, to_date(null) rilascio
, to_char(null) presso
, pegi.note
FROM qualifiche_giuridiche qugi
   , contratti_storici cost
   , attivita atti
   , figure_giuridiche figi
   , astensioni aste
   , eventi_rapporto evra
   , eventi_giuridici evgi
   , posizioni posi
   , rapporti_individuali rain
   , periodi_giuridici pegi 
WHERE ( evgi.codice (+) = pegi.evento)
  AND ( evra.codice (+) = pegi.evento)
  AND ( posi.codice (+) = pegi.posizione)
  AND ( aste.codice (+) = pegi.assenza)
  AND ( atti.codice (+) = pegi.attivita)
  AND ( figi.numero (+) = pegi.figura)
  AND ( least( nvl(pegi.al,to_date('3333333','j')) 
             , greatest(pegi.dal,sysdate)
             )
       between nvl(figi.dal,to_date('2222222','j'))
           and nvl(figi.al,to_date('3333333','j'))
      )
  AND ( cost.contratto (+) = qugi.contratto )
  AND ( least( nvl(pegi.al,to_date('3333333','j'))
             , greatest(pegi.dal,sysdate)
             )
       between nvl(cost.dal,to_date('2222222','j'))
           AND nvl(cost.al,to_date('3333333','j'))
      )
  AND ( qugi.numero (+) = pegi.qualifica )
  AND ( least( nvl(pegi.al,to_date('3333333','j'))
             , greatest(pegi.dal,sysdate)
             )
       between nvl(qugi.dal,to_date('2222222','j'))
           AND nvl(qugi.al,to_date('3333333','j'))
      )
  AND ( rain.ci = pegi.ci )
UNION
SELECT
  rain.ci ci
, rain.ni
, rain.cognome
, rain.nome
, 'D' rilevanza
, evgi.posizione
, posi.descrizione des_posizione
, dogi.del
, dogi.dal
, dogi.al
, dogi.evento
, evgi.descrizione des_evento
, dogi.descrizione des_rapporto
, dogi.scd         tipo           
, sodo.descrizione des_tipo   
, to_number(null) figura
, to_char(null)   des_figura
, to_char(null)   tipo_rapporto
, to_number(null) ore
, to_char(null)   attivita
, to_char(null)   des_attivita
, to_number(null) qualifica
, to_char(null)   des_qualifica
, to_char(null)   livello
, to_char(null)   gestione
, to_number(null) settore
, to_number(null) sede
, to_char(null)   gruppo
, dogi.sede_del 
, dogi.anno_del
, dogi.numero_del
, to_char(null)   sede_posto
, to_number(null) anno_posto
, to_number(null) numero_posto
, to_number(null) posto
, to_number(null) sostituto
, to_number(null) confermato
, dogi.rilascio
, dogi.presso||' '||comu.denominazione||
  decode(prov.sigla,null,null,' ('||prov.sigla||')') presso
, dogi.note
FROM a_provincie         prov
   , a_comuni            comu
   , sottocodici_documento sodo
   , posizioni             posi
   , eventi_giuridici      evgi
   , rapporti_individuali  rain
   , documenti_giuridici   dogi 
WHERE prov.provincia (+)       = dogi.provincia
  AND comu.provincia_stato (+) = dogi.provincia
  AND comu.comune (+)          = dogi.comune 
  AND sodo.evento (+) = dogi.evento
  AND sodo.codice (+) = dogi.scd
  AND posi.codice (+) = evgi.posizione
  AND evgi.codice (+) = dogi.evento
  AND rain.ci         = dogi.ci
;
