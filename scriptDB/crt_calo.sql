SET SCAN OFF

REM
REM TABLE
REM      Creazione tabella temporanea CALCOLI_DO 
REM INDEX
REM     CALO_UK1
REM

CREATE global temporary TABLE CALCOLI_DO 
( UTENTE         VARCHAR2 (8), 
  DATA           DATE, 
  REVISIONE      NUMBER (8), 
  DOOR_ID        NUMBER, 
  PROVENIENZA    CHAR (1), 
  GESTIONE       VARCHAR2 (8), 
  AREA           VARCHAR2 (8), 
  SETTORE        VARCHAR2 (15), 
  RUOLO          VARCHAR2 (4), 
  PROFILO        VARCHAR2 (4), 
  POSIZIONE      VARCHAR2 (4), 
  ATTIVITA       VARCHAR2 (4), 
  FIGURA         VARCHAR2 (8), 
  QUALIFICA      VARCHAR2 (8), 
  LIVELLO        VARCHAR2 (4), 
  TIPO_RAPPORTO  VARCHAR2 (4), 
  ORE            NUMBER, 
  NUMERO         NUMBER, 
  NUMERO_ORE     NUMBER, 
  EFFETTIVI      NUMBER, 
  DI_RUOLO       NUMBER, 
  ASSENTI        NUMBER, 
  INCARICATI     NUMBER, 
  NON_RUOLO      NUMBER, 
  CONTRATTISTI   NUMBER, 
  SOVRANNUMERO   NUMBER,
  DIFF_NUMERO    NUMBER, 
  DIFF_ORE       NUMBER, 
  UNITA_NI       NUMBER (8), 
  ID             NUMBER, 
  ORE_EFFETTIVE  NUMBER
) 
  ON COMMIT DELETE ROWS
;

 CREATE INDEX CALO_UK1 ON CALCOLI_DO 
 ( PROVENIENZA, DOOR_ID )
;
