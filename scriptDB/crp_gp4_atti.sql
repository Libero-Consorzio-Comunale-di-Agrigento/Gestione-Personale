CREATE OR REPLACE PACKAGE gp4_atti IS
/******************************************************************************
 NOME:        GP4_ATTI
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
      p_attivita            IN       VARCHAR2
   )
      RETURN varchar2;
END gp4_atti;
/
CREATE OR REPLACE PACKAGE BODY gp4_atti AS
   FUNCTION versione
      RETURN VARCHAR2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 attienente versione e descrizione.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
   BEGIN
      RETURN 'V1.0 del 12/09/2006';
   END versione;

--
   FUNCTION get_descrizione (
      p_attivita                   IN       VARCHAR2
   )
      RETURN varchar2 IS
      d_descrizione   attivita.descrizione%type;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la  descrizione dell'attività indicata
 PARAMETRI:   --
 RITORNA:     stringa varchar2 attienente versione e descrizione.
******************************************************************************/
   BEGIN
      BEGIN
         SELECT descrizione
           INTO d_descrizione
           FROM attivita
          WHERE codice = p_attivita  ;
      EXCEPTION
         WHEN NO_data_found THEN
            d_descrizione           := to_char(null);
         WHEN OTHERS THEN
            d_descrizione           := to_char(null);
      END;

      RETURN d_descrizione;
   END get_descrizione;
--
END gp4_atti;
/
