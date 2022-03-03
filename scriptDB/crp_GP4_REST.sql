CREATE OR REPLACE PACKAGE GP4_REST IS
       FUNCTION  GET_DAL               (p_revisione number) RETURN date ;
                 PRAGMA RESTRICT_REFERENCES(GET_DAL,wnds,wnps);
       FUNCTION  GET_AL                (p_revisione number) RETURN date ;
                 PRAGMA RESTRICT_REFERENCES(GET_DAL,wnds,wnps);
       FUNCTION  GET_DAL_REST_ATTIVA   (p_ottica varchar2) RETURN date ;
                 PRAGMA RESTRICT_REFERENCES(GET_DAL_REST_ATTIVA,wnds,wnps);
       FUNCTION  GET_DAL_REST_MODIFICA (p_ottica varchar2) RETURN date ;
                 PRAGMA RESTRICT_REFERENCES(GET_DAL_REST_MODIFICA,wnds,wnps);
       FUNCTION  GET_DATA_REST_MODIFICA (p_ottica varchar2) RETURN date ;
                 PRAGMA RESTRICT_REFERENCES(GET_DATA_REST_MODIFICA,wnds);
       FUNCTION  GET_DAL_REST_OBSOLETA (p_ottica varchar2) RETURN date ;
                 PRAGMA RESTRICT_REFERENCES(GET_DAL_REST_OBSOLETA,wnds);
       FUNCTION  GET_STATO             (p_ottica varchar2, p_revisione varchar2) RETURN varchar2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_STATO,wnds,wnps);
       FUNCTION  VERSIONE                                  RETURN varchar2;
                 PRAGMA RESTRICT_REFERENCES(VERSIONE,wnds,wnps);
/******************************************************************************
   NAME:       GP4_REST
   PURPOSE:    To calculate the desired information.
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        01/08/2002                   1. Created this package.
   1.1        06/07/2007  MS               Aggiunta function get_al
   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:
   CALLED BY:
   CALLS:
   EXAMPLE USE:     NUMBER := GP4_REST.MyFuncName(Number);
                    GP4_REST.MyProcName(Number, Varchar2);
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:
   Here is the complete list of available Auto Replace Keywords:
      Object Name:     GP4_REST or GP4_REST
      Sysdate:         01/08/2002
      Date/Time:       01/08/2002 7.58.13
      Date:            01/08/2002
      Time:            7.58.13
      Username:         (set in TOAD Options, Procedure Editor)
******************************************************************************/
END GP4_REST;
/
CREATE OR REPLACE PACKAGE BODY GP4_REST AS
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
   RETURN 'V1.1 del 06/03/2007';
END VERSIONE;
--
FUNCTION GET_DAL (p_revisione number) RETURN date IS
d_dal revisioni_struttura.dal%TYPE;
/******************************************************************************
   NAME:       GET_DAL
   PURPOSE:    Fornire la data di inizio validita della revisione fornita
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          1. Created this function.
   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:  VARCHAR
   CALLED BY:
   CALLS:
   EXAMPLE USE:     VARCHAR := GET_DAL();
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:
******************************************************************************/
BEGIN
  d_dal := to_date(null);
  begin
   select dal
     into d_dal
    from revisioni_struttura
   where revisione = p_revisione
     and ottica    = 'GP4'
   ;
   EXCEPTION
    when no_data_found then
     begin
      d_dal := to_date(null);
     end;
    when too_many_rows then
     begin
      d_dal := to_date(null);
     end;
  end;
  RETURN d_dal;
END GET_DAL ;
--
FUNCTION GET_AL (p_revisione number) RETURN date IS
d_al revisioni_struttura.dal%TYPE;
/******************************************************************************
   NAME:       GET_AL
   PURPOSE:    Fornire la data di fine validita della revisione fornita
               che equivale al dal della revisione successiva - 1 
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/03/2007  MS               1. Created this function.
   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:  DATE
   CALLED BY:
   CALLS:
   EXAMPLE USE:     DATE := GET_AL();
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:
******************************************************************************/
BEGIN
  d_al := to_date(null);
  begin
   select dal-1
     into d_al
    from revisioni_struttura
   where dal = ( select min(dal) 
                   from revisioni_struttura 
                  where dal > gp4_rest.get_dal(p_revisione)
                    and ottica    = 'GP4'
               )
     and ottica    = 'GP4'
   ;
   EXCEPTION
    when no_data_found then
     begin
      d_al := to_date(null);
     end;
    when too_many_rows then
     begin
      d_al := to_date(null);
     end;
  end;
  RETURN d_al;
END GET_AL ;
--
FUNCTION GET_DAL_REST_ATTIVA (p_ottica varchar2) RETURN date IS
d_dal revisioni_struttura.dal%TYPE;
/******************************************************************************
   NAME:       GET_DAL_REST_ATTIVA
   PURPOSE:    Fornire la data di inizio validita della revisione attiva
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          1. Created this function.
   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:  VARCHAR
   CALLED BY:
   CALLS:
   EXAMPLE USE:     VARCHAR := GET_DAL();
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:
******************************************************************************/
BEGIN
  d_dal := to_date(null);
  begin
   select dal
     into d_dal
    from revisioni_struttura
   where stato   = 'A'
     and ottica  = p_ottica
   ;
   EXCEPTION
    when no_data_found then
     begin
      d_dal := to_date(null);
     end;
    when too_many_rows then
     begin
      d_dal := to_date(null);
     end;
  end;
  RETURN d_dal;
END GET_DAL_REST_ATTIVA ;
--
FUNCTION GET_DAL_REST_MODIFICA (p_ottica varchar2) RETURN date IS
d_dal revisioni_struttura.dal%TYPE;
/******************************************************************************
   NAME:       GET_DAL_REST_ATTIVA
   PURPOSE:    Fornire la data di inizio validita della revisione in modifica
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          1. Created this function.
   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:  VARCHAR
   CALLED BY:
   CALLS:
   EXAMPLE USE:     VARCHAR := GET_DAL();
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:
******************************************************************************/
BEGIN
  d_dal := to_date(null);
  begin
   select dal
     into d_dal
    from revisioni_struttura
   where stato   = 'M'
     and ottica  = p_ottica
   ;
   EXCEPTION
    when no_data_found then
     begin
      d_dal := to_date(null);
     end;
    when too_many_rows then
     begin
      d_dal := to_date(null);
     end;
  end;
  RETURN d_dal;
END GET_DAL_REST_MODIFICA ;
--
FUNCTION GET_DATA_REST_MODIFICA (p_ottica varchar2) RETURN date IS
d_DATA revisioni_struttura.DATA%TYPE;
/******************************************************************************
   NAME:       GET_DATA_REST_ATTIVA
   PURPOSE:    Fornire la data di inizio validita della revisione in modifica
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          1. Created this function.
   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:  VARCHAR
   CALLED BY:
   CALLS:
   EXAMPLE USE:     VARCHAR := GET_DATA();
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:
******************************************************************************/
BEGIN
  d_DATA := to_date(null);
  begin
   select DATA
     into d_DATA
    from revisioni_struttura
   where stato   = 'M'
     and ottica  = p_ottica
   ;
   EXCEPTION
    when no_data_found then
     begin
      d_DATA := to_date(null);
     end;
    when too_many_rows then
     begin
      d_DATA := to_date(null);
     end;
  end;
  RETURN d_DATA;
END GET_DATA_REST_MODIFICA ;
--
FUNCTION GET_DAL_REST_OBSOLETA (p_ottica varchar2) RETURN date IS
d_dal revisioni_struttura.dal%TYPE;
/******************************************************************************
   NAME:       GET_DAL_REST_ATTIVA
   PURPOSE:    Fornire la data di inizio validita della revisione obsoleta
               piu recente
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/08/2002          1. Created this function.
******************************************************************************/
BEGIN
  d_dal := to_date(null);
  begin
   select max(dal)
     into d_dal
    from revisioni_struttura
   where stato   = 'O'
     and ottica  = p_ottica
   ;
   EXCEPTION
    when no_data_found then
     begin
      d_dal := to_date(null);
     end;
    when too_many_rows then
     begin
      d_dal := to_date(null);
     end;
  end;
  RETURN d_dal;
END GET_DAL_REST_OBSOLETA ;
--
FUNCTION GET_STATO (p_ottica varchar2 , p_revisione varchar2) RETURN varchar2 IS
d_stato revisioni_struttura.stato%TYPE;
/******************************************************************************
   NAME:       GET_DAL_REST_ATTIVA
   PURPOSE:    Fornire lo stato della revisione data
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/08/2002          1. Created this function.
******************************************************************************/
BEGIN
  d_stato := to_char(null);
  begin
   select stato
     into d_stato
    from revisioni_struttura
   where revisione = p_revisione
     and ottica    = p_ottica
   ;
   EXCEPTION
    when no_data_found then
     begin
      d_stato := to_char(null);
     end;
    when too_many_rows then
     begin
      d_stato := to_char(null);
     end;
  end;
  RETURN d_stato;
END GET_STATO ;
--
END GP4_REST;
/
