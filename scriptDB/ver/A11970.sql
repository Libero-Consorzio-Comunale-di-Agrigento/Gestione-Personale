DELETE from PEC_REF_CODES
 WHERE rv_domain = 'MODELLI_STAMPA.DEFINIZIONE'
   AND rv_low_value = 'sel_note.note';

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'sel_note.note', '<C:', '80', 'MODELLI_STAMPA.DEFINIZIONE', 'Note Dell''Individuo (RNOCE)'
, 'CFG', NULL, NULL); 


