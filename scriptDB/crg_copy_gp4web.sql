WHENEVER SQLERROR EXIT

select to_number('X')
  FROM DUAL
 where '&1' = user
/


grant execute on copy_default to &1;
grant all on REPOSITORY_DOCUMENTI to &1;