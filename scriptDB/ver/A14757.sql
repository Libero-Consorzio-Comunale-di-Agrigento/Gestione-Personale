-- Ricrea i diritti di creazione di snapshot all'utente oracle
declare
v_versione varchar2(1);
V_esiste   varchar2(2);
begin
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
   si4.sql_execute('drop VIEW TOTALI_RETRIBUZIONI_INAIL');
 ELSE 
   BEGIN
     select 'SI'
       into V_esiste
       from user_snapshot_logs
      where master = 'RETRIBUZIONI_INAIL'
     ;
   EXCEPTION WHEN NO_DATA_FOUND THEN 
      V_esiste := 'NO';
   END;
   IF V_esiste = 'SI' THEN
      si4.sql_execute('drop MATERIALIZED view log on retribuzioni_inail');
   END IF;
   si4.sql_execute('drop snapshot totali_retribuzioni_inail');
 END IF;
END;
/

alter table retribuzioni_inail add  CODICE_SIOPE NUMBER(4);

start crv_trei.sql
start crv_vimi.sql
start crv_mbii.sql

start crp_peccrein.sql
