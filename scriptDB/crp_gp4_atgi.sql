CREATE OR REPLACE PACKAGE gp4_atgi IS
/******************************************************************************
 NOME:        GP4_EVGI
 DESCRIZIONE: Funzioni su ATTRIBUTI_GIURIDICI
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    21/03/2006 __     Prima emissione.
******************************************************************************/
   FUNCTION versione
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (versione, WNDS, WNPS);

   FUNCTION get_attributo (
      p_id                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_attributo, WNDS, WNPS);

   FUNCTION get_coat_id (
      p_id                       IN       NUMBER
   )
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (get_coat_id, WNDS, WNPS);

   FUNCTION get_descrizione (
      p_id                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_descrizione, WNDS, WNPS);

   FUNCTION get_note (
      p_id                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_note, WNDS, WNPS);

   FUNCTION get_categoria (
      p_id                       IN       NUMBER
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_categoria, WNDS, WNPS);

   FUNCTION get_ultimo_id_assegnato (
      p_codice                   IN       VARCHAR2
   )
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (get_ultimo_id_assegnato, WNDS, WNPS);

   FUNCTION get_id_attributo_categoria (
      p_ci                       IN       NUMBER
     ,p_rilevanza                IN       VARCHAR2
     ,p_dal                      IN       DATE
     ,p_categoria                IN       VARCHAR2
   )
      RETURN NUMBER;

   PRAGMA RESTRICT_REFERENCES (get_id_attributo_categoria, WNDS, WNPS);
END gp4_atgi;
/







CREATE OR REPLACE PACKAGE BODY gp4_atgi AS
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
      RETURN 'V1.0 del 21/03/2006';
   END versione;

--
   FUNCTION get_attributo (
      p_id                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_attributo   codici_attributo.attributo%TYPE;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce il codice utente dell'attributo
 PARAMETRI:   --
 RITORNA:
 NOTE:
******************************************************************************/
   BEGIN
      BEGIN
         SELECT attributo
           INTO d_attributo
           FROM codici_attributo
          WHERE coat_id = p_id;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_attributo      := TO_CHAR (NULL);
         WHEN OTHERS THEN
            d_attributo      := TO_CHAR (NULL);
      END;

      RETURN d_attributo;
   END get_attributo;

--
   FUNCTION get_coat_id (
      p_id                       IN       NUMBER
   )
      RETURN NUMBER IS
      d_id   codici_attributo.coat_id%TYPE;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce il coat_id dell'attributo
 PARAMETRI:   --
 RITORNA:
 NOTE:
******************************************************************************/
   BEGIN
      BEGIN
         SELECT coat_id
           INTO d_id
           FROM attributi_giuridici
          WHERE atgi_id = p_id;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_id             := TO_CHAR (NULL);
         WHEN OTHERS THEN
            d_id             := TO_CHAR (NULL);
      END;

      RETURN d_id;
   END get_coat_id;

--
   FUNCTION get_descrizione (
      p_id                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_descrizione   codici_attributo.descrizione%TYPE;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la descrizione  dell'attributo
 PARAMETRI:   --
 RITORNA:
 NOTE:
******************************************************************************/
   BEGIN
      BEGIN
         SELECT descrizione
           INTO d_descrizione
           FROM codici_attributo
          WHERE coat_id = p_id;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_descrizione    := TO_CHAR (NULL);
         WHEN OTHERS THEN
            d_descrizione    := TO_CHAR (NULL);
      END;

      RETURN d_descrizione;
   END get_descrizione;

--
   FUNCTION get_note (
      p_id                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_note   codici_attributo.note%TYPE;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce le note  dell'attributo
 PARAMETRI:   --
 RITORNA:
 NOTE:
******************************************************************************/
   BEGIN
      BEGIN
         SELECT note
           INTO d_note
           FROM codici_attributo
          WHERE coat_id = p_id;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_note           := TO_CHAR (NULL);
         WHEN OTHERS THEN
            d_note           := TO_CHAR (NULL);
      END;

      RETURN d_note;
   END get_note;

--
   FUNCTION get_categoria (
      p_id                       IN       NUMBER
   )
      RETURN VARCHAR2 IS
      d_categoria   codici_attributo.categoria%TYPE;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la categoria  dell'attributo
 PARAMETRI:   --
 RITORNA:
 NOTE:
******************************************************************************/
   BEGIN
      BEGIN
         SELECT categoria
           INTO d_categoria
           FROM codici_attributo
          WHERE coat_id = p_id;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_categoria      := TO_CHAR (NULL);
         WHEN OTHERS THEN
            d_categoria      := TO_CHAR (NULL);
      END;

      RETURN d_categoria;
   END get_categoria;

--
   FUNCTION get_ultimo_id_assegnato (
      p_codice                   IN       VARCHAR2
   )
      RETURN NUMBER IS
      d_id   codici_attributo.coat_id%TYPE;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce l'id tra i vari del codice dato che è stato assegnato
              ad un dipendente di ruolo
 PARAMETRI:   --
 RITORNA:
 NOTE:
******************************************************************************/
   BEGIN
      BEGIN
         SELECT coat_id
           INTO d_id
           FROM attributi_giuridici atgi
          WHERE atgi.coat_id IN (SELECT coat_id
                                   FROM codici_attributo coat
                                  WHERE coat.attributo = p_codice)
            AND atgi.dal =
                   (SELECT MAX (dal)
                      FROM attributi_giuridici atgi2
                     WHERE atgi2.coat_id IN (SELECT coat_id
                                               FROM codici_attributo coat2
                                              WHERE coat2.attributo = p_codice)
                       AND EXISTS (
                              SELECT 'x'
                                FROM periodi_giuridici pegi
                               WHERE pegi.ci = atgi.ci
                                 AND pegi.rilevanza = atgi.rilevanza
                                 AND pegi.dal = atgi.dal
                                 AND gp4_posi.get_ruolo (pegi.posizione) = 'SI') );
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_id             := TO_NUMBER (NULL);
         WHEN OTHERS THEN
            d_id             := TO_NUMBER (NULL);
      END;

      RETURN d_id;
   END get_ultimo_id_assegnato;

--
   FUNCTION get_id_attributo_categoria (
      p_ci                       IN       NUMBER
     ,p_rilevanza                IN       VARCHAR2
     ,p_dal                      IN       DATE
     ,p_categoria                IN       VARCHAR2
   )
      RETURN NUMBER IS
      d_id   codici_attributo.coat_id%TYPE;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce l'id tra i vari del codice dato che è stato assegnato
              ad un dipendente di ruolo
 PARAMETRI:   --
 RITORNA:
 NOTE:
******************************************************************************/
   BEGIN
      BEGIN
         SELECT atgi_id
           INTO d_id
           FROM attributi_giuridici atgi
          WHERE ci = p_ci
            AND rilevanza = p_rilevanza
            AND dal = p_dal
            AND p_categoria = get_categoria (coat_id);
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_id             := TO_NUMBER (NULL);
         WHEN OTHERS THEN
            d_id             := TO_NUMBER (NULL);
      END;

      RETURN d_id;
   END get_id_attributo_categoria;
--
END gp4_atgi;
/







