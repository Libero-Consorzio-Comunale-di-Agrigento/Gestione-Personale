delete from PGM_REF_CODES
where RV_LOW_VALUE = '9'
and RV_DOMAIN = 'GESTIONI.FORMA_GIURIDICA'
;
INSERT INTO PGM_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'09', NULL, NULL, 'GESTIONI.FORMA_GIURIDICA', 'Fondazioni', NULL
, NULL, NULL)
; 