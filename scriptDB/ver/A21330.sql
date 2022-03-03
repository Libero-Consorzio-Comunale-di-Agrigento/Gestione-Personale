-- Ponderazione Individuale INAIL

-- Tabella PONDERAZIONI_INAIL_INDIVIDUALI

start crt_poii.sql

-- Nuovi campi su PONDERAZIONE_INAIL

alter table PONDERAZIONE_INAIL add ALQ_PRESUNTA NUMBER(5,2);
alter table PONDERAZIONE_INAIL add ALQ_EFFETTIVA NUMBER(5,2);

