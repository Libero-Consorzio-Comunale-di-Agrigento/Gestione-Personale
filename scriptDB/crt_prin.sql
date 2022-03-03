CREATE TABLE PREMI_INAIL ( 
  POSIZIONE        VARCHAR2 (4), 
  RUOLO            VARCHAR2 (4), 
  ANNO             NUMBER   (4), 
  IPN_PRESUNTO     NUMBER   (12,2), 
  ALQ_PRESUNTA     NUMBER   (7,5), 
  PREMIO_PRESUNTO  NUMBER   (12,2), 
  IPN_EFFETTIVO    NUMBER   (12,2), 
  ALQ_EFFETTIVA    NUMBER   (7,5), 
  SALDO_PREMIO     NUMBER   (12,2),
  PRIN_ID          NUMBER   (10) NOT NULL
)
;
create index PRIN_IK on premi_inail (anno,posizione,ruolo);

create unique index PRIN_PK on premi_inail (prin_id);