-- Create table
create table ATTRIBUZIONI_POSIZIONE_INAIL
(
  ATPI_ID         NUMBER(10) not null,
  GESTIONE        VARCHAR2(8) default '%' not null,
  PROFILO         VARCHAR2(4) default '%' not null,
  POSIZIONE       VARCHAR2(4) default '%' not null,
  FIGURA          VARCHAR2(8) default '%' not null,
  POSIZIONE_INAIL VARCHAR2(4) not null,
  CHIAVE          VARCHAR2(24) default '%%%%' not null,
  UTENTE          VARCHAR2(8),
  DATA_AGG        DATE
)
;
-- Add comments to the columns 
comment on column ATTRIBUZIONI_POSIZIONE_INAIL.ATPI_ID
  is 'Id progressivo (pk)';
comment on column ATTRIBUZIONI_POSIZIONE_INAIL.GESTIONE
  is 'Codice della Gestione di assegnazione';
comment on column ATTRIBUZIONI_POSIZIONE_INAIL.PROFILO
  is 'Codice del Profilo Professionale di appartenenza';
comment on column ATTRIBUZIONI_POSIZIONE_INAIL.POSIZIONE
  is 'Codice della Posizione Funzionale di appartenenza';
comment on column ATTRIBUZIONI_POSIZIONE_INAIL.FIGURA
  is 'Codice della Figura Giuridica di appartenenza';
comment on column ATTRIBUZIONI_POSIZIONE_INAIL.POSIZIONE_INAIL
  is 'Codice della posizione inail da attribuire';
comment on column ATTRIBUZIONI_POSIZIONE_INAIL.CHIAVE
  is 'Chiave di sintesi';
-- Create/Recreate indexes 
create index ATPI_IK on ATTRIBUZIONI_POSIZIONE_INAIL (CHIAVE)
;
create unique index ATPI_IK2 on ATTRIBUZIONI_POSIZIONE_INAIL (GESTIONE, PROFILO, POSIZIONE, FIGURA)
;
create unique index ATPI_PK on ATTRIBUZIONI_POSIZIONE_INAIL (ATPI_ID)
;
