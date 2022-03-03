create table PONDERAZIONI_INAIL_INDIVIDUALI
(
  CI           NUMBER(8) not null,
  VOCE_RISCHIO VARCHAR2(5) not null,
  ALIQUOTA     NUMBER(5,2) not null,
  DAL          DATE not null,
  AL           DATE,
  POII_ID      NUMBER(10) not null,
  UTENTE       VARCHAR2(8),
  DATA_AGG     DATE
)
;
 
comment on table PONDERAZIONI_INAIL_INDIVIDUALI
  is 'Ripartizione individuale sulle voci di rischio per l''autoliquidazione INAIL ';

create unique index POII_PK on PONDERAZIONI_INAIL_INDIVIDUALI (POII_ID)
;

create unique index POII_UK on PONDERAZIONI_INAIL_INDIVIDUALI (CI, VOCE_RISCHIO, DAL)
;

create index POII_VORI_FK on PONDERAZIONI_INAIL_INDIVIDUALI (VOCE_RISCHIO)
;
