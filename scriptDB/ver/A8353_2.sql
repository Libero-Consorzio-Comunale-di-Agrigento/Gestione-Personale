update pec_ref_codes
   set rv_low_value = '3'
 where rv_domain = 'TRATTAMENTI_PREVIDENZIALI.CONTRIBUZIONE'
   and rv_low_value = '03';