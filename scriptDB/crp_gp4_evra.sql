CREATE OR REPLACE PACKAGE gp4_evra IS
  /******************************************************************************
   NOME:        GP4_EVRA
   DESCRIZIONE: <Descrizione Package>
   ANNOTAZIONI: -
   REVISIONI:
   Rev. Data       Autore Descrizione
   ---- ---------- ------ ------------------------------------------------------
   0    12/09/2006 MM     Prima emissione.
  ******************************************************************************/
  FUNCTION versione RETURN VARCHAR2;

  FUNCTION get_descrizione
  (
    p_evento    IN VARCHAR2
   ,p_rilevanza IN VARCHAR2
  ) RETURN VARCHAR2;
END gp4_evra;
/
CREATE OR REPLACE PACKAGE BODY gp4_evra AS
  FUNCTION versione RETURN VARCHAR2 IS
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
  FUNCTION get_descrizione
  (
    p_evento    IN VARCHAR2
   ,p_rilevanza IN VARCHAR2
  ) RETURN VARCHAR2 IS
    d_descrizione eventi_rapporto.descrizione%TYPE;
    /******************************************************************************
     NOME:        VERSIONE
     DESCRIZIONE: Restituisce la  descrizione dell'evento di rapporto indicato
     PARAMETRI:   --
     RITORNA:     stringa varchar2 ruolenente versione e descrizione.
    ******************************************************************************/
  BEGIN
    BEGIN
      SELECT descrizione
        INTO d_descrizione
        FROM eventi_rapporto
       WHERE codice = p_evento
         AND rilevanza = p_rilevanza;
    EXCEPTION
      WHEN no_data_found THEN
        d_descrizione := to_char(NULL);
      WHEN OTHERS THEN
        d_descrizione := to_char(NULL);
    END;
  
    RETURN d_descrizione;
  END get_descrizione;
  --
END gp4_evra;
/
