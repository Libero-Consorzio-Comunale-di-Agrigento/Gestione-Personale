REM  Objects being generated in this file are:-
REM TABLE
REM      INQUADRAMENTI_ECONOMICI
REM INDEX
REM      INEC_PK
REM      INEC_QUAL_FK
REM      INEC_VOEC_FK

REM
REM     INEC - Periodi di inquadramento sulle voci a progressione economica
REM
PROMPT 
PROMPT Creating Table INQUADRAMENTI_ECONOMICI
CREATE TABLE inquadramenti_economici(
 ci                              NUMBER(8,0)      NOT NULL,
 dal                             DATE             NOT NULL,
 al                              DATE             NULL,
 qualifica                       NUMBER(6,0)      NOT NULL,
 tipo_rapporto                   VARCHAR(4)       NULL,
 voce                            VARCHAR(10)      NOT NULL,
 aa                              NUMBER(2,0)      NULL,
 mm                              NUMBER(2,0)      NULL,
 gg                              NUMBER(2,0)      NULL,
 eccedenza                       NUMBER(15,5)     NULL,
 periodo                         NUMBER(2,0)      NULL,
 prossimo                        DATE             NULL,
 max_periodi                     NUMBER(2,0)      NULL,
 data_agg                        DATE             NULL
)
STORAGE  (
  INITIAL   &1DIMx200
  NEXT   &1DIMx200
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  50
  )
;

COMMENT ON TABLE inquadramenti_economici
    IS 'INEC - Periodi di inquadramento sulle voci a progressione economica';


REM
REM 
REM
PROMPT
PROMPT Creating Index INEC_PK on Table INQUADRAMENTI_ECONOMICI
CREATE UNIQUE INDEX INEC_PK ON INQUADRAMENTI_ECONOMICI
(
      ci ,
      dal ,
      qualifica ,
      voce ,
      tipo_rapporto ,
      data_agg )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx200
  NEXT   &1DIMx200
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  50
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index INEC_QUAL_FK on Table INQUADRAMENTI_ECONOMICI
CREATE INDEX INEC_QUAL_FK ON INQUADRAMENTI_ECONOMICI
(
      qualifica )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx80
  NEXT   &1DIMx80
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  50
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index INEC_VOEC_FK on Table INQUADRAMENTI_ECONOMICI
CREATE INDEX INEC_VOEC_FK ON INQUADRAMENTI_ECONOMICI
(
      voce )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx125
  NEXT   &1DIMx125
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  50
  )
;

REM
REM  End of command file
REM
