CREATE OR REPLACE VIEW VISTA_PERIODI_DOTAZIONE AS
SELECT pedo.ci
      ,gp4_anag.get_sesso(gp4_rain.get_ni(pedo.ci)) sesso
      ,pedo.rilevanza
      ,pedo.dal
      ,pedo.al
      ,pedo.evento codice_evento
      ,pedo.revisione revisione_dotazione
      ,pedo.door_id door_id
      ,evgi.descrizione descrizione_evento
      ,evgi.certificabile evento_certificabile
      ,pedo.posizione codice_posizione
      ,posi.descrizione descrizione_posizione
      ,posi.ruolo ruolo
      ,posi.stagionale
      ,posi.part_time
      ,posi.tipo_part_time
      ,posi.tempo_determinato
      ,posi.tipo_determinato tipo_tempo_determinato
      ,posi.contratto_formazione
      ,posi.tipo_formazione
      ,posi.universitario
      ,posi.collaboratore
      ,posi.lsu
      ,posi.contratto_opera
      ,posi.sovrannumero
      ,posi.amm_cons amministratore_consigliere
      ,posi.posizione posizione_assimilabile
      ,pedo.tipo_rapporto
      ,gp4_tira.get_descrizione (pedo.tipo_rapporto) descrizione_tipo_rapporto
      ,pedo.qualifica numero_qualifica
      ,pedo.cod_qualifica codice_qualifica
      ,qugi.descrizione descrizione_qualifica
      ,pedo.livello livello_retributivo
      ,pedo.ruolo ruolo_qualifica
      ,gp4_ruol.get_descrizione (pedo.ruolo) descrizione_ruolo
      ,pedo.contratto contratto_lavoro
      ,gp4_cont.get_descrizione (pedo.contratto) descrizione_contratto
      ,pedo.ore
      ,pedo.figura numero_figura
      ,pedo.cod_figura codice_figura
      ,figi.descrizione descrizione_figura
      ,pedo.profilo profilo_prof
      ,gp4_prpr.get_descrizione (pedo.profilo) descrizione_profilo_prof
      ,pedo.pos_funz posizione_funz
      ,gp4_pofu.get_descrizione (pedo.profilo, pedo.pos_funz) descrizione_posizione_funz
      ,pedo.attivita
      ,gp4_atti.get_descrizione (pedo.attivita) descrizione_attivita
      ,pedo.settore numero_settore
      ,pedo.gestione
      ,gp4_geam.get_denominazione (pedo.gestione) denominazione_gestione
      ,pedo.unita_ni ni_unita_organizzative
      ,pedo.codice_uo codice_unita_organizzative
      ,unor.descrizione descr_unita_organizzative
      ,unor.suddivisione sudd_unita_organizzative
      ,sust.denominazione denom_sudd_unita_organizzative
      ,gp4_sust.get_livello (unor.suddivisione) liv_sudd_unita_organizzative
      ,rest.revisione revisione_struttura
      ,rest.descrizione descr_revisione_struttura
      ,gp4_anag.get_denominazione (unor.sede) disloc_unita_organizzative
      ,rest.sede_del sede_del_revisione_struttura
      ,rest.anno_del anno_del_revisione_struttura
      ,rest.numero_del numero_del_revisione_struttura
      ,rest.dal decorrenza_revisione_struttura
      ,rest.stato stato_revisione_struttura
      ,pedo.di_ruolo
      ,figu.fattore fatt_produttivo_figura
      ,figu.fattore_td fatt_produttivo_figura_td
      ,qual.fattore fatt_produttivo_qualifica
      ,qual.fattore_td fatt_produttivo_qualifica_td
      ,pedo.ue ue_effettive
      ,pedo.assenza codice_assenza
      ,pedo.incarico codice_incarico
  FROM posizioni posi
      ,eventi_giuridici evgi
      ,qualifiche_giuridiche qugi
      ,figure_giuridiche figi
      ,settori_amministrativi stam
      ,unita_organizzative unor
      ,revisioni_struttura rest
      ,suddivisioni_struttura sust
      ,figure figu
      ,qualifiche qual
      ,periodi_dotazione pedo
 WHERE stam.numero = pedo.settore
   AND posi.codice = pedo.posizione
   AND evgi.codice = pedo.evento
   AND unor.ni = stam.ni
   AND unor.ottica = 'GP4'
   AND unor.revisione = rest.revisione
   AND rest.revisione = gp4gm.get_revisione (NVL (pedo.al, TO_DATE (3333333, 'j')))
   AND NVL (pedo.al, TO_DATE (3333333, 'j')) BETWEEN unor.dal
                                                 AND NVL (unor.al, TO_DATE (3333333, 'j'))
   AND sust.livello = unor.suddivisione
   AND sust.ottica = unor.ottica
   AND pedo.qualifica = qugi.numero(+)
   AND qual.numero(+) = qugi.numero
   AND NVL (pedo.al, TO_DATE (3333333, 'j')) BETWEEN qugi.dal(+)
                                                 AND NVL (qugi.al(+), TO_DATE (3333333, 'j'))
   AND pedo.figura = figi.numero
   AND figu.numero = pedo.figura
   AND NVL (pedo.al, TO_DATE (3333333, 'j') ) BETWEEN figi.dal
                                                  AND NVL (figi.al, TO_DATE (3333333, 'j'))
/
