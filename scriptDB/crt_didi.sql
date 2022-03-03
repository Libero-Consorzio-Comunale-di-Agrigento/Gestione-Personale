SET SCAN OFF

REM
REM TABLE
REM     DICHIARAZIONE_DIS
REM
REM     DIDI - Modulo Disoccupazione
REM
PROMPT 
PROMPT Creating Table DICHIARAZIONE_DIS
CREATE TABLE DICHIARAZIONE_DIS
  ( DDIS_ID           NUMBER(10)    NOT NULL,
    GESTIONE          VARCHAR2(8)   NOT NULL,
    CI                NUMBER(8)     NOT NULL,
    QUA_INPS          NUMBER(1),
    QUA_ALTRO         VARCHAR2(50),
    TEMPO_DETERMINATO VARCHAR2(2),
    STAGIONALE        VARCHAR2(2),
    PART_TIME         VARCHAR2(2),
    TIPO_PART_TIME    VARCHAR2(2),
    CONT_ALTRO        VARCHAR2(50),
    CONT_ORE          NUMBER(5,2),
    DATA_ASS          DATE,
    DATA_INT          DATE,
    INT_INPS          VARCHAR2(3),
    MOT_INT           VARCHAR2(120),
    IMP_COMPL         NUMBER(12,2),
    IMP_GIOR          NUMBER(12,2),
    GG_LAV            NUMBER(3),
    GG_MOT1           NUMBER(3),
    GG_MOT2           NUMBER(3),
    GG_MOT3           NUMBER(3),
    GG_MOT4           NUMBER(3),
    GG_MOT5           NUMBER(3),
    GG_MOT6           NUMBER(3),
    GG_MOT7           NUMBER(3),
    UTENTE            VARCHAR2(8),
    DATA_AGG          DATE,
    TIPO_AGG          VARCHAR2(1),
    MODELLO           VARCHAR2(4),
    COLLABORATORE     VARCHAR2(2),
	DATA_RICHIESTA    DATE,
	GESTIONE_ALTERNATIVA VARCHAR2(8)
  )
;

COMMENT ON TABLE DICHIARAZIONE_DIS
    IS 'DIDI - Modulo Disoccupazione';

REM
REM  End of command file
REM


  
