-- Definita la tabella MODELLI_NOTE

CREATE TABLE MODELLI_NOTE ( 
  NOTA               NUMBER(6)        NOT NULL, 
  DENOMINAZIONE      varchar2 (60)     NOT NULL, 
  DENOMINAZIONE_AL1  varchar2 (60), 
  DENOMINAZIONE_AL2  varchar2 (60), 
  NOTE               varchar2 (4000), 
  NOTE_AL1           varchar2 (4000), 
  NOTE_AL2           varchar2 (4000), 
  DAL                DATE          NOT NULL, 
  AL                 DATE, 
  UTENTE             varchar2(8), 
  DATA_AGG           DATE);


-- Definito indice unico mono_pk su nota, denominazione, dal

CREATE UNIQUE INDEX MONO_PK ON MODELLI_NOTE (NOTA,DENOMINAZIONE,DAL);

  