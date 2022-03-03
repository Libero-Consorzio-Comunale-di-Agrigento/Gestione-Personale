DECLARE
V_type     varchar2(18);
BEGIN
   BEGIN
     select object_type
       into V_type
       from obj
      where object_name = 'REPOSITORY_DOCUMENTI'
     ;
   EXCEPTION WHEN NO_DATA_FOUND THEN 
         V_type := '';
   END;
   IF V_type = 'TABLE' THEN
         si4.sql_execute('ALTER TABLE REPOSITORY_DOCUMENTI '||
                      ' ADD ( NOTIFICATO  VARCHAR2(1) DEFAULT ''N'' ) '
                       );
   ELSE
     null;
   END IF;
END;
/

start crp_pecsmorm.sql