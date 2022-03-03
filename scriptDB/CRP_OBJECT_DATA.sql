CREATE OR REPLACE PACKAGE object_data IS
type objtype is record (
nome_oggetto varchar2(128),
tipo_oggetto varchar2(18),
stato_oggetto varchar2(7),
tabella_oggetto varchar2(30),
stato_trigger varchar2(8)
);
type objcurtyp is REF CURSOR return objtype;
procedure open_obj_cv( obj_cv in out objcurtyp);
END;
/

CREATE OR REPLACE PACKAGE BODY object_data IS
 procedure open_obj_cv( obj_cv in out objcurtyp) is
 begin
         open obj_cv for SELECT USER_OBJECTS.OBJECT_NAME, USER_OBJECTS.OBJECT_TYPE, USER_OBJECTS.STATUS, USER_TRIGGERS.TABLE_NAME, USER_TRIGGERS.STATUS
    FROM USER_OBJECTS,
         USER_TRIGGERS
   WHERE ( user_objects.object_name = user_triggers.trigger_name (+)) and
         ( ( USER_TRIGGERS.STATUS = 'DISABLED'  ) OR
         ( USER_OBJECTS.STATUS = 'INVALID' ) )
         and user_objects.object_name not like 'BIN$%'
UNION
  SELECT USER_CONSTRAINTS.CONSTRAINT_NAME,
         'CONSTRAINT',
         '',
         USER_CONSTRAINTS.TABLE_NAME,
         USER_CONSTRAINTS.STATUS
    FROM USER_CONSTRAINTS
   WHERE USER_CONSTRAINTS.STATUS = 'DISABLED'
ORDER BY 4,2,1;
 end open_obj_cv;
END; 
/

