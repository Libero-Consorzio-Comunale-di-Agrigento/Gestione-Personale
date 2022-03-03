-- Nuova funzionalità della validazione della struttura (spezza PEGI al cambio di codice di UO)

-- Aggiunge nuovi campi alla tabella ENTE Versione definitiva

alter table ENTE add DIVIDI_PEGI_IN_VALIDAZIONE VARCHAR2(2) default 'NO';
comment on column ENTE.DIVIDI_PEGI_IN_VALIDAZIONE
  is 'Se SI, in validazione di revisione di struttura, vengono spezzati i periodi giuridici a cavallo della data REVISIONI_STRUTTURA.DAL';

start crp_gp4_ente.sql

start crp_gp4gm.sql













