PROMPT Argomento 1 = Numero Dipendenti

column C1 noprint new_value P1

select least(nvl(&1,10),10000) C1
  from dual
;


start crt_gp4mt.sql &P1
start crt_gp4mt1.sql &P1
start crt_gp4mt2.sql &P1

start crq_dist.sql
start crq_redi.sql
start crq_riri.sql
start crq_rirr.sql
start crq_gp4mt_deve.sql

