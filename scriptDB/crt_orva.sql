CREATE TABLE ORIGINI_VARIABILI
(
  ORIGINE       VARCHAR2(10)                    NOT NULL,
  DESCRIZIONE   VARCHAR2(120)                   NOT NULL,
  SEQUENZA      NUMBER(4),
  OBBLIGATORIO  VARCHAR2(2)                     NOT NULL,
  NOTE          VARCHAR2(2000),
  MENSILITA     VARCHAR2(2)                     NOT NULL,
  UTENTE        VARCHAR2(8),
  DATA_AGG      DATE
)
;


CREATE UNIQUE INDEX ORVA_PK ON ORIGINI_VARIABILI
(ORIGINE)
;

