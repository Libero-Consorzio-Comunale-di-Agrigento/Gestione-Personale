declare
V_versione varchar2(1) := '';
V_tipo     VARCHAR2(30) := '';

begin
  begin
-- estrazione della versione
  select '7'
    into V_versione
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
 select DATA_TYPE 
   into V_tipo 
   from user_tab_columns
  where table_name = 'IMMAGINI'
    and column_name = 'IMAGE'
   ;
 EXCEPTION WHEN NO_DATA_FOUND THEN 
     V_tipo := 'BLOB';
 END;
   IF V_tipo = 'BLOB' THEN NULL;
   ELSE
     BEGIN
      si4.sql_execute(' ALTER TABLE IMMAGINI DROP COLUMN IMAGE ');
      si4.sql_execute(' ALTER TABLE IMMAGINI ADD IMAGE BLOB ');
     END;
   END IF;
 END IF;
END;
/

