CREATE OR REPLACE PACKAGE gp4_unor IS
   FUNCTION get_ni (
      p_codice                   IN       VARCHAR2
     ,p_ottica                   IN       VARCHAR2
     ,p_data                     IN       DATE
   )
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (get_ni, WNDS, WNPS);

   FUNCTION get_codice_uo (
      p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR
     ,p_data                     IN       DATE
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_codice_uo, WNDS, WNPS);

   FUNCTION get_dal (
      p_ni                       IN       NUMBER
   )
      RETURN DATE;

   PRAGMA RESTRICT_REFERENCES (get_dal, WNDS, WNPS);

   FUNCTION get_dal_o (
      p_ni                       IN       NUMBER
     ,p_revisione                IN       NUMBER
   )
      RETURN DATE;

   PRAGMA RESTRICT_REFERENCES (get_dal_o, WNDS, WNPS);

   FUNCTION get_dal_m (
      p_ni                       IN       NUMBER
   )
      RETURN DATE;

   PRAGMA RESTRICT_REFERENCES (get_dal_m, WNDS, WNPS);

   FUNCTION get_dal_data (
      p_ni                       IN       NUMBER
     ,p_data                              DATE
   )
      RETURN DATE;

   PRAGMA RESTRICT_REFERENCES (get_dal_data, WNDS, WNPS);

   FUNCTION get_descrizione (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_descrizione, WNDS, WNPS);

   FUNCTION get_descrizione_uo (
      p_ni                       IN       NUMBER
     ,p_revisione                IN       NUMBER
     ,p_data                     IN       DATE
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_descrizione_uo, WNDS, WNPS);

   FUNCTION get_descrizione_m (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_descrizione_m, WNPS);

   FUNCTION get_descrizione_al1 (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_descrizione_al1, WNPS, WNDS);

   FUNCTION get_descrizione_al2 (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_descrizione_al2, WNPS, WNDS);

   FUNCTION get_suddivisione (
      p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR2
     ,p_dal                      IN       DATE
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_suddivisione, WNDS, WNPS);

   FUNCTION get_suddivisione_m (
      p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR2
     ,p_dal                      IN       DATE
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_suddivisione_m, WNDS, WNPS);

   FUNCTION get_livello (
      p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR2
     ,p_dal                      IN       DATE
   )
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (get_livello, WNDS, WNPS);

   FUNCTION get_revisione (
      p_ni                       IN       NUMBER
   )
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (get_revisione, WNDS, WNPS);

   FUNCTION get_livello_m (
      p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR2
     ,p_dal                      IN       DATE
   )
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (get_livello, WNDS, WNPS);

   FUNCTION get_padre (
      p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR2
     ,p_dal                      IN       DATE
   )
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (get_padre, WNDS, WNPS);

   FUNCTION get_padre_rev (
      p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR2
     ,p_revisione                IN       NUMBER
   )
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (get_padre_rev, WNDS, WNPS);

   FUNCTION get_denominazione_sede (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_denominazione_sede, WNDS, WNPS);

   FUNCTION get_denominazione_sede_uo (
      p_ni                       IN       NUMBER
     ,p_revisione                IN       NUMBER
     ,p_data                     IN       DATE
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_denominazione_sede_uo, WNDS, WNPS);

   FUNCTION get_unita_superiore (
      p_ni                       IN       NUMBER
     ,p_revisione                IN       NUMBER
     ,p_ottica                   IN       VARCHAR2
     ,p_suddivisione             IN       VARCHAR2
     ,p_data                     IN       DATE
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_unita_superiore, WNDS, WNPS);

   FUNCTION get_sede 
   (  p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR
     ,p_data                     IN       DATE
   ) RETURN NUMBER;
   PRAGMA RESTRICT_REFERENCES (get_sede, WNDS, WNPS);
   
   FUNCTION versione
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (versione, WNDS, WNPS);
/******************************************************************************
   NAME:       GP4_UNOR
   PURPOSE:    To calculate the desired information.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        23/07/2002                   Created this package.
   2.0        01/02/2005              MM   Aggiunte nuove function GET_DESCRIZIONE_UO
                                           e GET_DENOMINAZIONE_SEDE_UO per migliorare
                                           la visualizzazione storica
                                           Introdotta la nuova function GET_UNITA_SUPERIORE
   2.1        11/03/2005              MM   Attivita 10116
   2.2        04/11/2005              MM   Attivita 13306
   2.3        24/01/2006              MM   Attivita 14413 - Nuova function get_revisione
   2.4        21/08/2006              MM   Attivita 17239
   2.5        19/03/2007              MS   Creazione function get_sede per Attivita 20195 emens 
******************************************************************************/
END gp4_unor;
/
CREATE OR REPLACE PACKAGE BODY gp4_unor AS
   FUNCTION versione
      RETURN VARCHAR2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
   BEGIN
      RETURN 'V2.4 del 21/06/2006';
   END versione;

--
   FUNCTION get_ni (
      p_codice                   IN       VARCHAR2
     ,p_ottica                   IN       VARCHAR2
     ,p_data                     IN       DATE
   )
      RETURN NUMBER IS
      d_ni   unita_organizzative.ni%TYPE;
/******************************************************************************
   NAME:       GET_NI
   PURPOSE:    Fornire l'ni dell'unita organizzativa
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03/05/2004                   Created this function.
******************************************************************************/
   BEGIN
      d_ni             := 0;

      BEGIN
         IF p_data IS NOT NULL THEN
            SELECT ni
              INTO d_ni
              FROM unita_organizzative unor
             WHERE codice_uo = p_codice
               AND ottica = p_ottica
               AND revisione = gp4gm.get_revisione (p_data)
               AND p_data BETWEEN unor.dal AND NVL (unor.al, TO_DATE ('3333333', 'j') )
               AND EXISTS (SELECT 'x'
                             FROM settori_amministrativi
                            WHERE ni = unor.ni);
         ELSE
            SELECT ni
              INTO d_ni
              FROM unita_organizzative unor
             WHERE codice_uo = p_codice
               AND ottica = 'GP4'
               AND revisione = gp4gm.get_revisione (gp4_unor.get_dal (ni) )
               AND gp4_unor.get_dal (ni) BETWEEN unor.dal AND NVL (unor.al
                                                                  ,TO_DATE ('3333333', 'j') )
               AND EXISTS (SELECT 'x'
                             FROM settori_amministrativi
                            WHERE ni = unor.ni);
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_ni             := NULL;
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_ni             := NULL;
            END;
      END;

      RETURN d_ni;
   END get_ni;

--
   FUNCTION get_codice_uo (
      p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR
     ,p_data                     IN       DATE
   )
      RETURN VARCHAR2 IS
      d_codice      unita_organizzative.codice_uo%TYPE;
      d_revisione   unita_organizzative.revisione%TYPE;
/******************************************************************************
   NAME:       GET_CODICE_UO
   PURPOSE:    Fornire il codice dell'unita_organizzative
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03/05/2004
******************************************************************************/
   BEGIN
      d_codice         := 'XXXXXXXXXXXXXX';
      d_revisione      := gp4gm.get_revisione (NVL (p_data, TO_DATE ('3333333', 'j') ) );

      BEGIN
         SELECT codice_uo
           INTO d_codice
           FROM unita_organizzative unor
          WHERE ni = p_ni
            AND ottica || '' = 'GP4'
            AND revisione = d_revisione
            AND NVL (p_data, TO_DATE ('3333333', 'j') ) BETWEEN dal
                                                            AND NVL (al, TO_DATE ('3333333', 'j') );

         IF d_codice IS NULL THEN
            RAISE NO_DATA_FOUND;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_revisione      := gp4_unor.get_revisione (p_ni);

               SELECT codice_uo
                 INTO d_codice
                 FROM unita_organizzative unor
                WHERE ni = p_ni
                  AND ottica || '' = 'GP4'
                  AND revisione = d_revisione
                  AND NVL (p_data, TO_DATE ('3333333', 'j') ) BETWEEN dal
                                                                  AND NVL (al
                                                                          ,TO_DATE ('3333333', 'j')
                                                                          );
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                  d_codice         := TO_CHAR (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_codice         := TO_CHAR (NULL);
            END;
      END;

      RETURN d_codice;
   END get_codice_uo;

--
   FUNCTION get_dal (
      p_ni                       IN       NUMBER
   )
      RETURN DATE IS
/******************************************************************************
   NAME:       GET_DAL
   PURPOSE:    Fornire l'ultimo dal dell'unita organizzativa dato un ni (ottica GP4)
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002
******************************************************************************/
      d_dal         unita_organizzative.dal%TYPE;
      d_revisione   unita_organizzative.revisione%TYPE;
   BEGIN
      d_dal            := TO_DATE (NULL);

      BEGIN
         SELECT revisione
           INTO d_revisione
           FROM revisioni_struttura rest
          WHERE ottica = 'GP4'
            AND dal =
                   (SELECT MAX (gp4_rest.get_dal (x.revisione) )
                      FROM revisioni_struttura x
                     WHERE EXISTS (
                              SELECT 'x'
                                FROM unita_organizzative
                               WHERE ni = p_ni
                                 AND ottica || '' = 'GP4'
                                 AND tipo = 'P'
                                 AND revisione = x.revisione)
                       AND ottica = 'GP4');

         SELECT MAX (dal)
           INTO d_dal
           FROM unita_organizzative
          WHERE ni = p_ni
            AND ottica = 'GP4'
            AND revisione = d_revisione
            AND tipo = 'P';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_dal            := TO_DATE (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_dal            := TO_DATE (NULL);
            END;
      END;

      RETURN d_dal;
   END get_dal;

--
   FUNCTION get_dal_o (
      p_ni                       IN       NUMBER
     ,p_revisione                IN       NUMBER
   )
      RETURN DATE IS
      d_dal   unita_organizzative.dal%TYPE;
/******************************************************************************
   NAME:       GET_DAL_O
   PURPOSE:    Fornire l'ultimo dal dell'unita organizzativa dato un ni (ottica GP4)
               per le revisioni obsolete
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        20/03/2003
******************************************************************************/
   BEGIN
      d_dal            := TO_DATE (NULL);

      BEGIN
         SELECT MAX (dal)
           INTO d_dal
           FROM unita_organizzative
          WHERE ni = p_ni
            AND ottica = 'GP4'
            AND revisione = p_revisione
            AND tipo = 'P';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_dal            := TO_DATE (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_dal            := TO_DATE (NULL);
            END;
      END;

      RETURN d_dal;
   END get_dal_o;

--
   FUNCTION get_dal_m (
      p_ni                       IN       NUMBER
   )
      RETURN DATE IS
      d_dal   unita_organizzative.dal%TYPE;
/******************************************************************************
   NAME:       GET_DAL
   PURPOSE:    Fornire l'ultimo dal dell'unita organizzativa dato un ni (ottica GP4)
               per le revisioni in modifica
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002
******************************************************************************/
   BEGIN
      d_dal            := TO_DATE (NULL);

      BEGIN
         SELECT MAX (dal)
           INTO d_dal
           FROM unita_organizzative
          WHERE ni = p_ni
            AND ottica = 'GP4'
            AND tipo = 'T';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_dal            := TO_DATE (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_dal            := TO_DATE (NULL);
            END;
      END;

      RETURN d_dal;
   END get_dal_m;

--
   FUNCTION get_dal_data (
      p_ni                       IN       NUMBER
     ,p_data                              DATE
   )
      RETURN DATE IS
      d_dal         unita_organizzative.dal%TYPE;
      d_revisione   unita_organizzative.revisione%TYPE;
/******************************************************************************
   NAME:       GET_DAL
   PURPOSE:    Fornire l'ultimo dal dell'unita organizzativa valida ad una certa data
               dato un ni (ottica GP4)
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002
******************************************************************************/
   BEGIN
      d_dal            := TO_DATE (NULL);

      BEGIN
         SELECT MAX (dal)
           INTO d_dal
           FROM unita_organizzative
          WHERE ni = p_ni
            AND NVL (p_data, TO_DATE (3333333, 'j') ) BETWEEN dal AND NVL (al
                                                                          ,TO_DATE (3333333, 'j')
                                                                          )
            AND ottica = 'GP4'
            AND tipo = 'P';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_dal            := TO_DATE (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_dal            := TO_DATE (NULL);
            END;
      END;

      RETURN d_dal;
   END get_dal_data;

--
   FUNCTION get_descrizione (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_descrizione   unita_organizzative.descrizione%TYPE;
/******************************************************************************
   NAME:       GET_DESCRIZIONE
   PURPOSE:    Fornire l'ultimo DESCRIZIONE dell'unita organizzativa dato un ni (ottica GP4)
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002
******************************************************************************/
   BEGIN
      d_descrizione    := TO_CHAR (NULL);

      BEGIN
         SELECT MAX (descrizione)
           INTO d_descrizione
           FROM unita_organizzative
          WHERE ni = p_ni
            AND ottica || '' = 'GP4'
            AND dal = get_dal (p_ni)
            AND tipo = 'P';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_descrizione    := TO_DATE (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_descrizione    := TO_DATE (NULL);
            END;
      END;

      RETURN d_descrizione;
   END get_descrizione;

--
   FUNCTION get_descrizione_uo (
      p_ni                       IN       NUMBER
     ,p_revisione                IN       NUMBER
     ,p_data                     IN       DATE
   )
      RETURN VARCHAR2 IS
      d_descrizione   unita_organizzative.descrizione%TYPE;
/******************************************************************************
   NAME:       GET_DESCRIZIONE
   PURPOSE:    Fornire la DESCRIZIONE dell'unita organizzativa dato un ni (ottica GP4),
               Revisione e data
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01/02/2005
******************************************************************************/
   BEGIN
      d_descrizione    := TO_CHAR (NULL);

      BEGIN
         SELECT descrizione
           INTO d_descrizione
           FROM unita_organizzative
          WHERE ni = p_ni
            AND ottica = 'GP4'
            AND revisione = p_revisione
            AND p_data BETWEEN dal AND NVL (al, TO_DATE (3333333, 'j') );
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_descrizione    := TO_CHAR (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_descrizione    := TO_CHAR (NULL);
            END;
      END;

      RETURN d_descrizione;
   END get_descrizione_uo;

--
   FUNCTION get_descrizione_al1 (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_descrizione   unita_organizzative.descrizione%TYPE;
/******************************************************************************
   NAME:       GET_DESCRIZIONE
   PURPOSE:    Fornire l'ultimo DESCRIZIONE dell'unita organizzativa dato un ni (ottica GP4)
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002
******************************************************************************/
   BEGIN
      d_descrizione    := TO_DATE (NULL);

      BEGIN
         SELECT descrizione_al1
           INTO d_descrizione
           FROM unita_organizzative
          WHERE ni = p_ni
            AND ottica = 'GP4'
            AND dal = get_dal (p_ni)
            AND tipo = 'P';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_descrizione    := TO_DATE (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_descrizione    := TO_DATE (NULL);
            END;
      END;

      RETURN d_descrizione;
   END get_descrizione_al1;

--
   FUNCTION get_descrizione_al2 (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_descrizione   unita_organizzative.descrizione%TYPE;
/******************************************************************************
   NAME:       GET_DESCRIZIONE
   PURPOSE:    Fornire l'ultimo DESCRIZIONE dell'unita organizzativa dato un ni (ottica GP4)
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002
******************************************************************************/
   BEGIN
      d_descrizione    := TO_DATE (NULL);

      BEGIN
         SELECT descrizione_al2
           INTO d_descrizione
           FROM unita_organizzative
          WHERE ni = p_ni
            AND ottica = 'GP4'
            AND dal = get_dal (p_ni)
            AND tipo = 'P';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_descrizione    := TO_DATE (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_descrizione    := TO_DATE (NULL);
            END;
      END;

      RETURN d_descrizione;
   END get_descrizione_al2;

--
--
   FUNCTION get_descrizione_m (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_descrizione_m   unita_organizzative.descrizione%TYPE;
/******************************************************************************
   NAME:       GET_DESCRIZIONE
   PURPOSE:    Fornire l'ultima DESCRIZIONE dell'unita organizzativa di tipo T dato un ni (ottica GP4)
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        28/04/2003
******************************************************************************/
   BEGIN
      d_descrizione_m  := TO_DATE (NULL);

      BEGIN
         SELECT descrizione
           INTO d_descrizione_m
           FROM unita_organizzative
          WHERE ni = p_ni
            AND ottica = 'GP4'
            AND dal = get_dal_m (p_ni)
            AND tipo = 'T';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_descrizione_m  := TO_DATE (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_descrizione_m  := TO_DATE (NULL);
            END;
      END;

      RETURN d_descrizione_m;
   END get_descrizione_m;

--
   FUNCTION get_denominazione_sede (
      p_ni                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_denominazione   anagrafici.denominazione%TYPE;
/******************************************************************************
   NAME:       GET_DENOMINAZIONE_SEDE
   PURPOSE:    Fornire la denominazione della sede dell'UO
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002
******************************************************************************/
   BEGIN
      d_denominazione  := TO_CHAR (NULL);

      BEGIN
         SELECT denominazione
           INTO d_denominazione
           FROM anagrafici
          WHERE ni = (SELECT sede
                        FROM unita_organizzative
                       WHERE ni = p_ni
                         AND ottica = 'GP4'
                         AND dal = get_dal (p_ni)
                         AND tipo = 'P')
            AND get_dal (p_ni) BETWEEN dal AND NVL (al, TO_DATE (3333333, 'j') );
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_denominazione  := TO_CHAR (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_denominazione  := TO_CHAR (NULL);
            END;
      END;

      RETURN d_denominazione;
   END get_denominazione_sede;

--
   FUNCTION get_denominazione_sede_uo (
      p_ni                       IN       NUMBER
     ,p_revisione                IN       NUMBER
     ,p_data                     IN       DATE
   )
      RETURN VARCHAR2 IS
      d_denominazione   anagrafici.denominazione%TYPE;
/******************************************************************************
   NAME:       GET_DENOMINAZIONE_SEDE
   PURPOSE:    Fornire la denominazione storica della sede dell'UO
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01/02/2005
******************************************************************************/
   BEGIN
      d_denominazione  := TO_CHAR (NULL);

      BEGIN
         SELECT denominazione
           INTO d_denominazione
           FROM anagrafici
          WHERE ni =
                   (SELECT sede
                      FROM unita_organizzative
                     WHERE ni = p_ni
                       AND ottica = 'GP4'
                       AND revisione = p_revisione
                       AND p_data BETWEEN dal AND NVL (al, TO_DATE (3333333, 'j') ) )
            AND p_data BETWEEN dal AND NVL (al, TO_DATE (3333333, 'j') );
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_denominazione  := TO_CHAR (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_denominazione  := TO_CHAR (NULL);
            END;
      END;

      RETURN d_denominazione;
   END get_denominazione_sede_uo;

--
   FUNCTION get_livello (
      p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR2
     ,p_dal                      IN       DATE
   )
      RETURN NUMBER IS
      d_livello   suddivisioni_struttura.sequenza%TYPE;
/******************************************************************************
   NAME:       GET_LIVELLO
   PURPOSE:    Fornire la profondita della suddivisione dell'UO
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002
******************************************************************************/
   BEGIN
      d_livello        := TO_NUMBER (NULL);

      BEGIN
         SELECT COUNT (*)
           INTO d_livello
           FROM suddivisioni_struttura sust
          WHERE ottica = p_ottica
            AND sequenza <
                    (SELECT sequenza
                       FROM suddivisioni_struttura
                      WHERE livello = get_suddivisione (p_ni, p_ottica, p_dal)
                        AND ottica = p_ottica);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_livello        := TO_CHAR (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_livello        := TO_CHAR (NULL);
            END;
      END;

      RETURN d_livello;
   END get_livello;

--
   FUNCTION get_livello_m (
      p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR2
     ,p_dal                      IN       DATE
   )
      RETURN NUMBER IS
      d_livello   suddivisioni_struttura.sequenza%TYPE;
/******************************************************************************
   NAME:       GET_LIVELLO
   PURPOSE:    Fornire la profondita della suddivisione dell'UO per la revisione in modifica
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002
******************************************************************************/
   BEGIN
      d_livello        := TO_NUMBER (NULL);

      BEGIN
         SELECT COUNT (*)
           INTO d_livello
           FROM suddivisioni_struttura sust
          WHERE ottica = p_ottica
            AND sequenza <
                   (SELECT sequenza
                      FROM suddivisioni_struttura
                     WHERE livello = get_suddivisione_m (p_ni, p_ottica, p_dal)
                       AND ottica = p_ottica);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_livello        := TO_CHAR (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_livello        := TO_CHAR (NULL);
            END;
      END;

      RETURN d_livello;
   END get_livello_m;

--
   FUNCTION get_revisione (
      p_ni                       IN       NUMBER
   )
      RETURN NUMBER IS
      d_revisione   revisioni_struttura.revisione%TYPE;
/******************************************************************************
   NAME:       GET_REVISIONE
   PURPOSE:    Fornire l'ultima revisione in cui e prevista la dell'UO
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        23/01/2005
******************************************************************************/
   BEGIN
      d_revisione      := TO_NUMBER (NULL);

      BEGIN
         SELECT DISTINCT unor.revisione
                    INTO d_revisione
                    FROM unita_organizzative unor
                        ,revisioni_struttura rest
                   WHERE unor.ottica = 'GP4'
                     AND unor.tipo = 'P'
                     AND unor.ni = p_ni
                     AND rest.revisione = unor.revisione
                     AND rest.dal = (SELECT MAX (gp4_rest.get_dal (revisione) )
                                       FROM unita_organizzative unor
                                      WHERE ottica = 'GP4'
                                        AND tipo = 'P'
                                        AND ni = p_ni);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_revisione      := TO_NUMBER (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_revisione      := TO_NUMBER (NULL);
            END;
      END;

      RETURN d_revisione;
   END get_revisione;

--
   FUNCTION get_padre (
      p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR2
     ,p_dal                      IN       DATE
   )
      RETURN NUMBER IS
      d_padre   unita_organizzative.unita_padre%TYPE;
/******************************************************************************
   NAME:       GET_PADRE
   PURPOSE:    Fornire la profondita della suddivisione dell'UO
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002
******************************************************************************/
   BEGIN
      d_padre          := TO_NUMBER (NULL);

      BEGIN
         SELECT unita_padre
           INTO d_padre
           FROM unita_organizzative
          WHERE ottica = p_ottica
            AND ni = p_ni
            AND dal = p_dal;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_padre          := TO_NUMBER (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_padre          := TO_NUMBER (NULL);
            END;
      END;

      RETURN d_padre;
   END get_padre;

--
   FUNCTION get_padre_rev (
      p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR2
     ,p_revisione                IN       NUMBER
   )
      RETURN NUMBER IS
      d_padre   unita_organizzative.unita_padre%TYPE;
/******************************************************************************
   NAME:       GET_PADRE_REV
   PURPOSE:    Fornire la profondita della suddivisione dell'UO
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06/12/2004
******************************************************************************/
   BEGIN
      d_padre          := TO_NUMBER (NULL);

      BEGIN
         SELECT unita_padre
           INTO d_padre
           FROM unita_organizzative
          WHERE ottica = p_ottica
            AND ni = p_ni
            AND revisione = p_revisione
            AND dal = (SELECT MAX (dal)
                         FROM unita_organizzative
                        WHERE ottica = p_ottica
                          AND ni = p_ni
                          AND revisione = p_revisione);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_padre          := TO_NUMBER (NULL);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_padre          := TO_NUMBER (NULL);
            END;
      END;

      RETURN d_padre;
   END get_padre_rev;

--
   FUNCTION get_suddivisione (
      p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR2
     ,p_dal                      IN       DATE
   )
      RETURN VARCHAR2 IS
      d_suddivisione   unita_organizzative.suddivisione%TYPE;
/******************************************************************************
   NAME:       GET_SUDDIVISIONE
   PURPOSE:    Fornire la suddivisione di struttura della UO per le revisioni attive
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002
******************************************************************************/
   BEGIN
      d_suddivisione   := TO_CHAR (NULL);

      BEGIN
         SELECT suddivisione
           INTO d_suddivisione
           FROM unita_organizzative
          WHERE ni = p_ni
            AND p_dal = dal
            AND ottica = p_ottica
            AND tipo = 'P'
            AND revisione = gp4gm.get_revisione (p_dal);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_suddivisione   := TO_CHAR (NULL);
               RETURN d_suddivisione;
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_suddivisione   := TO_CHAR (NULL);
               RETURN d_suddivisione;
            END;
      END;

      RETURN d_suddivisione;
   END get_suddivisione;

--
   FUNCTION get_suddivisione_m (
      p_ni                       IN       NUMBER
     ,p_ottica                   IN       VARCHAR2
     ,p_dal                      IN       DATE
   )
      RETURN VARCHAR2 IS
      d_suddivisione   unita_organizzative.suddivisione%TYPE;
/******************************************************************************
   NAME:       GET_SUDDIVISIONE
   PURPOSE:    Fornire la suddivisione di struttura della UO per le revisioni in modifica
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002
******************************************************************************/
   BEGIN
      d_suddivisione   := TO_CHAR (NULL);

      BEGIN
         SELECT suddivisione
           INTO d_suddivisione
           FROM unita_organizzative
          WHERE ni = p_ni
            AND p_dal BETWEEN dal AND NVL (al, TO_DATE (3333333, 'j') )
            AND ottica = p_ottica
            AND revisione = gp4gm.get_revisione_m;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_suddivisione   := TO_CHAR (NULL);
               RETURN d_suddivisione;
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
               d_suddivisione   := TO_CHAR (NULL);
               RETURN d_suddivisione;
            END;
      END;

      RETURN d_suddivisione;
   END get_suddivisione_m;

--
   FUNCTION get_unita_superiore (
      p_ni                       IN       NUMBER
     ,p_revisione                IN       NUMBER
     ,p_ottica                   IN       VARCHAR2
     ,p_suddivisione             IN       VARCHAR2
     ,p_data                     IN       DATE
   )
      RETURN VARCHAR2 IS
      d_predecessore         unita_organizzative.ni%TYPE;
      d_unor                 unita_organizzative.ni%TYPE;
      d_padre                unita_organizzative.ni%TYPE;
      d_suddivisione_padre   unita_organizzative.suddivisione%TYPE;
      situazione_anomala     EXCEPTION;
/******************************************************************************
   NAME:       GET_UNITA_SUPERIORE
   PURPOSE:    Restituire l'U.O. della suddivisione indicata che precede l'unita
               data
******************************************************************************/
   BEGIN
      BEGIN
         IF gp4_sust.get_livello (p_suddivisione) >=
               gp4_sust.get_livello (gp4_unor.get_suddivisione (p_ni
                                                               ,p_ottica
                                                               ,gp4_unor.get_dal_data (p_ni, p_data)
                                                               )
                                    ) THEN
            RAISE situazione_anomala;
         END IF;

         d_unor           := p_ni;
         d_suddivisione_padre := -1;

         WHILE d_suddivisione_padre <> p_suddivisione
         LOOP
            d_padre          :=
                     gp4_unor.get_padre (d_unor, p_ottica, gp4_unor.get_dal_data (d_unor, p_data) );
            d_suddivisione_padre :=
               gp4_unor.get_suddivisione (d_padre
                                         ,p_ottica
                                         ,gp4_unor.get_dal_data (d_padre, p_data)
                                         );
            d_unor           := d_padre;
         END LOOP;

         RETURN d_padre;
      EXCEPTION
         WHEN situazione_anomala THEN
            d_predecessore   := TO_NUMBER (NULL);
            RETURN d_predecessore;
      END;
   END get_unita_superiore;

FUNCTION get_sede
 ( p_ni                       IN       NUMBER
 , p_ottica                   IN       VARCHAR
 , p_data                     IN       DATE
 ) RETURN NUMBER IS
   d_ni_sede     unita_organizzative.sede%TYPE;
   d_revisione   unita_organizzative.revisione%TYPE;
/******************************************************************************
   NAME:       GET_CODICE_UO
   PURPOSE:    Fornire ni della sede geografica dell'un.or. ad una certa data
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.1        19/03/2007
******************************************************************************/
   BEGIN
      d_ni_sede        := to_number(null);
      d_revisione      := gp4gm.get_revisione (NVL (p_data, TO_DATE ('3333333', 'j') ) );

      BEGIN
         SELECT sede
           INTO d_ni_sede
           FROM unita_organizzative unor
          WHERE ni = p_ni
            AND ottica || '' = p_ottica
            AND revisione = d_revisione
            AND NVL (p_data, TO_DATE ('3333333', 'j') ) 
                BETWEEN dal
                    AND NVL (al, TO_DATE ('3333333', 'j') )
         ;

         IF d_ni_sede IS NULL THEN
            RAISE NO_DATA_FOUND;
         END IF;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            BEGIN
               d_revisione      := gp4_unor.get_revisione (p_ni);
               SELECT sede
                 INTO d_ni_sede
                 FROM unita_organizzative unor
                WHERE ni = p_ni
                  AND ottica || '' = p_ottica
                  AND revisione = d_revisione
                  AND NVL (p_data, TO_DATE ('3333333', 'j') ) 
                      BETWEEN dal
                          AND NVL (al ,TO_DATE ('3333333', 'j'))
               ;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 d_ni_sede        := to_number(null);
            END;
         WHEN TOO_MANY_ROWS THEN
            BEGIN
                 d_ni_sede        := to_number(null);
            END;
      END;
      RETURN d_ni_sede;
   END get_sede;
--
END gp4_unor;
/
