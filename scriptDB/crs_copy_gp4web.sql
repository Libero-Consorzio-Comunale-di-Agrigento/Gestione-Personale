DECLARE
V_type     varchar2(18);
v_comando  varchar2(100);
BEGIN
   BEGIN
     select object_type
       into V_type
       from obj
      where object_name = 'COPY_DEFAULT'
      ;
      EXCEPTION WHEN NO_DATA_FOUND THEN 
         V_type := '';
      END;
   IF V_type is not null THEN
      V_comando := 'drop '||V_type||' COPY_DEFAULT';
      si4.sql_execute(V_comando);
   END IF;
   IF nvl('&1',user) != user THEN
       si4.sql_execute('create synonym copy_default for '||'&1'||'.copy_default');
   ELSE
       si4.sql_execute('CREATE OR REPLACE PROCEDURE copy_default '||
                      '( url IN VARCHAR2, tableName IN VARCHAR2, columnName IN VARCHAR2, whereClause IN VARCHAR2)  IS '||
                      'BEGIN null; END; ');
   END IF;
END;
/


DECLARE
V_type     varchar2(18);
v_comando  varchar2(100);
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
   IF V_type is not null THEN
      V_comando := 'drop '||V_type||' REPOSITORY_DOCUMENTI';
      si4.sql_execute(V_comando);
   END IF;
   IF nvl('&1',user) != user THEN
       si4.sql_execute('create synonym REPOSITORY_DOCUMENTI for '||'&1'||'.REPOSITORY_DOCUMENTI');
   ELSE
         si4.sql_execute('CREATE TABLE REPOSITORY_DOCUMENTI '||
                      '(  CI            NUMBER (10)   NOT NULL, '||
                      ' TIPO_DOCUMENTO  VARCHAR2 (100)  NOT NULL, '||
                      ' DOCUMENTO       BLOB, '||
                      ' CHIAVE          VARCHAR2 (2000), '||
                      ' UTENTE_AGG      VARCHAR2(8), '||
                      ' DATA_AGG        DATE, '||
                      ' NOTIFICATO  VARCHAR2(1) DEFAULT ''N'' ) '
                       );
   END IF;
END;
/