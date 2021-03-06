alter table trattamenti_contabili add (tipo_trattamento varchar2(1)  default '0' not null);

drop index trco_pk;

CREATE UNIQUE INDEX TRCO_PK ON TRATTAMENTI_CONTABILI
(PROFILO_PROFESSIONALE, POSIZIONE, TIPO_TRATTAMENTO);

alter table rapporti_retributivi add (tipo_trattamento varchar2(1));

alter table rapporti_retributivi_storici add (tipo_trattamento varchar2(1));

start crf_rars_tma.sql

INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'0', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.TIPO_TRATTAMENTO', 'Valore di default'
, NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'1', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.TIPO_TRATTAMENTO', 'TFS', NULL, NULL, NULL); 
INSERT INTO PEC_REF_CODES ( RV_LOW_VALUE, RV_HIGH_VALUE, RV_ABBREVIATION, RV_DOMAIN, RV_MEANING,
RV_TYPE, RV_MEANING_AL1, RV_MEANING_AL2 ) VALUES ( 
'2', NULL, NULL, 'TRATTAMENTI_PREVIDENZIALI.TIPO_TRATTAMENTO', 'TFR', NULL, NULL, NULL); 
