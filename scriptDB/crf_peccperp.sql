CREATE OR REPLACE PROCEDURE fpeccperp (a_alias_pk in varchar2,errore out varchar2,passo_err out varchar2) IS
BEGIN
    IF a_alias_pk = 'RIEL' THEN
      peccperp.CALCOLO;  -- Esecuzione del Calcolo Periodi
    END IF;
errore:=peccperp.errore;
passo_err:=peccperp.err_passo;
EXCEPTION
   WHEN OTHERS THEN
    	null;
END;
/

