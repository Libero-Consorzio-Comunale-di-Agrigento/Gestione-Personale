CREATE OR REPLACE PACKAGE GP4_QUAL IS
       FUNCTION  GET_QUA_INPS          (p_numero in number) RETURN VARCHAR2 ;
       FUNCTION  GET_CAT_MINIMALE      (p_numero in number) RETURN VARCHAR2 ;
       FUNCTION  VERSIONE              RETURN varchar2;
/******************************************************************************
   NAME:       GP4_QUAL
   PURPOSE:    To calculate the desired information.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        13/08/2003             1. Created this package.

******************************************************************************/
END GP4_QUAL;
/
CREATE OR REPLACE PACKAGE BODY GP4_QUAL AS


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
   RETURN 'V1.0 del 13/08/2003';
END VERSIONE;
--
FUNCTION GET_QUA_INPS  (p_numero in number) RETURN VARCHAR2 IS
d_codice qualifiche.QUA_INPS%TYPE;
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
  d_codice := to_number(null);
  begin
   select qua_inps
     into d_codice
	 from qualifiche
	where numero       = p_numero
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_codice := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_codice := to_char(null);
	  end;
  end;
  RETURN d_codice;
END GET_QUA_INPS ;
--
FUNCTION GET_CAT_MINIMALE  (p_numero in number) RETURN VARCHAR2 IS
d_categoria qualifiche.cat_minimale%TYPE;
/******************************************************************************
   NAME:       GET_CAT_MINIMALE
   PURPOSE:    Fornire la categoria di minimale contributivo della qualifica

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        13/08/2003          1. Created this function.


******************************************************************************/
BEGIN
  d_categoria := to_number(null);
  begin
   select cat_minimale
     into d_categoria
	 from qualifiche
	where numero       = p_numero
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_categoria := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_categoria := to_char(null);
	  end;
  end;
  RETURN d_categoria;
END GET_CAT_MINIMALE ;
--
--
END GP4_QUAL;
/
