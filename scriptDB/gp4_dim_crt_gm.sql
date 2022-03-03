column C1 noprint new_value P1

select count(*) C1
  from anagrafici
 where al is null
;

start crt_gp4gm.sql &P1
