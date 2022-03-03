PROMPT Argomento 1 = Numero Dipendenti

column C1 noprint new_value P1

select least(nvl(&1,10),10000) C1
  from dual
;

start crt_gp4do.sql &P1