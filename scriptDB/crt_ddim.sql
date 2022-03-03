SET SCAN OFF

REM
REM TABLE
REM      DICHIARAZIONE_DIS_IMPORTI
REM
REM     DDIM - Importi Modulo Disoccupazione
REM
PROMPT 
PROMPT Creating Table DICHIARAZIONE_DIS_IMPORTI
CREATE TABLE DICHIARAZIONE_DIS_IMPORTI
  ( DDIS_ID           NUMBER(10)    NOT NULL,
    ANNO              NUMBER(4)     NOT NULL,
    CI                NUMBER(8)     NOT NULL,
    MESE              NUMBER(2)     NOT NULL,
    RETRIBUZIONE      NUMBER(12,2),
    RETRIBUZIONE_SPE  NUMBER(12,2),
    SETTIMANE         NUMBER(3),
    GG_LAV            NUMBER(3),
    GG_NLAV           NUMBER(3),    
    UTENTE            VARCHAR2(8),
    DATA_AGG          DATE,
    TIPO_AGG          VARCHAR2(1),
    MODELLO           VARCHAR2(4),
	GIORNI            VARCHAR2(62),
	GG_AF             NUMBER(3),
	GG_RET            NUMBER(3)
  )
;

COMMENT ON TABLE DICHIARAZIONE_DIS_IMPORTI
    IS 'DDIM - Importi Modulo Disoccupazione';

REM
REM  End of command file
REM
