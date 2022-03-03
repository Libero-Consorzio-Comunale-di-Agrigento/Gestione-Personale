REM /******************************************************************************
REM  NOME:        GP4_crs
REM  DESCRIZIONE: Creazione dinamica sinonimi sugli oggetti
REM 
REM  ARGOMENTI:   1: IN User di DB SI4V3
REM               2: IN User di DB GP4
REM  
REM  ANNOTAZIONI: Script di automatica di sinonimi su TABLE, VIEWS E 
REM               SYNONYMS attualmente presenti sullo user di DB. 
REM  REVISIONI:
REM  Rev. Data       Autore Descrizione
REM  ---- ---------- ------ ------------------------------------------------------
REM  0    10/05/01   VA     Prima emissione.
REM  1    22/10/02   VA     Parametrizzazione.
REM ******************************************************************************/

DECLARE
d_user_S   varchar2(20) := upper('&1');
d_user_G   varchar2(20) := upper('&2');
cursor c_obj is
	   select object_name, object_type, owner
	   from all_objects
	   where object_type in ('TABLE', 'VIEW', 'SYNONYM')
             and owner in (d_user_S,d_user_G);
BEGIN
for v_obj in c_obj loop
   begin
      afc.sql_execute('drop synonym '||v_obj.object_name);
   exception
      when others then null;
   end;
   begin
      afc.sql_execute('create synonym '||v_obj.object_name||' for '||v_obj.owner||'.'||v_obj.object_name);
   exception
      when others then null;
   end;
end loop;
end;
/