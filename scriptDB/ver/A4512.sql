update note_cud 
   set sequenza = rownum
where nvl(sequenza,0) = 0
/
alter table note_cud modify sequenza not null;
BEGIN
DECLARE
V_comando   varchar2(1000);
 BEGIN
 FOR CUR_IDX in 
  ( select distinct index_name
      from user_indexes
     where table_name = 'NOTE_CUD'
  ) LOOP
  V_comando := 'drop index '||CUR_IDX.index_name;
dbms_output.put_line(V_comando);
  si4.sql_execute ( V_comando );
  END LOOP;
  V_comando := 'create unique index NOCU_PK on note_cud (ci,anno,codice,sequenza)';
dbms_output.put_line(V_comando);
  si4.sql_execute ( V_comando );
 END;
END;
/