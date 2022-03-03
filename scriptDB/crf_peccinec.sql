CREATE OR REPLACE PROCEDURE fpeccinec (a_alias_pk in varchar2,a_pk1 in number,errore in out varchar2,passo_err in out varchar2) IS
ci number;
BEGIN
  IF a_alias_pk = 'RIEL' OR a_alias_pk = 'RAGI' THEN
         -- viene riazzerato in Form chiamante per evitare Trasaction Completed
      IF a_alias_pk = 'RAGI' THEN
         ci := a_pk1;
         peccinec.INEC_COLLETTIVO(ci,a_alias_pk);  -- Inquadramento Individuale
      ELSE
         peccinec.INEC_COLLETTIVO(null,a_alias_pk);     -- Inquadramento Collettivo
      END IF;
      ERRORE := PECCINEC.ERRORE;
      PASSO_ERR := PECCINEC.PASSO_ERR;
   end if;
END;
/

