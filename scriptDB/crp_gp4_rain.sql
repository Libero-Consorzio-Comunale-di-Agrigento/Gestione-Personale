CREATE OR REPLACE PACKAGE GP4_rain IS
      FUNCTION  VERSIONE                RETURN VARCHAR2;
                PRAGMA RESTRICT_REFERENCES(VERSIONE,wnds,wnps);
      FUNCTION  GET_NI                 (p_ci in number) RETURN NUMBER ;
                PRAGMA RESTRICT_REFERENCES(GET_NI,wnds,wnps);
      FUNCTION  GET_NOMINATIVO         (p_ci in number) RETURN varchar2 ;
                PRAGMA RESTRICT_REFERENCES(GET_NOMINATIVO,wnds);
      FUNCTION  GET_NOME               (p_ci in number) RETURN varchar2 ;
                PRAGMA RESTRICT_REFERENCES(GET_NOME,wnds,wnps);
      FUNCTION  GET_COGNOME            (p_ci in number) RETURN varchar2 ;
                PRAGMA RESTRICT_REFERENCES(GET_COGNOME,wnds,wnps);
      FUNCTION  GET_RAPPORTO           (p_ci in number) RETURN varchar2 ;
                PRAGMA RESTRICT_REFERENCES(GET_RAPPORTO,wnds,wnps);
      FUNCTION  GET_DATA_NAS           (p_ci in number) RETURN date ;
                PRAGMA RESTRICT_REFERENCES(GET_DATA_NAS,wnds,wnps);
END GP4_rain;
/
CREATE OR REPLACE PACKAGE BODY GP4_rain AS
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 24/07/2002';
END VERSIONE;
--
FUNCTION GET_NI (P_CI in NUMBER) RETURN NUMBER IS
d_ni rapporti_individuali.NI%type;
/******************************************************************************
   NAME:       GET_NOME_COMPONENTE
   PURPOSE:    Restituire il numero individuale dato il CI
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        14/08/2002          1. Created this function.
******************************************************************************/
BEGIN
  BEGIN
  SELECT
       rain.ni
      into d_ni
       from rapporti_individuali rain
         where rain.ci =p_ci ;
   EXCEPTION
    when no_data_found then
          d_ni := to_number(null);
   when too_many_rows then
        d_ni := to_number(null);
   END;
RETURN d_ni;
END GET_NI;
--
FUNCTION GET_NOMINATIVO (P_CI in NUMBER) RETURN VARCHAR2 IS
d_nominativo varchar2(100);
/******************************************************************************
   NAME:       GET_NOMINATIVO
   PURPOSE:    Restituire il cognome e nome dell'individuo dato il CI
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        21/08/2002          1. Created this function.
******************************************************************************/
BEGIN
  BEGIN
  SELECT
       rain.cognome||'  '||rain.nome
      into d_nominativo
       from rapporti_individuali rain
         where rain.ci =p_ci ;
   EXCEPTION
    when no_data_found then
          d_nominativo := to_char(null);
   when too_many_rows then
        d_nominativo := to_char(null);
   END;
RETURN d_nominativo;
END GET_NOMINATIVO;
--
FUNCTION GET_NOME (P_CI in NUMBER) RETURN VARCHAR2 IS
d_nome varchar2(100);
/******************************************************************************
   NAME:       GET_NOME
   PURPOSE:    Restituire il  nome dell'individuo dato il CI
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        21/08/2002          1. Created this function.
******************************************************************************/
BEGIN
  BEGIN
  SELECT
       rain.nome
      into d_nome
       from rapporti_individuali rain
         where rain.ci =p_ci ;
   EXCEPTION
    when no_data_found then
          d_nome := to_char(null);
   when too_many_rows then
        d_nome := to_char(null);
   END;
RETURN d_nome;
END GET_NOME;
--
FUNCTION GET_COGNOME (P_CI in NUMBER) RETURN VARCHAR2 IS
d_COGNOME varchar2(100);
/******************************************************************************
   NAME:       GET_COGNOME
   PURPOSE:    Restituire il cognome dell'individuo dato il CI
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        21/08/2002          1. Created this function.
******************************************************************************/
BEGIN
  BEGIN
  SELECT
       rain.cognome
      into d_COGNOME
       from rapporti_individuali rain
         where rain.ci =p_ci ;
   EXCEPTION
    when no_data_found then
          d_COGNOME := to_char(null);
   when too_many_rows then
        d_COGNOME := to_char(null);
   END;
RETURN d_COGNOME;
END GET_COGNOME;
--
FUNCTION GET_RAPPORTO (P_CI in NUMBER) RETURN VARCHAR2 IS
d_RAPPORTO varchar2(100);
/******************************************************************************
   NAME:       GET_RAPPORTO
   PURPOSE:    Restituire il codice del RAPPORTO anagrafico dell'individuo dato il CI
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        21/08/2002          1. Created this function.
******************************************************************************/
BEGIN
  BEGIN
  SELECT
       rain.RAPPORTO
      into d_RAPPORTO
       from rapporti_individuali rain
         where rain.ci =p_ci ;
   EXCEPTION
    when no_data_found then
          d_RAPPORTO := to_char(null);
   when too_many_rows then
        d_RAPPORTO := to_char(null);
   END;
RETURN d_RAPPORTO;
END GET_RAPPORTO;
--
FUNCTION GET_DATA_NAS (P_CI in NUMBER) RETURN date IS
d_DATA_NAS date;
/******************************************************************************
   NAME:       GET_DATA_NAS
   PURPOSE:    Restituire la data di nascita dell'individuo dato il CI
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        21/08/2002          1. Created this function.
******************************************************************************/
BEGIN
  BEGIN
  SELECT
       rain.DATA_NAS
      into d_DATA_NAS
       from rapporti_individuali rain
         where rain.ci =p_ci ;
   EXCEPTION
    when no_data_found then
          d_DATA_NAS := to_date(null);
   when too_many_rows then
        d_DATA_NAS := to_date(null);
   END;
RETURN d_DATA_NAS;
END GET_DATA_NAS;
--
--
END GP4_rain;
/
