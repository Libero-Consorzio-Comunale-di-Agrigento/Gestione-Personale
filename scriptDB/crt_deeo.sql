CREATE TABLE DENUNCIA_EVENTI_ONAOSI
(
  ANNO               NUMBER(4)                  NOT NULL,
  PERIODO            NUMBER(4)                  NOT NULL,
  GESTIONE           VARCHAR2(8)                NOT NULL,
  CI                 NUMBER(8)                  NOT NULL,
  NR_EVENTO          NUMBER(2)                  NOT NULL,
  EVENTO             NUMBER(2)                  NOT NULL,
  DATA               DATE,
  UTENTE             VARCHAR2(8),
  TIPO_AGG           VARCHAR2(1),
  DATA_AGG           DATE
);

CREATE UNIQUE INDEX DEEO_PK ON DENUNCIA_EVENTI_ONAOSI
(ANNO, PERIODO, CI, NR_EVENTO);
CREATE INDEX DEEO_GEST_FK   ON DENUNCIA_EVENTI_ONAOSI
(GESTIONE);
