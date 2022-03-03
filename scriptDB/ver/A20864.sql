declare 
V_controllo varchar2(1);
V_comando  varchar2(200);
BEGIN
 BEGIN
  select 'Y' 
    into V_controllo
    from dual
   where exists ( select 'x' from obj 
                   where object_name in ( 'PEGI_S_PRE_A20864' )
                 );
 EXCEPTION WHEN NO_DATA_FOUND THEN V_controllo := 'X';
 END;
 IF V_controllo = 'Y' THEN 
    NULL;
 ELSE
   V_comando := 'create table PEGI_S_PRE_A20864 as select * from PERIODI_GIURIDICI where rilevanza = ''S''';
   si4.sql_execute(V_comando);
 END IF;
END;
/

update periodi_giuridici
set sede = '' 
where sede = 0 
and not exists (select 'x' from sedi where numero = 0)
and rilevanza = 'S';



