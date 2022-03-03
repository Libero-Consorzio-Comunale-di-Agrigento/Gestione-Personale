SET SCAN OFF
REM
REM TABLE
REM      SETTIMANE_EMENS
REM INDEX
REM     SEIE_PK
REM     SEIE_IK
REM     SEIE_IK1
REM
REM     SEIE - Archivio Settimane Denuncia I.N.P.S. EMENS

PROMPT 


PROMPT 
PROMPT Creating Table SETTIMANE_EMENS
CREATE TABLE SETTIMANE_EMENS
(
 ci                 NUMBER(8)      NOT NULL,
 anno               NUMBER(4)      NOT NULL,
 mese               NUMBER(2)      NOT NULL,
 dal_emens          DATE           NOT NULL,
 deie_id            NUMBER(10)     NOT NULL,
 id_settimana       NUMBER(2)          NULL,
 tipo_copertura     VARCHAR2(1)        NULL,
 codice_evento1     VARCHAR2(3)        NULL,
 diff_accredito1    NUMBER(11,2)       NULL,
 sett_accredito1    NUMBER(3)          NULL,
 codice_evento2     VARCHAR2(3)        NULL,
 diff_accredito2    NUMBER(11,2)       NULL,
 sett_accredito2    NUMBER(3)          NULL,
 codice_evento3     VARCHAR2(3)        NULL,
 diff_accredito3    NUMBER(11,2)       NULL,
 sett_accredito3    NUMBER(3)          NULL,
 codice_evento4     VARCHAR2(3)        NULL,
 diff_accredito4    NUMBER(11,2)       NULL,
 sett_accredito4    NUMBER(3)          NULL,
 codice_evento5     VARCHAR2(3)        NULL,
 diff_accredito5    NUMBER(11,2)       NULL,
 sett_accredito5    NUMBER(3)          NULL,
 codice_evento6     VARCHAR2(3)        NULL,
 diff_accredito6    NUMBER(11,2)       NULL,
 sett_accredito6    NUMBER(3)          NULL,
 codice_evento7     VARCHAR2(3)        NULL,
 diff_accredito7    NUMBER(11,2)       NULL,
 sett_accredito7    NUMBER(3)          NULL,
 dal                DATE           NOT NULL,
 al                 DATE           NOT NULL, 
 utente		  VARCHAR2(8)	   NULL,
 tipo_agg		  VARCHAR2(1)	   NULL,
 data_agg		  DATE		   NULL
);

COMMENT ON TABLE SETTIMANE_EMENS
    IS 'SEIE - Archivio Settimane Denuncia I.N.P.S. EMENS';

PROMPT
PROMPT Creating Index SEIE_PK on Table SETTIMANE_EMENS
CREATE INDEX SEIE_PK on SETTIMANE_EMENS
(     ci
    , anno
    , mese
    , id_settimana
    , dal
)
PCTFREE  10
;
PROMPT
PROMPT Creating Index SEIE_IK on Table SETTIMANE_EMENS
CREATE INDEX SEIE_IK on SETTIMANE_EMENS
(     anno
    , mese
    , ci
    , dal_emens
)
PCTFREE  10
;
PROMPT
PROMPT Creating Index SEIE_IK1 on Table SETTIMANE_EMENS
CREATE INDEX SEIE_IK1 on SETTIMANE_EMENS
(     deie_id
)
PCTFREE  10
;
