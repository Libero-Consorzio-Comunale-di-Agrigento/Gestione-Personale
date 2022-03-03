CREATE OR REPLACE PACKAGE GP4_REDO IS
       FUNCTION  GET_DAL (p_revisione number)              RETURN date ;
                 PRAGMA RESTRICT_REFERENCES(GET_DAL,wnds,wnps);
       FUNCTION  GET_REVISIONE (p_data date)               RETURN number ;
                 PRAGMA RESTRICT_REFERENCES(GET_REVISIONE,wnds,wnps);
       FUNCTION  GET_PROVVEDIMENTO (p_revisione number)    RETURN varchar2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_PROVVEDIMENTO,wnds,wnps);
       FUNCTION  GET_DESCRIZIONE_REVISIONE (p_revisione number)    RETURN varchar2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_DESCRIZIONE_REVISIONE,wnds,wnps);
       FUNCTION  GET_DAL_REDO_ATTIVA    RETURN date ;
                 PRAGMA RESTRICT_REFERENCES(GET_DAL_REDO_ATTIVA,wnds,wnps);
       FUNCTION  GET_DAL_REDO_MODIFICA  RETURN date ;
                 PRAGMA RESTRICT_REFERENCES(GET_DAL_REDO_MODIFICA,wnds,wnps);
       FUNCTION  GET_DAL_REDO_OBSOLETA  RETURN date ;
                 PRAGMA RESTRICT_REFERENCES(GET_DAL_REDO_OBSOLETA,wnds,wnps);
       FUNCTION  GET_DATA_REDO_MODIFICA  RETURN date ;
                 PRAGMA RESTRICT_REFERENCES(GET_DATA_REDO_MODIFICA,wnds,wnps);
       FUNCTION  VERSIONE                                  RETURN varchar2;
                 PRAGMA RESTRICT_REFERENCES(VERSIONE,wnds,wnps);
/******************************************************************************
   NAME:       GP4_REDO
   PURPOSE:    To calculate the desired information.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        12/08/2002                   1. Created this package.
   1.1        29/12/2004  MM               Nuova function get_revisione
   1.2        23/08/2007  CB               Nuova function get_data_redo_modifica

******************************************************************************/
END GP4_REDO;
/
CREATE OR REPLACE PACKAGE BODY GP4_REDO AS

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
   RETURN 'V1.2 del 23/08/2007';
END VERSIONE;
--
FUNCTION GET_DAL (p_revisione number) RETURN date IS
d_dal REVISIONI_DOTAZIONE.dal%TYPE;
/******************************************************************************
   NAME:       GET_DAL
   PURPOSE:    Fornire la data di inizio validita della revisione

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          


******************************************************************************/
BEGIN
  d_dal := to_date(null);
  begin
   select dal
     into d_dal
	 from REVISIONI_DOTAZIONE
	where revisione = p_revisione
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
END GET_DAL;
--
FUNCTION GET_PROVVEDIMENTO (p_revisione number) RETURN varchar2 IS
d_provvedimento varchar2(60);
/******************************************************************************
   NAME:       GET_PROVVEDIMENTO
   PURPOSE:    Fornire il provvedimento deliberativo della revisione

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        22/11/2002                   


******************************************************************************/
BEGIN
  d_provvedimento := to_char(null);
  begin
   select nvl(gp4_sepr.get_descrizione(sede_del),'Provv.')||' '||
          sede_del||
		  ' num. '||numero_del||
		  ' Anno '||anno_del provvedimento
     into d_provvedimento
	 from REVISIONI_DOTAZIONE
	where revisione = p_revisione
	  and numero_del is not null
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_provvedimento := to_char(null);
	  end;
    when too_many_rows then
	  begin
		d_provvedimento := to_char(null);
	  end;
  end;
  RETURN d_provvedimento;
END GET_provvedimento;
--
FUNCTION GET_DAL_REDO_ATTIVA  RETURN date IS
d_dal REVISIONI_DOTAZIONE.dal%TYPE;
/******************************************************************************
   NAME:       GET_DAL_REDO_ATTIVA
   PURPOSE:    Fornire la data di inizio validita della revisione attiva

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          


******************************************************************************/
BEGIN
  d_dal := to_date(null);
  begin
   select dal
     into d_dal
	 from REVISIONI_DOTAZIONE
	where stato   = 'A'
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
END GET_DAL_REDO_ATTIVA ;
--
FUNCTION GET_DAL_REDO_MODIFICA  RETURN date IS
d_dal REVISIONI_DOTAZIONE.dal%TYPE;
/******************************************************************************
   NAME:       GET_DAL_REDO_ATTIVA
   PURPOSE:    Fornire la data di inizio validita della revisione in modifica

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        18/07/2002          


******************************************************************************/
BEGIN
  d_dal := to_date(null);
  begin
   select dal
     into d_dal
	 from REVISIONI_DOTAZIONE
	where stato   = 'M'
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
END GET_DAL_REDO_MODIFICA ;
--
FUNCTION GET_DATA_REDO_MODIFICA  RETURN date IS
d_data REVISIONI_DOTAZIONE.data%TYPE;
/******************************************************************************
   NAME:       GET_DATA_REDO_MODIFICA
   PURPOSE:    Fornire la data della revisione in modifica

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        23/08/2007         
******************************************************************************/
BEGIN
  d_data := to_date(null);
  begin
   select data
     into d_data
	 from REVISIONI_DOTAZIONE
	where stato   = 'M'
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_data := to_date(null);
	  end;
    when too_many_rows then
	  begin
		d_data := to_date(null);
	  end;
  end;
  RETURN d_data;
END GET_DATA_REDO_MODIFICA ;
--
FUNCTION GET_DAL_REDO_OBSOLETA  RETURN date IS
d_dal REVISIONI_DOTAZIONE.dal%TYPE;
/******************************************************************************
   NAME:       GET_DAL_REDO_ATTIVA
   PURPOSE:    Fornire la data di inizio validita della revisione obsoleta
               piu recente

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        05/08/2002          

******************************************************************************/
BEGIN
  d_dal := to_date(null);
  begin
   select max(dal)
     into d_dal
	 from REVISIONI_DOTAZIONE
	where stato   = 'O'
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
END GET_DAL_REDO_OBSOLETA ;
--
FUNCTION GET_DESCRIZIONE_REVISIONE (p_revisione number) RETURN varchar2 IS
d_descrizione varchar2(60);
/******************************************************************************
   NAME:       GET_DESCRIZIONE_REVISIONE
   PURPOSE:    Fornire la descrizione della revisione

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        02/12/2002                   


******************************************************************************/
BEGIN
  d_descrizione := to_char(null);
  begin
   select descrizione
     into d_descrizione
	 from REVISIONI_DOTAZIONE
	where revisione = p_revisione
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
END GET_DESCRIZIONE_REVISIONE;
--
FUNCTION  GET_REVISIONE (p_data date) RETURN number IS
d_revisione REVISIONI_DOTAZIONE.REVISIONE%TYPE;
/******************************************************************************
   NAME:       GET_DAL
   PURPOSE:    Fornire la revisione di dotazione valida alla data indicata
   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        10/08/2004                   
******************************************************************************/
BEGIN
  d_revisione := to_number(null);
  begin
   select revisione
     into d_revisione
	 from REVISIONI_DOTAZIONE
	where dal = (select max(dal)
	               from revisioni_dotazione
				  where dal <= p_data
				)
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_revisione := to_number(null);
	  end;
    when too_many_rows then
	  begin
		d_revisione := to_number(null);
	  end;
  end;
  RETURN d_revisione;
END GET_REVISIONE;
--
END GP4_REDO;
/
