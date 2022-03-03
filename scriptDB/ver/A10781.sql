update pec_ref_codes
set rv_abbreviation = rv_low_value
where rv_low_value in
( '0','10','57','58','59','61','62','63','64','71','76','80','86')
and rv_domain = 'DENUNCIA_O1_INPS.TIPO_RAPPORTO'
and rv_abbreviation is null;