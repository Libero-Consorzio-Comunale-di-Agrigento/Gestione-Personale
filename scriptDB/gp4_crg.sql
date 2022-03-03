REM ******************************************************************************
REM  NOME:        GP4_crg
REM  DESCRIZIONE: Creazione dinamica autorizzazioni sugli oggetti
REM 
REM  ARGOMENTI:   1: IN User di DB
REM               2: IN(optional) Tipo di grant( Select, All ...)     default = select
REM               3: IN(optional) Opzioni della grant (YES, NO, ...)  default = NO
REM
REM  ANNOTAZIONI: Script di attribuzione dinamica delle grant su TABLE, VIEWS E 
REM               SYNONYMS attualmente presenti sullo user di DB.
REM               Se nel terzo parametro viene introdotto un valore diverso da YES o NO
REM               il parametro viene concatenato all'istruzione. 
REM  REVISIONI:
REM  Rev. Data       Autore Descrizione
REM  ---- ---------- ------ ------------------------------------------------------
REM  0    10/05/01   __     Prima emissione.
REM  1    16/01/02   VA     Parametrizzazione
REM ******************************************************************************/

DECLARE
d_user   varchar2(20) := upper('&1');
d_type   varchar2(20) := upper('&2');
d_option varchar2(20) := upper('&3'); 
cursor c_obj is
	   select object_name, object_type
	   from user_objects
	   where object_type in ('TABLE', 'VIEW', 'SYNONYM');
BEGIN
if    d_type is null then
      d_type :='select';
end if;
if    d_option = 'YES' then
      d_option := ' with grant option';
elsif d_option = 'NO' then
      d_option := '';
else  d_option := ' '||d_option;
end if;
for v_obj in c_obj loop
   begin
     si4.sql_execute('grant '||d_type||' on '||v_obj.object_name||' to '||d_user||d_option);
   exception
     when others then null;
   end;
end loop;
end;
/