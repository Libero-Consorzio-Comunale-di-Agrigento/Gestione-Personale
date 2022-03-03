REM  Objects being generated in this file are:-
REM TABLE
REM      PROGRESSIONI_ECONOMICHE
REM INDEX
REM      PREC_PK

REM
REM     PREC - Validita` dei periodi di voce a progressione attribuita
REM
PROMPT 
PROMPT Creating Table PROGRESSIONI_ECONOMICHE
CREATE TABLE progressioni_economiche(
 ci                              NUMBER(8,0)      NOT NULL,
 qualifica                       NUMBER(6,0)      NOT NULL,
 voce                            VARCHAR(10)      NOT NULL,
 dal                             DATE             NOT NULL,
 tipo_rapporto                   VARCHAR(4)       NULL,
 periodo                         NUMBER(2,0)      NOT NULL,
 inizio                          DATE             NOT NULL,
 fine                            DATE             NULL
)
STORAGE  (
  INITIAL  &1DIMx50
  NEXT   &1DIMx300
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  50
  )
;

COMMENT ON TABLE progressioni_economiche
    IS 'PREC - Validita` dei periodi di voce a progressione attribuita';


REM
REM 
REM
PROMPT
PROMPT Creating Index PREC_PK on Table PROGRESSIONI_ECONOMICHE
CREATE UNIQUE INDEX PREC_PK ON PROGRESSIONI_ECONOMICHE
(
      ci ,
      dal ,
      qualifica ,
      voce ,
      tipo_rapporto ,
      periodo )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx50        
  NEXT   &1DIMx300       
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  50
  )
;

REM
REM  End of command file
REM
