CREATE OR REPLACE PACKAGE GP4_COVO IS 
/******************************************************************************
 NOME:        GP4_COVO
 DESCRIZIONE: <Descrizione Package>

 ANNOTAZIONI: -  
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    03/12/2002 __     Prima emissione.
******************************************************************************/
   FUNCTION  VERSIONE                RETURN VARCHAR2;
   FUNCTION  GET_DESCRIZIONE         (p_voce in varchar2, p_sub in varchar2, p_data in date) RETURN varchar2 ;
END GP4_COVO;
/

CREATE OR REPLACE PACKAGE BODY GP4_COVO AS
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
   RETURN 'V1.0 del 03/12/2002';
END VERSIONE;
--
FUNCTION GET_DESCRIZIONE (p_voce in varchar2, p_sub in varchar2, p_data in date) RETURN VARCHAR2 IS
d_DESCRIZIONE varchar2(120);
/******************************************************************************
   NAME:       GET_DESCRIZIONE
   PURPOSE:    Restituire la descrizione della voce contabile alla data
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        03/12/2002          1. Created this function.
******************************************************************************/
BEGIN
  BEGIN
  SELECT
       descrizione
	   into d_DESCRIZIONE
       from contabilita_voce covo
	      where covo.voce = p_voce
		    and covo.sub  = p_sub
			and p_data between nvl(covo.dal,to_date(2222222,'j'))
			               and nvl(covo.al,to_date(3333333,'j'))
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

END GP4_COVO;
/* End Package Body: GP4_COVO */
/
/ 

