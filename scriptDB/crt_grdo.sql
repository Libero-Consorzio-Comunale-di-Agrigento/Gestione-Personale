CREATE TABLE GRUPPI_DOTAZIONE ( 
  GRUPPO           VARCHAR2 (10)  NOT NULL, 
  DESCRIZIONE      VARCHAR2 (120)  NOT NULL, 
  DESCRIZIONE_AL1  VARCHAR2 (120), 
  DESCRIZIONE_AL2  VARCHAR2 (120));

CREATE UNIQUE INDEX GRDO_PK ON GRUPPI_DOTAZIONE
(GRUPPO);