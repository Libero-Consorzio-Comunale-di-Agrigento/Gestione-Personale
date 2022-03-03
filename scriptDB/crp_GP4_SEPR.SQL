CREATE OR REPLACE PACKAGE GP4_SEPR IS
/******************************************************************************
 NOME:        GP4_SEPR
 DESCRIZIONE: <Descrizione Package>

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    25/11/2002 __     Prima emissione.
******************************************************************************/
       FUNCTION  VERSIONE                RETURN VARCHAR2;
                 PRAGMA RESTRICT_REFERENCES(VERSIONE,wnds,wnps);
       FUNCTION  GET_DESCRIZIONE  (p_codice in varchar2) RETURN varchar2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_DESCRIZIONE,wnds,wnps);
END GP4_SEPR;
/

CREATE OR REPLACE PACKAGE BODY GP4_SEPR AS
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
   RETURN 'V1.0 del 25/11/2002';
END VERSIONE;
--

FUNCTION GET_DESCRIZIONE (P_codice in varchar2) RETURN VARCHAR2 IS
d_DESCRIZIONE sedi_provvedimento.descrizione%type;
/******************************************************************************
   NAME:       GET_DESCRIZIONE
   PURPOSE:    Restituire la descrizione del provvedimento

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        25/11/2002                   1. Created this function.


******************************************************************************/
BEGIN
  BEGIN
  SELECT descrizione
	into d_DESCRIZIONE
    from sedi_provvedimento
   where codice = p_codice
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
END GP4_SEPR;
/* End Package Body: GP4_SEPR */
/

