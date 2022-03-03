create table new_pip_ref_codes
as select distinct *
from pip_ref_codes;

truncate table pip_ref_codes;

insert into pip_ref_codes 
select * from new_pip_ref_codes;

insert into pip_ref_codes 
( rv_low_value, rv_meaning, rv_domain )
select  'P','Provvisoria','PROGETTI_INCENTIVO.SITUAZIONE'
from dual
where not exists ( select 'x' from pip_ref_codes 
where rv_domain = 'PROGETTI_INCENTIVO.SITUAZIONE'
and rv_low_value = 'P');