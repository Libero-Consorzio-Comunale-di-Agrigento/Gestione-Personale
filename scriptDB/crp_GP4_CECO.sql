CREATE OR REPLACE PACKAGE gp4_ceco IS
/******************************************************************************
 NOME:        GP4_ceco
 DESCRIZIONE: <Descrizione Package>
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    14/09/2006 MM     Prima emissione.
******************************************************************************/
   FUNCTION versione
      RETURN VARCHAR2;

   FUNCTION get_descrizione (
      p_cdc            IN       VARCHAR2
   )
      RETURN varchar2;
END gp4_ceco;
/
CREATE OR REPLACE PACKAGE BODY gp4_ceco AS
   FUNCTION versione
      RETURN VARCHAR2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 ruolenente versione e descrizione.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
   BEGIN
      RETURN 'V1.0 del 12/09/2006';
   END versione;

--
   FUNCTION get_descrizione (
      p_cdc                      IN       VARCHAR2
   )
      RETURN VARCHAR2 IS
      d_descrizione   centri_costo.descrizione%TYPE;
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la  descrizione del centro di costo indicato
 PARAMETRI:   --
 RITORNA:     stringa varchar2 ruolenente versione e descrizione.
******************************************************************************/
   BEGIN
      BEGIN
         SELECT descrizione
           INTO d_descrizione
           FROM centri_costo
          WHERE codice = p_cdc;
      EXCEPTION
         WHEN NO_DATA_FOUND THEN
            d_descrizione    := TO_CHAR (NULL);
         WHEN OTHERS THEN
            d_descrizione    := TO_CHAR (NULL);
      END;

      RETURN d_descrizione;
   END get_descrizione;
--
END gp4_ceco;
/

