CREATE OR REPLACE PROCEDURE fpeccpere(a_alias_pk in varchar2,errore out varchar2,passo_err out varchar2) IS
BEGIN
IF a_alias_pk = 'RIEL' THEN
      peccpere.CALCOLO;  -- Esecuzione del Calcolo Periodi
   END IF;
   errore := peccpere.errore;
   passo_err := peccpere.err_passo;
EXCEPTION
   WHEN OTHERS THEN
		null;
END;
/

