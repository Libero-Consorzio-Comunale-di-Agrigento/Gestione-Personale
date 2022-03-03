REM  Check situazione Sinonimi Archivio COMUNI su AD4

WHENEVER SQLERROR EXIT 1
-- WHEN ERROR Sinonimo AD4_COMUNI vuoto o non previsto!
SELECT to_number('X')
  FROM DUAL
 where not exists
      (select 'x' from ad4_comuni)
/
