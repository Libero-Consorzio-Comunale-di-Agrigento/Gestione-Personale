CREATE TABLE PERIODI_DOTAZIONE
(
  CI              NUMBER(8)          NOT NULL,
  RILEVANZA       VARCHAR2(1)        NOT NULL,
  DAL             DATE               NOT NULL,
  AL              DATE,
  GESTIONE        VARCHAR2(8),
  ORE             NUMBER(5,2),
  REVISIONE       NUMBER(8)          NOT NULL,
  DOOR_ID         NUMBER(10)         NOT NULL,
  FIGURA          NUMBER(6),
  QUALIFICA       NUMBER(6),
  POSIZIONE       VARCHAR2(4),
  REVISIONE_PREC  NUMBER(8),
  DOOR_ID_PREC    NUMBER(10),
  ATTIVITA        VARCHAR2(4),
  TIPO_RAPPORTO   VARCHAR2(4),
  SETTORE         NUMBER(6),
  AREA            VARCHAR2(8),
  CODICE_UO       VARCHAR2(15),
  RUOLO           VARCHAR2(4),
  PROFILO         VARCHAR2(4),
  POS_FUNZ        VARCHAR2(4),
  COD_FIGURA      VARCHAR2(8),
  COD_QUALIFICA   VARCHAR2(8),
  LIVELLO         VARCHAR2(4),
  ASSENZA         VARCHAR2(4),
  DI_RUOLO        VARCHAR2(2),
  INCARICO        VARCHAR2(6),
  PART_TIME       VARCHAR2(2),
  EVENTO          VARCHAR2(6),
  SETT_1          NUMBER(6),
  SETT_2          NUMBER(6),
  SETT_3          NUMBER(6),
  SETT_4          NUMBER(6),
  SETT_5          NUMBER(6),
  SETT_6          NUMBER(6),
  UE              NUMBER(5,4),
  UNITA_NI        NUMBER(8),
  CONTRATTISTA    VARCHAR2(2),
  SOVRANNUMERO    VARCHAR2(2),
  CONTRATTO       VARCHAR2(4),
  ORE_LAVORO      NUMBER(5,2),
  TIPO_PART_TIME  VARCHAR2(2),
  ASS_PART_TIME   VARCHAR2(2)
)
STORAGE    (
  INITIAL   &1DIMx3000
  NEXT   &1DIMx1500
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
           )
;


CREATE UNIQUE INDEX PEDO_PK ON PERIODI_DOTAZIONE
(REVISIONE, DOOR_ID, CI, RILEVANZA, GESTIONE, 
DAL, AL)
STORAGE    (
  INITIAL   &1DIMx2000
  NEXT   &1DIMx1000
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
           )
;


CREATE INDEX PEDO_UK_DI_RUOLO ON PERIODI_DOTAZIONE
(DOOR_ID, REVISIONE, DI_RUOLO, GESTIONE, RILEVANZA, 
DAL, AL)
STORAGE    (
  INITIAL   &1DIMx1000
  NEXT   &1DIMx500
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
           )
;


CREATE INDEX PEDO_UK ON PERIODI_DOTAZIONE
(REVISIONE, DOOR_ID)
STORAGE    (
  INITIAL   &1DIMx1000
  NEXT   &1DIMx500
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
           )
;


CREATE INDEX PEDO_UK2 ON PERIODI_DOTAZIONE
(RILEVANZA, REVISIONE, DOOR_ID, GESTIONE, PROFILO, 
POS_FUNZ, ATTIVITA)
STORAGE    (
  INITIAL   &1DIMx1000
  NEXT   &1DIMx500
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
           )
;


CREATE INDEX PEDO_UK3 ON PERIODI_DOTAZIONE
(REVISIONE, CI, RILEVANZA, GESTIONE, DAL, 
AL)
STORAGE    (
  INITIAL   &1DIMx1000
  NEXT   &1DIMx500
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
           )
;


CREATE INDEX PEDO_FIGI_FK ON PERIODI_DOTAZIONE
(COD_FIGURA)
STORAGE    (
  INITIAL   &1DIMx800
  NEXT   &1DIMx400
            MAXEXTENTS       121
            PCTINCREASE      0
           )
;


CREATE INDEX PEDO_UK_CONTR ON PERIODI_DOTAZIONE
(RILEVANZA, REVISIONE, DOOR_ID, GESTIONE, DAL, 
AL, CONTRATTISTA)
STORAGE    (
  INITIAL   &1DIMx800
  NEXT   &1DIMx400
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
           )
;


CREATE INDEX PEDO_STAM_FK ON PERIODI_DOTAZIONE
(SETTORE)
STORAGE    (
  INITIAL   &1DIMx800
  NEXT   &1DIMx400
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
           )
;


CREATE INDEX PEDO_UNOR_FK ON PERIODI_DOTAZIONE
(UNITA_NI)
STORAGE    (
  INITIAL   &1DIMx800
  NEXT   &1DIMx400
            MINEXTENTS       1
            MAXEXTENTS       121
            PCTINCREASE      0
           )
;


