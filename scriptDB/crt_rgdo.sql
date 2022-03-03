CREATE TABLE RIGHE_GRUPPI_DOTAZIONE ( 
  RGDO_ID    NUMBER (10)   NOT NULL, 
  REVISIONE  NUMBER (8)    NOT NULL, 
  DOOR_ID    NUMBER (10)   NOT NULL, 
  RIGD_ID    NUMBER (10)   NOT NULL, 
  DAL        DATE          NOT NULL, 
  AL         DATE);


CREATE UNIQUE INDEX RGDO_PK ON RIGHE_GRUPPI_DOTAZIONE
(RGDO_ID);