-- Create table
create table RELAZIONI_COMPONENTI
(
  GESTIONE        VARCHAR2(8) not null,
  RESPONSABILE_ID NUMBER(8) not null,
  NI_RESPONSABILE NUMBER(8) not null,
  CI_RESPONSABILE NUMBER(8) not null,
  NI              NUMBER(8) not null,
  CI              NUMBER(8) not null,
  REVISIONE_UO    NUMBER(8) not null,
  UO              NUMBER(8) not null,
  COMPONENTE      NUMBER(8),
  TIPO            VARCHAR2(1) not null,
  DAL             DATE not null,
  AL              DATE,
  RILEVANZA       VARCHAR2(1),
  LIVELLO_UO      NUMBER(2)
)
;
-- Add comments to the columns 
comment on column RELAZIONI_COMPONENTI.GESTIONE
  is 'Codice della gestione della unita organizzativa';
comment on column RELAZIONI_COMPONENTI.RESPONSABILE_ID
  is 'ID del componente del responsabile';
comment on column RELAZIONI_COMPONENTI.NI_RESPONSABILE
  is 'NI del responsabile';
comment on column RELAZIONI_COMPONENTI.CI_RESPONSABILE
  is 'CI del responsabile';
comment on column RELAZIONI_COMPONENTI.NI
  is 'NI del dipendente';
comment on column RELAZIONI_COMPONENTI.CI
  is 'CI del dipendente';
comment on column RELAZIONI_COMPONENTI.REVISIONE_UO
  is 'Revisione della unita organizzativa del dipendente';
comment on column RELAZIONI_COMPONENTI.UO
  is 'NI della unita organizzativa del dipendente';
comment on column RELAZIONI_COMPONENTI.COMPONENTE
  is 'ID del dipendente se componente';
comment on column RELAZIONI_COMPONENTI.TIPO
  is 'R=Responsabile, D=Dipendente, C=Componente Dipendente';
comment on column RELAZIONI_COMPONENTI.DAL
  is 'Per i responsabili: periodo di responsabilita; per i dipendenti: periodo di dipendenza ';
comment on column RELAZIONI_COMPONENTI.RILEVANZA
  is 'Rilevanza del periodo giuridico di dipendenza';
comment on column RELAZIONI_COMPONENTI.LIVELLO_UO
  is 'Livello gerarchico dell''unita organizzativa';
-- Create/Recreate indexes 
create index RECO_IK on RELAZIONI_COMPONENTI (NI_RESPONSABILE, NI)
;
