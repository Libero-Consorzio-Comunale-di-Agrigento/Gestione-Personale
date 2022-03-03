create table PGC_RECO_ANTE_13152_9 
as select * from  PGC_REF_CODES;

drop table PGC_REF_CODES;

CREATE TABLE PGC_REF_CODES ( 
  RV_LOW_VALUE     VARCHAR2(240)  NOT NULL, 
  RV_HIGH_VALUE    VARCHAR2(240), 
  RV_ABBREVIATION  VARCHAR2(240), 
  RV_DOMAIN        VARCHAR2(100)  NOT NULL, 
  RV_MEANING       VARCHAR2(240), 
  RV_MEANING_AL1   VARCHAR2(240), 
  RV_MEANING_AL2   VARCHAR2(240),
  RV_TYPE          VARCHAR2(10)) 
   PCTFREE 10   PCTUSED 40
   INITRANS 1   MAXTRANS 255
 STORAGE ( 
   INITIAL 8192 NEXT 4096 PCTINCREASE 50
   MINEXTENTS 1 MAXEXTENTS 100 )
   NOCACHE; 

CREATE INDEX X_PGC_REF_CODES_1 ON 
  PGC_REF_CODES(RV_DOMAIN, RV_LOW_VALUE) 
  STORAGE(INITIAL 14336 NEXT 4096 PCTINCREASE 50 ) ; 

insert into pgc_ref_codes
  (rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning, rv_meaning_al1, rv_meaning_al2, rv_type)
select 
  rv_low_value, rv_high_value, rv_abbreviation, rv_domain, rv_meaning, rv_meaning, rv_meaning, rv_type
 from PGC_RECO_ANTE_13152_9 
/
