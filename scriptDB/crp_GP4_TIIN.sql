CREATE OR REPLACE PACKAGE GP4_TIIN IS
/******************************************************************************
 NOME:        GP4_TIIN
 DESCRIZIONE: funzioni sulla tabella tipi_incarico

 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    03/09/2002 __     Prima emissione.
******************************************************************************/
       FUNCTION  GET_DESCRIZIONE     (p_incarico in varchar2) RETURN varchar2 ;
       FUNCTION  GET_SE_RESPONSABILE (p_incarico in varchar2) RETURN varchar2 ;
       FUNCTION  VERSIONE                                   RETURN varchar2;
END GP4_TIIN;
/

CREATE OR REPLACE PACKAGE BODY GP4_TIIN AS

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
   RETURN 'V1.0 del 03/09/2002';
END VERSIONE;
--
FUNCTION GET_DESCRIZIONE  (p_incarico in varchar2) RETURN varchar2 IS
d_descrizione tipi_incarico.descrizione%TYPE;
/******************************************************************************
   NAME:       GET_DESCRIZIONE
   PURPOSE:    Fornire la descrizione del tipo di incarico

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        13/08/2002          1. Created this function.

   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:  VARCHAR

******************************************************************************/
BEGIN
  d_descrizione := to_char(null);
  begin
   select descrizione
     into d_descrizione
	 from tipi_incarico
	where incarico = p_incarico
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
END GET_DESCRIZIONE ;
--
FUNCTION GET_SE_RESPONSABILE  (p_incarico in varchar2) RETURN varchar2 IS
d_se_responsabile tipi_incarico.responsabile%TYPE;
/******************************************************************************
   NAME:       GET_SE_RESPONSABILE
   PURPOSE:    Fornire l'indicazione di responsabilita dell'incarico dato

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        13/08/2002          1. Created this function.

   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:  VARCHAR

******************************************************************************/
BEGIN
  d_se_responsabile := 'NO';
  begin
   select responsabile
     into d_se_responsabile
	 from tipi_incarico
	where incarico = p_incarico
   ;
   EXCEPTION
    when no_data_found then
	  begin
		d_se_responsabile := 'NO';
	  end;
    when too_many_rows then
	  begin
		d_se_responsabile := to_char(null);
	  end;
  end;
  RETURN d_se_responsabile;
END GET_se_responsabile ;
--

END GP4_TIIN;
/* End Package Body: GP4_TIIN */
/

