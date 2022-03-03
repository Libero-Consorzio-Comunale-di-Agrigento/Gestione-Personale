CREATE OR REPLACE FUNCTION 
 GET_MODIFICATO (p_id_variazione varchar2,p_progressivo varchar2,p_colonna varchar2) RETURN number is
 d_modificato           number;
BEGIN
  BEGIN
    select modificato
      into d_modificato
      from w_variazioni
     where id_variazione = p_id_variazione
       and progressivo   = p_progressivo
       and colonna       = upper(p_colonna)
       and sequenza     != 999
     ;
  EXCEPTION 
    WHEN NO_DATA_FOUND THEN
      d_modificato := 0;
  END;
   return d_modificato;
END;
/