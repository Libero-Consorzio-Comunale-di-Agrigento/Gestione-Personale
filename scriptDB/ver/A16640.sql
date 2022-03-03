DECLARE
v_comando    varchar2(200) := '';
BEGIN
FOR CUR_IDX IN
( select index_name
    from user_indexes
   where TABLE_NAME = 'CALCOLI_RETRIBUZIONI_INAIL'
) LOOP
  BEGIN
   V_comando := 'drop index '||CUR_IDX.index_name;
   si4.sql_execute(V_comando);
  END;
END LOOP;
END;
/

update CALCOLI_RETRIBUZIONI_INAIL 
set progressivo = 1
where nvl(quota,0) = nvl(intero,0)
  and progressivo is null;

update CALCOLI_RETRIBUZIONI_INAIL 
set progressivo = 2
where nvl(quota,0) != nvl(intero,0)
  and progressivo is null;

alter table CALCOLI_RETRIBUZIONI_INAIL
modify PROGRESSIVO not null;

create unique index CARI_PK on CALCOLI_RETRIBUZIONI_INAIL 
(  CI ASC,
   ANNO ASC,
   MESE ASC,
   DAL ASC,
   PROGRESSIVO
);

start crp_peccrein.sql