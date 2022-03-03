alter table certificati
  add u_presso varchar2(2);

update certificati set u_presso = 'NO';
commit;

alter table certificati 
modify u_presso varchar2(2) not null;

start crv_pegi_qi.sql
start crv_pegi_se.sql
start crp_cursore_certificato.sql
start crp_pgmscert.sql


