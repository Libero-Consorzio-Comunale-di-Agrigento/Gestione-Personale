CREATE TABLE ASSEGNAZIONI_BADGE
(
  ASBA_ID               NUMBER(10)              NOT NULL,
  NUMERO_BADGE          NUMBER(8)               NOT NULL,
  PROGRESSIVO_BADGE     NUMBER(3)               NOT NULL,
  CI                    NUMBER(8)               NOT NULL,
  DAL                   DATE                    NOT NULL,
  AL                    DATE,
  CAUSALE_ATTRIBUZIONE  VARCHAR2(20)            NOT NULL,
  CAUSALE_CHIUSURA      VARCHAR2(20),
  STATO                 VARCHAR2(1)             NOT NULL,
  NOTE                  VARCHAR2(4000),
  UTENTE                VARCHAR2(8),
  DATA_AGG              DATE
);
