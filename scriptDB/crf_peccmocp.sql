CREATE OR REPLACE PROCEDURE fpeccmocp(a_alias_pk in varchar2,errore out varchar2,passo_err out varchar2) IS
BEGIN
   IF a_alias_pk = 'RIEL' THEN
      peccmocp.CALCOLO;  -- Esecuzione del Calcolo Cedolino
   END IF;
   errore    := peccmocp.w_errore;
   passo_err := peccmocp.err_passo;
EXCEPTION
   WHEN OTHERS THEN
      null;
END;
/

