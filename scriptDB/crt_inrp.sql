REM  Objects being generated in this file are:-
REM TABLE
REM      INFORMAZIONI_RETRIBUTIVE_BP
REM INDEX
REM      INRP_ISCR_FK
REM      INRP_PK
REM      INRP_QUAL_FK
REM      INRP_VOCO_FK

REM
REM    INRP - Informazioni su voci e valori che compongono la retribuzione per Bilancio di Previsione
REM
PROMPT 
PROMPT Creating Table INFORMAZIONI_RETRIBUTIVE_BP
CREATE TABLE informazioni_retributive_bp(
 ci                              NUMBER (8,0)     NOT NULL,
 voce                            VARCHAR (10)     NOT NULL,
 sub                             VARCHAR (2)      NOT NULL,
 sequenza_voce                   NUMBER (4,0)     NOT NULL,
 tariffa                         NUMBER (15,5)    NULL,
 dal                             DATE             NULL,
 al                              DATE             NULL,
 tipo                            VARCHAR(1)       NOT NULL,
 qualifica                       NUMBER (6,0)     NULL,
 tipo_rapporto                   VARCHAR (4)      NULL,
 sospensione                     NUMBER (2,0)     NULL,
 imp_tot                         NUMBER (12,2)    NULL,
 rate_tot                        NUMBER (4,0)     NULL,
 note                            VARCHAR (4000)   NULL,
 istituto                        VARCHAR (5)      NULL,
 numero                          VARCHAR (12)     NULL,
 data                            DATE             NULL,
 utente                          VARCHAR(8)       NULL,
 data_agg                        DATE             NULL
)
PCTFREE  10
PCTUSED  40
INITRANS 1
MAXTRANS 255
STORAGE  (
  INITIAL   &1DIMx2500
  NEXT   &1DIMx1250
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

COMMENT ON TABLE informazioni_retributive_bp
    IS 'INRP - Informazioni su voci e valori che compongono la retribuzione per Bilancio di Previsione';


REM
REM 
REM
REM 
REM

PROMPT
PROMPT Creating Index INRP_ISCR_FK on Table INFORMAZIONI_RETRIBUTIVE_BP
CREATE INDEX INRP_ISCR_FK ON INFORMAZIONI_RETRIBUTIVE_BP
(
      istituto )
PCTFREE  0
INITRANS 2
MAXTRANS 255
;


REM
REM 
REM
REM 
REM

PROMPT
PROMPT Creating Index INRP_PK on Table INFORMAZIONI_RETRIBUTIVE_BP
CREATE UNIQUE INDEX INRP_PK ON INFORMAZIONI_RETRIBUTIVE_BP
(
      ci ,
      voce ,
      sub ,
      dal )
PCTFREE  0
INITRANS 2
MAXTRANS 255
STORAGE  (
  INITIAL   &1DIMx1500      
  NEXT   &1DIMx750     
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
REM 
REM

PROMPT
PROMPT Creating Index INRP_QUAL_FK on Table INFORMAZIONI_RETRIBUTIVE_BP
CREATE INDEX INRP_QUAL_FK ON INFORMAZIONI_RETRIBUTIVE_BP
(
      qualifica )
PCTFREE  0
INITRANS 2
MAXTRANS 255
STORAGE  (
  INITIAL   &1DIMx700       
  NEXT   &1DIMx350   
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
REM 
REM

PROMPT
PROMPT Creating Index INRP_VOCO_FK on Table INFORMAZIONI_RETRIBUTIVE_BP
CREATE INDEX INRP_VOCO_FK ON INFORMAZIONI_RETRIBUTIVE_BP
(
      voce ,
      sub )
PCTFREE  0
INITRANS 2
MAXTRANS 255
STORAGE  (
  INITIAL   &1DIMx1000      
  NEXT   &1DIMx500     
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

REM
REM  End of command file
REM
