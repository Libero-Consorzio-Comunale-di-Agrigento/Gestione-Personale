REM =============================================
REM Verifica versione DB 
REM
REM =============================================
column c1 NOPRINT new_value P1
select substr(banner, instr(upper(banner), 'RELEASE') + 8, 1) c1
  from v$version
 where upper(banner) like '%ORACLE%'
;