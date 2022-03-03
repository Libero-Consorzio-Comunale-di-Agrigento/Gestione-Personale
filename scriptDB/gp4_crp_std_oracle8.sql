-- Compilazione package di utilita generale solo in Oracle 8 
WHENEVER SQLERROR EXIT
select to_number( 'xx7xx')
  from v$version
 where instr(upper(banner),'RELEASE')>0
   and substr(banner,7,1) = '7'
   and substr(banner,instr(upper(banner),'RELEASE ')+8,1)= '7'
;
WHENEVER SQLERROR CONTINUE
start crp_SI4_BASE64.sql
start crp_WEBUTIL_DB.sql