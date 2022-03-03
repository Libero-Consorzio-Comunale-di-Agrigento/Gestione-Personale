CREATE OR REPLACE FORCE VIEW vista_sostituzioni_giuridiche (livello
                                                           ,sogi_id
                                                           ,titolare
                                                           ,nominativo_titolare
                                                           ,dal_astensione
                                                           ,al_astensione
                                                           ,rilevanza_astensione
                                                           ,ore_sostituibili
                                                           ,sostituto
                                                           ,nominativo_sostituto
                                                           ,dal
                                                           ,al
                                                           ,rilevanza_sostituzione
                                                           ,ore_sostituzione
                                                           ,note
                                                           ,ore_sostituto
                                                           ,tipo
                                                           ,ordina
							   ,utente
							   ,data_agg
                                                           ) AS
-- assenze per nulla sostituite
   SELECT 999
         ,0
         ,pegi.ci titolare
         , rain.cognome || ' ' || rain.nome nominativo_titolare
         ,pegi.dal
         ,pegi.al
         ,'A'
         ,NVL (gp4_pegi.get_ore (pegi.ci, 'Q', pegi.dal)
              ,gp4_cost.get_ore_lavoro (gp4_pegi.get_qualifica (pegi.ci, 'S', pegi.dal), pegi.dal)
              ) ore_sostituibili
         ,TO_NUMBER (NULL)
         ,TO_CHAR (NULL)
         ,TO_DATE (NULL)
         ,TO_DATE (NULL)
         ,TO_CHAR (NULL)
         ,TO_NUMBER (NULL)
         ,TO_CHAR (NULL)
         ,TO_NUMBER (NULL)
         ,'NS'
         ,'ZZZZZ'
         ,pegi.utente
         ,pegi.data_agg
     FROM periodi_giuridici pegi
         ,rapporti_individuali rain
    WHERE pegi.rilevanza = 'A'
      AND gp4_aste.get_sostituibile (pegi.assenza) = 1
      AND NOT EXISTS (
               SELECT 'x'
                 FROM sostituzioni_giuridiche
                WHERE titolare = pegi.ci
                  AND dal_astensione = pegi.dal
                  AND rilevanza_astensione = 'A')
      AND rain.ci = pegi.ci
   UNION
-- incarichi per nulla sostituiti
   SELECT 999
         ,0
         ,pegi.ci titolare
         , rain.cognome || ' ' || rain.nome nominativo_titolare
         ,pegi.dal
         ,pegi.al
         ,'I'
         ,NVL (gp4_pegi.get_ore (pegi.ci, 'Q', pegi.dal)
              ,gp4_cost.get_ore_lavoro (gp4_pegi.get_qualifica (pegi.ci, 'S', pegi.dal), pegi.dal)
              ) ore_sostituibili
         ,TO_NUMBER (NULL)
         ,TO_CHAR (NULL)
         ,TO_DATE (NULL)
         ,TO_DATE (NULL)
         ,TO_CHAR (NULL)
         ,TO_NUMBER (NULL)
         ,TO_CHAR (NULL)
         ,TO_NUMBER (NULL)
         ,'NS'
         ,'ZZZZZ'
         ,pegi.utente
         ,pegi.data_agg
     FROM periodi_giuridici pegi
         ,rapporti_individuali rain
    WHERE pegi.rilevanza = 'I'
      AND NOT EXISTS (
               SELECT 'x'
                 FROM sostituzioni_giuridiche
                WHERE titolare = pegi.ci
                  AND dal_astensione = pegi.dal
                  AND rilevanza_astensione = 'I')
      AND rain.ci = pegi.ci
   UNION
-- assenze/incarichi in qualche modo sostituite
   SELECT 0
         ,sogi.sogi_id
         ,sogi.titolare
         ,SUBSTR (gp4_rain.get_nominativo (sogi.titolare), 1, 120) nominativo_titolare
         ,sogi.dal_astensione
         ,gp4_pegi.get_al (sogi.titolare, sogi.rilevanza_astensione, sogi.dal_astensione)
                                                                                      al_astensione
         ,sogi.rilevanza_astensione
         ,sogi.ore_sostituibili
         ,sogi.sostituto
         ,    SUBSTR (gp4_rain.get_nominativo (sogi.sostituto), 1, 120)
           || gp4_sogi.get_ulteriore_sostituto (sogi.sostituto, sogi.dal, sogi.al)
                                                                               nominativo_sostituto
         ,sogi.dal
         ,sogi.al
         ,sogi.rilevanza_sostituzione
         ,sogi.ore_sostituzione
         ,sogi.note
         ,NVL (gp4_pegi.get_ore (sogi.sostituto, 'Q', NVL (sogi.al, TO_DATE (3333333, 'j') ) )
              ,gp4_cost.get_ore_lavoro (gp4_pegi.get_qualifica (sogi.sostituto
                                                               ,'S'
                                                               ,NVL (sogi.al
                                                                    ,TO_DATE (3333333, 'j') )
                                                               )
                                       ,NVL (sogi.al, TO_DATE (3333333, 'j') )
                                       )
              )
         ,gp4gm.astensione_sostituita (sogi.titolare, sogi.rilevanza_astensione
                                      ,sogi.dal_astensione) tipo
         ,gp4gm.ordertree (0
                          ,    gp4_rain.get_cognome (sogi.titolare)
                            || TO_CHAR (sogi.dal_astensione, 'yyyymmdd')
                            || TO_CHAR (sogi.dal, 'yyyymmdd')
                          )
         ,sogi.utente
         ,sogi.data_agg
     FROM sostituzioni_giuridiche sogi
    WHERE sogi.rilevanza_astensione IN ('A', 'I')
/