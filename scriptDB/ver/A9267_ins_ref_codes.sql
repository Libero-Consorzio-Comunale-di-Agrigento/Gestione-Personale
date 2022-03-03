delete from pgm_ref_codes
where substr(rv_low_value,1,2) in ('30','31','32')
  and rv_domain = 'ASTENSIONI.CAT_FISCALE'
/
INSERT INTO PGM_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) 
VALUES ( '30', NULL, NULL, 'ASTENSIONI.CAT_FISCALE', 'Servizio non utile ( per il CUD/2005: Servizio ed aspettativa non retribuita per motivi sindacali (art. 31, L.300/1970) )'
, NULL, NULL, NULL); 
INSERT INTO PGM_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) 
VALUES ( '32', NULL, NULL, 'ASTENSIONI.CAT_FISCALE', 'Servizio ed aspettativa non retribuita per motivi sindacali (art. 31, L.300/1970)'
, NULL, NULL, NULL); 
COMMIT;