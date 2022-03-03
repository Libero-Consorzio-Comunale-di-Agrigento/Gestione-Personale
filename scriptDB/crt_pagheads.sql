create table PAGHEADS
(
  MATRICOLA   VARCHAR2(8),
  CODPAGHE    VARCHAR2(8),
  BADGE       VARCHAR2(8),
  DAL         VARCHAR2(8),
  AL          VARCHAR2(8),
  RIFERIMENTO VARCHAR2(8),
  CHIUSO      VARCHAR2(2),
  INPUT       VARCHAR2(1),
  CLASSE      VARCHAR2(10),
  DALLE       VARCHAR2(4),
  ALLE        VARCHAR2(4),
  VALORE      VARCHAR2(12),
  CDC         VARCHAR2(10),
  SEDE        VARCHAR2(6),
  NOTE        VARCHAR2(240),
  UTENTE      VARCHAR2(8),
  DATA_AGG    VARCHAR2(8),
  SETTORE     VARCHAR2(15),
  VOCE        VARCHAR2(10),
  SUB         VARCHAR2(2)
)
;
create index pagheads_ik1 on pagheads (settore,voce,sub);
create index pagheads_ik2 on pagheads (data_agg);
