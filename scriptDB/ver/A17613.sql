--
-- sistemazione del campo CODICE_SIOPE in tabella RAPPORTI_CONCORSUALI
--
declare
v_comando   varchar2(500);
v_versione  varchar2(1);
V_alter     varchar2(2);
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
   BEGIN
-- verifico se e una tabel e se esiste il campo da cancellare
     select 'SI'
       into V_alter
       from user_tab_columns
      where table_name = 'RAPPORTI_CONCORSUALI'
        and column_name = 'CODICE_SIOPE'
     ;
   EXCEPTION WHEN NO_DATA_FOUND THEN  
     V_alter := 'NO';
   END;
   IF V_alter = 'SI' THEN
    v_comando := 'alter table rapporti_concorsuali drop column codice_siope';
    si4.sql_execute(V_comando);
   END IF;
 END IF;
END;
/
--
-- sistemazione dei campi GG_DET e GG_365 in PERIODI_RETRIBUTIVI e BP
-- eseguo controlli per fare update solo se necessario
--
DECLARE
v_null     varchar2(1);
v_comando  varchar2(500);
BEGIN
-- campo gg_det di pere
   BEGIN
     select nullable
       into V_null
       from user_tab_columns
      where table_name = 'PERIODI_RETRIBUTIVI'
        and column_name = 'GG_DET'
     ;
   EXCEPTION WHEN NO_DATA_FOUND THEN  
     V_null := 'N';
   END;
   IF V_null = 'Y' THEN
      update PERIODI_RETRIBUTIVI
         set GG_DET = 0
       where GG_DET is null;
      commit;
      v_comando := 'alter table PERIODI_RETRIBUTIVI modify GG_DET number(3) NOT NULL';
      si4.sql_execute(V_comando);
   END IF;

-- campo gg_365 di pere
   BEGIN
     select nullable
       into V_null
       from user_tab_columns
      where table_name = 'PERIODI_RETRIBUTIVI'
        and column_name = 'GG_365'
     ;
   EXCEPTION WHEN NO_DATA_FOUND THEN  
     V_null := 'N';
   END;
   IF V_null = 'Y' THEN
      update PERIODI_RETRIBUTIVI
         set GG_365 = 0
       where GG_365 is null;
      commit;
      v_comando := 'alter table PERIODI_RETRIBUTIVI modify GG_365 number(3) NOT NULL';
      si4.sql_execute(V_comando);
   END IF;

-- campo gg_det di perp
   BEGIN
     select nullable
       into V_null
       from user_tab_columns
      where table_name = 'PERIODI_RETRIBUTIVI_BP'
        and column_name = 'GG_DET'
     ;
   EXCEPTION WHEN NO_DATA_FOUND THEN  
     V_null := 'N';
   END;
   IF V_null = 'Y' THEN
      update PERIODI_RETRIBUTIVI_BP
         set GG_DET = 0
       where GG_DET is null;
      commit;
      v_comando := 'alter table PERIODI_RETRIBUTIVI_BP modify GG_DET number(3) NOT NULL';
      si4.sql_execute(V_comando);
   END IF;

-- campo gg_365 di perp
   BEGIN
     select nullable
       into V_null
       from user_tab_columns
      where table_name = 'PERIODI_RETRIBUTIVI_BP'
        and column_name = 'GG_365'
     ;
   EXCEPTION WHEN NO_DATA_FOUND THEN  
     V_null := 'N';
   END;
   IF V_null = 'Y' THEN
      update PERIODI_RETRIBUTIVI_BP
         set GG_365 = 0
       where GG_365 is null;
      commit;
      v_comando := 'alter table PERIODI_RETRIBUTIVI_BP modify GG_365 number(3) NOT NULL';
      si4.sql_execute(V_comando);
   END IF;
END;
/
--
-- sistemazione dei campi GG_DET e GG_365 in CALCOLI_RETRIBUTIVI
-- non faccio controlli, dovrebbe essere sempre vuota ma faccio updare per sicurezza
-- le alter le tengo separate , uno dei 2 potrebbe già essere ok
--
update CALCOLI_RETRIBUTIVI
   set GG_DET = 0
 where GG_DET is null;
update CALCOLI_RETRIBUTIVI
   set GG_365 = 0
 where GG_365 is null;
alter table CALCOLI_RETRIBUTIVI modify GG_DET number(3) NOT NULL ;
alter table CALCOLI_RETRIBUTIVI modify GG_365 number(3) NOT NULL ;

--
-- sistemazione del campo ANNO in RAPPORTI_DIVERSI mettendo 1900 per evidenziarlo
-- non faccio controlli, i record non sono tantissimi in questa tabella
-- 
   update RAPPORTI_DIVERSI
      set anno = 1900
    where anno is null;
alter table RAPPORTI_DIVERSI modify ANNO number(4) NOT NULL ;

--
-- cancellazione vista non più in uso
--
drop view differenze_accredito_emens;

--
-- sistemazione del campo CALENDARIO in tabella SEDI_AMMINISTRATIVE
--
alter table sedi_amministrative modify calendario varchar2(4);

--
-- sistemazione del campo CODICE in tabella SEDI_PROVVEDIMENTO
--
alter table sedi_provvedimento modify codice varchar2(4);

-- 
-- sistemazione chiave univoca su RDRE
-- 
declare
v_comando   varchar2(500);
v_esiste    varchar2(2);
BEGIN
   BEGIN
-- verifico se indice da cancellare esiste
     select 'SI'
       into V_esiste
       from user_indexes
      where index_name = 'RIGHE_DELIBERA_RETRIBUTIVA_PK'
     ;
   EXCEPTION WHEN NO_DATA_FOUND THEN  
     V_esiste := 'NO';
   END;
   IF V_esiste = 'SI' THEN
    v_comando := 'drop index RIGHE_DELIBERA_RETRIBUTIVA_PK';
    si4.sql_execute(V_comando);
    v_comando := 'CREATE UNIQUE INDEX RDRE_PK ON RIGHE_DELIBERA_RETRIBUTIVA(SEDE, ANNO, NUMERO, TIPO, BILANCIO )';
    si4.sql_execute(V_comando);
   END IF;
END;
/