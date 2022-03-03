CREATE OR REPLACE PACKAGE GP4_COMU IS
/******************************************************************************
 NOME:        GP4_COMU
 DESCRIZIONE: Funzioni su COMUNI

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    03/09/2002 __     Prima emissione.
******************************************************************************/
       FUNCTION  VERSIONE                RETURN VARCHAR2;
	   FUNCTION  GET_DESCRIZIONE      (p_provincia in number, p_comune in number) RETURN varchar2 ;
	   FUNCTION  GET_SIGLA_PROVINCIA  (p_provincia in number, p_comune in number) RETURN varchar2 ;
END GP4_COMU;
/

CREATE OR REPLACE PACKAGE BODY GP4_COMU AS

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
   RETURN 'V1.0 del 03/09/2002';
END VERSIONE;
--
FUNCTION GET_DESCRIZIONE (p_provincia in number, p_comune in number) RETURN VARCHAR2 IS
d_DESCRIZIONE comuni.descrizione%type;
/******************************************************************************
   NAME:       GET_DESCRIZIONE
   PURPOSE:    Restituire la descrizione del comune dati codici istat di provincia
               e comune

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03/09/2002  				             1. Created this function.


******************************************************************************/
BEGIN
  BEGIN
  SELECT descrizione
	into d_DESCRIZIONE
    from comuni comu
   where cod_provincia = p_provincia
     and cod_comune    = p_comune
  ;

   EXCEPTION
    when no_data_found then
	  	  d_DESCRIZIONE := to_char(null);
	when too_many_rows then
		  d_DESCRIZIONE := to_char(null);
   END;
RETURN d_DESCRIZIONE;
END GET_DESCRIZIONE;
--
FUNCTION GET_SIGLA_PROVINCIA (p_provincia in number, p_comune in number) RETURN VARCHAR2 IS
d_SIGLA_PROVINCIA comuni.SIGLA_PROVINCIA%type;
/******************************************************************************
   NAME:       GET_SIGLA_PROVINCIA
   PURPOSE:    Restituire la SIGLA_PROVINCIA del comune dati codici istat di provincia
               e comune

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03/09/2002  				             1. Created this function.


******************************************************************************/
BEGIN
  BEGIN
  SELECT SIGLA_PROVINCIA
	into d_SIGLA_PROVINCIA
    from comuni comu
   where cod_provincia = p_provincia
     and cod_comune    = p_comune
  ;

   EXCEPTION
    when no_data_found then
	  	  d_SIGLA_PROVINCIA := to_char(null);
	when too_many_rows then
		  d_SIGLA_PROVINCIA := to_char(null);
   END;
RETURN d_SIGLA_PROVINCIA;
END GET_SIGLA_PROVINCIA;
--

END GP4_COMU;
/* End Package Body: GP4_COMU */
/

