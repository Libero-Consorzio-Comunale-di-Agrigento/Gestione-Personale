REM  Objects being generated in this file are:-
REM TABLE
REM      FAMILIARI
REM INDEX
REM      FAMI_CONP_FK
REM      FAMI_INDI_FK
REM      FAMI_PARE_FK
REM      FAMI_PK

REM
REM     FAMI - Dati anagrafici dei familiari dell"individuo
REM
PROMPT 
PROMPT Creating Table FAMILIARI
CREATE TABLE familiari(
 ni                              NUMBER(8,0)      NOT NULL,
 relazione                       NUMBER(3,0)      NOT NULL,
 cognome                         VARCHAR(36)      NOT NULL,
 nome                            VARCHAR(36)      NOT NULL,
 data_nas                        DATE             NOT NULL,
 codice_fiscale                  VARCHAR(16)      NULL,
 dal                             DATE             NOT NULL,
 al                              DATE             NULL,
 condizione_pro                  VARCHAR(4)       NULL,
 intestatario                    VARCHAR(2)   DEFAULT 'NO' NOT NULL,
 origine                         VARCHAR(30)      NULL
)
STORAGE  (
  INITIAL   &1DIMx500
  NEXT   &1DIMx250
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

COMMENT ON TABLE familiari
    IS 'FAMI - Dati anagrafici dei familiari dell"individuo';


REM
REM 
REM
PROMPT
PROMPT Creating Index FAMI_CONP_FK on Table FAMILIARI
CREATE INDEX FAMI_CONP_FK ON FAMILIARI
(
      condizione_pro )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index FAMI_INDI_FK on Table FAMILIARI
CREATE INDEX FAMI_INDI_FK ON FAMILIARI
(
      ni )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index FAMI_PARE_FK on Table FAMILIARI
CREATE INDEX FAMI_PARE_FK ON FAMILIARI
(
      relazione )
PCTFREE  10
;


REM
REM 
REM
PROMPT
PROMPT Creating Index FAMI_PK on Table FAMILIARI
CREATE UNIQUE INDEX FAMI_PK ON FAMILIARI
(
      ni ,
      cognome ,
      nome ,
      data_nas ,
      dal )
PCTFREE  10
;

REM
REM  End of command file
REM
