CREATE OR REPLACE PACKAGE GP4_SUST IS
       FUNCTION  GET_SEQUENZA      (p_livello in varchar2,p_ottica in varchar2)                  RETURN number ;
                 PRAGMA RESTRICT_REFERENCES(GET_SEQUENZA,wnds,wnps);
       FUNCTION  GET_SUCCESSIVA    (p_suddivisione in varchar2) RETURN varchar2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_SUCCESSIVA,wnds,wnps);
       FUNCTION  GET_LIVELLO       (p_suddivisione in varchar2) RETURN number ;
                 PRAGMA RESTRICT_REFERENCES(GET_LIVELLO,wnds,wnps);
       FUNCTION  GET_SUDDIVISIONE  (p_livello in number) RETURN varchar2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_SUDDIVISIONE,wnds,wnps);
       FUNCTION  VERSIONE                                RETURN varchar2;
                 PRAGMA RESTRICT_REFERENCES(VERSIONE,wnds,wnps);
/******************************************************************************
   NAME:       GP4_SUST
   PURPOSE:    To calculate the desired information.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        25/07/2002
   1.1        22/10/2004                   Introdotta function get_suddivisione
******************************************************************************/
END GP4_SUST;
/
CREATE OR REPLACE PACKAGE BODY GP4_SUST AS
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
   RETURN 'V1.0 del 25/07/2002';
END VERSIONE;
--
FUNCTION GET_SEQUENZA  (p_livello in varchar2,p_ottica in varchar2) RETURN number IS
d_sequenza suddivisioni_struttura.sequenza%TYPE;
/******************************************************************************
   NAME:       GET_SEQUENZA
   PURPOSE:    Fornire la sequenza di ordinamento del livello di suddivisione
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          1. Created this function.

******************************************************************************/
BEGIN
  d_sequenza := to_number(null);
  begin
   select sequenza
     into d_sequenza
	 from suddivisioni_struttura
	where livello = p_livello
	  and ottica  = p_ottica
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_sequenza := to_number(null);
	  end;
    when too_many_rows then
	  begin
		d_sequenza := to_number(null);
	  end;
  end;
  RETURN d_sequenza;
END GET_SEQUENZA ;
--
FUNCTION GET_SUCCESSIVA  (p_suddivisione in varchar2) RETURN varchar2 IS
d_suddivisione suddivisioni_struttura.livello%TYPE;
/******************************************************************************
   NAME:       GET_SEQUENZA
   PURPOSE:    Fornire la suddivisione successiva a quella data
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        13/08/2002          1. Created this function.
******************************************************************************/
BEGIN
  d_suddivisione := to_char(null);
  begin
   select livello
     into d_suddivisione
	 from suddivisioni_struttura
	where sequenza = (select min(sequenza)
	                    from suddivisioni_struttura
					   where sequenza > get_sequenza (p_suddivisione,'GP4')
					     and ottica   = 'GP4'
					 )
	  and ottica  = 'GP4'
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_suddivisione := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_suddivisione := to_char(null);
	  end;
  end;
  RETURN d_suddivisione;
END GET_SUCCESSIVA ;
--
FUNCTION GET_LIVELLO  (p_suddivisione in varchar2) RETURN number IS
d_livello number;
/******************************************************************************
   NAME:       GET_SEQUENZA
   PURPOSE:    Fornire il livello di profondita della suddivisione di struttura
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        13/08/2002          1. Created this function.
******************************************************************************/
BEGIN
  d_livello := to_number(null);
  begin
   select count(*)
     into d_livello
	 from suddivisioni_struttura sust
	where ottica    = 'GP4'
      and sequenza  < (select sequenza
	                     from suddivisioni_struttura
						where livello = p_suddivisione
						  and ottica  = 'GP4'
					  )
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_livello := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_livello := to_char(null);
	  end;
  end;
  RETURN d_livello;
END GET_LIVELLO ;
--
FUNCTION GET_SUDDIVISIONE  (p_livello in number) RETURN varchar2 IS
d_suddivisione SUDDIVISIONI_STRUTTURA.livello%type;
/******************************************************************************
   NAME:       GET_SUDDIVISIONE
   PURPOSE:    Determina la suddivisione che si trova al livello di profindita
               dato
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        16/08/2004
******************************************************************************/
BEGIN
  d_suddivisione := to_char(null);
  begin
   select min(livello)
     into d_suddivisione
	 from suddivisioni_struttura sust
	where ottica    = 'GP4'
      and get_livello (livello) = p_livello
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_suddivisione := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_suddivisione := to_char(null);
	  end;
  end;
  RETURN d_suddivisione;
END GET_SUDDIVISIONE ;
--
END GP4_SUST;
/
