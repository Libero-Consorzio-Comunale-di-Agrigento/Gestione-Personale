PROMPT Argomento 1 = Utente di Ambiente
column C1 noprint new_value P1

select '&1' C1
  from dual
;
create synonym A_PRENOTAZIONI_LOG for &P1.A_PRENOTAZIONI_LOG;