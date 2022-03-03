REM  Objects being generated in this file are:-
REM TABLE
REM      RAPPORTI_GIURIDICI
REM INDEX
REM      RAGI_PK
REM      RAGI_UK

REM
REM     RAGI - Identificazione dei rapporti con caratteristiche giuridiche
REM
PROMPT 
PROMPT Creating Table RAPPORTI_GIURIDICI
CREATE TABLE rapporti_giuridici(
 ci                              NUMBER(8,0)      NOT NULL,
 d_cong                          DATE             NULL,
 flag_elab                       VARCHAR(1)       NULL,
 d_coni                          DATE             NULL,
 d_gipe                          DATE             NULL,
 ini_blocco                      DATE             NULL,
 fin_blocco                      DATE             NULL,
 flag_gipe                       VARCHAR(1)       NULL,
 flag_inqe                       VARCHAR(1)       NULL,
 d_inqe                          DATE             NULL,
 cong_ind                        NUMBER(1,0)      NULL,
 dal                             DATE             NULL,
 al                              DATE             NULL,
 posizione                       VARCHAR(4)       NULL,
 di_ruolo                        VARCHAR(2)       NULL,
 contratto                       VARCHAR(4)       NULL,
 qualifica                       NUMBER(6,0)      NULL,
 ruolo                           VARCHAR(4)       NULL,
 livello                         VARCHAR(4)       NULL,
 tipo_rapporto                   VARCHAR(4)       NULL,
 attivita                        VARCHAR(4)       NULL,
 figura                          NUMBER(6,0)      NULL,
 ore                             NUMBER(5,2)      NULL,
 gestione                        VARCHAR(8)       NULL,
 settore                         NUMBER(6,0)      NULL,
 sede                            NUMBER(6,0)      NULL,
 note                            VARCHAR(4000)    NULL,
 d_cong_al                       DATE             NULL,
 cassa_competenza                VARCHAR(2)       DEFAULT 'NO'
)
STORAGE  (
  INITIAL   &1DIMx140 
  NEXT   &1DIMx70  
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

COMMENT ON TABLE rapporti_giuridici
    IS 'RAGI - Identificazione dei rapporti con caratteristiche giuridiche';


REM
REM 
REM
PROMPT
PROMPT Creating Index RAGI_PK on Table RAPPORTI_GIURIDICI
CREATE UNIQUE INDEX RAGI_PK ON RAPPORTI_GIURIDICI
(
      ci )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx20       
  NEXT   &1DIMx10     
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;


REM
REM 
REM
PROMPT
PROMPT Creating Index RAGI_UK on Table RAPPORTI_GIURIDICI
CREATE UNIQUE INDEX RAGI_UK ON RAPPORTI_GIURIDICI
(
      flag_elab ,
      ci )
PCTFREE  10
STORAGE  (
  INITIAL   &1DIMx70        
  NEXT   &1DIMx35     
  MINEXTENTS  1
  MAXEXTENTS  121 
  PCTINCREASE  0
  )
;

REM
REM  End of command file
REM
