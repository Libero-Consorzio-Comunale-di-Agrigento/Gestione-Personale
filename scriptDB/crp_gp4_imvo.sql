CREATE OR REPLACE PACKAGE GP4_IMVO IS
       FUNCTION  GET_MINIMALE_GG  ( p_voce in varchar2, p_data in date
                                  , p_categoria in number, p_tipo in varchar2) RETURN NUMBER ;
       FUNCTION  VERSIONE              RETURN varchar2;
/******************************************************************************
   NAME:       GP4_IMVO
   PURPOSE:    To calculate the desired information.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        13/08/2003             1. Created this package.

******************************************************************************/
END GP4_IMVO;
/
CREATE OR REPLACE PACKAGE BODY GP4_IMVO AS


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
FUNCTION GET_MINIMALE_GG  ( p_voce in varchar2, p_data in date
                          , p_categoria in number, p_tipo in varchar2) RETURN NUMBER IS
d_minimale imponibili_voce.MIN_GG_1%TYPE;
/******************************************************************************
   NAME:       GET_MINIMALE_GG
   PURPOSE:    Determina il minimale in base alla categoria

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        13/08/2003          1. Created this function.


******************************************************************************/
BEGIN
  d_minimale := to_number(null);
  begin
   select decode( p_categoria
                 ,1,decode( p_tipo,'PT',MIN_GG_1_PT
				                       ,MIN_GG_1
						  )
                 ,2,decode( p_tipo,'PT',MIN_GG_2_PT
				                       ,MIN_GG_2
						  )
                 ,3,decode( p_tipo,'PT',MIN_GG_3_PT
				                       ,MIN_GG_3
						  )
                   ,decode( p_tipo,'PT',MIN_GG_PT
				                       ,MIN_GG
						  )
				)
     into d_minimale
	 from imponibili_voce
	where voce         = p_voce
	  and p_data between nvl(dal,to_date(2222222,'j'))
	                 and nvl(al,to_date(3333333,'j'))
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_minimale := to_number(null);
	  end;
    when too_many_rows then
	  begin
		d_minimale := to_number(null);
	  end;
  end;
  RETURN d_minimale;
END GET_MINIMALE_GG ;
--
--
END GP4_IMVO;
/
