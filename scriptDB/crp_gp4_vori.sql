CREATE OR REPLACE PACKAGE GP4_VORI IS
       FUNCTION  VERSIONE                RETURN VARCHAR2;
                 PRAGMA RESTRICT_REFERENCES(VERSIONE,wnds,wnps);
	   FUNCTION  GET_DESCRIZIONE  (p_voce in varchar2) RETURN varchar2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_DESCRIZIONE,wnds,wnps);
END GP4_VORI;
/
CREATE OR REPLACE PACKAGE BODY GP4_VORI AS

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
   RETURN 'V1.0 del 08/08/2003';
END VERSIONE;
--

FUNCTION GET_DESCRIZIONE (P_voce in varchar2) RETURN VARCHAR2 IS
d_DESCRIZIONE voci_rischio_inail.descrizione%type;
/******************************************************************************
   NAME:       GET_DESCRIZIONE
   PURPOSE:    Restituire la descrizione della voce di rischio

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        08/08/2003          1. Created this function.


******************************************************************************/
BEGIN
  BEGIN
  SELECT descrizione
	into d_DESCRIZIONE
    from voci_rischio_inail vori
   where vori.VOCE_RISCHIO     = p_voce
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
END GP4_VORI;
/
