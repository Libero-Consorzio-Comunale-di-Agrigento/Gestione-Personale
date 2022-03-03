REM  Objects being generated in this file are:-
REM TABLE
REM      TEMP_PERE_IPN
REM INDEX
REM      TEPI_IK
REM      TEPI_IK2

REM
REM    TEPI - Tabella di servizio per calcolo cedolino
REM
PROMPT 
PROMPT Creating Table TEMP_PERE_IPN

create table temp_pere_ipn
( CACO_ROWID                      ROWID         NOT NULL
, CI                              NUMBER(8)     NOT NULL
, PERIODO                         DATE          NOT NULL
, DAL                             DATE          NOT NULL
, AL                              DATE          NOT NULL
, PEGI_AL                         DATE
, RIFERIMENTO                     DATE          NOT NULL
, RUOLO                           VARCHAR2(4)
, COD_ASTENSIONE                  VARCHAR2(4)
, RAP_ORE                         NUMBER(9,6)
, COMPETENZA                      VARCHAR2(1)   NOT NULL
, INTERO                          NUMBER(5,2)   NOT NULL
, QUOTA                           NUMBER(5,2)   NOT NULL
, GESTIONE                        VARCHAR2(8)   NOT NULL
, CONTRATTO                       VARCHAR2(4)   NOT NULL
, TRATTAMENTO                     VARCHAR2(4)   NOT NULL
, GG_FIS                          NUMBER(3)     NOT NULL
, FUNZIONALE                      VARCHAR2(8)
, PART_TIME                       VARCHAR2(2)
, CAT_MINIMALE                    NUMBER(1)
, CLASSE                          VARCHAR2(1)
, SPECIE                          VARCHAR2(1)
, RAPPORTO                        VARCHAR2(1)
, FISCALE                         VARCHAR2(1)
, mol_ipn_c                       NUMBER(1)
, mol_ipn_s                       NUMBER(1)
, mol_ipn_p                       NUMBER(1)
, mol_ipn_l                       NUMBER(1)
, mol_ipn_e                       NUMBER(1)
, mol_ipn_t                       NUMBER(1)
, mol_ipn_a                       NUMBER(1)
, mol_ipn_ap                      NUMBER(1)
, assesta_segno                   NUMBER(1)
)
;

COMMENT ON TABLE temp_pere_ipn
    IS 'TEPI - Tabella di servizio per calcolo cedolino';
REM
REM 

PROMPT Creating Index TEPI_IK on Table TEMP_PERE_IPN
CREATE INDEX TEPI_IK ON TEMP_PERE_IPN
(
      caco_rowid)
;
REM
REM  End of command file
REM
