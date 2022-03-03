DECLARE
V_type    varchar2(100);
V_esiste  varchar2(2);
V_comando varchar2(2000);

BEGIN
-- Creazione indice su oggetto quietanze_contabilita se table
  V_type := '';
  V_esiste := 'NO';
  V_comando := '';
  BEGIN
    select object_type
      into V_type 
      from obj
     where object_name = 'QUIETANZE_CONTABILITA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
     V_type := 'NULL';
  END;
  IF V_type = 'TABLE' THEN
     BEGIN
       select 'SI'
         into V_esiste
         from obj
        where object_name = 'QUCO_PK'
       ;
     EXCEPTION WHEN NO_DATA_FOUND THEN
        V_esiste := 'NO';
     END;
     IF V_esiste = 'NO' THEN
        V_comando := 'CREATE UNIQUE INDEX QUCO_PK ON QUIETANZE_CONTABILITA ( SOGGETTO, NUM_QUIETANZA)';
        si4.sql_execute(V_comando);
     END IF;
  END IF;
-- Creazione indice su oggetto capitoli_contabilita se table
  V_type := '';
  V_esiste := 'NO';
  V_comando := '';
  BEGIN
    select object_type
      into V_type 
      from obj
     where object_name = 'CAPITOLI_CONTABILITA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
     V_type := 'NULL';
  END;
  IF V_type = 'TABLE' THEN
     BEGIN
       select 'SI'
         into V_esiste
         from obj
        where object_name = 'CAPC_PK'
       ;
     EXCEPTION WHEN NO_DATA_FOUND THEN
        V_esiste := 'NO';
     END;
     IF V_esiste = 'NO' THEN
        V_comando := 'CREATE UNIQUE INDEX CAPC_PK ON CAPITOLI_CONTABILITA ( ESERCIZIO, E_S, RISORSA_INTERVENTO, CAPITOLO, ARTICOLO)';
        si4.sql_execute(V_comando);
     END IF;
  END IF;

-- Creazione indice su oggetto acc_imp_contabilita se table
  V_type := '';
  V_esiste := 'NO';
  V_comando := '';
  BEGIN
    select object_type
      into V_type 
      from obj
     where object_name = 'ACC_IMP_CONTABILITA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
     V_type := 'NULL';
  END;
  IF V_type = 'TABLE' THEN
     BEGIN
       select 'SI'
         into V_esiste
         from obj
        where object_name = 'ACON_PK'
       ;
     EXCEPTION WHEN NO_DATA_FOUND THEN
        V_esiste := 'NO';
     END;
     IF V_esiste = 'NO' THEN
      V_comando := 'update ACC_IMP_CONTABILITA '||
                   '   set esercizio = nvl(esercizio, 1900)'||
                   '     , e_s       = nvl(e_s,''S'')'||
                   '     , risorsa_intervento = nvl(risorsa_intervento, rownum)'||
                   '     , capitolo = nvl(capitolo, rownum)'||
                   '     , articolo = nvl(articolo, rownum)'||
                   '     , anno_imp_acc = nvl(anno_imp_acc, 1900)'||
                   '     , numero_imp_acc = nvl(numero_imp_acc, rownum)'||
                   ' where ( esercizio is null'||
                   '      or e_s is null'||
                   '      or risorsa_intervento is null'||
                   '      or capitolo is null'||
                   '      or articolo is null'||
                   '      or anno_imp_acc is null'||
                   '      or numero_imp_acc is null'||
                   '        )';
        si4.sql_execute(V_comando);
        V_comando := 'alter table acc_imp_contabilita modify '||
                     '( ESERCIZIO                                NUMBER       NOT NULL '||
                     ', E_S                                      VARCHAR2(1)  NOT NULL '||
                     ', RISORSA_INTERVENTO                       NUMBER       NOT NULL '||
                     ', CAPITOLO                                 NUMBER       NOT NULL '||
                     ', ARTICOLO                                 NUMBER       NOT NULL '||
                     ', ANNO_IMP_ACC                             NUMBER       NOT NULL '||
                     ', NUMERO_IMP_ACC                           NUMBER       NOT NULL )';
        si4.sql_execute(V_comando);
        V_comando := 'CREATE UNIQUE INDEX ACON_PK ON ACC_IMP_CONTABILITA( ESERCIZIO, E_S, RISORSA_INTERVENTO, CAPITOLO, ARTICOLO, ANNO_IMP_ACC, NUMERO_IMP_ACC)';
        si4.sql_execute(V_comando);
     END IF;
  END IF;
-- Creazione indice su oggetto subimp_contabilita se table
  V_type := '';
  V_esiste := 'NO';
  V_comando := '';
  BEGIN
    select object_type
      into V_type 
      from obj
     where object_name = 'SUBIMP_CONTABILITA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
     V_type := 'NULL';
  END;

  IF V_type = 'TABLE' THEN
     BEGIN
       select 'SI'
         into V_esiste
         from obj
        where object_name = 'SUCO_PK'
       ;
     EXCEPTION WHEN NO_DATA_FOUND THEN
        V_esiste := 'NO';
     END;
     IF V_esiste = 'NO' THEN
        V_comando := 'update SUBIMP_CONTABILITA'||
                     '   set e_s       = nvl(e_s,''S'')'||
                     ' where e_s is null';
        si4.sql_execute(V_comando);
        V_comando := 'alter table SUBIMP_CONTABILITA modify  E_S VARCHAR2(1)  NOT NULL ';
        si4.sql_execute(V_comando);
        V_comando := 'CREATE UNIQUE INDEX SUCO_PK ON  SUBIMP_CONTABILITA '||
                     '( ESERCIZIO, E_S, RISORSA_INTERVENTO, CAPITOLO, ARTICOLO, ANNO_IMP, NUMERO_IMP , ANNO_SUBIMP, NUMERO_SUBIMP)';
        si4.sql_execute(V_comando);
     END IF;
  END IF;
END;
/