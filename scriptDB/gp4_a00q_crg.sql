PROMPT Argomento 1 = Utente di Progetto
column C1 noprint new_value P1

select '&1' C1
  from dual
;

grant select on a_comuni to &P1;                                                 
grant select on a_regioni to &P1;                                                
grant select on a_provincie to &P1;                                                       
grant select on a_stati_territori to &P1; 

