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
   si4.sql_execute('alter trigger PEGI_PEDO_TMA disable');
   si4.sql_execute('alter trigger PEGI_DOES_TMA disable');
   si4.sql_execute('alter trigger PEGI_SOGI_TMA disable');
 ELSE
   si4.sql_execute('alter trigger PEGI_PEDO_TMA enable');
   si4.sql_execute('alter trigger PEGI_DOES_TMA enable');
   si4.sql_execute('alter trigger PEGI_SOGI_TMA enable');
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
   BEGIN
   select counT(*) 
     into V_conta
     from periodi_dotazione
   ;
   EXCEPTION WHEN NO_DATA_FOUND THEN V_conta := 0;
   END;
   IF V_conta = 0 THEN
   begin
   si4.sql_execute('begin utilitypackage.compile_all; end;');
   exception when others then null;
   end;
   v_comando := 'insert into periodi_dotazione
                (ci,rilevanza,dal,revisione)
                select pegi.ci,pegi.rilevanza,pegi.dal,redo.revisione
                  from periodi_giuridici pegi
                     , revisioni_dotazione redo
                 where pegi.rilevanza in (''Q'',''S'',''I'',''E'') ';
   si4.sql_execute(v_comando);
   v_comando := ' update periodi_giuridici set ci = ci
                   where rilevanza in (''Q'',''S'',''I'',''E'') ';
   si4.sql_execute(v_comando);
   END IF;
   END IF; -- d_esegui
 END IF;
END;
/

