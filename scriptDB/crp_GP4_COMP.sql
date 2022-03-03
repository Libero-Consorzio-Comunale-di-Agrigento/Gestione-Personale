CREATE OR REPLACE PACKAGE GP4_COMP IS
       FUNCTION  VERSIONE              RETURN varchar2;
       FUNCTION  GET_DAL              (p_componente in number) RETURN date;
       FUNCTION  GET_DAL_MAX          (p_ni in number,p_unita_ni in number) RETURN date;
/******************************************************************************

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0       05/08/2002             1. Created this package.
   2.0       13/06/2007             2. Function get_dal_max


   Here is the complete list of available Auto Replace Keywords:
      Object Name:     GP4_COMP or GP4_COMP
      Sysdate:         05/08/2002
      Date/Time:       05/08/2002 11.37.45
      Date:            05/08/2002
      Time:            11.37.45
      Username:         (set in TOAD Options, Procedure Editor)
******************************************************************************/
END GP4_COMP;
/

CREATE OR REPLACE PACKAGE BODY GP4_COMP AS

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
   RETURN 'V2.0 del 13/06/2007';
END VERSIONE;

FUNCTION GET_DAL (p_componente in NUMBER) RETURN date IS
d_dal date;
/******************************************************************************
   NAME:       GET_NDENOMINAZIONE_LIVELLO
   PURPOSE:    Restituire max(dal) del componente

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/08/2002          1. Created this function.


******************************************************************************/
BEGIN
  BEGIN
   select max(dal)
     into d_dal
     from componenti comp
    where comp.componente = p_componente
   ;
   EXCEPTION
    when no_data_found then
	  	  d_dal := to_date(null);
		  RETURN d_dal;
	when too_many_rows then
	  	  d_dal := to_date(null);
	      RETURN d_dal;
   END;
RETURN d_dal;
END GET_DAL;
--
FUNCTION GET_DAL_MAX (p_ni in NUMBER,p_unita_ni in NUMBER) RETURN date IS
d_dal date;
/******************************************************************************
   NAME:       GET_DAL_MAX
   PURPOSE:    Restituire max(dal) dell'ni

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   2.0        13/06/2007   CB              2. Created this function.


******************************************************************************/
BEGIN
  BEGIN
   select max(dal)
     into d_dal
     from componenti comp
    where (comp.ni = p_ni and comp.unita_ni=p_unita_ni)
           or   
          (comp.ni = p_ni and p_unita_ni is null)
   ;
   EXCEPTION
    when no_data_found then
	  	  d_dal := to_date(null);
		  RETURN d_dal;
	when too_many_rows then
	  	  d_dal := to_date(null);
	      RETURN d_dal;
   END;
RETURN d_dal;
END GET_DAL_MAX;


END GP4_COMP;
/

