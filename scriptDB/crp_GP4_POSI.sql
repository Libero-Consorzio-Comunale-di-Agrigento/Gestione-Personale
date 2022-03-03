CREATE OR REPLACE PACKAGE gp4_posi IS
/******************************************************************************
 NOME:        GP4_POSI
 DESCRIZIONE: funzioni sulla tabella POSIZIONI
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    21/08/2002 __     Prima emissione.
 1    10/06/2004 MV     A6207 (Brunico - Contrattisti)
 2    21/01/2005 CB     Soggetti sovrannumero
 2.1  20/12/2005 CB     get_universitari
 3	  14/04/2006 MM		Tipo Part-time
******************************************************************************/
   FUNCTION versione
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (versione, WNDS, WNPS);

   FUNCTION get_ruolo (
      p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_ruolo, WNDS, WNPS);

   FUNCTION get_part_time (
      p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_part_time, WNDS, WNPS);

   FUNCTION get_tipo_part_time (
      p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_tipo_part_time, WNDS, WNPS);

   FUNCTION get_ruolo_do (
      p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_ruolo_do, WNDS, WNPS);

   FUNCTION get_contratto_opera (
      p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_contratto_opera, WNDS, WNPS);

   FUNCTION get_sovrannumero (
      p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_sovrannumero, WNDS, WNPS);

   FUNCTION get_universitario (
      p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2;

   PRAGMA RESTRICT_REFERENCES (get_universitario, WNDS, WNPS);
END gp4_posi;
/
CREATE OR REPLACE PACKAGE BODY gp4_posi AS
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
      RETURN 'V2.3 del 14/06/2006';
   END versione;

--
   FUNCTION get_ruolo (
      p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2 IS
      d_ruolo   posizioni.ruolo%TYPE;
/******************************************************************************
 NOME:       indica sel la posizione giuridica data e di ruolo oppure no
******************************************************************************/
   BEGIN
      BEGIN
         SELECT ruolo
           INTO d_ruolo
           FROM posizioni
          WHERE codice = p_posizione;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_ruolo          := TO_CHAR (NULL);
      END;

      RETURN d_ruolo;
   END get_ruolo;

--
   FUNCTION get_ruolo_do (
      p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2 IS
      d_ruolo   posizioni.ruolo%TYPE;
/******************************************************************************
 NOME:       indica sel la posizione giuridica data e di ruolo oppure no
******************************************************************************/
   BEGIN
      BEGIN
         SELECT ruolo_do
           INTO d_ruolo
           FROM posizioni
          WHERE codice = p_posizione;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_ruolo          := TO_CHAR (NULL);
      END;

      RETURN d_ruolo;
   END get_ruolo_do;

--
   FUNCTION get_part_time (
      p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2 IS
      d_part_time   posizioni.part_time%TYPE;
/******************************************************************************
 NOME:       indica sel la posizione giuridica data e part time oppure no
******************************************************************************/
   BEGIN
      BEGIN
         SELECT part_time
           INTO d_part_time
           FROM posizioni
          WHERE codice = p_posizione;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_part_time      := TO_CHAR (NULL);
      END;

      RETURN d_part_time;
   END get_part_time;

--
   FUNCTION get_tipo_part_time (
      p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2 IS
      d_tipo_part_time   posizioni.tipo_part_time%TYPE;
/******************************************************************************
 NOME:       riporta il tipo di part-time della posizione_giuridica
******************************************************************************/
   BEGIN
      BEGIN
         SELECT tipo_part_time
           INTO d_tipo_part_time
           FROM posizioni
          WHERE codice = p_posizione;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_tipo_part_time := TO_CHAR (NULL);
      END;

      RETURN d_tipo_part_time;
   END get_tipo_part_time;

--
--
   FUNCTION get_contratto_opera (
      p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2 IS
      d_c_opera   posizioni.contratto_opera%TYPE;
/******************************************************************************
 NOME:       indica se trattasi di contrattista
******************************************************************************/
   BEGIN
      BEGIN
         SELECT contratto_opera
           INTO d_c_opera
           FROM posizioni
          WHERE codice = p_posizione
            AND ruolo = 'NO';
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_c_opera        := TO_CHAR (NULL);
      END;

      RETURN d_c_opera;
   END get_contratto_opera;

--
   FUNCTION get_sovrannumero (
      p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2 IS
      d_sovrannumero   posizioni.sovrannumero%TYPE;
/******************************************************************************
 NOME:       indica se trattasi di sovrannumero
******************************************************************************/
   BEGIN
      BEGIN
         SELECT sovrannumero
           INTO d_sovrannumero
           FROM posizioni
          WHERE codice = p_posizione;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_sovrannumero   := TO_CHAR (NULL);
      END;

      RETURN d_sovrannumero;
   END get_sovrannumero;

--
   FUNCTION get_universitario (
      p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2 IS
      d_universitario   posizioni.universitario%TYPE;
/******************************************************************************
 NOME:       indica se trattasi di universitario
******************************************************************************/
   BEGIN
      BEGIN
         SELECT universitario
           INTO d_universitario
           FROM posizioni
          WHERE codice = p_posizione;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_universitario  := TO_CHAR (NULL);
      END;

      RETURN d_universitario;
   END get_universitario;
--
END gp4_posi;
/
