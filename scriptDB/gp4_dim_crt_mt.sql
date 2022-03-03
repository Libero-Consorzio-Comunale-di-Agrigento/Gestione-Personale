column C1 noprint new_value P1

select count(*) C1
  from anagrafici
 where al is null
;

start crt_gp4mt.sql &P1
start crt_gp4mt1.sql &P1
start crt_gp4mt2.sql &P1


