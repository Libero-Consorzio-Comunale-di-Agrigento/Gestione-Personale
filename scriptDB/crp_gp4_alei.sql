CREATE OR REPLACE PACKAGE GP4_ALEI IS
       FUNCTION  VERSIONE                RETURN VARCHAR2;
                 PRAGMA RESTRICT_REFERENCES(VERSIONE,wnds,wnps);
	 FUNCTION  GET_ALIQUOTA  (p_esenzione in varchar2, p_anno in number) RETURN number ;
                 PRAGMA RESTRICT_REFERENCES(GET_ALIQUOTA,wnds,wnps);
END GP4_ALEI;
/
CREATE OR REPLACE PACKAGE BODY GP4_ALEI AS

FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 aliquota: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 07/08/2003';
END VERSIONE;
--

FUNCTION GET_ALIQUOTA (P_esenzione in varchar2, p_anno in number) RETURN NUMBER IS
d_aliquota aliquote_esenzione_inail.aliquota%type;
/******************************************************************************
   NAME:       GET_aliquota
   PURPOSE:    Restituire la aliquota della tipologia di esenzione

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        07/08/2003          1. Created this function.


******************************************************************************/
BEGIN
  BEGIN
  SELECT aliquota
	into d_aliquota
    from aliquote_esenzione_inail alin
   where alin.esenzione = p_esenzione
     and alin.anno      = p_anno
  ;

   EXCEPTION
    when no_data_found then
	  	  d_aliquota := to_char(null);
	when too_many_rows then
		  d_aliquota := to_char(null);
   END;
RETURN d_aliquota;
END GET_ALIQUOTA;
--
END GP4_ALEI;
/
