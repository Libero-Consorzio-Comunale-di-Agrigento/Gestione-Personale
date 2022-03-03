CREATE OR REPLACE TRIGGER SUST_REUO_TMA
AFTER Update Of sequenza
ON SUDDIVISIONI_STRUTTURA 
DECLARE
  /******************************************************************************
     NAME:
     PURPOSE:   Mantiene l'allineamento tra SUDDIVISIONI_STRUTTURA e RELAZIONI_UO
     REVISIONS:
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     1.0        24/10/2006  MM
     NOTES:
  ******************************************************************************/
BEGIN
  /* Elimina precedenti registrazioni */
  FOR rest IN (SELECT rest.revisione
                     ,MAX(unor.dal) dal
                     ,MAX(rest.data) data
                 FROM revisioni_struttura rest
                     ,unita_organizzative unor
                WHERE stato IN ('A', 'M')
                  AND unor.revisione = rest.revisione
                GROUP BY rest.revisione)
  LOOP
    DELETE FROM relazioni_uo
     WHERE revisione = rest.revisione;
    FOR sett IN (SELECT stam.ni
                       ,unor.codice_uo codice
                       ,unor.suddivisione
                       ,unor.revisione
                       ,stam.gestione
                       ,stam.sequenza sequenza_padre
                       ,unor.descrizione descrizione_padre
                       ,gp4_sust.get_livello(unor.suddivisione) livello_padre
                   FROM unita_organizzative    unor
                       ,settori_amministrativi stam
                  WHERE unor.revisione = rest.revisione
                    AND unor.ottica = 'GP4'
                    AND nvl(rest.dal, rest.data) BETWEEN unor.dal AND nvl(unor.al, to_date(3333333, 'j'))
                    AND stam.ni = unor.ni)
    LOOP
      FOR cur_unor IN (SELECT sett.revisione
                             ,sett.gestione
                             ,sett.ni padre
                             ,sett.codice codice_padre
                             ,sett.suddivisione suddivisione_padre
                             ,unor.ni figlio
                             ,unor.codice_uo codice_figlio
                             ,unor.suddivisione suddivisione_figlio
                             ,gp4_stam.get_sequenza(unor.ni) sequenza_figlio
                             ,unor.descrizione descrizione_figlio
                             ,gp4_sust.get_livello(unor.suddivisione) livello_figlio
                         FROM unita_organizzative unor
                        WHERE unor.ottica = 'GP4'
                          AND unor.revisione = sett.revisione
                          AND nvl(rest.dal, rest.data) BETWEEN unor.dal AND
                              nvl(unor.al, to_date(3333333, 'j'))
                        START WITH unor.ni = sett.ni
                               AND unor.ottica = 'GP4'
                               AND unor.revisione = sett.revisione
                       CONNECT BY PRIOR unor.ni = unor.unita_padre
                              AND unor.ottica = 'GP4'
                              AND unor.revisione = sett.revisione)
      LOOP
        INSERT INTO relazioni_uo
          (revisione
          ,gestione
          ,padre
          ,codice_padre
          ,suddivisione_padre
          ,figlio
          ,codice_figlio
          ,suddivisione_figlio
          ,sequenza_figlio
          ,sequenza_padre
          ,descrizione_figlio
          ,descrizione_padre
          ,livello_figlio
          ,livello_padre)
          SELECT cur_unor.revisione
                ,cur_unor.gestione
                ,cur_unor.padre
                ,cur_unor.codice_padre
                ,cur_unor.suddivisione_padre
                ,cur_unor.figlio
                ,cur_unor.codice_figlio
                ,cur_unor.suddivisione_figlio
                ,cur_unor.sequenza_figlio
                ,sett.sequenza_padre
                ,cur_unor.descrizione_figlio
                ,sett.descrizione_padre
                ,cur_unor.livello_figlio
                ,sett.livello_padre
            FROM dual
           WHERE NOT EXISTS (SELECT 'x'
                    FROM relazioni_uo
                   WHERE revisione = cur_unor.revisione
                     AND gestione = cur_unor.gestione
                     AND padre = cur_unor.padre
                     AND codice_padre = cur_unor.codice_padre
                     AND suddivisione_padre = cur_unor.suddivisione_padre
                     AND figlio = cur_unor.figlio
                     AND codice_figlio = cur_unor.codice_figlio
                     AND suddivisione_figlio = cur_unor.suddivisione_figlio);
      END LOOP;
    END LOOP;
  END LOOP;
END;
/
