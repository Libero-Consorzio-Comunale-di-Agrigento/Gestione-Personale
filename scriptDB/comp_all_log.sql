spool on
set hea off
select '=============================================================================='
from dual
/
select 'OGGETTI INVALIDI' titolo
from dual
/
select '=============================================================================='
from dual
/
select rpad(object_name,128),
       rpad(object_type,18)       
  from OBJ
 where object_type in ('PROCEDURE'
                      ,'TRIGGER'
                      ,'FUNCTION'
                      ,'PACKAGE'
                      ,'PACKAGE BODY'
                      ,'VIEW')
   and status = 'INVALID'
 order by  decode(object_type
                 ,'PACKAGE',1
                 ,'PACKAGE BODY',2
                 ,'FUNCTION',3
                 ,'PROCEDURE',4
                 ,'VIEW',5
                 ,6)
           , object_name
/
spool off
