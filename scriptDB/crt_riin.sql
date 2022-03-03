CREATE TABLE RIMBORSI_INFORTUNIO
(
  PROGRESSIVO     NUMBER(8),
  DAL             DATE,
  AL              DATE,
  NUMERO_PRATICA  NUMBER(10),
  IMPORTO         NUMBER(12,2),
  CAUSALE         VARCHAR2(50)
);


CREATE UNIQUE INDEX RIIN_PK ON RIMBORSI_INFORTUNIO
(PROGRESSIVO, NUMERO_PRATICA, DAL);
