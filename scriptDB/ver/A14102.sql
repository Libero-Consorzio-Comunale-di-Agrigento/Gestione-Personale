DECLARE
V_controllo varchar2(1);
V_comando   varchar2(1000);

BEGIN
 BEGIN
  select 'Y' 
    into V_controllo
    from dual
   where exists ( select 'x' from obj 
                   where object_name = 'ADIR_PRIMA_DELLA_14102'
                 );
 EXCEPTION WHEN NO_DATA_FOUND THEN V_controllo := 'X';
 END;
/* Salvataggio Dati */
 IF V_controllo = 'Y' THEN NULL;
 ELSE
   V_comando := 'create table ADIR_PRIMA_DELLA_14102 as select * from ADDIZIONALE_IRPEF_REGIONALE';
   si4.sql_execute(V_comando);
 END IF;
END;
/

DECLARE
V_dal     date;
BEGIN
FOR CUR_ADIR in 
( select distinct dal, al
    from ADDIZIONALE_IRPEF_REGIONALE 
   where dal is null
) 
LOOP
/* Sistemazione EVentuali DAL vuoti */
 IF  CUR_ADIR.al is not null THEN
 BEGIN
   select dal
     into V_dal
     from validita_fiscale
    where al = CUR_ADIR.al
    ;
 EXCEPTION WHEN NO_DATA_FOUND THEN
    select min(dal)
      into V_dal
      from validita_fiscale
     ;
 END;
 ELSE 
  BEGIN
    select dal
      into V_dal
      from validita_fiscale
     where al is null
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN
    select min(dal)
      into V_dal
      from validita_fiscale
     ;
  END;
 END IF;
 IF V_dal is null THEN V_dal := to_date('01011940','ddmmyyyy');
 END IF;
 BEGIN
    update ADDIZIONALE_IRPEF_REGIONALE 
       set dal = V_dal
     where dal is null
       and nvl(al,sysdate) = nvl(CUR_ADIR.al,sysdate)
   ;
 commit;
 END;
END LOOP;
/* Sistemazione scaglioni nulli */
update ADDIZIONALE_IRPEF_REGIONALE 
   set scaglione = 0
 where nvl(scaglione,0) = 0;
commit;
END;
/

BEGIN
/* cancellazione record doppi vecchi */
   FOR CUR_DEL in 
      ( select cod_regione, dal, scaglione, count(*) record
          from ADDIZIONALE_IRPEF_REGIONALE adir
         where nvl(al,to_date('3333333','j')) < to_date('01012006','ddmmyyyy') 
         group by cod_regione, dal, scaglione
         having count(*) > 1
      ) LOOP
      BEGIN
        delete from ADDIZIONALE_IRPEF_REGIONALE
         where dal = CUR_DEL.dal
           and cod_regione = CUR_DEL.cod_regione
           and scaglione = CUR_DEL.scaglione
           and rownum < CUR_DEL.record
        ;
       commit;
      END;
     END LOOP;
END;
/

alter table ADDIZIONALE_IRPEF_REGIONALE modify dal NOT NULL;
alter table ADDIZIONALE_IRPEF_REGIONALE modify scaglione NOT NULL;

DROP INDEX AIRE_PK;

CREATE UNIQUE INDEX AIRE_PK ON ADDIZIONALE_IRPEF_REGIONALE
( cod_regione
 , dal
 , scaglione )
;