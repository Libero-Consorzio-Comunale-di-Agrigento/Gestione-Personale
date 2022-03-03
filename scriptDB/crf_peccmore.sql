CREATE OR REPLACE PROCEDURE fpeccmore(a_alias_pk in varchar2,errore out varchar2,passo_err out varchar2) IS
BEGIN
   IF a_alias_pk = 'RIEL' THEN
      peccmore.CALCOLO;  -- Esecuzione del Calcolo Cedolino
   END IF;
   errore := peccmore.w_errore;
   passo_err := peccmore.err_passo;
EXCEPTION when others then
	null;
END;
/

