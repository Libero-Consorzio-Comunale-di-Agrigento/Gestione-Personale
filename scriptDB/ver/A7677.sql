update pgm_ref_codes
   set rv_meaning   = 'Progressioni Economiche:'
 where rv_domain    = 'VOCABOLO'
   and rv_low_value = 'PROGR_ECON'
/
update pgm_ref_codes
   set rv_meaning   = '------------------------'
 where rv_domain    = 'VOCABOLO'
   and rv_low_value = 'SOTT_PROGR'
/
update pgm_ref_codes
   set rv_meaning   = 'Matura il'
 where rv_domain    = 'VOCABOLO'
   and rv_low_value = 'MATURA'
/

start crp_cursore_certificato.sql
start crp_pgmscert.sql
