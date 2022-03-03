DECLARE
P_valore1 number;
P_valore2 number;
P_tipo    varchar2(18);
V_comando varchar2(500);
V_controllo varchar2(1);
BEGIN
BEGIN 
select nvl(max(door_id),0)
      ,nvl(max(door_id),0)+1 
  into P_valore1, P_valore2
  from dotazione_organica  
;
EXCEPTION WHEN NO_DATA_FOUND THEN
p_valore1 := 0;
p_valore2 := 1;
END;

BEGIN
 select object_type 
   into P_tipo
   from obj
  where object_name = 'DOOR_SQ';
EXCEPTION WHEN NO_DATA_FOUND THEN
  P_tipo := 'CREA';
END;
IF P_tipo = 'CREA' THEN
   BEGIN
   select 'X' 
     into V_controllo
     from obj
    where object_name = 'DOTAZIONE_ORGANICA_PK';
   EXCEPTION WHEN NO_DATA_FOUND THEN V_controllo := null;
   END;
   IF V_controllo = 'X' THEN
      V_comando := 'DROP INDEX DOTAZIONE_ORGANICA_PK';
      si4.sql_execute(V_comando);
   END IF;
   V_comando := 'ALTER TABLE DOTAZIONE_ORGANICA DISABLE ALL TRIGGERS';
   si4.sql_execute(V_comando);
   V_comando := 'CREATE SEQUENCE door_sq INCREMENT BY 1 START WITH '||P_valore2||' MINVALUE 1
                 MAXVALUE 999999 NOCYCLE  CACHE 2 NOORDER ';
   si4.sql_execute(V_comando);
   V_comando := 'update dotazione_organica set door_id = door_sq.NEXTVAL';
   si4.sql_execute(V_comando);
   V_comando := 'create unique index DOTAZIONE_ORGANICA_PK on DOTAZIONE_ORGANICA (REVISIONE ASC,DOOR_ID ASC )';
   si4.sql_execute(V_comando);
   V_comando := 'ALTER TABLE DOTAZIONE_ORGANICA ENABLE ALL TRIGGERS';
   si4.sql_execute(V_comando);
END IF;
END;
/
start crp_gp4_ente.sql