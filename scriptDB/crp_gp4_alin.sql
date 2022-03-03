CREATE OR REPLACE PACKAGE GP4_ALIN IS
       FUNCTION  VERSIONE                RETURN VARCHAR2;
	   FUNCTION  GET_ALIQUOTA  (p_posizione_inail in varchar2,
	   			 			    p_anno in number,
								p_tipo_ipn in varchar2) RETURN number ;
/******************************************************************************
 NOME:        GP4_ALIN
 DESCRIZIONE: Funzioni sulla tabella ALIQUOTE_INAIL
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 1    07/08/2003 MM	
 1.1  17/02/2005 MM		Attività 9730
******************************************************************************/
END GP4_ALIN;
/
CREATE OR REPLACE PACKAGE BODY GP4_ALIN AS

FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 aliquota:    Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.1 del 17/02/2005';
END VERSIONE;
--

FUNCTION GET_ALIQUOTA (P_posizione_inail in varchar2, p_anno in number, p_tipo_ipn in varchar2) RETURN NUMBER IS
d_aliquota aliquote_inail.alq_effettiva%type;
/******************************************************************************
   NAME:       GET_aliquota
   PURPOSE:    Restituire la aliquota della posizione inail per l'anno e il tipo indicati

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        07/08/2003          
   1.1		  17/02/2005		  MM	   Attività 9730


******************************************************************************/
BEGIN
  BEGIN
  select distinct decode(p_tipo_ipn,'P',alq_presunta,'C',alq_effettiva)
  into d_aliquota
  from aliquote_inail alin,retribuzioni_inail rein
  where alin.posizione_inail=p_posizione_inail
  and alin.anno=p_anno
  and alin.posizione_inail=rein.posizione_inail
  and alin.anno=rein.anno;
   EXCEPTION
    when no_data_found then
	  	  d_aliquota := to_number(null);
	when too_many_rows then
		  d_aliquota := to_number(null);
   END;
RETURN d_aliquota;
END GET_ALIQUOTA;
--
END GP4_ALIN;
/
