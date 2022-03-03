SET SCAN OFF
REM
REM TABLE
REM      DATI_PARTICOLARI_EMENS
REM INDEX
REM     DAPE_PK
REM     DAPE_IK
REM     DAPE_IK1
REM
REM     DEIE - Archivio Dati Particolari Denuncia I.N.P.S. EMENS

PROMPT 
PROMPT Creating Table dati_particolari_emens
CREATE TABLE dati_particolari_emens
(  
 ci                 NUMBER(8)      NOT NULL,
 anno               NUMBER(4)      NOT NULL,
 mese               NUMBER(2)      NOT NULL,
 dal_emens          DATE           NOT NULL,
 deie_id            NUMBER(10)     NOT NULL,
 identificatore     VARCHAR2(10)       NULL,
 imponibile         NUMBER(9)          NULL,
 dal                DATE               NULL,
 al                 DATE               NULL,
 num_settimane      NUMBER(4)          NULL,
 settimane_utili    NUMBER(5,2)        NULL,
 anno_rif           NUMBER(4)          NULL,
 utente	            VARCHAR2(8)        NULL,
 tipo_agg           VARCHAR2(1)	       NULL,
 data_agg           DATE               NULL
);

COMMENT ON TABLE DATI_PARTICOLARI_EMENS
    IS 'DEIE - Archivio Dati Particolari Denuncia I.N.P.S. EMENS';

PROMPT
PROMPT Creating Index DAPE_PK on Table DATI_PARTICOLARI_EMENS
CREATE UNIQUE INDEX DAPE_PK on DATI_PARTICOLARI_EMENS
(     ci
    , anno
    , mese
    , identificatore
    , dal
)
PCTFREE  10
;
PROMPT
PROMPT Creating Index DAPE_IK on Table DATI_PARTICOLARI_EMENS
CREATE INDEX DAPE_IK on DATI_PARTICOLARI_EMENS
(     anno
    , mese
    , ci
    , dal_emens
)
PCTFREE  10
;

PROMPT
PROMPT Creating Index DAPE_IK1 on Table DATI_PARTICOLARI_EMENS
CREATE INDEX DAPE_IK1 on DATI_PARTICOLARI_EMENS
(     deie_id
)
PCTFREE  10
;
