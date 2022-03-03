SET SCAN OFF

REM
REM TABLE
REM      FONDI_SPECIALI_EMENS
REM INDEX
REM     FOSE_PK
REM     FOSE_IK1
REM
REM     FOSE - Archivio Fondi Speciali Denuncia I.N.P.S. EMENS

PROMPT 
PROMPT Creating Table fondi_speciali_emens
CREATE TABLE fondi_speciali_emens
(  
 ci                 NUMBER(8)      NOT NULL,
 anno               NUMBER(4)      NOT NULL,
 mese               NUMBER(2)      NOT NULL,
 fondo              VARCHAR2(10)   NOT NULL,
 dal_emens          DATE           NOT NULL,
 deie_id            NUMBER(10)     NOT NULL,
 dal                DATE               NULL,
 al                 DATE               NULL,
 anno_rif           VARCHAR2(4)        NULL,
 retr_pens          NUMBER(11,2)       NULL,
 gg_non_retr        NUMBER(3)          NULL,
 arretrati          NUMBER(11,2)       NULL,
 contr_sind         NUMBER(11,2)       NULL,
 utente		  VARCHAR2(8)	   NULL,
 tipo_agg		  VARCHAR2(1)	   NULL,
 data_agg		  DATE		   NULL
);

COMMENT ON TABLE FONDI_SPECIALI_EMENS
    IS 'VAIE - Archivio  Fondi Speciali Denuncia I.N.P.S. EMENS';

PROMPT
PROMPT Creating Index FOSE_PK on Table FONDI_SPECIALI_EMENS
CREATE INDEX FOSE_PK on FONDI_SPECIALI_EMENS
(     ci
    , anno
    , mese
    , fondo
    , dal_emens
    , anno_rif
)
PCTFREE  10
;

PROMPT
PROMPT Creating Index FOSE_IK1 on Table FONDI_SPECIALI_EMENS
CREATE INDEX FOSE_IK1 on FONDI_SPECIALI_EMENS
(     deie_id
)
PCTFREE  10
;


