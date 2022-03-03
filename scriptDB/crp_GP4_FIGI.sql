CREATE OR REPLACE PACKAGE gp4_figi IS
  FUNCTION get_codice
  (
    p_numero IN NUMBER
   ,p_data   IN DATE
  ) RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES(get_codice, WNDS, WNPS);
  FUNCTION get_profilo
  (
    p_numero IN NUMBER
   ,p_data   IN DATE
  ) RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES(get_profilo, WNDS, WNPS);
  FUNCTION get_posizione
  (
    p_numero IN NUMBER
   ,p_data   IN DATE
  ) RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES(get_posizione, WNDS, WNPS);
  FUNCTION get_descrizione
  (
    p_numero IN NUMBER
   ,p_data   IN DATE
  ) RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES(get_descrizione, WNDS, WNPS);
  FUNCTION get_qualifica
  (
    p_numero IN NUMBER
   ,p_data   IN DATE
  ) RETURN NUMBER;
  PRAGMA RESTRICT_REFERENCES(get_qualifica, WNDS, WNPS);
  FUNCTION get_numero
  (
    p_codice IN VARCHAR2
   ,p_data   IN DATE
  ) RETURN NUMBER;
  PRAGMA RESTRICT_REFERENCES(get_numero, WNDS, WNPS);
  FUNCTION versione RETURN VARCHAR2;
  PRAGMA RESTRICT_REFERENCES(versione, WNDS, WNPS);
  /******************************************************************************
     NAME:       GP4_FIGI
     PURPOSE:    To calculate the desired information.
     REVISIONS:
     Ver        Date        Author           Description
     ---------  ----------  ---------------  ------------------------------------
     1.0        23/07/2002                   1. Created this package.
     2.0        24/10/2006                MM Att.17716
  ******************************************************************************/
END gp4_figi;
/
CREATE OR REPLACE PACKAGE BODY gp4_figi AS
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
    RETURN 'V2.0 del 24/10/2006';
  END versione;
  --
  FUNCTION get_codice
  (
    p_numero IN NUMBER
   ,p_data   IN DATE
  ) RETURN VARCHAR2 IS
    d_codice figure_giuridiche.codice%TYPE;
    /******************************************************************************
       NAME:       GET_CODICE
       PURPOSE:    Fornire il codice della figura dato il numero
       REVISIONS:
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        12/08/2002          1. Created this function.
       PARAMETERS:
       INPUT:
       OUTPUT:
       RETURNED VALUE:  VARCHAR
       CALLED BY:
       CALLS:
       EXAMPLE USE:     VARCHAR := GET_CODICE();
       ASSUMPTIONS:
       LIMITATIONS:
       ALGORITHM:
       NOTES:
    ******************************************************************************/
  BEGIN
    d_codice := to_char(NULL);
    BEGIN
      SELECT codice
        INTO d_codice
        FROM figure_giuridiche
       WHERE numero = p_numero
         AND p_data BETWEEN dal AND nvl(al, to_date(3333333, 'j'));
    EXCEPTION
      WHEN no_data_found THEN
        BEGIN
          d_codice := to_char(NULL);
        END;
      WHEN too_many_rows THEN
        BEGIN
          d_codice := to_char(NULL);
        END;
    END;
    RETURN d_codice;
  END get_codice;
  --
  FUNCTION get_profilo
  (
    p_numero IN NUMBER
   ,p_data   IN DATE
  ) RETURN VARCHAR2 IS
    d_profilo figure_giuridiche.profilo%TYPE;
    /******************************************************************************
       NAME:       GET_CODICE
       PURPOSE:    Fornire il profilo professionale della figura dato il numero
       REVISIONS:
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        12/08/2002          1. Created this function.
       PARAMETERS:
       INPUT:
       OUTPUT:
       RETURNED VALUE:  VARCHAR
       CALLED BY:
       CALLS:
       EXAMPLE USE:     VARCHAR := GET_PROFILO();
       ASSUMPTIONS:
       LIMITATIONS:
       ALGORITHM:
       NOTES:
    ******************************************************************************/
  BEGIN
    d_profilo := to_char(NULL);
    BEGIN
      SELECT profilo
        INTO d_profilo
        FROM figure_giuridiche
       WHERE numero = p_numero
         AND p_data BETWEEN dal AND nvl(al, to_date(3333333, 'j'));
    EXCEPTION
      WHEN no_data_found THEN
        BEGIN
          d_profilo := to_char(NULL);
        END;
      WHEN too_many_rows THEN
        BEGIN
          d_profilo := to_char(NULL);
        END;
    END;
    RETURN d_profilo;
  END get_profilo;
  --
  FUNCTION get_posizione
  (
    p_numero IN NUMBER
   ,p_data   IN DATE
  ) RETURN VARCHAR2 IS
    d_posizione figure_giuridiche.posizione%TYPE;
    /******************************************************************************
       NAME:       GET_CODICE
       PURPOSE:    Fornire il posizione professionale della figura dato il numero
       REVISIONS:
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        12/08/2002          1. Created this function.
       PARAMETERS:
       INPUT:
       OUTPUT:
       RETURNED VALUE:  VARCHAR
       CALLED BY:
       CALLS:
       EXAMPLE USE:     VARCHAR := GET_posizione();
       ASSUMPTIONS:
       LIMITATIONS:
       ALGORITHM:
       NOTES:
    ******************************************************************************/
  BEGIN
    d_posizione := to_char(NULL);
    BEGIN
      SELECT posizione
        INTO d_posizione
        FROM figure_giuridiche
       WHERE numero = p_numero
         AND p_data BETWEEN dal AND nvl(al, to_date(3333333, 'j'));
    EXCEPTION
      WHEN no_data_found THEN
        BEGIN
          d_posizione := to_char(NULL);
        END;
      WHEN too_many_rows THEN
        BEGIN
          d_posizione := to_char(NULL);
        END;
    END;
    RETURN d_posizione;
  END get_posizione;
  --
  FUNCTION get_descrizione
  (
    p_numero IN NUMBER
   ,p_data   IN DATE
  ) RETURN VARCHAR2 IS
    d_descrizione figure_giuridiche.descrizione%TYPE;
    /******************************************************************************
       NAME:       GET_DESCRIZIONE
       PURPOSE:    Fornire la descrizione della figura dato il numero
       REVISIONS:
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        12/08/2002          1. Created this function.
       PARAMETERS:
       INPUT:
       OUTPUT:
       RETURNED VALUE:  VARCHAR
       CALLED BY:
       CALLS:
       EXAMPLE USE:     VARCHAR := GET_descrizione();
       ASSUMPTIONS:
       LIMITATIONS:
       ALGORITHM:
       NOTES:
    ******************************************************************************/
  BEGIN
    d_descrizione := to_char(NULL);
    BEGIN
      SELECT descrizione
        INTO d_descrizione
        FROM figure_giuridiche
       WHERE numero = p_numero
         AND p_data BETWEEN dal AND nvl(al, to_date(3333333, 'j'));
    EXCEPTION
      WHEN no_data_found THEN
        BEGIN
          d_descrizione := to_char(NULL);
        END;
      WHEN too_many_rows THEN
        BEGIN
          d_descrizione := to_char(NULL);
        END;
    END;
    RETURN d_descrizione;
  END get_descrizione;
  --
  FUNCTION get_qualifica
  (
    p_numero IN NUMBER
   ,p_data   IN DATE
  ) RETURN NUMBER IS
    d_qualifica figure_giuridiche.qualifica%TYPE;
    /******************************************************************************
       NAME:       GET_qualifica
       PURPOSE:    Fornire la qualifica della figura dato il numero
       REVISIONS:
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        12/08/2002          1. Created this function.
       PARAMETERS:
       INPUT:
       OUTPUT:
       RETURNED VALUE:  VARCHAR
       CALLED BY:
       CALLS:
       EXAMPLE USE:     VARCHAR := GET_qualifica();
       ASSUMPTIONS:
       LIMITATIONS:
       ALGORITHM:
       NOTES:
    ******************************************************************************/
  BEGIN
    d_qualifica := to_number(NULL);
    BEGIN
      SELECT qualifica
        INTO d_qualifica
        FROM figure_giuridiche
       WHERE numero = p_numero
         AND p_data BETWEEN dal AND nvl(al, to_date(3333333, 'j'));
    EXCEPTION
      WHEN no_data_found THEN
        BEGIN
          d_qualifica := to_number(NULL);
        END;
      WHEN too_many_rows THEN
        BEGIN
          d_qualifica := to_number(NULL);
        END;
    END;
    RETURN d_qualifica;
  END get_qualifica;
  --
  FUNCTION get_numero
  (
    p_codice IN VARCHAR2
   ,p_data   IN DATE
  ) RETURN NUMBER IS
    d_numero figure_giuridiche.numero%TYPE;
    /******************************************************************************
       NAME:       GET_numero
       PURPOSE:    Fornire il numero della figura dato il codice
       REVISIONS:
       Ver        Date        Author           Description
       ---------  ----------  ---------------  ------------------------------------
       1.0        26/08/2002          1. Created this function.
    ******************************************************************************/
  BEGIN
    d_numero := to_number(NULL);
    BEGIN
      SELECT numero
        INTO d_numero
        FROM figure_giuridiche
       WHERE codice = p_codice
         AND p_data BETWEEN dal AND nvl(al, to_date(3333333, 'j'));
    EXCEPTION
      WHEN no_data_found THEN
        BEGIN
          d_numero := to_number(NULL);
        END;
      WHEN too_many_rows THEN
        BEGIN
          d_numero := to_number(NULL);
        END;
    END;
    RETURN d_numero;
  END get_numero;
  --
--
END gp4_figi;
/
