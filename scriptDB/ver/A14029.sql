alter table addizionale_irpef_regionale add regione number(2);

alter table validita_fiscale
modify ( ALIQUOTA_IRPEF_COMUNALE       NUMBER(7,4)
       , ALIQUOTA_IRPEF_REGIONALE      NUMBER(7,4)
       , ALIQUOTA_IRPEF_PROVINCIALE    NUMBER(7,4)
       )
;

alter table addizionale_irpef_comunale
modify ALIQUOTA   NUMBER(7,4)
;

alter table addizionale_irpef_regionale
modify ( ALIQUOTA         NUMBER(7,4)
       , ALIQUOTA_COND1   NUMBER(7,4)
       , ALIQUOTA_COND2   NUMBER(7,4)
       )
;

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'1', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Valle d''Aosta', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'10', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Marche', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'11', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Umbria', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'12', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Lazio', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'13', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Abruzzo', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'14', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Molise', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'15', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Campania', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'16', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Puglia', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'17', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Basilicata', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'18', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Calabria', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'19', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Sicilia', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'2', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Piemonte', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'20', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Sardegna', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'3', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Liguria', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'4', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Lombardia', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'5', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Trentino Alto Adige', 'CFG'
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'6', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Friuli Venezia Giulia', 'CFG'
, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'7', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Veneto', 'CFG', NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'8', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Emilia Romagna', 'CFG', NULL
, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'9', NULL, NULL, 'ADDIZIONALE_IRPEF_REGIONALE.REGIONE', 'Toscana', 'CFG', NULL, NULL); 

