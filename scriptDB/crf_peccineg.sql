CREATE OR REPLACE PROCEDURE fpeccineg (a_alias_pk in varchar2,errore out varchar2,passo_err out varchar2)  IS
BEGIN
   IF a_alias_pk = 'RIEL' THEN
      peccineg.INEC_GENERALE;     -- Inquadramento Generale
      errore := peccineg.errore;
      passo_err := peccineg.passo_err;
   END IF;
EXCEPTION
   WHEN OTHERS THEN
	null;
END;
/

