declare
v_controllo varchar2(2);
v_comando   varchar2(200);
begin
 begin
  select 'SI' 
    into v_controllo
    from dual
   where exists ( select 'x' from obj where object_name = 'DEFS_2004_DETTAGLI_OLD');
 exception when no_data_found then v_controllo := 'NO';
 end;
 if v_controllo = 'NO' then
    v_comando := 'create table defs_2004_dettagli_old as select * from denuncia_fiscale
                  where anno >= 2004';
    si4.sql_execute(v_comando);
   update denuncia_fiscale defs
      set c60 = c64
        , c61 = c65
        , c62 = c66
        , c63  = c67
        , c64 = null
        , c65 = null
        , c66 = null
        , c67 = null
     where anno >= 2004
       and rilevanza = 'D'
       and nvl(c60,0)+nvl(c61,0)+nvl(c62,0)+nvl(c63,0) = 0
       and nvl(c64,0) + nvl(c65,0) + nvl(c66,0) + nvl(c67,0) != 0;
  end if;
end;
/
start crp_peccarfi.sql
start crp_pecsmfa1.sql