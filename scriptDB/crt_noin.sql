-- Definita la tabella NOTE_INDIVIDUALI

CREATE TABLE NOTE_INDIVIDUALI ( 
  ANNO       NUMBER(4)        NOT NULL, 
  MESE       NUMBER(2)        NOT NULL, 
  MENSILITA  VARCHAR2 (4)  NOT NULL, 
  NOTA       NUMBER(6)        , 
  CI         NUMBER(8)        NOT NULL, 
  NOTE       VARCHAR2 (4000), 
  NOTE_AL1   VARCHAR2 (4000), 
  NOTE_AL2   VARCHAR2 (4000), 
  UTENTE     VARCHAR2 (8), 
  DATA_AGG   DATE);

-- Definito indice noin_pk su anno, mese, mensilita, nota, ci

CREATE INDEX NOIN_PK ON NOTE_INDIVIDUALI (ANNO,MESE,MENSILITA,CI);
  