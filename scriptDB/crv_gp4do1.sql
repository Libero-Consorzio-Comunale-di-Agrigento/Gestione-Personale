REM            creazione delle viste specifiche della Dotazione Organica che sono
REM            INDISPENSABILI per la validazione degli oggetti di DB
/*==============================================================*/
/* View: ASTENSIONI_SOSTITUIBILI                                */
/*==============================================================*/
CREATE OR REPLACE FORCE VIEW astensioni_sostituibili (ci_assente
                                                     ,nominativo_assente
                                                     ,rilevanza
                                                     ,assenza
                                                     ,des_assenza
                                                     ,dal
                                                     ,al
                                                     ,ore_sostituibili
                                                     ,ci_sostituto
                                                     ,nominativo_sostituto
                                                     ,dal_sostituto
                                                     ,al_sostituto
                                                     ,ore_sostituzione
                                                     ,tipo_assenza
                                                     ) AS
   SELECT pegi.ci
         ,gp4_rain.get_nominativo (pegi.ci) nominativo_assente
         ,pegi.rilevanza
         ,pegi.assenza
         ,gp4_aste.get_descrizione (pegi.assenza) des_assenza
         ,pegi.dal
         ,pegi.al
         ,gp4do.get_ore_sostituibili (pegi.ci, pegi.dal) ore_sostituibili
         ,gp4do.get_ultimo_sostituto (pegi.ci, pegi.dal, NVL (pegi.al, TO_DATE (3333333, 'j') ) )
                                                                                          sostituto
         ,gp4_rain.get_nominativo (gp4do.get_ultimo_sostituto (pegi.ci
                                                              ,pegi.dal
                                                              ,NVL (pegi.al, TO_DATE (3333333, 'j') )
                                                              )
                                  ) nominativo_sostituto
         ,gp4do.get_dal_ultimo_sostituto (pegi.ci, pegi.dal, NVL (pegi.al, TO_DATE (3333333, 'j') ) )
                                                                                      dal_sostituto
         ,gp4do.get_al_ultimo_sostituto (pegi.ci, pegi.dal, NVL (pegi.al, TO_DATE (3333333, 'j') ) )
                                                                                       al_sostituto
         ,0 ore_sostituzione
         ,1 tipo_assenza                                                   -- assenze non sostituite
     FROM periodi_giuridici pegi
    WHERE rilevanza = 'A'
      AND EXISTS (SELECT 'x'
                    FROM astensioni
                   WHERE codice = pegi.assenza
                     AND sostituibile = 1)
      AND NOT EXISTS (
             SELECT '1'
               FROM sostituzioni_giuridiche
              WHERE titolare = pegi.ci
                AND dal_astensione = pegi.dal
                AND rilevanza_astensione = pegi.rilevanza)
   UNION
   SELECT pegi.ci
         ,gp4_rain.get_nominativo (pegi.ci) nominativo_assente
         ,pegi.rilevanza
         ,pegi.evento
         , 'Incarico : ' || gp4_evgi.get_descrizione (pegi.evento) des_assenza
         ,pegi.dal
         ,pegi.al
         ,gp4do.get_ore_sostituibili (pegi.ci, pegi.dal) ore_sostituibili
         ,gp4do.get_ultimo_sostituto (pegi.ci, pegi.dal, NVL (pegi.al, TO_DATE (3333333, 'j') ) )
                                                                                          sostituto
         ,gp4_rain.get_nominativo (gp4do.get_ultimo_sostituto (pegi.ci
                                                              ,pegi.dal
                                                              ,NVL (pegi.al, TO_DATE (3333333, 'j') )
                                                              )
                                  ) nominativo_sostituto
         ,gp4do.get_dal_ultimo_sostituto (pegi.ci, pegi.dal, NVL (pegi.al, TO_DATE (3333333, 'j') ) )
                                                                                      dal_sostituto
         ,gp4do.get_al_ultimo_sostituto (pegi.ci, pegi.dal, NVL (pegi.al, TO_DATE (3333333, 'j') ) )
                                                                                       al_sostituto
         ,0 ore_sostituzione
         ,4 tipo_assenza                                                  -- incarico non sostituito
     FROM periodi_giuridici pegi
    WHERE rilevanza = 'I'
      AND NOT EXISTS (
             SELECT '1'
               FROM sostituzioni_giuridiche
              WHERE titolare = pegi.ci
                AND dal_astensione = pegi.dal
                AND rilevanza_astensione = pegi.rilevanza)
   UNION
   SELECT pegi.ci
         ,gp4_rain.get_nominativo (pegi.ci) nominativo_assente
         ,pegi.rilevanza
         ,pegi.assenza
         ,gp4_aste.get_descrizione (pegi.assenza) des_assenza
         ,pegi.dal
         ,pegi.al
         ,gp4do.get_ore_sostituibili (pegi.ci, pegi.dal) ore_sostituibili
         ,sogi.sostituto
         ,    gp4_rain.get_nominativo (sogi.sostituto)
           || ' '
           || DECODE (gp4_posi.get_contratto_opera (gp4_pegi.get_posizione (sogi.sostituto
                                                                           ,'Q'
                                                                           ,sogi.dal
                                                                           )
                                                   )
                     ,'SI', '( Contrattista )'
                     ) nominativo_sostituto
         , sogi.dal - NVL (gp4_gest.get_gg_sost_ante_assenza (pegi.gestione), 0) dal_sostituto
         , sogi.al + NVL (gp4_gest.get_gg_sost_post_assenza (pegi.gestione), 0) al_sostituto
         ,sogi.ore_sostituzione
         ,DECODE (gp4do.get_ore_sostituibili (sogi.titolare, sogi.dal_astensione)
                 ,gp4do.get_ore_sostituite (sogi.titolare, sogi.dal_astensione, sogi.dal), DECODE
                            (gp4_posi.get_contratto_opera (gp4_pegi.get_posizione (sogi.sostituto
                                                                                  ,'Q'
                                                                                  ,sogi.dal
                                                                                  )
                                                          )
                            ,'SI', 7
                            ,3
                            )
                 ,DECODE (gp4_posi.get_contratto_opera (gp4_pegi.get_posizione (sogi.sostituto
                                                                               ,'Q'
                                                                               ,sogi.dal
                                                                               )
                                                       )
                         ,'SI', 8
                         ,2
                         )
                 )
                  -- assenze sostituite o parzialmente
          tipo_assenza
     FROM periodi_giuridici pegi
         ,sostituzioni_giuridiche sogi
    WHERE pegi.rilevanza = 'A'
      AND pegi.ci = sogi.titolare
      AND pegi.dal = sogi.dal_astensione
      AND pegi.rilevanza = sogi.rilevanza_astensione
      AND EXISTS (SELECT 'x'
                    FROM astensioni
                   WHERE codice = pegi.assenza
                     AND sostituibile = 1)
   UNION
   SELECT pegi.ci
         ,gp4_rain.get_nominativo (pegi.ci) nominativo_assente
         ,pegi.rilevanza
         ,pegi.evento
         , 'Incarico : ' || gp4_evgi.get_descrizione (pegi.evento) des_assenza
         ,pegi.dal
         ,pegi.al
         ,gp4do.get_ore_sostituibili (pegi.ci, pegi.dal) ore_sostituibili
         ,sogi.sostituto
         ,    gp4_rain.get_nominativo (sogi.sostituto)
           || ' '
           || DECODE (gp4_posi.get_contratto_opera (gp4_pegi.get_posizione (sogi.sostituto
                                                                           ,'Q'
                                                                           ,sogi.dal
                                                                           )
                                                   )
                     ,'SI', '( Contrattista )'
                     ) nominativo_sostituto
         , sogi.dal - NVL (gp4_gest.get_gg_sost_ante_assenza (pegi.gestione), 0) dal_sostituto
         , sogi.al + NVL (gp4_gest.get_gg_sost_post_assenza (pegi.gestione), 0) al_sostituto
         ,sogi.ore_sostituzione
         ,DECODE (gp4do.get_ore_sostituibili (sogi.titolare, sogi.dal_astensione)
                 ,gp4do.get_ore_sostituite (sogi.titolare, sogi.dal_astensione, sogi.dal), DECODE
                            (gp4_posi.get_contratto_opera (gp4_pegi.get_posizione (sogi.sostituto
                                                                                  ,'Q'
                                                                                  ,sogi.dal
                                                                                  )
                                                          )
                            ,'SI', 9
                            ,6
                            )
                 ,DECODE (gp4_posi.get_contratto_opera (gp4_pegi.get_posizione (sogi.sostituto
                                                                               ,'Q'
                                                                               ,sogi.dal
                                                                               )
                                                       )
                         ,'SI', 10
                         ,5
                         )
                 ) tipo_assenza                               -- incarichi sostituiti o parzialmente
     FROM periodi_giuridici pegi
         ,sostituzioni_giuridiche sogi
    WHERE pegi.rilevanza = 'I'
      AND pegi.ci = sogi.titolare
      AND pegi.dal = sogi.dal_astensione
      AND pegi.rilevanza = sogi.rilevanza_astensione
/
/*==============================================================*/
/* View: DOTAZIONE_NOMINATIVA_FATTO                             */
/*==============================================================*/

CREATE OR REPLACE FORCE VIEW dotazione_nominativa_fatto (utente
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
                                                        ,assunto_part_time
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
         ,gp4do.get_assenza (pedo.ci, rido.DATA)
         ,pedo.di_ruolo di_ruolo
         ,DECODE (part_time, 'SI', NVL (pedo.tipo_part_time, 'O'), TO_CHAR (NULL) )
         ,gp4_pegi.get_assunto_part_time (pedo.ci, rido.DATA)
         ,gp4do.get_incarico (pedo.ci, rido.DATA) incarico
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
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.codice_uo, 1) settore_1
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.codice_uo, 2) settore_2
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.codice_uo, 3) settore_3
         ,gp4_reuo.get_codice_padre (gp4gm.get_revisione (rido.DATA), pedo.codice_uo, 4) settore_4
     FROM riferimento_dotazione rido
         ,rapporti_individuali rain
         ,periodi_dotazione pedo
    WHERE pedo.rilevanza = 'S'
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
         ,gp4do.get_assenza (pedo.ci, rido.DATA)
         ,pedo.di_ruolo
         ,DECODE (part_time, 'SI', NVL (pedo.tipo_part_time, 'O'), TO_CHAR (NULL) )
         ,gp4_pegi.get_assunto_part_time (pedo.ci, rido.DATA)
         ,gp4do.get_incarico (pedo.ci, rido.DATA)
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
    WHERE pedo.rilevanza = 'S'
      AND rain.ci = pedo.ci
      AND rido.DATA BETWEEN pedo.dal AND NVL (pedo.al, TO_DATE (3333333, 'j') )
      AND pedo.door_id = 0
/

/*==============================================================*/
/* View: DOTAZIONE_NOMINATIVA_DIRITTO                           */
/*==============================================================*/

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
                                                          ,assunto_part_time
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
         ,gp4do.get_assenza (pedo.ci, rido.DATA)
         ,pedo.di_ruolo
         ,DECODE (part_time, 'SI', NVL (pedo.tipo_part_time, 'O'), TO_CHAR (NULL) )
         ,gp4_pegi.get_assunto_part_time (pedo.ci, rido.DATA)
         ,gp4do.get_incarico (pedo.ci, rido.DATA)
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
         ,gp4do.get_assenza (pedo.ci, rido.DATA)
         ,pedo.di_ruolo
         ,DECODE (part_time, 'SI', NVL (pedo.tipo_part_time, 'O'), TO_CHAR (NULL) )
         ,gp4_pegi.get_assunto_part_time (pedo.ci, rido.DATA)
         ,gp4do.get_incarico (pedo.ci, rido.DATA)
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

start crv_dodi.sql
start crv_dodu.sql
start crv_dofa.sql
start crv_dofu.sql