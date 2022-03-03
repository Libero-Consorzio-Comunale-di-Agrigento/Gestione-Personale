declare
v_versione varchar2(1);
v_comando  varchar2(500);
V_esegui   varchar2(1);
v_conta    number;
BEGIN
  BEGIN
-- estrazione della versione
  select '7'
    into v_versione
    from v$version
   where instr(upper(banner),'RELEASE')>0
     and substr(banner,7,1) = '7'
     and substr(banner,instr(upper(banner),'RELEASE ')+8,1)= '7'
      ;
   exception
   when no_data_found then
        v_versione := '8';
   END;
 IF v_versione = '7' THEN
    null;
 ELSE
-- disabilito i trigger su pegi tranne pegi_pedo_tma
   si4.sql_execute('alter table periodi_giuridici disable all triggers');
   si4.sql_execute('alter trigger PEGI_PEDO_TMA enable');
   BEGIN
     select '1'
       into V_esegui
       from dual 
      where exists ( select 'x' 
                       from revisioni_dotazione
                      where utente <> 'Aut.POPI'
                   )
    ;
   EXCEPTION WHEN NO_DATA_FOUND THEN  
       V_esegui := '0';
   END;
   IF V_esegui = '1' THEN
   begin
   si4.sql_execute('begin utilitypackage.compile_all; end;');
   exception when others then null;
   end;
   v_comando := ' update periodi_giuridici set ci = ci
                   where rilevanza in (''Q'',''S'',''I'',''E'') 
                     and ore is not null';
   si4.sql_execute(v_comando);
   END IF; -- d_esegui
-- riabilito i trigger
   si4.sql_execute('alter table periodi_giuridici enable all triggers');
 END IF; -- versione
END;
/