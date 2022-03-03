declare
v_comando varchar2(32000);
v_versione varchar2(1);
procedure ridimensiona (p_table_name varchar2, p_column_name varchar2) is
D_table varchar2(150);
begin
begin
  select OBJECT_TYPE    
     into D_table
 from obj where OBJECT_NAME = p_table_name;
exception
  when no_data_found then
    D_table := null;
end;
if D_table  = 'TABLE' THEN
 v_comando := 'alter table '|| p_table_name || 
                   ' modify '||p_column_name||'  varchar2( ' ||4000|| ')';
 si4.sql_execute(v_comando);
end if;
end ridimensiona;

begin
  begin
-- estrazione della versione
  select '7'
    into v_versione
    from v$version
   where instr(upper(banner),'RELEASE')>0
     and substr(banner,7,1) = '7'
     and substr(banner,instr(upper(banner),'RELEASE ')+8,1)= '7';
   exception
   when no_data_found then
        v_versione := '8';
   END;
 IF v_versione = '7' THEN NULL;
 ELSE
   ridimensiona('REGOLE_CONVERSIONI','CODIFICA_VALORE');
   ridimensiona('REGOLE_CONVERSIONI','CODIFICA_VALORE_PRECEDENTE');
   ridimensiona('VARIAZIONI','VALORE');
   ridimensiona('VARIAZIONI','VALORE_PRECEDENTE');
   ridimensiona('VARIAZIONI_STORICHE','VALORE');
   ridimensiona('VARIAZIONI_STORICHE','VALORE_PRECEDENTE');
   ridimensiona('W_VARIAZIONI','VALORE');
   ridimensiona('W_VARIAZIONI','VALORE_PRECEDENTE');
 END IF;
END;
/

