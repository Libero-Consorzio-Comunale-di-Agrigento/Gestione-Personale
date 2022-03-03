DECLARE
V_controllo varchar2(1);
V_comando   varchar2(1000);
V_tipo      varchar2(106);

BEGIN
 BEGIN
  select 'Y' 
    into V_controllo
    from dual
   where exists ( select 'x' from obj 
                   where object_name = 'COVO_PRIMA_DELLA_16753'
                 );
 EXCEPTION WHEN NO_DATA_FOUND THEN V_controllo := 'X';
 END;
 IF V_controllo = 'Y' THEN NULL;
 ELSE
    select DATA_TYPE 
      into V_tipo
      from user_tab_columns
     where table_name = 'CONTABILITA_VOCE'
       and COLUMN_NAME    = 'RISORSA_INTERVENTO'
   ;
   IF V_tipo = 'NUMBER' THEN

   V_comando := 'create table COVO_PRIMA_DELLA_16753 as select * from CONTABILITA_VOCE';
   si4.sql_execute(V_comando);

   update CONTABILITA_VOCE
      set risorsa_intervento = ''
    where risorsa_intervento is not null;

   V_comando := 'alter table CONTABILITA_VOCE modify risorsa_intervento varchar2(7)';
   si4.sql_execute(V_comando);

   V_comando := 
    'update CONTABILITA_VOCE covo
      set risorsa_intervento = ( select to_char(risorsa_intervento)
                                   from COVO_PRIMA_DELLA_16753
                                  where voce = covo.voce
                                    and sub = covo.sub
                                    and nvl(dal,to_date(''3333333'',''j'')) = nvl(covo.dal,to_date(''3333333'',''j''))
                               )
    where exists ( select ''x'' 
                     from COVO_PRIMA_DELLA_16753
                    where voce = covo.voce
                      and sub = covo.sub
                      and nvl(dal,to_date(''3333333'',''j'')) = nvl(covo.dal,to_date(''3333333'',''j''))
                      and risorsa_intervento is not null
                )';
   si4.sql_execute(V_comando);
   END IF;
 END IF;
END;
/
