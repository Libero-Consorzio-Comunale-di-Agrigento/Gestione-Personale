CREATE OR REPLACE PACKAGE gp4_tira IS
/******************************************************************************
 NOME:        GP4_TIRA
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
      p_tipo_rapporto            IN       VARCHAR2
   )
      RETURN varchar2;
END gp4_tira;
/
CREATE OR REPLACE PACKAGE BODY gp4_tira AS
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
      p_tipo_rapporto                   IN       VARCHAR2
   )
      RETURN varchar2 IS
      d_descrizione   tipi_rapporto.descrizione%type;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la  descrizione del tipo di rapporto indicato
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e descrizione.
******************************************************************************/
   BEGIN
      BEGIN
         SELECT descrizione
           INTO d_descrizione
           FROM tipi_rapporto
          WHERE codice = p_tipo_rapporto  ;
      EXCEPTION
         WHEN NO_data_found THEN
            d_descrizione           := to_char(null);
         WHEN OTHERS THEN
            d_descrizione           := to_char(null);
      END;

      RETURN d_descrizione;
   END get_descrizione;
--
END gp4_tira;
/
