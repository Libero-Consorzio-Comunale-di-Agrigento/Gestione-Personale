CREATE TABLE DEPOSITO_VARIABILI_ECONOMICHE
(
  INPUT                   VARCHAR2(10)          NOT NULL,
  RIFERIMENTO             DATE                  NOT NULL,
  DEVE_ID                 NUMBER(10)            NOT NULL,
  CI                      NUMBER(8)             NOT NULL,
  ANNO                    NUMBER(4),
  MESE                    NUMBER(2),
  MENSILITA               VARCHAR2(3),
  VOCE                    VARCHAR2(10)          NOT NULL,
  SUB                     VARCHAR2(2)           NOT NULL,
  ARR                     VARCHAR2(1),
  TAR                     NUMBER(15,5),
  QTA                     NUMBER(14,4),
  IMP                     NUMBER(12,2),
  SEDE_DEL                VARCHAR2(4),
  ANNO_DEL                NUMBER(4),
  NUMERO_DEL              NUMBER(7),
  DELIBERA                VARCHAR2(4),
  CAPITOLO                VARCHAR2(14),
  ARTICOLO                VARCHAR2(14),
  CONTO                   VARCHAR2(2),
  COMPETENZA              DATE,
  DATA_INSERIMENTO        DATE,
  UTENTE_INSERIMENTO      VARCHAR2(8),
  DATA_ACQUISIZIONE       DATE,
  UTENTE_ACQUISIZIONE     VARCHAR2(8),
  ANNO_LIQUIDAZIONE       NUMBER(4),
  MESE_LIQUIDAZIONE       NUMBER(2),
  MENSILITA_LIQUIDAZIONE  VARCHAR2(3),
  DISTINTA                number(8),
  DATA_DISTINTA           date,
  IMPEGNO                 NUMBER(5),
  RISORSA_INTERVENTO      VARCHAR2(7),
  ANNO_IMPEGNO            NUMBER(4),
  SUB_IMPEGNO             NUMBER(5),
  ANNO_SUB_IMPEGNO        NUMBER(4),
  codice_siope		  NUMBER(4)
)
;


CREATE UNIQUE INDEX DEVE_PK ON DEPOSITO_VARIABILI_ECONOMICHE
(INPUT, RIFERIMENTO, DEVE_ID)
;
CREATE INDEX DEVE_FK ON DEPOSITO_VARIABILI_ECONOMICHE
(INPUT)
;


