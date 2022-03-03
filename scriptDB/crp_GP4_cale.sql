CREATE OR REPLACE PACKAGE GP4_cale IS
       FUNCTION  GET_GIORNO  ( p_data in date, P_sede number) RETURN VARCHAR2;
       FUNCTION  VERSIONE              RETURN varchar2;
/******************************************************************************
   NAME:       GP4_cale
   PURPOSE:
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06/04/2007             1. Created this package.
******************************************************************************/
END GP4_cale;
/
CREATE OR REPLACE PACKAGE BODY GP4_cale AS
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
   RETURN 'V1.0 del 06/04/2007';
END VERSIONE;
--
FUNCTION GET_GIORNO  (p_data in date, P_sede number) RETURN VARCHAR2 IS
d_giorno  VARCHAR2(1);
/******************************************************************************
   NAME:       GET_GIORNO
   PURPOSE:    Determina il giorno in base alla data
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        06/04/2007          1. Created this function.
******************************************************************************/
BEGIN
  d_giorno := '*';
  begin
   select substr(max(cale.giorni),to_char(p_data,'dd'),1)
     into d_giorno
	 from calendari cale
	where cale.anno = to_char(p_data,'yyyy')
    and cale.mese = to_char(p_data,'mm')
    and cale.calendario = (select nvl(calendario,'*') from sedi where numero = P_sede)
   ;
   EXCEPTION
    when no_data_found then
	  begin
		 d_giorno := '*';
	  end;
    when too_many_rows then
	  begin
		 d_giorno := '*';
	  end;
  end;
  RETURN d_giorno;
END GET_GIORNO  ;
--
--
END GP4_cale;
/
