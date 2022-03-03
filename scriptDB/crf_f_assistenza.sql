CREATE OR REPLACE FUNCTION F_ASSISTENZA (v_ci number, v_profilo_professionale varchar2, v_posizione varchar2)
RETURN VARCHAR2 IS
v_trattamento RAPPORTI_RETRIBUTIVI_STORICI.TRATTAMENTO%TYPE:= to_char(null);
v_assistenza  TRATTAMENTI_PREVIDENZIALI.ASSISTENZA%TYPE:= to_char(null);
BEGIN
   v_trattamento := f_trattamento (v_ci , v_profilo_professionale , v_posizione );
   begin
      select assistenza
	    into v_assistenza
		from trattamenti_previdenziali
	   where codice = v_trattamento
	  ;
   exception when no_data_found then v_assistenza := to_char(null);
   end;
RETURN v_assistenza;
END F_ASSISTENZA;
/
