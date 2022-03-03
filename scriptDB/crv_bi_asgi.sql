CREATE OR REPLACE VIEW VISTA_ASTENSIONI_GIURIDICHE
(sogi_id, titolare, dal_astensione, al_astensione, evento_astensione, descrizione_evento_astensione, assenza, descrizione_assenza, percentuale_retribuzione, percentuale_astensione, rilevanza_astensione, ore_sostituibili, note_astensione, sede_del_astensione, anno_del_astensione, numero_del_astensione, sostituto, nominativo_sostituto, dal_sostituzione, al_sostituzione, ore_sostituzione, note_sostituzione, ore_sostituto, tipo_sostituzione, matura_anzianita, matura_ferie, matura_gg_inps, matura_assegni_familiari, matura_detrazioni, interruzione_servizio, categoria_fiscale, servizio_inpdap, certificabile, utente_modifica_pegi, data_modifica_pegi)
AS
SELECT TO_NUMBER (NULL) sogi_id
      ,pegi.ci titolare
      ,pegi.dal dal_astensione
      ,pegi.al al_astensione
      ,pegi.evento evento_astensione
      ,gp4_evgi.get_descrizione (pegi.evento) descrizione_evento_astensione
      ,pegi.assenza assenza
      ,aste.descrizione descrizione_assenza
      ,aste.per_ret percentuale_retribuzione
      ,pegi.ore percentuale_astensione
      ,pegi.rilevanza rilevanza_astensione
      ,NVL (gp4_pegi.get_ore (pegi.ci, 'Q', pegi.dal)
           ,gp4_cost.get_ore_lavoro (gp4_pegi.get_qualifica (pegi.ci, 'S', pegi.dal), pegi.dal)
           ) ore_sostituibili
      ,pegi.note note_astensione
      ,pegi.sede_del sede_del_astensione
      ,pegi.anno_del anno_del_astensione
      ,pegi.numero_del numero_del_astensione
      ,TO_NUMBER (NULL) sostituto
      ,TO_CHAR (NULL) nominativo_sostituto
      ,TO_DATE (NULL) dal_sostituzione
      ,TO_DATE (NULL) al_sostituzione
      ,TO_NUMBER (NULL) ore_sostituzione
      ,TO_CHAR (NULL) note_sostituzione
      ,TO_NUMBER (NULL) ore_sostituto
      ,'NS' tipo_sostituzione
      ,aste.mat_anz
      ,aste.mat_fer
      ,aste.mat_inps
      ,aste.mat_assfam
      ,aste.detrazioni
      ,aste.servizio
      ,aste.cat_fiscale
      ,aste.servizio_inpdap
      ,evgi.certificabile
      ,pegi.utente
      ,pegi.data_agg
  FROM periodi_giuridici pegi
      ,eventi_giuridici evgi
      ,astensioni aste
 WHERE pegi.rilevanza = 'A'
   AND aste.codice = pegi.assenza
   AND evgi.codice = aste.evento
   AND NOT EXISTS (SELECT 'x'
                     FROM sostituzioni_giuridiche
                    WHERE titolare = pegi.ci
                      AND dal_astensione = pegi.dal
                      AND rilevanza_astensione = 'A')
UNION ALL
SELECT sogi.sogi_id
      ,sogi.titolare
      ,sogi.dal_astensione
      ,pegi.al
      ,pegi.evento evento_astensione
      ,gp4_evgi.get_descrizione (pegi.evento) descrizione_evento_astensione
      ,pegi.assenza assenza
      ,aste.descrizione descrizione_assenza
      ,aste.per_ret percentuale_retribuzione
      ,pegi.ore percentuale_astensione
      ,pegi.rilevanza rilevanza_astensione
      ,NVL (gp4_pegi.get_ore (pegi.ci, 'Q', pegi.dal)
           ,gp4_cost.get_ore_lavoro (gp4_pegi.get_qualifica (pegi.ci, 'S', pegi.dal), pegi.dal)
           ) ore_sostituibili
      ,pegi.note note_astensione
      ,pegi.sede_del sede_del_astensione
      ,pegi.anno_del anno_del_astensione
      ,pegi.numero_del numero_del_astensione
      ,sogi.sostituto
      ,SUBSTR (gp4_rain.get_nominativo (sogi.sostituto), 1, 120) nominativo_sostituto
      ,sogi.dal
      ,sogi.al
      ,sogi.ore_sostituzione
      ,sogi.note
      ,NVL (gp4_pegi.get_ore (sogi.sostituto, 'Q', NVL (sogi.al, TO_DATE (3333333, 'j')))
           ,gp4_cost.get_ore_lavoro (gp4_pegi.get_qualifica (sogi.sostituto
                                                            ,'S'
                                                            ,NVL (sogi.al, TO_DATE (3333333, 'j'))
                                                            )
                                    ,NVL (sogi.al, TO_DATE (3333333, 'j'))
                                    ))
      ,gp4gm.astensione_sostituita (sogi.titolare, sogi.rilevanza_astensione, sogi.dal_astensione) tipo
      ,aste.mat_anz
      ,aste.mat_fer
      ,aste.mat_inps
      ,aste.mat_assfam
      ,aste.detrazioni
      ,aste.servizio
      ,aste.cat_fiscale
      ,aste.servizio_inpdap
      ,evgi.certificabile
      ,pegi.utente
      ,pegi.data_agg
  FROM sostituzioni_giuridiche sogi
      ,astensioni aste
      ,eventi_giuridici evgi
      ,periodi_giuridici pegi
 WHERE sogi.rilevanza_astensione = pegi.rilevanza
   AND sogi.titolare = pegi.ci
   AND sogi.dal_astensione = pegi.dal
   AND pegi.rilevanza = 'A'
   AND aste.codice = pegi.assenza
   AND evgi.codice = aste.evento
/
