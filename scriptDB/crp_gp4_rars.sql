CREATE OR REPLACE PACKAGE GP4_rars IS
       FUNCTION  VERSIONE                RETURN VARCHAR2;
	   FUNCTION  GET_TIPO_TRATTAMENTO  (p_ci in number,
								        p_data in date) RETURN varchar2 ;
END GP4_rars;
/
CREATE OR REPLACE PACKAGE BODY GP4_RARS AS

FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 aliquota: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.0 del 26/10/2004';
END VERSIONE;
--

FUNCTION  GET_TIPO_TRATTAMENTO  (p_ci in number,
								 p_data in date) RETURN varchar2  IS
d_tipo_tratt rapporti_retributivi_storici.tipo_trattamento%type;
/******************************************************************************

   NAME:       GET_aliquota
   PURPOSE:    Restituire iltipo di trattamento previdenziale dell'individuo

******************************************************************************/
BEGIN
  BEGIN
  select nvl(tipo_trattamento,0)
    into d_tipo_tratt
    from rapporti_retributivi_storici rars
   where rars.ci = p_ci
     and p_data  between rars.dal 
	                 and nvl(rars.al,to_date(3333333,'j'))
  ;
   EXCEPTION
    when no_data_found then
	  	  d_tipo_tratt := '0';
	when too_many_rows then
		  d_tipo_tratt := '0';
   END;
RETURN d_tipo_tratt;
END GET_TIPO_TRATTAMENTO;
--
END GP4_RARS;
/
