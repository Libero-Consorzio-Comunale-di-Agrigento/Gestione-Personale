CREATE TABLE QUALIFICHE_STATISTICHE ( 
  STATISTICA   VARCHAR2 (6)  NOT NULL, 
  CODICE       VARCHAR2 (6)  NOT NULL, 
  DESCRIZIONE  VARCHAR2 (45), 
  SEQUENZA     NUMBER(6),
  TIPO VARCHAR2(1)); 


CREATE UNIQUE INDEX QUST_PK ON 
  QUALIFICHE_STATISTICHE(STATISTICA, CODICE); 
