SET SCAN OFF
REM
REM TABLE
REM      GESTIONE_TFR_EMENS
REM INDEX
REM     GETE_PK
REM     GETE_IK
REM
REM     GETE - Archivio Gestione TFR Denuncia I.N.P.S. EMENS

PROMPT 
PROMPT Creating Table GESTIONE_TFR_EMENS
CREATE TABLE GESTIONE_TFR_EMENS
(  
 ci                 NUMBER(8)      NOT NULL,
 anno               NUMBER(4)      NOT NULL,
 mese               NUMBER(2)      NOT NULL,
 dal_emens          DATE           NOT NULL,
 deie_id            NUMBER(10)     NOT NULL,
 base_calcolo       NUMBER(12,2)       NULL,
 imp_corrente       NUMBER(12,2)       NULL,
 imp_pregresso      NUMBER(12,2)       NULL,
 imp_liquidazione   NUMBER(12,2)       NULL,
 imp_anticipazione  NUMBER(12,2)       NULL,
 utente	            VARCHAR2(8)        NULL,
 tipo_agg           VARCHAR2(1)	       NULL,
 data_agg           DATE               NULL,
 base_calcolo_prev_compl         NUMBER(12,2)    NULL,
 tipo_scelta                     VARCHAR2(2)     NULL,
 data_scelta                     DATE            NULL,
 iscr_prev_obbl                  VARCHAR2(3)     NULL,
 iscr_prev_compl                 VARCHAR2(2)     NULL,
 fondo_tesoreria                 VARCHAR2(2)     NULL,
 data_adesione                   DATE            NULL,
 forma_prev_compl                NUMBER(4)       NULL,
 tipo_quota_prev_compl           VARCHAR2(4)     NULL,
 quota_prev_compl                NUMBER(5,2)     NULL
);

COMMENT ON TABLE GESTIONE_TFR_EMENS
    IS 'GETE - Archivio Gestione TFR Denuncia I.N.P.S. EMENS';

PROMPT
PROMPT Creating Index GETE_PK on Table GESTIONE_TFR_EMENS
CREATE UNIQUE INDEX GETE_PK on GESTIONE_TFR_EMENS
(     ci
    , anno
    , mese
    , dal_emens
)
PCTFREE  10
;

PROMPT
PROMPT Creating Index GETE_IK1 on Table GESTIONE_TFR_EMENS
CREATE INDEX GETE_IK1 on GESTIONE_TFR_EMENS
(     deie_id
)
PCTFREE  10
;
