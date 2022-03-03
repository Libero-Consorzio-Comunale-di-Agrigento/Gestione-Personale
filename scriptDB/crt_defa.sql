SET SCAN OFF

REM
REM TABLE
REM      DENUNCIA_FISCALE_AUTONOMI
REM INDEX

PROMPT 
PROMPT Creating Table DENUNCIA_FISCALE_AUTONOMI
CREATE TABLE DENUNCIA_FISCALE_AUTONOMI
( ANNO                   number(4) not null,
  CI                     number(8) not null,
  EREDE                  number(1),
  COD_EVENTO_ECCEZIONALE varchar2(1),
  CAUSALE                varchar2(1),
  LORDO                  number(12,2),
  NO_SOGG_RC             number(12,2),
  NO_SOGG                number(12,2),
  REG_AGEVOLATO          number(12,2),
  IMPONIBILE             number(12,2),
  RIT_ACCONTO            number(12,2),
  RIT_IMPOSTA            number(12,2),
  RIT_SOSPESE            number(12,2),
  PREV_EROGANTE          number(12,2),
  PREV_LAVORATORE        number(12,2),
  PREV_ENPAM             number(12,2),
  SPESE_RIMB             number(12,2),
  RIT_RIMB               number(12,2),
  ALTRE_RIT              number(12,2),
  UTENTE                 varchar2(8),
  TIPO_AGG               varchar2(1),
  DATA_AGG               date
)
;

COMMENT ON TABLE denuncia_fiscale
    IS 'DEFA - Archivio Denuncia Fiscale Autonomi';

PROMPT
PROMPT Creating Index DEFA_PK on Table DENUNCIA_FISCALE_AUTONOMI
CREATE INDEX DEFA_PK ON DENUNCIA_FISCALE_AUTONOMI
( anno , ci )
;
