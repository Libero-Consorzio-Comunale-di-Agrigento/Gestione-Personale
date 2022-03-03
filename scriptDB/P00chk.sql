REM  Check esistenza utenti di progetto
WHENEVER SQLERROR EXIT 1
SET CONCAT OFF

-- WHEN ERROR Utenti inesistenti
SELECT 'X'
  FROM DUAL
 where not exists
      (select 'x' from &1.ente)
/
SELECT 'X'
  FROM DUAL
 where not exists
      (select 'x' from &1.a_applicazioni)
/
