SET SCAN OFF

REM
REM TABLE
REM      VARIABILI_EMENS
REM INDEX
REM     VAIE_PK
REM     VAIE_IK1
REM
REM     VAIE - Archivio Variabili Denuncia I.N.P.S. EMENS

PROMPT 
PROMPT Creating Table variabili_emens
CREATE TABLE variabili_emens
(
 ci                 NUMBER(8)      NOT NULL,
 anno               NUMBER(4)      NOT NULL,
 mese               NUMBER(2)      NOT NULL,
 dal_emens          DATE           NOT NULL,
 deie_id            NUMBER(10)     NOT NULL,
 dal                DATE               NULL,
 al                 DATE               NULL,
 anno_rif           VARCHAR2(4)        NULL,
 aum_imponibile     NUMBER(11,2)       NULL,
 dim_imponibile     NUMBER(11,2)       NULL,
 utente		  VARCHAR2(8)	   NULL,
 tipo_agg		  VARCHAR2(1)	   NULL,
 data_agg		  DATE		   NULL
);

COMMENT ON TABLE VARIABILI_EMENS
    IS 'VAIE - Archivio Variabili Denuncia I.N.P.S. EMENS';

PROMPT
PROMPT Creating Index VAIE_PK on Table VARIABILI_EMENS
CREATE UNIQUE INDEX VAIE_PK on VARIABILI_EMENS
(     ci
    , anno
    , mese
    , dal_emens
    , anno_rif
)
PCTFREE  10
;
PROMPT
PROMPT Creating Index VAIE_IK1 on Table VARIABILI_EMENS
CREATE INDEX VAIE_IK1 on VARIABILI_EMENS
(     deie_id
)
PCTFREE  10
;