column c1 NOPRINT new_value P1

select max(grantee) C1
  from user_tab_privs
where table_name = 'GP4WEB_SS'
  and grantor = user
/
