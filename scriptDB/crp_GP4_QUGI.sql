CREATE OR REPLACE PACKAGE GP4_QUGI IS
       FUNCTION  GET_CODICE          (p_numero in number, p_data in date) RETURN VARCHAR2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_CODICE,wnds,wnps);
       FUNCTION  GET_LIVELLO         (p_numero in number, p_data in date) RETURN VARCHAR2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_LIVELLO,wnds,wnps);
       FUNCTION  GET_CONTRATTO       (p_numero in number, p_data in date) RETURN VARCHAR2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_CONTRATTO,wnds,wnps);
       FUNCTION  GET_RUOLO           (p_numero in number, p_data in date) RETURN VARCHAR2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_RUOLO,wnds,wnps);
       FUNCTION  GET_DESCRIZIONE     (p_numero in number, p_data in date) RETURN VARCHAR2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_DESCRIZIONE,wnds,wnps);
       FUNCTION  GET_NUMERO          (p_codice in varchar2, p_data in date) RETURN NUMBER ;
                 PRAGMA RESTRICT_REFERENCES(GET_NUMERO,wnds,wnps);
       FUNCTION  VERSIONE              RETURN varchar2;
                 PRAGMA RESTRICT_REFERENCES(VERSIONE,wnds,wnps);
/******************************************************************************
   NAME:       GP4_QUGI
   PURPOSE:    To calculate the desired information.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        23/07/2002                   1. Created this package.
   1.1        29/12/2004  MM               Nuova function get_numero

   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:
   CALLED BY:
   CALLS:
   EXAMPLE USE:     NUMBER := GP4_QUGI.MyFuncName(Number);
                    GP4_QUGI.MyProcName(Number, Varchar2);
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:

   Here is the complete list of available Auto Replace Keywords:
      Object Name:     GP4_QUGI or GP4_QUGI
      Sysdate:         23/07/2002
      Date/Time:       23/07/2002 9.15.42
      Date:            23/07/2002
      Time:            9.15.42
      Username:         (set in TOAD Options, Procedure Editor)
******************************************************************************/
END GP4_QUGI;
/
CREATE OR REPLACE PACKAGE BODY GP4_QUGI AS
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
   RETURN 'V1.1 del 29/12/2004';
END VERSIONE;
--
FUNCTION GET_CODICE  (p_numero in number, p_data in date) RETURN VARCHAR2 IS
d_codice qualifiche_giuridiche.CODICE%TYPE;
/******************************************************************************
   NAME:       GET_CODICE
   PURPOSE:    Fornire il codice della figura dato il numero

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/08/2002          


******************************************************************************/
BEGIN
  d_codice := to_char(null);
  begin
   select codice
     into d_codice
	 from qualifiche_giuridiche
	where numero       = p_numero
	  and p_data between dal
	                 and nvl(al,to_date(3333333,'j'))
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
END GET_CODICE ;
--
FUNCTION GET_LIVELLO  (p_numero in number, p_data in date) RETURN VARCHAR2 IS
d_LIVELLO qualifiche_giuridiche.LIVELLO%TYPE;
/******************************************************************************
   NAME:       GET_CODICE
   PURPOSE:    Fornire il LIVELLO professionale della figura dato il numero

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/08/2002          


******************************************************************************/
BEGIN
  d_LIVELLO := to_char(null);
  begin
   select LIVELLO
     into d_LIVELLO
	 from qualifiche_giuridiche
	where numero       = p_numero
	  and p_data between dal
	                 and nvl(al,to_date(3333333,'j'))
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_LIVELLO := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_LIVELLO := to_char(null);
	  end;
  end;
  RETURN d_LIVELLO;
END GET_LIVELLO ;
--
FUNCTION GET_CONTRATTO  (p_numero in number, p_data in date) RETURN VARCHAR2 IS
d_contratto qualifiche_giuridiche.CONTRATTO%TYPE;
/******************************************************************************
   NAME:       GET_CONTRATTO
   PURPOSE:    Fornire il contratto della qualifica dato il numero

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        22/08/2002          


******************************************************************************/
BEGIN
  d_contratto := to_char(null);
  begin
   select contratto
     into d_contratto
	 from qualifiche_giuridiche
	where numero       = p_numero
	  and p_data between dal
	                 and nvl(al,to_date(3333333,'j'))
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_contratto := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_contratto := to_char(null);
	  end;
  end;
  RETURN d_contratto;
END GET_contratto ;
--
FUNCTION GET_RUOLO  (p_numero in number, p_data in date) RETURN VARCHAR2 IS
d_RUOLO qualifiche_giuridiche.RUOLO%TYPE;
/******************************************************************************
   NAME:       GET_CODICE
   PURPOSE:    Fornire il RUOLO professionale della figura dato il numero

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/08/2002          


******************************************************************************/
BEGIN
  d_RUOLO := to_char(null);
  begin
   select RUOLO
     into d_RUOLO
	 from qualifiche_giuridiche
	where numero       = p_numero
	  and p_data between dal
	                 and nvl(al,to_date(3333333,'j'))
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_RUOLO := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_RUOLO := to_char(null);
	  end;
  end;
  RETURN d_RUOLO;
END GET_RUOLO ;
--
FUNCTION GET_descrizione  (p_numero in number, p_data in date) RETURN VARCHAR2 IS
d_descrizione qualifiche_giuridiche.descrizione%TYPE;
/******************************************************************************
   NAME:       GET_DESCRIZIONE
   PURPOSE:    Fornire la descrizione della figura dato il numero

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/08/2002          


******************************************************************************/
BEGIN
  d_descrizione := to_char(null);
  begin
   select descrizione
     into d_descrizione
	 from qualifiche_giuridiche
	where numero       = p_numero
	  and p_data between dal
	                 and nvl(al,to_date(3333333,'j'))
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_descrizione := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_descrizione := to_char(null);
	  end;
  end;
  RETURN d_descrizione;
END GET_descrizione ;
--
FUNCTION GET_NUMERO (p_codice in varchar2, p_data in date) RETURN NUMBER IS
d_numero qualifiche_giuridiche.numero%TYPE;
/******************************************************************************
   NAME:       GET_DESCRIZIONE
   PURPOSE:    Fornire il numero della qualifica dato il codice
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        11/08/2004
******************************************************************************/
BEGIN
  d_numero := to_number(null);
  begin
   select numero
     into d_numero
	 from qualifiche_giuridiche
	where codice       = p_codice
	  and p_data between dal
	                 and nvl(al,to_date(3333333,'j'))
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_numero := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_numero := to_number(null);
	  end;
  end;
  RETURN d_numero;
END GET_NUMERO ;
--
END GP4_QUGI;
/
