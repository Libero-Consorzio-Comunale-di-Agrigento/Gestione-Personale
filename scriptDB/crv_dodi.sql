CREATE OR REPLACE FORCE VIEW dotazione_diritto (utente
                                               ,DATA
                                               ,revisione
                                               ,provenienza
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
                                               ,numero
                                               ,numero_ore
                                               ,effettivi
                                               ,di_ruolo
                                               ,assenti
                                               ,incaricati
                                               ,non_ruolo
                                               ,contrattisti
                                               ,sovrannumero
                                               ,diff_numero
                                               ,diff_ore
                                               ,settore_1
                                               ,settore_2
                                               ,settore_3
                                               ,settore_4
                                               ) AS
   SELECT rido.utente
         ,rido.DATA
         ,door.revisione
         ,'D'
         ,door.gestione
         ,door.area
         ,door.settore
         ,door.ruolo
         ,door.profilo
         ,door.posizione
         ,door.attivita
         ,door.figura
         ,door.qualifica
         ,door.livello
         ,door.tipo_rapporto
         ,door.ore
         ,door.numero
         ,door.numero_ore
         ,gp4do.conta_dotazione (door.revisione, 'Q', rido.DATA, door.gestione, door.door_id)
                                                                                          effettivi
         ,gp4do.conta_dot_ruolo (door.revisione, 'Q', rido.DATA, door.gestione, door.door_id) ruolo
         ,gp4do.conta_dot_assenti (door.revisione, 'Q', rido.DATA, door.gestione, door.door_id)
                                                                                              ruolo
         ,gp4do.conta_dot_incaricati (door.revisione, 'Q', rido.DATA, door.gestione, door.door_id)
                                                                                              ruolo
         ,gp4do.conta_dot_non_ruolo (door.revisione, 'Q', rido.DATA, door.gestione, door.door_id)
                                                                                              ruolo
         ,gp4do.conta_dot_contrattisti (door.revisione, 'Q', rido.DATA, door.gestione, door.door_id)
                                                                                       contrattisti
         ,gp4do.conta_dot_sovrannumero (door.revisione, 'Q', rido.DATA, door.gestione, door.door_id)
                                                                                       sovrannumero
         ,   gp4do.conta_dotazione (door.revisione, 'Q', rido.DATA, door.gestione, door.door_id)
           - numero diff_numero
         ,ROUND (  gp4do.conta_dot_ore (revisione
                                       ,'Q'
                                       ,rido.DATA
                                       ,gestione
                                       ,door_id
                                       ,gp4do.get_ore_lavoro_ue (rido.DATA
                                                                ,ruolo
                                                                ,profilo
                                                                ,posizione
                                                                ,figura
                                                                ,qualifica
                                                                ,livello
                                                                )
                                       )
                 - numero_ore
                ,2
                ) diff_ore
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), door.settore, 1) settore_1
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), door.settore, 2) settore_2
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), door.settore, 3) settore_3
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), door.settore, 4) settore_4
     FROM dotazione_organica door
         ,riferimento_dotazione rido
   UNION
   SELECT   rido.utente
           ,rido.DATA
           ,pedo.revisione
           ,'G'
           ,pedo.gestione
           ,TO_CHAR (NULL) area
           ,pedo.codice_uo
           ,TO_CHAR (NULL)
           ,pedo.profilo
           ,pedo.pos_funz
           ,pedo.attivita
           ,pedo.cod_figura
           ,TO_CHAR (NULL)
           ,TO_CHAR (NULL)
           ,pedo.tipo_rapporto
           ,pedo.ore
           ,0
           ,0
           ,COUNT (ci)
           ,SUM (DECODE (gp4_posi.get_ruolo (pedo.posizione), 'SI', 1, 0) ) di_ruolo
           ,SUM (gp4gm.get_se_assente (pedo.ci, rido.DATA) ) assenti
           ,SUM (gp4gm.get_se_incaricato (pedo.ci, rido.DATA) ) incaricati
           ,SUM (DECODE (gp4_posi.get_ruolo (pedo.posizione), 'NO', 1, 0) ) non_ruolo
           ,SUM (DECODE (gp4_posi.get_contratto_opera (pedo.posizione), 'SI', 1, 0) ) contrattisti
           ,SUM (DECODE (gp4_posi.get_sovrannumero (pedo.posizione), 'SI', 1, 0) ) sovrannumero
           ,COUNT (ci)
           ,SUM (pedo.ore)
           ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.codice_uo, 1)
                                                                                          settore_1
           ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.codice_uo, 2)
                                                                                          settore_2
           ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.codice_uo, 3)
                                                                                          settore_3
           ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.codice_uo, 4)
                                                                                          settore_4
       FROM periodi_dotazione pedo
           ,riferimento_dotazione rido
      WHERE pedo.rilevanza = 'Q'
        AND rido.DATA BETWEEN pedo.dal AND NVL (pedo.al, TO_DATE (3333333, 'j') )
        AND pedo.door_id = 0
   GROUP BY rido.utente
           ,rido.DATA
           ,pedo.revisione
           ,pedo.gestione
           ,pedo.codice_uo
           ,pedo.profilo
           ,pedo.pos_funz
           ,pedo.attivita
           ,pedo.cod_figura
           ,pedo.tipo_rapporto
           ,pedo.ore
/