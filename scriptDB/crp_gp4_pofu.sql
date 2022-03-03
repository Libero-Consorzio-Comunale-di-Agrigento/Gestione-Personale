CREATE OR REPLACE PACKAGE gp4_pofu IS
/******************************************************************************
 NOME:        GP4_POFU
 DESCRIZIONE: <Descrizione Package>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    12/09/2006 MM     Prima emissione.
******************************************************************************/
   FUNCTION versione
      RETURN VARCHAR2;

   FUNCTION get_descrizione (
      p_profilo                  IN       VARCHAR2
     ,p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2;
END gp4_pofu;
/

CREATE OR REPLACE PACKAGE BODY gp4_pofu AS
   FUNCTION versione
      RETURN VARCHAR2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e descrizione.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
   BEGIN
      RETURN 'V1.0 del 12/09/2006';
   END versione;

--
   FUNCTION get_descrizione (
      p_profilo                  IN       VARCHAR2
     ,p_posizione                IN       VARCHAR2
   )
      RETURN VARCHAR2 IS
      d_descrizione   posizioni_funzionali.descrizione%TYPE;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la  descrizione della posizione funzionale indicato
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e descrizione.
******************************************************************************/
   BEGIN
      BEGIN
         SELECT descrizione
           INTO d_descrizione
           FROM posizioni_funzionali
          WHERE codice = p_posizione
            AND profilo = p_profilo;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_descrizione    := TO_CHAR (NULL);
         WHEN OTHERS THEN
            d_descrizione    := TO_CHAR (NULL);
      END;

      RETURN d_descrizione;
   END get_descrizione;
--
END gp4_pofu;
/

