CREATE OR REPLACE PACKAGE GP4_ASTE IS
       FUNCTION  VERSIONE                RETURN VARCHAR2;
	   FUNCTION  GET_DESCRIZIONE  (p_assenza in varchar2) RETURN varchar2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_DESCRIZIONE,wnds);
	   FUNCTION  GET_SOSTITUIBILE (p_assenza in varchar2) RETURN varchar2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_SOSTITUIBILE,wnds);
END GP4_ASTE;
/
CREATE OR REPLACE PACKAGE BODY GP4_ASTE AS

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
   RETURN 'V2.0 del 07/06/2004';
END VERSIONE;
--

FUNCTION GET_DESCRIZIONE (P_assenza in varchar2) RETURN VARCHAR2 IS
d_DESCRIZIONE astensioni.descrizione%type;
/******************************************************************************
   NAME:       GET_DESCRIZIONE
   PURPOSE:    Restituire la descrizione della tipologia di assenza

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        26/08/2002          1. Created this function.


******************************************************************************/
BEGIN
  BEGIN
  SELECT descrizione
	into d_DESCRIZIONE
    from astensioni aste
   where aste.codice = p_assenza
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
FUNCTION GET_SOSTITUIBILE (P_assenza in varchar2) RETURN VARCHAR2 IS
d_sostituibile astensioni.sostituibile%type;
/******************************************************************************
   NAME:       GET_sostituibile
   PURPOSE:    Indica se l'assenza e sostituibile 

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        07/06/2004                   1. Created this function.


******************************************************************************/
BEGIN
  BEGIN
  SELECT sostituibile
	into d_sostituibile
    from astensioni aste
   where aste.codice = p_assenza
  ;

   EXCEPTION
    when no_data_found then
	  	  d_sostituibile := to_number(null);
	when too_many_rows then
		  d_sostituibile := to_number(null);
   END;
RETURN d_sostituibile;
END GET_sostituibile;
--
END GP4_ASTE;
/* End Package Body: GP4_ASTE */
/
