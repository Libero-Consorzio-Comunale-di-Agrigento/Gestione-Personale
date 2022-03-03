CREATE OR REPLACE FORCE VIEW dotazione_nominativa_diritto (utente
                                                          ,revisione
                                                          ,provenienza
                                                          ,ci
                                                          ,nominativo
                                                          ,dal
                                                          ,al
                                                          ,evento
                                                          ,posizione_ind
                                                          ,ore_ind
                                                          ,assenza
                                                          ,di_ruolo
                                                          ,part_time
                                                          ,incarico
                                                          ,gestione
                                                          ,area
                                                          ,settore
                                                          ,ruolo
                                                          ,profilo
                                                          ,posizione
                                                          ,attivita
                                                          ,figura
                                                          ,qualifica
                                                          ,livello
                                                          ,tipo_rapporto
                                                          ,ore
                                                          ,door_id
                                                          ,settore_1
                                                          ,settore_2
                                                          ,settore_3
                                                          ,settore_4
                                                          ) AS
   SELECT rido.utente
         ,pedo.revisione
         ,'D'
         ,pedo.ci
         , rain.cognome || ' ' || rain.nome nominativo
         ,pedo.dal
         ,pedo.al
         ,pedo.evento
         ,pedo.posizione
         ,pedo.ore
         ,NVL (gp4do.get_assenza (pedo.ci, rido.DATA), '%')
         ,pedo.di_ruolo
         ,pedo.part_time
         ,NVL (gp4do.get_incarico (pedo.ci, rido.DATA), '%')
         ,pedo.gestione
         ,pedo.area area
         ,pedo.codice_uo
         ,pedo.ruolo
         ,pedo.profilo
         ,pedo.pos_funz
         ,pedo.attivita
         ,pedo.cod_figura
         ,pedo.cod_qualifica
         ,pedo.livello
         ,pedo.tipo_rapporto
         ,pedo.ore
         ,pedo.door_id
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.codice_uo, 1) settore_1
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.codice_uo, 2) settore_2
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.codice_uo, 3) settore_3
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.codice_uo, 4) settore_4
     FROM riferimento_dotazione rido
         ,rapporti_individuali rain
         ,periodi_dotazione pedo
    WHERE pedo.rilevanza = 'Q'
      AND rain.ci = pedo.ci
      AND rido.DATA BETWEEN pedo.dal AND NVL (pedo.al, TO_DATE (3333333, 'j') )
      AND pedo.door_id <> 0
   UNION
   SELECT rido.utente
         ,pedo.revisione
         ,'G'
         ,pedo.ci
         , rain.cognome || ' ' || rain.nome nominativo
         ,pedo.dal
         ,pedo.al
         ,pedo.evento
         ,pedo.posizione
         ,pedo.ore
         ,NVL (gp4do.get_assenza (pedo.ci, rido.DATA), '%')
         ,pedo.di_ruolo
         ,pedo.part_time
         ,NVL (gp4do.get_incarico (pedo.ci, rido.DATA), '%')
         ,pedo.gestione
         ,pedo.area
         ,pedo.codice_uo
         ,pedo.ruolo
         ,pedo.profilo
         ,pedo.pos_funz
         ,pedo.attivita
         ,pedo.cod_figura
         ,pedo.cod_qualifica
         ,pedo.livello
         ,pedo.tipo_rapporto
         ,pedo.ore
         ,pedo.door_id
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.settore, 1) settore_1
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.settore, 2) settore_2
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.settore, 3) settore_3
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.settore, 4) settore_4
     FROM riferimento_dotazione rido
         ,rapporti_individuali rain
         ,periodi_dotazione pedo
    WHERE pedo.rilevanza = 'Q'
      AND rain.ci = pedo.ci
      AND rido.DATA BETWEEN pedo.dal AND NVL (pedo.al, TO_DATE (3333333, 'j') )
      AND pedo.door_id = 0
/