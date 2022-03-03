WHENEVER SQLERROR EXIT
-- Verifica la versione del DB
select to_number('X')
  FROM DUAL
 where &2 = 0
/
-- Verifica se l'utente ha le grant sui ruoli JAVASYSPRIV, CONNECT e RESOURCE e le java Permission
select to_number('X')
  FROM DUAL
 where exists (select 1
                 from USER_ROLE_PRIVS
                where USERNAME = upper('&1')
                  and GRANTED_ROLE = 'JAVASYSPRIV'
              )
   and exists (select 1
                 from USER_JAVA_POLICY
                where GRANTEE_NAME = upper('&1')
                  and lower(TYPE_NAME) = 'java.util.propertypermission'
                  and instr(lower(ACTION), 'read') > 0
                  and instr(lower(ACTION), 'write') > 0
              )
   and exists (select 1
                 from USER_JAVA_POLICY
                where GRANTEE_NAME = upper('&1')
                  and lower(TYPE_NAME) = 'java.security.securitypermission'
                  and ACTION = '*'
              )
   and exists (select 1
                 from USER_JAVA_POLICY
                where GRANTEE_NAME = upper('&1')
                  and lower(TYPE_NAME) = 'oracle.aurora.security.jserverpermission'
                  and lower(NAME) = 'verifier'
              )
/
WHENEVER SQLERROR EXIT 1
connect sys/change_on_install
GRANT JAVASYSPRIV TO &1
/
call dbms_java.grant_permission(upper('&1'), 'java.util.PropertyPermission', '*','read,write')
/
call dbms_java.grant_permission(upper('&1'), 'java.security.SecurityPermission', '*', '*')
/
call dbms_java.grant_permission(upper('&1'), 'java.net.SocketPermission', '*', 'connect')
/
call dbms_java.grant_permission(upper('&1'), 'SYS:oracle.aurora.security.JServerPermission', 'Verifier', '' )
/