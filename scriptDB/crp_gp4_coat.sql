CREATE OR REPLACE PACKAGE gp4_coat IS
  /******************************************************************************
   NOME:        GP4_COAT
   DESCRIZIONE: Funzioni su CODICI_ATTRIBUTO
   ANNOTAZIONI: -
   REVISIONI:
   Rev. Data       Autore Descrizione
   ---- ---------- ------ ------------------------------------------------------
   0    26/06/2006 __     Prima emissione.
  ******************************************************************************/
  FUNCTION versione RETURN VARCHAR2;

  PRAGMA RESTRICT_REFERENCES(versione, WNDS, WNPS);

  FUNCTION get_attributo(p_id IN NUMBER) RETURN VARCHAR2;

  PRAGMA RESTRICT_REFERENCES(get_attributo, WNDS, WNPS);

  FUNCTION get_descrizione(p_id IN NUMBER) RETURN VARCHAR2;

  PRAGMA RESTRICT_REFERENCES(get_descrizione, WNDS, WNPS);

  FUNCTION get_note(p_id IN NUMBER) RETURN VARCHAR2;

  PRAGMA RESTRICT_REFERENCES(get_note, WNDS, WNPS);

  FUNCTION get_categoria(p_id IN NUMBER) RETURN VARCHAR2;

  PRAGMA RESTRICT_REFERENCES(get_categoria, WNDS, WNPS);

  FUNCTION get_ultimo_id_assegnato(p_codice IN VARCHAR2) RETURN NUMBER;

  PRAGMA RESTRICT_REFERENCES(get_ultimo_id_assegnato, WNDS, WNPS);
END gp4_coat;
/
CREATE OR REPLACE PACKAGE BODY gp4_coat AS
  FUNCTION versione RETURN VARCHAR2 IS
    /******************************************************************************
     NOME:        VERSIONE
     DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
     PARAMETRI:   --
     RITORNA:     stringa varchar2 contenente versione e data.
     NOTE:        Il secondo numero della versione corrisponde alla revisione
                  del package.
    ******************************************************************************/
  BEGIN
    RETURN 'V1.0 del 26/06/2006';
  END versione;

  --
  FUNCTION get_attributo(p_id IN NUMBER) RETURN VARCHAR2 IS
    d_attributo codici_attributo.attributo%TYPE;
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
      WHEN no_data_found THEN
        d_attributo := to_char(NULL);
      WHEN OTHERS THEN
        d_attributo := to_char(NULL);
    END;
  
    RETURN d_attributo;
  END get_attributo;

  --
  FUNCTION get_descrizione(p_id IN NUMBER) RETURN VARCHAR2 IS
    d_descrizione codici_attributo.descrizione%TYPE;
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
      WHEN no_data_found THEN
        d_descrizione := to_char(NULL);
      WHEN OTHERS THEN
        d_descrizione := to_char(NULL);
    END;
  
    RETURN d_descrizione;
  END get_descrizione;

  --
  FUNCTION get_note(p_id IN NUMBER) RETURN VARCHAR2 IS
    d_note codici_attributo.note%TYPE;
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
      WHEN no_data_found THEN
        d_note := to_char(NULL);
      WHEN OTHERS THEN
        d_note := to_char(NULL);
    END;
  
    RETURN d_note;
  END get_note;

  --
  FUNCTION get_categoria(p_id IN NUMBER) RETURN VARCHAR2 IS
    d_categoria codici_attributo.categoria%TYPE;
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
      WHEN no_data_found THEN
        d_categoria := to_char(NULL);
      WHEN OTHERS THEN
        d_categoria := to_char(NULL);
    END;
  
    RETURN d_categoria;
  END get_categoria;

  --
  FUNCTION get_ultimo_id_assegnato(p_codice IN VARCHAR2) RETURN NUMBER IS
    d_id codici_attributo.coat_id%TYPE;
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
         AND atgi.dal = (SELECT MAX(dal)
                           FROM attributi_giuridici atgi2
                          WHERE atgi2.coat_id IN (SELECT coat_id
                                                    FROM codici_attributo coat2
                                                   WHERE coat2.attributo = p_codice)
                            AND EXISTS (SELECT 'x'
                                   FROM periodi_giuridici pegi
                                  WHERE pegi.ci = atgi.ci
                                    AND pegi.rilevanza = atgi.rilevanza
                                    AND pegi.dal = atgi.dal
                                    AND gp4_posi.get_ruolo(pegi.posizione) = 'SI'));
    EXCEPTION
      WHEN no_data_found THEN
        d_id := to_number(NULL);
      WHEN OTHERS THEN
        d_id := to_number(NULL);
    END;
  
    RETURN d_id;
  END get_ultimo_id_assegnato;
  --
END gp4_coat;
/
