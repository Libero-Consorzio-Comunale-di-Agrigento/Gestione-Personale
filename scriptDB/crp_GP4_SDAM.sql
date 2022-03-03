CREATE OR REPLACE PACKAGE GP4_SDAM IS
       FUNCTION  GET_CODICE_NUMERO   (p_numero in number) RETURN VARCHAR2 ;
                 PRAGMA RESTRICT_REFERENCES(GET_CODICE_NUMERO,wnds,wnps);
       FUNCTION  GET_CODICE_SETT     (p_numero in number) RETURN VARCHAR2 ;
       FUNCTION  GET_NI              (p_numero in number) RETURN number ;
       FUNCTION  GET_DENOMINAZIONE   (p_ni in number) RETURN VARCHAR2 ;
       FUNCTION  GET_DENOMINAZIONE_NUMERO   (p_numero in number) RETURN VARCHAR2 ;
       FUNCTION  VERSIONE              RETURN varchar2;
/******************************************************************************
   NAME:       GP4_SDAM
   PURPOSE:    To calculate the desired information.

   REVISIONS:
   Ver        Date        Author           Description
   ---------  ----------  ---------------  ------------------------------------
   1.0        23/07/2002             1. Created this package.

   PARAMETERS:
   INPUT:
   OUTPUT:
   RETURNED VALUE:
   CALLED BY:
   CALLS:
   EXAMPLE USE:     NUMBER := GP4_SDAM.MyFuncName(Number);
                    GP4_SDAM.MyProcName(Number, Varchar2);
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:

   Here is the complete list of available Auto Replace Keywords:
      Object Name:     GP4_SDAM or GP4_SDAM
      Sysdate:         23/07/2002
      Date/Time:       23/07/2002 9.15.42
      Date:            23/07/2002
      Time:            9.15.42
      Username:         (set in TOAD Options, Procedure Editor)
******************************************************************************/
END GP4_SDAM;
/

CREATE OR REPLACE PACKAGE BODY GP4_SDAM AS


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
   RETURN 'V1.0 del 23/07/2002';
END VERSIONE;
--
FUNCTION GET_CODICE_SETT  (p_numero in number) RETURN VARCHAR2 IS
d_codice sedi_amministrative.CODICE%TYPE;
/******************************************************************************
   NAME:       GET_CODICE_SETT
   PURPOSE:    Fornire il codice della SEDE amministrativo
               dato il settore_Amministrativo

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
   EXAMPLE USE:     VARCHAR := GET_CODICE_SETT();
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:

******************************************************************************/
BEGIN
  d_codice := to_char(null);
  begin
   select codice
     into d_codice
	 from sedi_amministrative
	where numero = (select sede
	                  from settori_amministrativi
					 where numero = p_numero
				   )
   ;
   EXCEPTION
    when no_data_found then
	  begin
-- gestione errore	    P_errore := 'P08002';  -- Non esistono il SEDE amministrativo
		d_codice := to_char(null);
	  end;
    when too_many_rows then
	  begin
-- gestione errore	    P_errore := 'P08003';  -- Esistono piu di un SEDE amministrativo per la UO
		d_codice := to_char(null);
	  end;
  end;
  RETURN d_codice;
END GET_CODICE_SETT ;
--
FUNCTION GET_NI  (p_numero in number) RETURN NUMBER IS
d_ni sedi_amministrative.ni%TYPE;
/******************************************************************************
   NAME:       GET_NI
   PURPOSE:    Fornire il codice della SEDE amministrativo
               dato il settore_Amministrativo

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
   EXAMPLE USE:     VARCHAR := GET_NI();
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:

******************************************************************************/
BEGIN
  d_ni := to_number(null);
  begin
   select ni
     into d_ni
	 from sedi_amministrative
	where numero = p_numero
   ;
   EXCEPTION
    when no_data_found then
	  begin
-- gestione errore	    P_errore := 'P08002';  -- Non esistono il SEDE amministrativo
		d_ni := to_number(null);
	  end;
    when too_many_rows then
	  begin
-- gestione errore	    P_errore := 'P08003';  -- Esistono piu di un SEDE amministrativo per la UO
		d_ni := to_number(null);
	  end;
  end;
  RETURN d_ni;
END GET_NI ;
--
FUNCTION GET_CODICE_NUMERO (p_numero in number) RETURN VARCHAR2 IS
d_codice sedi_amministrative.CODICE%TYPE;
/******************************************************************************
   NAME:       GET_CODICE
   PURPOSE:    Fornire in codice della SEDE amministrativo
               dato il numero

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
   EXAMPLE USE:     VARCHAR := GET_CODICE();
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:

******************************************************************************/
BEGIN
  d_codice := to_char(null);
  begin
   select codice
     into d_codice
	 from sedi_amministrative
	where numero = p_numero
   ;
   EXCEPTION
    when no_data_found then
	  begin
-- gestione errore	    P_errore := 'P08002';  -- Non esistono il SEDE amministrativo
		d_codice := to_char(null);
	  end;
    when too_many_rows then
	  begin
-- gestione errore	    P_errore := 'P08003';  -- Esistono piu di un SEDE amministrativo per la UO
		d_codice := to_char(null);
	  end;
  end;
  RETURN d_codice;
END GET_CODICE_NUMERO;
--
FUNCTION GET_DENOMINAZIONE (p_ni in number) RETURN VARCHAR2 IS
d_DENOMINAZIONE sedi_amministrative.DENOMINAZIONE%TYPE;
/******************************************************************************
   NAME:       GET_DENOMINAZIONE
   PURPOSE:    Fornire la DENOMINAZIONE del SEDE amministrativo
               data una unita organizzativa

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
   EXAMPLE USE:     VARCHAR := GET_DENOMINAZIONE();
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:

******************************************************************************/
BEGIN
  d_DENOMINAZIONE := 'XXXXXXXXXXXXXX';
  begin
   select DENOMINAZIONE
     into d_DENOMINAZIONE
	 from sedi_amministrative
	where ni = p_ni
   ;
   EXCEPTION
    when no_data_found then
	  begin
-- gestione errore	    P_errore := 'P08002';  -- Non esistono il SEDE amministrativo
		d_DENOMINAZIONE := to_char(null);
	  end;
    when too_many_rows then
	  begin
-- gestione errore	    P_errore := 'P08003';  -- Esistono piu di un SEDE amministrativo per la UO
		d_DENOMINAZIONE := to_char(null);
	  end;
  end;
  RETURN d_DENOMINAZIONE;
END GET_DENOMINAZIONE;
--
FUNCTION GET_DENOMINAZIONE_NUMERO (p_numero in number) RETURN VARCHAR2 IS
d_DENOMINAZIONE sedi_amministrative.DENOMINAZIONE%TYPE;
/******************************************************************************
   NAME:       GET_DENOMINAZIONE
   PURPOSE:    Fornire la DENOMINAZIONE del SEDE amministrativo
               data una unita organizzativa

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
   EXAMPLE USE:     VARCHAR := GET_DENOMINAZIONE();
   ASSUMPTIONS:
   LIMITATIONS:
   ALGORITHM:
   NOTES:

******************************************************************************/
BEGIN
  d_DENOMINAZIONE := 'XXXXXXXXXXXXXX';
  begin
   select DENOMINAZIONE
     into d_DENOMINAZIONE
	 from sedi_amministrative
	where numero = p_numero
   ;
   EXCEPTION
    when no_data_found then
	  begin
-- gestione errore	    P_errore := 'P08002';  -- Non esistono il SEDE amministrativo
		d_DENOMINAZIONE := to_char(null);
	  end;
    when too_many_rows then
	  begin
-- gestione errore	    P_errore := 'P08003';  -- Esistono piu di un SEDE amministrativo per la UO
		d_DENOMINAZIONE := to_char(null);
	  end;
  end;
  RETURN d_DENOMINAZIONE;
END GET_DENOMINAZIONE_NUMERO;
--
END GP4_SDAM;
/

