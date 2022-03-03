SET SCAN OFF

REM
REM TABLE
REM      DENUNCIA_EMENS
REM INDEX
REM     DEIE_PK
REM     DEIE_IK
REM
REM     DEIE - Archivio Denuncia I.N.P.S. EMENS

PROMPT 
PROMPT Creating Table denuncia_emens
CREATE TABLE denuncia_emens
(
 deie_id            NUMBER(10)     NOT NULL,
 ci                 NUMBER(8)      NOT NULL,
 anno               NUMBER(4)      NOT NULL,
 mese               NUMBER(2)      NOT NULL,
 dal                DATE           NOT NULL,
 al                 DATE               NULL,
 rilevanza          VARCHAR2(1)        NULL,
 gestione           VARCHAR2(8)    NOT NULL,
 specie_rapporto    VARCHAR2(4)    NOT NULL,
 riferimento        VARCHAR2(6)        NULL,
 rettifica          VARCHAR2(1)        NULL,
 qualifica1         VARCHAR2(1)        NULL,
 qualifica2         VARCHAR2(1)        NULL,
 qualifica3         VARCHAR2(1)        NULL,
 tipo_contribuzione VARCHAR2(2)        NULL,
 codice_contratto   VARCHAR2(3)        NULL,
 giorno_assunzione  NUMBER(2)          NULL, 
 tipo_assunzione    VARCHAR2(2)        NULL,
 giorno_cessazione  NUMBER(2)          NULL,
 tipo_cessazione    VARCHAR2(2)        NULL,
 tipo_lavoratore    VARCHAR2(2)        NULL,
 imponibile         NUMBER(11,2)       NULL,
 contributo         NUMBER(12,2)       NULL,
 bonus              NUMBER(12,2)       NULL,
 ritenuta           NUMBER(12,2)       NULL,
 aliquota           NUMBER(5,2)        NULL,
 giorni_retribuiti  NUMBER(2)          NULL,
 settimane_utili    NUMBER(5,2)        NULL,
 tab_anf            VARCHAR2(3)        NULL,
 num_anf            NUMBER(2)          NULL,
 classe_anf         NUMBER(3)          NULL,
 tfr                NUMBER(11,2)       NULL,
 tipo_rapporto      VARCHAR2(2)        NULL,
 cod_attivita       VARCHAR2(2)        NULL,
 altra_ass          VARCHAR2(3)        NULL,
 imp_agevolazione   NUMBER(11,2)       NULL,
 tipo_agevolazione  VARCHAR(2)         NULL,
 cod_calamita       VARCHAR(2)         NULL,
 cod_certificazione VARCHAR(3)         NULL,
 codice_catasto     varchar2(4)        NULL,
 GESTIONE_ALTERNATIVA  VARCHAR2(8)     NULL,
 utente		    VARCHAR2(8)	       NULL,
 tipo_agg	    VARCHAR2(1)	       NULL,
 data_agg	    DATE	       NULL
);

COMMENT ON TABLE DENUNCIA_EMENS
    IS 'DEIE - Archivio Denuncia I.N.P.S. EMENS';

PROMPT
PROMPT Creating Index DEIE_PK on Table DENUNCIA_EMENS
CREATE UNIQUE INDEX DEIE_PK on DENUNCIA_EMENS
(     deie_id
)
PCTFREE  10
;

PROMPT
PROMPT Creating Index DEIE_IK on Table DENUNCIA_EMENS
CREATE INDEX DEIE_IK on DENUNCIA_EMENS
(     ci
    , anno
    , mese
    , dal
)
PCTFREE  10
;

