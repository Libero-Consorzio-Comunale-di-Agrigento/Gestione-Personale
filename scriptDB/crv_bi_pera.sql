CREATE OR REPLACE VIEW VISTA_PERIODI_RAPPORTO
(ci, rilevanza, dal, al, inizio_rapporto, descrizione_inizio_rapporto, sede_del_inizio_rapporto, anno_del_inizio_rapporto, numero_del_inizio_rapporto, note, termine_rapporto, descrizione_termine_rapporto, sede_del_termine_rapporto, anno_del_termine_rapporto, numero_del_termine_rapporto, utente_modifica_pegi, data_modifica_pegi)
AS
SELECT pegi.ci
      ,pegi.rilevanza
      ,pegi.dal
      ,pegi.al
      ,pegi.evento inizio_rapporto
      ,gp4_evra.get_descrizione (pegi.evento,'I') descrizione_inizio_rapporto
      ,pegi.sede_del sede_del_inizio_rapporto
      ,pegi.anno_del anno_del_inizio_rapporto
      ,pegi.numero_del numero_del_inizio_rapporto
      ,pegi.note
      ,pegi.posizione termine_rapporto
      ,gp4_evra.get_descrizione (pegi.posizione,'T') descrizione_termine_rapporto
      ,pegi.sede_posto sede_del_termine_rapporto
      ,pegi.anno_posto anno_del_termine_rapporto
      ,pegi.numero_posto numero_del_termine_rapporto
      ,pegi.utente
      ,pegi.data_agg
  FROM periodi_giuridici pegi
 WHERE pegi.rilevanza = 'P'
/