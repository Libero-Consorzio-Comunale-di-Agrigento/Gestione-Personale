CREATE OR REPLACE FORCE VIEW INDIVIDUI_RIASSEGNABILI
(CI, NOMINATIVO, RILEVANZA, DAL, AL, 
 SETTORE, FIGURA)
AS 
SELECT pegi.ci ci 
         , rain.cognome || ' ' || rain.nome nominativo 
         ,rilevanza rilevanza 
         ,pegi.dal dal 
         ,pegi.al al 
         ,    NVL (gp4_unor.get_codice_uo (stam.ni, 'GP4', pegi.al) 
                  ,gp4_unor.get_codice_uo (stam.ni, 'GP4', gp4_unor.get_dal (stam.ni) ) 
                  ) 
           || DECODE (gp4_sdam.get_codice_numero (pegi.sede) 
                     ,TO_CHAR (NULL), TO_CHAR (NULL) 
                     , '/' || gp4_sdam.get_codice_numero (pegi.sede) 
                     ) settore 
         ,figi.codice figura 
     FROM periodi_giuridici pegi 
         ,settori_amministrativi stam 
         ,revisioni_struttura rest 
         ,figure_giuridiche figi 
         ,rapporti_individuali rain 
    WHERE rilevanza IN (SELECT 'Q' 
                          FROM DUAL 
                        UNION 
                        SELECT 'S' 
                          FROM DUAL 
                        UNION 
                        SELECT 'I' 
                          FROM DUAL 
                        UNION 
                        SELECT 'E' 
                          FROM DUAL) 
      AND NVL (pegi.al, TO_DATE (3333333, 'j') ) >= rest.dal 
      AND rest.stato = 'A' 
      AND rain.ci = pegi.ci 
      AND NOT EXISTS ( 
             SELECT 'x' 
               FROM unita_organizzative unor 
              WHERE ni = (SELECT ni 
                            FROM settori_amministrativi 
                           WHERE numero = pegi.settore) 
                AND unor.ottica = 'GP4' 
                AND unor.revisione = rest.revisione) 
      AND EXISTS ( 
             SELECT 'x' 
               FROM unita_organizzative unor 
              WHERE ni = (SELECT ni 
                            FROM settori_amministrativi 
                           WHERE numero = pegi.settore) 
                AND unor.ottica = 'GP4' 
                AND unor.revisione = gp4gm.get_revisione_o) 
      AND stam.numero = pegi.settore 
      AND figi.numero = pegi.figura 
      AND NVL (pegi.al, TO_DATE (3333333, 'j') ) BETWEEN figi.dal 
                                                     AND NVL (figi.al, TO_DATE (3333333, 'j') )
/


