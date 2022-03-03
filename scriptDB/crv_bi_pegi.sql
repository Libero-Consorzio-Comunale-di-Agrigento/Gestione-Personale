CREATE OR REPLACE VIEW VISTA_PERIODI_GIURIDICI AS
SELECT pegi.ci
      ,pegi.rilevanza
      ,pegi.dal
      ,pegi.al
      ,pegi.evento codice_evento
      ,evgi.descrizione descrizione_evento
      ,evgi.certificabile evento_certificabile
      ,pegi.sede_del sede_del_evento
      ,pegi.anno_del anno_del_evento
      ,pegi.numero_del numero_del_evento
      ,pegi.note
      ,pegi.posizione codice_posizione
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
      ,pegi.tipo_rapporto
      ,gp4_tira.get_descrizione (pegi.tipo_rapporto) descrizione_tipo_rapporto
      ,pegi.qualifica numero_qualifica
      ,qugi.codice codice_qualifica
      ,qugi.descrizione descrizione_qualifica
      ,qugi.livello livello_retributivo
      ,qugi.ruolo ruolo_qualifica
      ,gp4_ruol.get_descrizione (qugi.ruolo) descrizione_ruolo
      ,qugi.contratto contratto_lavoro
      ,gp4_cont.get_descrizione (qugi.contratto) descrizione_contratto
      ,pegi.ore
      ,pegi.figura numero_figura
      ,figi.codice codice_figura
      ,figi.descrizione descrizione_figura
      ,figi.profilo profilo_prof
      ,gp4_prpr.get_descrizione (figi.profilo) descrizione_profilo_prof
      ,figi.posizione posizione_funz
      ,gp4_pofu.get_descrizione (figi.profilo, figi.posizione) descrizione_posizione_funz
      ,pegi.attivita
      ,gp4_atti.get_descrizione (pegi.attivita) descrizione_attivita
      ,pegi.settore numero_settore
      ,pegi.gestione
      ,gp4_geam.get_denominazione (pegi.gestione) denominazione_gestione
      ,stam.ni ni_unita_organizzative
      ,unor.codice_uo codice_unita_organizzative
      ,unor.descrizione     descr_unita_organizzative
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
      ,pegi.sede numero_sede_contabile
      ,gp4_sdam.get_codice_numero (pegi.sede) codice_sede_contabile
      ,gp4_sdam.get_denominazione_numero (pegi.sede) descrizione_sede_contabile
      ,rifu.cdc
      ,gp4_ceco.get_descrizione(rifu.cdc) descrizione_cdc
      ,rifu.funzionale
      ,gp4_clfu.get_descrizione(rifu.funzionale) descrizione_funzionale
      ,posi.di_ruolo
      ,figu.fattore     fatt_produttivo_figura
      ,figu.fattore_td  fatt_produttivo_figura_td
      ,qual.fattore     fatt_produttivo_qualifica
      ,qual.fattore_td  fatt_produttivo_qualifica_td
      ,pegi.utente
      ,pegi.data_agg
  FROM posizioni               posi
      ,eventi_giuridici        evgi
      ,qualifiche_giuridiche   qugi
      ,figure_giuridiche       figi
      ,settori_amministrativi  stam
      ,unita_organizzative     unor
      ,revisioni_struttura     rest
      ,suddivisioni_struttura  sust
      ,ripartizioni_funzionali rifu
      ,figure                  figu
      ,qualifiche              qual
      ,periodi_giuridici pegi
    WHERE pegi.rilevanza IN ('Q', 'I', 'S', 'E')
      AND stam.numero = pegi.settore
      AND posi.codice = pegi.posizione
      and evgi.codice=pegi.evento
      AND rifu.settore = pegi.settore
      AND NVL (pegi.sede, 0) = rifu.sede
      AND unor.ni = stam.ni
      AND unor.ottica = 'GP4'
      AND unor.revisione = rest.revisione
      AND rest.revisione = gp4gm.get_revisione (NVL (pegi.al, TO_DATE (3333333, 'j')))
      AND NVL (pegi.al, TO_DATE (3333333, 'j')) BETWEEN unor.dal
                                                    AND NVL (unor.al, TO_DATE (3333333, 'j'))
      AND sust.livello = unor.suddivisione
      AND sust.ottica = unor.ottica
      AND pegi.qualifica = qugi.numero(+)
      and qual.numero (+)   = qugi.numero
      AND NVL (pegi.al, TO_DATE (3333333, 'j')) BETWEEN qugi.dal(+)
                                                    AND NVL (qugi.al(+), TO_DATE (3333333, 'j'))
      AND pegi.figura = figi.numero
      and figu.numero=pegi.figura
      AND NVL (pegi.al, TO_DATE (3333333, 'j')) BETWEEN figi.dal
                                                    AND NVL (figi.al, TO_DATE (3333333, 'j'))
/

