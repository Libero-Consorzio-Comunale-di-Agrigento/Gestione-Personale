CREATE OR REPLACE PACKAGE gp4_cont IS
/******************************************************************************
 NOME:        GP4_cont
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
      p_contratto            IN       VARCHAR2
   )
      RETURN varchar2;
END gp4_cont;
/
CREATE OR REPLACE PACKAGE BODY gp4_cont AS
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
      p_contratto                   IN       VARCHAR2
   )
      RETURN varchar2 IS
      d_descrizione   contratti.descrizione%type;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la  descrizione del contratto di lavoro indicato
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e descrizione.
******************************************************************************/
   BEGIN
      BEGIN
         SELECT descrizione
           INTO d_descrizione
           FROM contratti
          WHERE codice = p_contratto  ;
      EXCEPTION
         WHEN NO_data_found THEN
            d_descrizione           := to_char(null);
         WHEN OTHERS THEN
            d_descrizione           := to_char(null);
      END;

      RETURN d_descrizione;
   END get_descrizione;
--
END gp4_cont;
/
