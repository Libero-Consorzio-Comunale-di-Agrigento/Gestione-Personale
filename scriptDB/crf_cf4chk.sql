CREATE OR REPLACE FUNCTION controlla_oggetti_cf4 RETURN boolean IS
d_temp              varchar2(1);
d_contabilita       varchar2(1);
d_esiste            boolean;
BEGIN
  BEGIN
  select nvl(contabilita,'F')
    into d_contabilita 
    from ente;
  END;
  IF d_contabilita = 'F' THEN
  BEGIN
    select 'x'
      into d_temp
      from dual
     where ( exists ( select 1 from capitoli_contabilita)
        or exists (select 1 from acc_imp_contabilita)
           )
     ;
    d_esiste := TRUE;
  EXCEPTION
    when NO_DATA_FOUND then 
    d_esiste := FALSE;
  END;
  ELSE  d_esiste := FALSE;
  END IF;
  RETURN d_esiste;  
END controlla_oggetti_cf4;
/