start crt_inmo.sql

DECLARE
D_valore1   number(10);
D_valore2   number(10);
V_comando   varchar2(200);
BEGIN
-- creazione della sequence con un pl/sql per evitare errori di connessione ORA-01017
-- durante l'esecuzione degli script successivi
  BEGIN
    select nvl(max(PROGRESSIVO),0)
         , nvl(max(PROGRESSIVO),0)+1
      into D_valore1, D_valore2
      from individui_modificati
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
     D_valore1   := 0;
     D_valore2   := 0;
  END;

  V_comando := 'CREATE SEQUENCE INMO_SQ INCREMENT BY 1 START WITH '||D_valore2||'  MINVALUE 1 MAXVALUE 9999999999 NOCYCLE  CACHE 2 NOORDER ';
-- dbms_output.put_line(V_comando);
  si4.sql_execute(V_comando);
END;
/