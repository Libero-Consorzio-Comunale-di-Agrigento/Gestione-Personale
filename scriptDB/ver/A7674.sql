alter table certificati
  add autocertificazione varchar2(2)
/

update certificati set autocertificazione = 'NO'
 where autocertificazione is null
/

alter table certificati 
modify autocertificazione varchar2(2) not null
/

insert into pgm_ref_codes
       (rv_domain,rv_low_value,rv_meaning)
values ('VOCABOLO','SOTTOSCRITTO','io sottoscritto')
/
insert into pgm_ref_codes
       (rv_domain,rv_low_value,rv_meaning)
values ('VOCABOLO','SOTTOSCRITTA','io sottoscritta')
/

start crp_pgmscert.sql
