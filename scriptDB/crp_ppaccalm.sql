CREATE OR REPLACE PACKAGE PPACCALM IS
/******************************************************************************
 NOME:          PPACCALM
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000    
 2    09/09/2004 MV	A7024 - Trattamenti Previdenziali         
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO        IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY ppaccalm IS
	W_UTENTE	VARCHAR2(10);
	W_AMBIENTE	VARCHAR2(10);
	W_ENTE		VARCHAR2(10);
	W_LINGUA	VARCHAR2(1);
	W_PRENOTAZIONE	NUMBER(10);
	errore		varchar2(6);
 -- PULIZIA TABELLA DI LAVORO
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V2.0 del 09/09/2004';
 END VERSIONE;
      PROCEDURE DELETE_TAB IS
      BEGIN
        DELETE FROM CALCOLO_LIQUIDAZIONE_MALATTIE
         WHERE CALM_PRENOTAZIONE = W_PRENOTAZIONE;
      EXCEPTION
        WHEN OTHERS THEN
          RAISE ;
      END;
      --  DATA PRESUNTA DEL PARTO
      PROCEDURE DETERMINA_01 (
                P_EVENTO     IN     NUMBER,
                P_DATA       IN OUT DATE
                             ) IS
      BEGIN
        BEGIN
          SELECT DECODE(MAX(NVL(EVPA.AL,TO_DATE('3333333','J')))
                       ,TO_DATE('3333333','J'),NULL,
                        MAX(NVL(EVPA.AL,TO_DATE('3333333','J')))
                       )
            INTO P_DATA
            FROM CAUSALI_EVENTO  CAEV
                ,EVENTI_PRESENZA EVPA
           WHERE EVPA.CLASSE          = P_EVENTO
             AND EVPA.CAUSALE         = CAEV.CODICE
             AND CAEV.PROSPETTO       = 1
          ;
        END;
      END;
      --  DATA EFFETTIVA DEL PARTO
      PROCEDURE DETERMINA_02 (
                P_EVENTO     IN     NUMBER,
                P_DATA       IN OUT DATE
                             ) IS
      BEGIN
        BEGIN
          SELECT DECODE(MAX(NVL(EVPA.AL,TO_DATE('3333333','J')))
                       ,TO_DATE('3333333','J'),NULL,
                        MAX(NVL(EVPA.AL,TO_DATE('3333333','J')))
                       )
            INTO P_DATA
            FROM CAUSALI_EVENTO  CAEV
                ,EVENTI_PRESENZA EVPA
           WHERE EVPA.CLASSE          = P_EVENTO
             AND EVPA.CAUSALE         = CAEV.CODICE
             AND CAEV.PROSPETTO       = 2
          ;
        END;
      END;
      --  RETRIBUZIONE MENSILE LORDA IMPIEGATI
      PROCEDURE DETERMINA_03 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_RIRE_ANNO  IN     NUMBER,
                P_RIRE_MESE  IN     NUMBER,
                P_ASSISTENZIALE IN  VARCHAR2,
                P_IMPORTO    IN OUT NUMBER
                             ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(MOCO.IMP,0))
            INTO P_IMPORTO
            FROM EVENTI_PRESENZA             EVPA
                ,MOVIMENTI_CONTABILI         MOCO
                ,ESTRAZIONE_RIGHE_CONTABILI  ESRC
           WHERE EVPA.CLASSE         = P_EVENTO
             AND EVPA.DATA_AGG       = P_AL
             AND MOCO.CI             = EVPA.CI
             AND MOCO.ANNO           = P_RIRE_ANNO
             AND MOCO.MESE           = P_RIRE_MESE
             AND MOCO.VOCE           = ESRC.VOCE
             AND MOCO.SUB            = ESRC.SUB
             AND MOCO.RIFERIMENTO    = EVPA.RIFERIMENTO
             AND ESRC.ESTRAZIONE     = 'PROSPETTO_MAL_MAT'
             AND ESRC.COLONNA        = 'RETR_LORDA_IMP'
             AND P_AL          BETWEEN ESRC.DAL
                                   AND NVL(ESRC.AL,TO_DATE('3333333','J'))
          ;
        END;
      END;
--  RATEO MENSILE LORDO IMPIEGATI
      PROCEDURE DETERMINA_04 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_RIRE_ANNO  IN     NUMBER,
                P_RIRE_MESE  IN     NUMBER,
                P_ASSISTENZIALE IN  VARCHAR2,
                P_IMPORTO    IN OUT NUMBER
                             ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(MOCO.IMP,0))
            INTO P_IMPORTO
            FROM EVENTI_PRESENZA             EVPA
                ,MOVIMENTI_CONTABILI         MOCO
                ,ESTRAZIONE_RIGHE_CONTABILI  ESRC
           WHERE EVPA.CLASSE         = P_EVENTO
             AND EVPA.DATA_AGG       = P_AL
             AND MOCO.CI             = EVPA.CI
             AND MOCO.ANNO           = P_RIRE_ANNO
             AND MOCO.MESE           = P_RIRE_MESE
             AND MOCO.VOCE           = ESRC.VOCE
             AND MOCO.SUB            = ESRC.SUB
             AND MOCO.RIFERIMENTO    = EVPA.RIFERIMENTO
             AND ESRC.ESTRAZIONE     = 'PROSPETTO_MAL_MAT'
             AND ESRC.COLONNA        = 'RATEO_LORDO_IMP'
             AND P_AL          BETWEEN ESRC.DAL
                                   AND NVL(ESRC.AL,TO_DATE('3333333','J'))
          ;
        END;
      END;
--  RETRIBUZIONE MENSILE LORDA OPERAI
      PROCEDURE DETERMINA_05 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_RIRE_ANNO  IN     NUMBER,
                P_RIRE_MESE  IN     NUMBER,
                P_ASSISTENZIALE IN  VARCHAR2,
                P_IMPORTO    IN OUT NUMBER
                             ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(MOCO.IMP,0))
            INTO P_IMPORTO
            FROM EVENTI_PRESENZA             EVPA
                ,MOVIMENTI_CONTABILI         MOCO
                ,ESTRAZIONE_RIGHE_CONTABILI  ESRC
           WHERE EVPA.CLASSE         = P_EVENTO
             AND EVPA.DATA_AGG       = P_AL
             AND MOCO.CI             = EVPA.CI
             AND MOCO.ANNO           = P_RIRE_ANNO
             AND MOCO.MESE           = P_RIRE_MESE
             AND MOCO.VOCE           = ESRC.VOCE
             AND MOCO.SUB            = ESRC.SUB
             AND MOCO.RIFERIMENTO    = EVPA.RIFERIMENTO
             AND ESRC.ESTRAZIONE     = 'PROSPETTO_MAL_MAT'
             AND ESRC.COLONNA        = 'RETR_LORDA_OPE'
             AND P_AL          BETWEEN ESRC.DAL
                                   AND NVL(ESRC.AL,TO_DATE('3333333','J'))
          ;
        END;
      END;
      --  GIORNI DI LAVORO OPERAI
      PROCEDURE DETERMINA_06 (
                P_CI         IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_DEL        IN     DATE,
                P_VALORE     IN OUT NUMBER
                             ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(EVPA.VALORE,0))
            INTO P_VALORE
            FROM CAUSALI_EVENTO  CAEV
                ,EVENTI_PRESENZA EVPA
           WHERE EVPA.CI            = P_CI
             AND EVPA.RIFERIMENTO   = P_DEL
             AND CAEV.CODICE        = EVPA.CAUSALE
             AND CAEV.PROSPETTO     = 6
             AND EVPA.DATA_AGG      = P_AL
          ;
        END;
      END;
      --  RATEO MENSILE LORDO OPERAI
      PROCEDURE DETERMINA_07 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_RIRE_ANNO  IN     NUMBER,
                P_RIRE_MESE  IN     NUMBER,
                P_ASSISTENZIALE IN  VARCHAR2,
                P_IMPORTO    IN OUT NUMBER
                             ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(MOCO.IMP,0))
            INTO P_IMPORTO
            FROM EVENTI_PRESENZA             EVPA
                ,MOVIMENTI_CONTABILI         MOCO
                ,ESTRAZIONE_RIGHE_CONTABILI  ESRC
           WHERE EVPA.CLASSE         = P_EVENTO
             AND EVPA.DATA_AGG       = P_AL
             AND MOCO.CI             = EVPA.CI
             AND MOCO.ANNO           = P_RIRE_ANNO
             AND MOCO.MESE           = P_RIRE_MESE
             AND MOCO.VOCE           = ESRC.VOCE
             AND MOCO.SUB            = ESRC.SUB
             AND MOCO.RIFERIMENTO    = EVPA.RIFERIMENTO
             AND ESRC.ESTRAZIONE     = 'PROSPETTO_MAL_MAT'
             AND ESRC.COLONNA        = 'RATEO_LORDO_OPE'
             AND P_AL          BETWEEN ESRC.DAL
                                   AND NVL(ESRC.AL,TO_DATE('3333333','J'))
          ;
        END;
      END;
    --  DETERMINA DATO1,DATO2,DAL,AL POSIZIONE 08
      PROCEDURE DETERMINA_DATI_08 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_VALORE1    IN OUT NUMBER,
                P_VALORE2    IN OUT NUMBER,
                P_VALORE3    IN OUT NUMBER,
                P_INIZIO     IN OUT DATE,
                P_FINE       IN OUT DATE
                                  ) IS
      BEGIN
        BEGIN
          SELECT SUM(DECODE(CAEV.PROSPETTO,12,0,NVL(EVPA.VALORE,0)))
                ,SUM(DECODE(CAEV.PROSPETTO,8
                           ,EVPA.AL - EVPA.DAL + 1 - NVL(EVPA.VALORE,0)
                           ,NVL(EVPA.VALORE,0)
                           )
                    )
                ,SUM(DECODE(CAEV.PROSPETTO,8,0,NVL(EVPA.VALORE,0)))
                ,MIN(GREATEST(EVPA.DAL,P_DAL))
                ,MAX(LEAST(NVL(EVPA.AL,TO_DATE('3333333','J')),P_AL))
            INTO P_VALORE1
                ,P_VALORE2
                ,P_VALORE3
                ,P_INIZIO
                ,P_FINE
            FROM CAUSALI_EVENTO  CAEV
                ,EVENTI_PRESENZA EVPA
           WHERE EVPA.CLASSE        = P_EVENTO
             AND CAEV.CODICE        = EVPA.CAUSALE
             AND CAEV.PROSPETTO    IN (12,8)
             AND EVPA.DATA_AGG      = P_AL
          ;
        END;
      END;
     --  DETERMINA DATO1,DATO2,DAL,AL POSIZIONE 09
      PROCEDURE DETERMINA_DATI_09 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_VALORE1    IN OUT NUMBER,
                P_VALORE2    IN OUT NUMBER,
                P_INIZIO     IN OUT DATE,
                P_FINE       IN OUT DATE
                                  ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(EVPA.VALORE,0))
                ,SUM(LEAST(NVL(EVPA.AL,TO_DATE('3333333','J')),P_AL) -
                     GREATEST(EVPA.DAL,P_DAL) + 1 - NVL(EVPA.VALORE,0)
                    )
                ,MIN(GREATEST(EVPA.DAL,P_DAL))
                ,MAX(LEAST(NVL(EVPA.AL,TO_DATE('3333333','J')),P_AL))
            INTO P_VALORE1
                ,P_VALORE2
                ,P_INIZIO
                ,P_FINE
            FROM CAUSALI_EVENTO  CAEV
                ,EVENTI_PRESENZA EVPA
           WHERE EVPA.CLASSE        = P_EVENTO
             AND CAEV.CODICE        = EVPA.CAUSALE
             AND CAEV.PROSPETTO     = 9
             AND EVPA.DATA_AGG      = P_AL
          ;
        END;
      END;
 --  DETERMINA DATO1,DATO2,DAL,AL POSIZIONE 10
      PROCEDURE DETERMINA_DATI_10 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_VALORE1    IN OUT NUMBER,
                P_VALORE2    IN OUT NUMBER,
                P_INIZIO     IN OUT DATE,
                P_FINE       IN OUT DATE
                                  ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(EVPA.VALORE,0))
                ,SUM(LEAST(NVL(EVPA.AL,TO_DATE('3333333','J')),P_AL) -
                     GREATEST(EVPA.DAL,P_DAL) + 1 - NVL(EVPA.VALORE,0)
                    )
                ,MIN(GREATEST(EVPA.DAL,P_DAL))
                ,MAX(LEAST(NVL(EVPA.AL,TO_DATE('3333333','J')),P_AL))
            INTO P_VALORE1
                ,P_VALORE2
                ,P_INIZIO
                ,P_FINE
            FROM CAUSALI_EVENTO  CAEV
                ,EVENTI_PRESENZA EVPA
           WHERE EVPA.CLASSE        = P_EVENTO
             AND CAEV.CODICE        = EVPA.CAUSALE
             AND CAEV.PROSPETTO     = 10
             AND EVPA.DATA_AGG      = P_AL
          ;
        END;
      END;
      --  DETERMINA DATO1,DATO2,DAL,AL POSIZIONE 11
      PROCEDURE DETERMINA_DATI_11 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_VALORE1    IN OUT NUMBER,
                P_VALORE2    IN OUT NUMBER,
                P_INIZIO     IN OUT DATE,
                P_FINE       IN OUT DATE
                                  ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(EVPA.VALORE,0))
                ,SUM(LEAST(NVL(EVPA.AL,TO_DATE('3333333','J')),P_AL) -
                     GREATEST(EVPA.DAL,P_DAL) + 1 - NVL(EVPA.VALORE,0)
                    )
                ,MIN(GREATEST(EVPA.DAL,P_DAL))
                ,MAX(LEAST(NVL(EVPA.AL,TO_DATE('3333333','J')),P_AL))
            INTO P_VALORE1
                ,P_VALORE2
                ,P_INIZIO
                ,P_FINE
            FROM CAUSALI_EVENTO  CAEV
                ,EVENTI_PRESENZA EVPA
           WHERE EVPA.CLASSE        = P_EVENTO
             AND CAEV.CODICE        = EVPA.CAUSALE
             AND CAEV.PROSPETTO     = 11
             AND EVPA.DATA_AGG      = P_AL
          ;
        END;
      END;
     --  DETERMINA DATO1,DATO2,DAL,AL POSIZIONE 13
      PROCEDURE DETERMINA_DATI_13 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_VALORE1    IN OUT NUMBER,
                P_VALORE2    IN OUT NUMBER,
                P_INIZIO     IN OUT DATE,
                P_FINE       IN OUT DATE
                                  ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(EVPA.VALORE,0))
                ,SUM(LEAST(NVL(EVPA.AL,TO_DATE('3333333','J')),P_AL) -
                     GREATEST(EVPA.DAL,P_DAL) + 1 - NVL(EVPA.VALORE,0)
                    )
                ,MIN(GREATEST(EVPA.DAL,P_DAL))
                ,MAX(LEAST(NVL(EVPA.AL,TO_DATE('3333333','J')),P_AL))
            INTO P_VALORE1
                ,P_VALORE2
                ,P_INIZIO
                ,P_FINE
            FROM CAUSALI_EVENTO  CAEV
                ,EVENTI_PRESENZA EVPA
                ,RIFERIMENTO_PRESENZA RIPA
                ,ENTE
           WHERE EVPA.CLASSE        = P_EVENTO
             AND CAEV.CODICE        = EVPA.CAUSALE
             AND CAEV.PROSPETTO     = 13
      AND  (    TO_DATE(TO_CHAR(EVPA.DATA_AGG,'DDMMYYYY'),'DDMMYYYY')
                                   = RIPA.FIN_MES
            OR (TO_DATE(TO_CHAR(EVPA.DATA_AGG,'DDMMYYYY'),'DDMMYYYY')
                                  <= RIPA.FIN_MES
            AND EVPA.DAL >= (SELECT INI_ELA FROM RIFERIMENTO_RETRIBUZIONE)
            AND NVL(EVPA.AL,TO_DATE('3333333','J'))
                                  >= (SELECT FIN_ELA
                                        FROM RIFERIMENTO_RETRIBUZIONE)
               )
           )
          ;
        END;
      END;
     --  DETERMINA DATO1,DATO2,DAL,AL POSIZIONE 14
      PROCEDURE DETERMINA_DATI_14 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_VALORE1    IN OUT NUMBER,
                P_VALORE2    IN OUT NUMBER,
                P_INIZIO     IN OUT DATE,
                P_FINE       IN OUT DATE
                                  ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(EVPA.VALORE,0))
                ,SUM(LEAST(NVL(EVPA.AL,TO_DATE('3333333','J')),P_AL) -
                     GREATEST(EVPA.DAL,P_DAL) + 1 - NVL(EVPA.VALORE,0)
                    )
                ,MIN(GREATEST(EVPA.DAL,P_DAL))
                ,MAX(LEAST(NVL(EVPA.AL,TO_DATE('3333333','J')),P_AL))
            INTO P_VALORE1
                ,P_VALORE2
                ,P_INIZIO
                ,P_FINE
            FROM CAUSALI_EVENTO  CAEV
                ,EVENTI_PRESENZA EVPA
                ,RIFERIMENTO_PRESENZA RIPA
                ,ENTE
           WHERE EVPA.CLASSE        = P_EVENTO
             AND CAEV.CODICE        = EVPA.CAUSALE
             AND CAEV.PROSPETTO     = 14
      AND  (    TO_DATE(TO_CHAR(EVPA.DATA_AGG,'DDMMYYYY'),'DDMMYYYY')
                                   = RIPA.FIN_MES
            OR (TO_DATE(TO_CHAR(EVPA.DATA_AGG,'DDMMYYYY'),'DDMMYYYY')
                                  <= RIPA.FIN_MES
            AND EVPA.DAL >= (SELECT INI_ELA FROM RIFERIMENTO_RETRIBUZIONE)
            AND NVL(EVPA.AL,TO_DATE('3333333','J'))
                                  >= (SELECT FIN_ELA
                                        FROM RIFERIMENTO_RETRIBUZIONE)
               )
           )
          ;
        END;
      END;
   --  LIQUIDAZIONE IMPORTI (POSIZIONE 08)
      PROCEDURE DETERMINA_IMP_08 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_RIRE_ANNO  IN     NUMBER,
                P_RIRE_MESE  IN     NUMBER,
                P_ASSISTENZIALE IN  VARCHAR2,
                P_IMPORTO    IN OUT NUMBER
                                 ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(MOCO.IMP,0))
            INTO P_IMPORTO
            FROM EVENTI_PRESENZA             EVPA
                ,CAUSALI_EVENTO              CAEV
                ,MOVIMENTI_CONTABILI         MOCO
                ,ESTRAZIONE_RIGHE_CONTABILI  ESRC
           WHERE EVPA.CLASSE         = P_EVENTO
             AND EVPA.DATA_AGG       = P_AL
             AND CAEV.CODICE         = EVPA.CAUSALE
             AND CAEV.PROSPETTO      IN (8,12)
             AND MOCO.CI             = EVPA.CI
             AND MOCO.ANNO           = P_RIRE_ANNO
             AND MOCO.MESE           = P_RIRE_MESE
             AND MOCO.VOCE           = ESRC.VOCE
             AND MOCO.SUB            = ESRC.SUB
             AND MOCO.RIFERIMENTO    = EVPA.RIFERIMENTO
             AND ESRC.ESTRAZIONE     = 'PROSPETTO_MAL_MAT'
             AND ESRC.COLONNA        = 'RETR_POS_8'
             AND P_AL          BETWEEN ESRC.DAL
                                   AND NVL(ESRC.AL,TO_DATE('3333333','J'))
          ;
        END;
      END;
      --  LIQUIDAZIONE IMPORTI (POSIZIONE 09)
      PROCEDURE DETERMINA_IMP_09 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_RIRE_ANNO  IN     NUMBER,
                P_RIRE_MESE  IN     NUMBER,
                P_ASSISTENZIALE IN  VARCHAR2,
                P_IMPORTO    IN OUT NUMBER
                                 ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(MOCO.IMP,0))
            INTO P_IMPORTO
            FROM EVENTI_PRESENZA             EVPA
                ,CAUSALI_EVENTO              CAEV
                ,MOVIMENTI_CONTABILI         MOCO
                ,ESTRAZIONE_RIGHE_CONTABILI  ESRC
           WHERE EVPA.CLASSE         = P_EVENTO
             AND EVPA.DATA_AGG       = P_AL
             AND CAEV.CODICE         = EVPA.CAUSALE
             AND CAEV.PROSPETTO      = 9
             AND MOCO.CI             = EVPA.CI
             AND MOCO.ANNO           = P_RIRE_ANNO
             AND MOCO.MESE           = P_RIRE_MESE
             AND MOCO.VOCE           = ESRC.VOCE
             AND MOCO.SUB            = ESRC.SUB
             AND MOCO.RIFERIMENTO    = EVPA.RIFERIMENTO
             AND ESRC.ESTRAZIONE     = 'PROSPETTO_MAL_MAT'
             AND ESRC.COLONNA        = 'RETR_POS_9'
             AND P_AL          BETWEEN ESRC.DAL
                                   AND NVL(ESRC.AL,TO_DATE('3333333','J'))
          ;
        END;
      END;
      --  DETERMINA DATO1,DATO2,DAL,AL POSIZIONE 15
      PROCEDURE DETERMINA_DATI_15 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_VALORE1    IN OUT NUMBER,
                P_VALORE2    IN OUT NUMBER,
                P_INIZIO     IN OUT DATE,
                P_FINE       IN OUT DATE
                                  ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(EVPA.VALORE,0))
                ,SUM(LEAST(NVL(EVPA.AL,TO_DATE('3333333','J')),P_AL) -
                     GREATEST(EVPA.DAL,P_DAL) + 1 - NVL(EVPA.VALORE,0)
                    )
                ,MIN(GREATEST(EVPA.DAL,P_DAL))
                ,MAX(LEAST(NVL(EVPA.AL,TO_DATE('3333333','J')),P_AL))
            INTO P_VALORE1
                ,P_VALORE2
                ,P_INIZIO
                ,P_FINE
            FROM CAUSALI_EVENTO  CAEV
                ,EVENTI_PRESENZA EVPA
           WHERE EVPA.CLASSE        = P_EVENTO
             AND CAEV.CODICE        = EVPA.CAUSALE
             AND CAEV.PROSPETTO     = 15
             AND EVPA.DATA_AGG      = P_AL
          ;
        END;
      END;
      --  LIQUIDAZIONE IMPORTI (POSIZIONE 10)
      PROCEDURE DETERMINA_IMP_10 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_RIRE_ANNO  IN     NUMBER,
                P_RIRE_MESE  IN     NUMBER,
                P_ASSISTENZIALE IN  VARCHAR2,
                P_IMPORTO    IN OUT NUMBER
                                 ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(MOCO.IMP,0))
            INTO P_IMPORTO
            FROM EVENTI_PRESENZA             EVPA
                ,CAUSALI_EVENTO              CAEV
                ,MOVIMENTI_CONTABILI         MOCO
                ,ESTRAZIONE_RIGHE_CONTABILI  ESRC
           WHERE EVPA.CLASSE         = P_EVENTO
             AND EVPA.DATA_AGG       = P_AL
             AND CAEV.CODICE         = EVPA.CAUSALE
             AND CAEV.PROSPETTO      = 10
             AND MOCO.CI             = EVPA.CI
             AND MOCO.ANNO           = P_RIRE_ANNO
             AND MOCO.MESE           = P_RIRE_MESE
             AND MOCO.VOCE           = ESRC.VOCE
             AND MOCO.SUB            = ESRC.SUB
             AND MOCO.RIFERIMENTO    = EVPA.RIFERIMENTO
             AND ESRC.ESTRAZIONE     = 'PROSPETTO_MAL_MAT'
             AND ESRC.COLONNA        = 'RETR_POS_10'
             AND P_AL          BETWEEN ESRC.DAL
                                   AND NVL(ESRC.AL,TO_DATE('3333333','J'))
          ;
        END;
      END;
      --  LIQUIDAZIONE IMPORTI (POSIZIONE 11)
      PROCEDURE DETERMINA_IMP_11 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_RIRE_ANNO  IN     NUMBER,
                P_RIRE_MESE  IN     NUMBER,
                P_ASSISTENZIALE IN  VARCHAR2,
                P_IMPORTO    IN OUT NUMBER
                                 ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(MOCO.IMP,0))
            INTO P_IMPORTO
            FROM EVENTI_PRESENZA             EVPA
                ,CAUSALI_EVENTO              CAEV
                ,MOVIMENTI_CONTABILI         MOCO
                ,ESTRAZIONE_RIGHE_CONTABILI  ESRC
           WHERE EVPA.CLASSE         = P_EVENTO
             AND EVPA.DATA_AGG       = P_AL
             AND CAEV.CODICE         = EVPA.CAUSALE
             AND CAEV.PROSPETTO      = 11
             AND MOCO.CI             = EVPA.CI
             AND MOCO.ANNO           = P_RIRE_ANNO
             AND MOCO.MESE           = P_RIRE_MESE
             AND MOCO.VOCE           = ESRC.VOCE
             AND MOCO.SUB            = ESRC.SUB
             AND MOCO.RIFERIMENTO    = EVPA.RIFERIMENTO
             AND ESRC.ESTRAZIONE     = 'PROSPETTO_MAL_MAT'
             AND ESRC.COLONNA        = 'RETR_POS_11'
             AND P_AL          BETWEEN ESRC.DAL
                                   AND NVL(ESRC.AL,TO_DATE('3333333','J'))
          ;
        END;
      END;
      --  LIQUIDAZIONE IMPORTI (POSIZIONE 13)
      PROCEDURE DETERMINA_IMP_13 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_RIRE_ANNO  IN     NUMBER,
                P_RIRE_MESE  IN     NUMBER,
                P_ASSISTENZIALE IN  VARCHAR2,
                P_IMPORTO    IN OUT NUMBER
                                 ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(MOCO.IMP,0))
            INTO P_IMPORTO
            FROM EVENTI_PRESENZA             EVPA
                ,CAUSALI_EVENTO              CAEV
                ,MOVIMENTI_CONTABILI         MOCO
                ,ESTRAZIONE_RIGHE_CONTABILI  ESRC
           WHERE EVPA.CLASSE         = P_EVENTO
             AND EVPA.DATA_AGG       = P_AL
             AND CAEV.CODICE         = EVPA.CAUSALE
             AND CAEV.PROSPETTO      = 13
             AND MOCO.CI             = EVPA.CI
             AND MOCO.ANNO           = P_RIRE_ANNO
             AND MOCO.MESE           = P_RIRE_MESE
             AND MOCO.VOCE           = ESRC.VOCE
             AND MOCO.SUB            = ESRC.SUB
             AND MOCO.RIFERIMENTO    = EVPA.RIFERIMENTO
             AND ESRC.ESTRAZIONE     = 'PROSPETTO_MAL_MAT'
             AND ESRC.COLONNA        = 'RETR_POS_13'
             AND P_AL          BETWEEN ESRC.DAL
                                   AND NVL(ESRC.AL,TO_DATE('3333333','J'))
          ;
        END;
      END;
      --  LIQUIDAZIONE IMPORTI (POSIZIONE 14)
      PROCEDURE DETERMINA_IMP_14 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_RIRE_ANNO  IN     NUMBER,
                P_RIRE_MESE  IN     NUMBER,
                P_ASSISTENZIALE IN  VARCHAR2,
                P_IMPORTO    IN OUT NUMBER
                                 ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(MOCO.IMP,0))
            INTO P_IMPORTO
            FROM EVENTI_PRESENZA             EVPA
                ,CAUSALI_EVENTO              CAEV
                ,MOVIMENTI_CONTABILI         MOCO
                ,ESTRAZIONE_RIGHE_CONTABILI  ESRC
           WHERE EVPA.CLASSE         = P_EVENTO
             AND EVPA.DATA_AGG       = P_AL
             AND CAEV.CODICE         = EVPA.CAUSALE
             AND CAEV.PROSPETTO      = 14
             AND MOCO.CI             = EVPA.CI
             AND MOCO.ANNO           = P_RIRE_ANNO
             AND MOCO.MESE           = P_RIRE_MESE
             AND MOCO.VOCE           = ESRC.VOCE
             AND MOCO.SUB            = ESRC.SUB
             AND MOCO.RIFERIMENTO    = EVPA.RIFERIMENTO
             AND ESRC.ESTRAZIONE     = 'PROSPETTO_MAL_MAT'
             AND ESRC.COLONNA        = 'RETR_POS_14'
             AND P_AL          BETWEEN ESRC.DAL
                                   AND NVL(ESRC.AL,TO_DATE('3333333','J'))
          ;
        END;
      END;
      --  LIQUIDAZIONE IMPORTI (POSIZIONE 15)
      PROCEDURE DETERMINA_IMP_15 (
                P_EVENTO     IN     NUMBER,
                P_DAL        IN     DATE,
                P_AL         IN     DATE,
                P_RIRE_ANNO  IN     NUMBER,
                P_RIRE_MESE  IN     NUMBER,
                P_ASSISTENZIALE IN  VARCHAR2,
                P_IMPORTO    IN OUT NUMBER
                                 ) IS
      BEGIN
        BEGIN
          SELECT SUM(NVL(MOCO.IMP,0))
            INTO P_IMPORTO
            FROM EVENTI_PRESENZA             EVPA
                ,CAUSALI_EVENTO              CAEV
                ,MOVIMENTI_CONTABILI         MOCO
                ,ESTRAZIONE_RIGHE_CONTABILI  ESRC
           WHERE EVPA.CLASSE         = P_EVENTO
             AND EVPA.DATA_AGG       = P_AL
             AND CAEV.CODICE         = EVPA.CAUSALE
             AND CAEV.PROSPETTO      = 15
             AND MOCO.CI             = EVPA.CI
             AND MOCO.ANNO           = P_RIRE_ANNO
             AND MOCO.MESE           = P_RIRE_MESE
             AND MOCO.VOCE           = ESRC.VOCE
             AND MOCO.SUB            = ESRC.SUB
             AND MOCO.RIFERIMENTO    = EVPA.RIFERIMENTO
             AND ESRC.ESTRAZIONE     = 'PROSPETTO_MAL_MAT'
             AND ESRC.COLONNA        = 'RETR_POS_15'
             AND P_AL          BETWEEN ESRC.DAL
                                   AND NVL(ESRC.AL,TO_DATE('3333333','J'))
          ;
        END;
      END;
-- INSERIMENTO REGISTRAZIONI DI LIQUIDAZIONE MALATTIE
      PROCEDURE INSERT_CALM IS
      D_RIRE_MESE           NUMBER (2)     ;
      D_MENS_DESCRIZIONE      VARCHAR2 (30)    ;
      D_RIRE_ANNO           NUMBER (4)     ;
      D_RIPA_INI_MES          DATE         ;
      D_RIPA_FIN_MES          DATE         ;
      D_RAIN_CI             NUMBER (8)     ;
      D_RAIN_COGNOME          VARCHAR2 (36)    ;
      D_RAIN_NOME             VARCHAR2 (36)    ;
      D_ANAG_INDIRIZZO        VARCHAR2 (40)    ;
      D_ANAG_PROVINCIA      NUMBER (3)     ;
      D_ANAG_COMUNE         NUMBER (3)     ;
      D_COMU_DESCRIZIONE      VARCHAR2 (40)    ;
      D_COMU_SIGLA_PROVINCIA  VARCHAR2 (5)     ;
      D_ANAG_PRESSO           VARCHAR2 (40)    ;
      D_GEST_CODICE           VARCHAR2 (4)     ;
      D_GEST_NOME             VARCHAR2 (40)    ;
      D_CLPA_EVENTO         NUMBER (10)    ;
      D_CLPA_CLASSE           VARCHAR2 (8)     ;
      D_CLPA_DAL              DATE         ;
      D_CLPA_AL               DATE         ;
      D_CLPA_RIFERIMENTO      DATE         ;
      D_CALM_DAL_RETRIBUZIONE DATE         ;
      D_CALM_AL_RETRIBUZIONE  DATE         ;
      D_CALM_DATA_01          DATE         ;
      D_CALM_DATA_02          DATE         ;
      D_CALM_IMPORTO_03     NUMBER      ;
      D_CALM_GG_03          NUMBER (2)     ;
      D_CALM_IMPORTO_04     NUMBER      ;
      D_CALM_GG_04          NUMBER (2)     ;
      D_CALM_IMPORTO_05     NUMBER      ;
      D_CALM_GG_06          NUMBER (2)     ;
      D_CALM_IMPORTO_07     NUMBER      ;
      D_CALM_GG_07          NUMBER (2)     ;
      D_CALM_DATO1_08       NUMBER (2)     ;
      D_CALM_DATO2_08       NUMBER (2)     ;
      D_CALM_DATO1_12       NUMBER (2)     ;
      D_CALM_DAL_08           DATE         ;
      D_CALM_AL_08            DATE         ;
      D_CALM_IMPORTO_08     NUMBER      ;
      D_CALM_DATO1_09       NUMBER      ;
      D_CALM_DATO2_09       NUMBER      ;
      D_CALM_DAL_09           DATE         ;
      D_CALM_AL_09            DATE         ;
      D_CALM_IMPORTO_09     NUMBER      ;
      D_CALM_DATO1_10       NUMBER      ;
      D_CALM_DATO2_10       NUMBER      ;
      D_CALM_DAL_10           DATE         ;
      D_CALM_AL_10            DATE         ;
      D_CALM_IMPORTO_10     NUMBER      ;
      D_CALM_DATO1_11       NUMBER      ;
      D_CALM_DATO2_11       NUMBER      ;
      D_CALM_DAL_11           DATE         ;
      D_CALM_AL_11            DATE         ;
      D_CALM_IMPORTO_11     NUMBER      ;
      D_CALM_DATO1_13       NUMBER      ;
      D_CALM_DATO2_13       NUMBER      ;
      D_CALM_DAL_13           DATE         ;
      D_CALM_AL_13            DATE         ;
      D_CALM_IMPORTO_13     NUMBER      ;
      D_CALM_DATO1_14       NUMBER      ;
      D_CALM_DATO2_14       NUMBER      ;
      D_CALM_DAL_14           DATE         ;
      D_CALM_AL_14            DATE         ;
      D_CALM_IMPORTO_14     NUMBER      ;
      D_CALM_DATO1_15       NUMBER      ;
      D_CALM_DATO2_15       NUMBER      ;
      D_CALM_DAL_15           DATE         ;
      D_CALM_AL_15            DATE         ;
      D_CALM_IMPORTO_15     NUMBER      ;
      D_COST_GG_LAVORO      NUMBER (2)     ;
      D_ASSISTENZIALE         VARCHAR2(4)      ;
      CURSOR  MALATTIE IS
      SELECT  RIRE.MESE
             ,MENS.DESCRIZIONE
             ,RIRE.ANNO
             ,RIPA.INI_MES
             ,RIPA.FIN_MES
             ,RAIN.CI
             ,RAIN.COGNOME
             ,RAIN.NOME
             ,NVL(ANAG.INDIRIZZO_DOM,ANAG.INDIRIZZO_RES)
             ,NVL(ANAG.PROVINCIA_DOM,ANAG.PROVINCIA_RES)
             ,NVL(ANAG.COMUNE_DOM,ANAG.COMUNE_RES)
             ,COMU.DESCRIZIONE
             ,COMU.SIGLA_PROVINCIA
             ,ANAG.PRESSO
             ,GEST.CODICE
             ,GEST.NOME
             ,CLPA.EVENTO
             ,CLPA.CLASSE
             ,CLPA.DAL
             ,CLPA.AL
             ,CLPA.RIFERIMENTO
             ,ADD_MONTHS(LAST_DAY(CLPA.RIFERIMENTO),-1)+1
             ,LAST_DAY(CLPA.RIFERIMENTO)
             ,COST.GG_LAVORO
             ,NVL(RAPA.ASSISTENZA,TRPR.ASSISTENZA)
        FROM  MENSILITA                 MENS
             ,RIFERIMENTO_RETRIBUZIONE  RIRE
             ,RIFERIMENTO_PRESENZA      RIPA
             ,CONTRATTI_STORICI         COST
             ,GESTIONI                  GEST
             ,SETTORI                   SETT
             ,RAPPORTI_INDIVIDUALI      RAIN
             ,ANAGRAFICI                ANAG
             ,COMUNI                    COMU
             ,RAPPORTI_PRESENZA         RAPA
             ,TRATTAMENTI_PREVIDENZIALI TRPR
             ,TRATTAMENTI_CONTABILI     TRCO
             ,PERIODI_GIURIDICI         PEGI
             ,FIGURE_GIURIDICHE         FIGI
             ,RAPPORTI_RETRIBUTIVI      RARE
             ,PERIODI_SERVIZIO_PRESENZA PSPA
             ,CLASSI_PRESENZA           CLPA
       WHERE  MENS.MESE             = RIRE.MESE
         AND  MENS.TIPO             = 'N'
         AND  RIRE.RIRE_ID          = 'RIRE'
         AND  COST.CONTRATTO        = PSPA.CONTRATTO
         AND  COST.DAL              = PSPA.DAL_CONTRATTO
         AND  GEST.CODICE           = SETT.GESTIONE
         AND  SETT.NUMERO           = PSPA.SETTORE
         AND  RAIN.CI               = CLPA.CI
         AND  ANAG.NI               = RAIN.NI
         AND  CLPA.DAL        BETWEEN ANAG.DAL
                                  AND NVL(ANAG.AL,TO_DATE('3333333','J'))
         AND  COMU.COD_PROVINCIA    = NVL(ANAG.PROVINCIA_DOM
                                         ,ANAG.PROVINCIA_RES)
         AND  COMU.COD_COMUNE       = NVL(ANAG.COMUNE_DOM,ANAG.COMUNE_RES)
         AND  RAPA.CI               = CLPA.CI
         AND  CLPA.DAL        BETWEEN RAPA.DAL
                                  AND NVL(RAPA.AL,TO_DATE('3333333','J'))
         AND  RARE.CI               = RAPA.CI
         AND  PEGI.CI               = RARE.CI
         AND  PEGI.RILEVANZA        = 'S'
         AND  CLPA.DAL        BETWEEN PEGI.DAL
                                  AND NVL(PEGI.AL,TO_DATE('3333333','J'))
         AND  FIGI.NUMERO           = PEGI.FIGURA
         AND  CLPA.DAL        BETWEEN FIGI.DAL
                                  AND NVL(FIGI.AL,TO_DATE('3333333','J'))
         AND  TRCO.PROFILO_PROFESSIONALE
                                    = FIGI.PROFILO
         AND  TRCO.POSIZIONE        = PEGI.POSIZIONE
         AND  TRPR.CODICE           = NVL( RARE.TRATTAMENTO
                                          ,TRCO.TRATTAMENTO
                                         )
         and  trco.tipo_trattamento = nvl(rare.trattamento, 0)
         AND  PSPA.CI               = CLPA.CI
         AND  CLPA.DAL        BETWEEN PSPA.DAL
                                  AND NVL(PSPA.AL,TO_DATE('3333333','J'))
         AND  EXISTS (SELECT 'X'
                        FROM CAUSALI_EVENTO  CAEV
                            ,ENTE
                            ,EVENTI_PRESENZA EVPA
                       WHERE EVPA.CLASSE     = CLPA.EVENTO
                         AND CAEV.CODICE     = EVPA.CAUSALE
                         AND CAEV.PROSPETTO IS NOT NULL
      AND  (    TO_DATE(TO_CHAR(EVPA.DATA_AGG,'DDMMYYYY'),'DDMMYYYY')
                                   = RIPA.FIN_MES
            OR  TO_DATE(TO_CHAR(EVPA.DATA_AGG,'DDMMYYYY'),'DDMMYYYY')
                                  <= RIPA.FIN_MES
            AND NVL(EVPA.AL,TO_DATE('3333333','J'))
                                  >= ADD_MONTHS(RIPA.FIN_MES
                                               ,NVL(ENTE.VARIABILI_GAPE,0)
                                               )
           )
                     )
      ;
      BEGIN
        OPEN MALATTIE;
        LOOP
          FETCH MALATTIE INTO D_RIRE_MESE,D_MENS_DESCRIZIONE,D_RIRE_ANNO,
                              D_RIPA_INI_MES,D_RIPA_FIN_MES,
                              D_RAIN_CI,D_RAIN_COGNOME,D_RAIN_NOME,
                              D_ANAG_INDIRIZZO,D_ANAG_PROVINCIA,D_ANAG_COMUNE,
                              D_COMU_DESCRIZIONE,D_COMU_SIGLA_PROVINCIA,
                              D_ANAG_PRESSO,
                              D_GEST_CODICE,D_GEST_NOME,D_CLPA_EVENTO,
                              D_CLPA_CLASSE,D_CLPA_DAL,D_CLPA_AL,
                              D_CLPA_RIFERIMENTO,
                              D_CALM_DAL_RETRIBUZIONE,D_CALM_AL_RETRIBUZIONE,
                              D_COST_GG_LAVORO,D_ASSISTENZIALE;
          EXIT  WHEN MALATTIE%NOTFOUND;
      --
      --  DATA PRESUNTA DEL PARTO
      --
          DETERMINA_01 (D_CLPA_EVENTO,D_CALM_DATA_01);
      --
      --  DATA EFFETTIVA DEL PARTO
      --
          DETERMINA_02 (D_CLPA_EVENTO,D_CALM_DATA_02);
      --
      --  RETRIBUZIONE MENSILE LORDA IMPIEGATI
      --
          DETERMINA_03 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                        D_RIRE_ANNO,D_RIRE_MESE,
                        D_ASSISTENZIALE,
                        D_CALM_IMPORTO_03);
          D_CALM_GG_03 := 30;
      --
      --  RATEO MENSILE LORDO IMPIEGATI
      --
          DETERMINA_04 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                        D_RIRE_ANNO,D_RIRE_MESE,
                        D_ASSISTENZIALE,
                        D_CALM_IMPORTO_04);
          D_CALM_GG_04 := 30;
      --
      --  RETRIBUZIONE MENSILE LORDA OPERAI
      --
          DETERMINA_05 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                        D_RIRE_ANNO,D_RIRE_MESE,
                        D_ASSISTENZIALE,
                        D_CALM_IMPORTO_05);
      --
      --  GIORNI DI LAVORO OPERAI
      --
          DETERMINA_06 (D_RAIN_CI,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                        D_CLPA_RIFERIMENTO,D_CALM_GG_06);
          IF D_CALM_GG_06 IS NULL THEN
             D_CALM_GG_06 := 26;
          END IF;
      --
      --  RATEO MENSILE LORDO OPERAI
      --
          DETERMINA_07 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                        D_RIRE_ANNO,D_RIRE_MESE,
                        D_ASSISTENZIALE,
                        D_CALM_IMPORTO_07);
          D_CALM_GG_07 := 25;
      --
      --  IMPORTO POSIZIONE 08
      --
          DETERMINA_IMP_08 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                            D_RIRE_ANNO,D_RIRE_MESE,
                            D_ASSISTENZIALE,
                            D_CALM_IMPORTO_08);
      --
      --  ALTRI DATI POSIZIONE 08
      --
          DETERMINA_DATI_08 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                             D_CALM_DATO1_08,D_CALM_DATO2_08,D_CALM_DATO1_12,
                             D_CALM_DAL_08,D_CALM_AL_08);
      --
      --  IMPORTO POSIZIONE 09
      --
          DETERMINA_IMP_09 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                            D_RIRE_ANNO,D_RIRE_MESE,
                            D_ASSISTENZIALE,
                            D_CALM_IMPORTO_09);
      --
      --  ALTRI DATI POSIZIONE 09
      --
          DETERMINA_DATI_09 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                             D_CALM_DATO1_09,D_CALM_DATO2_09,
                             D_CALM_DAL_09,D_CALM_AL_09);
      --
      --  IMPORTO POSIZIONE 10
      --
          DETERMINA_IMP_10 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                            D_RIRE_ANNO,D_RIRE_MESE,
                            D_ASSISTENZIALE,
                            D_CALM_IMPORTO_10);
      --
      --  ALTRI DATI POSIZIONE 10
      --
          DETERMINA_DATI_10 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                             D_CALM_DATO1_10,D_CALM_DATO2_10,
                             D_CALM_DAL_10,D_CALM_AL_10);
      --
      --  IMPORTO POSIZIONE 11
      --
          DETERMINA_IMP_11 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                            D_RIRE_ANNO,D_RIRE_MESE,
                            D_ASSISTENZIALE,
                            D_CALM_IMPORTO_11);
      --
      --  ALTRI DATI POSIZIONE 11
      --
          DETERMINA_DATI_11 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                             D_CALM_DATO1_11,D_CALM_DATO2_11,
                             D_CALM_DAL_11,D_CALM_AL_11);
      --
      --  IMPORTO POSIZIONE 13
      --
          DETERMINA_IMP_13 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                            D_RIRE_ANNO,D_RIRE_MESE,
                            D_ASSISTENZIALE,
                            D_CALM_IMPORTO_13);
      --
      --  ALTRI DATI POSIZIONE 13
      --
          DETERMINA_DATI_13 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                             D_CALM_DATO1_13,D_CALM_DATO2_13,
                             D_CALM_DAL_13,D_CALM_AL_13);
      --
      --  IMPORTO POSIZIONE 14
      --
          DETERMINA_IMP_14 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                            D_RIRE_ANNO,D_RIRE_MESE,
                            D_ASSISTENZIALE,
                            D_CALM_IMPORTO_14);
      --
      --  ALTRI DATI POSIZIONE 14
      --
          DETERMINA_DATI_14 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                             D_CALM_DATO1_14,D_CALM_DATO2_14,
                             D_CALM_DAL_14,D_CALM_AL_14);
      --
      --  IMPORTO POSIZIONE 15
      --
          DETERMINA_IMP_15 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                            D_RIRE_ANNO,D_RIRE_MESE,
                            D_ASSISTENZIALE,
                            D_CALM_IMPORTO_15);
      --
      --  ALTRI DATI POSIZIONE 15
      --
          DETERMINA_DATI_15 (D_CLPA_EVENTO,D_RIPA_INI_MES,D_RIPA_FIN_MES,
                             D_CALM_DATO1_15,D_CALM_DATO2_15,
                             D_CALM_DAL_15,D_CALM_AL_15);
      --
      --  INSERIMENTO REGISTRAZIONE DI LIQUIDAZIONE MALATTIE
      --
          INSERT INTO CALCOLO_LIQUIDAZIONE_MALATTIE
                (CALM_PRENOTAZIONE
                ,RIPA_MESE
                ,MENS_DESCRIZIONE
                ,RIPA_ANNO
                ,RAIN_CI
                ,RAIN_COGNOME
                ,RAIN_NOME
                ,ANAG_INDIRIZZO
                ,ANAG_PROVINCIA
                ,ANAG_COMUNE
                ,COMU_DESCRIZIONE
                ,COMU_SIGLA_PROVINCIA
                ,ANAG_PRESSO
                ,GEST_CODICE
                ,GEST_NOME
                ,CLPA_EVENTO
                ,CLPA_CLASSE
                ,CLPA_DAL
                ,CLPA_AL
                ,CLPA_RIFERIMENTO
                ,CALM_DAL_RETRIBUZIONE
                ,CALM_AL_RETRIBUZIONE
                ,CALM_DATA_01
                ,CALM_DATA_02
                ,CALM_IMPORTO_03
                ,CALM_GG_03
                ,CALM_IMPORTO_04
                ,CALM_GG_04
                ,CALM_IMPORTO_05
                ,CALM_GG_06
                ,CALM_IMPORTO_07
                ,CALM_GG_07
                ,CALM_DATO1_08
                ,CALM_DATO2_08
                ,CALM_DATO1_12
                ,CALM_DAL_08
                ,CALM_AL_08
                ,CALM_IMPORTO_08
                ,CALM_DATO1_09
                ,CALM_DATO2_09
                ,CALM_DAL_09
                ,CALM_AL_09
                ,CALM_IMPORTO_09
                ,CALM_DATO1_10
                ,CALM_DATO2_10
                ,CALM_DAL_10
                ,CALM_AL_10
                ,CALM_IMPORTO_10
                ,CALM_DATO1_11
                ,CALM_DATO2_11
                ,CALM_DAL_11
                ,CALM_AL_11
                ,CALM_IMPORTO_11
                ,CALM_DATO1_13
                ,CALM_DATO2_13
                ,CALM_DAL_13
                ,CALM_AL_13
                ,CALM_IMPORTO_13
                ,CALM_DATO1_14
                ,CALM_DATO2_14
                ,CALM_DAL_14
                ,CALM_AL_14
                ,CALM_IMPORTO_14
                ,CALM_DATO1_15
                ,CALM_DATO2_15
                ,CALM_DAL_15
                ,CALM_AL_15
                ,CALM_IMPORTO_15
                )
          SELECT W_PRENOTAZIONE
                ,D_RIRE_MESE
                ,D_MENS_DESCRIZIONE
                ,D_RIRE_ANNO
                ,D_RAIN_CI
                ,D_RAIN_COGNOME
                ,D_RAIN_NOME
                ,D_ANAG_INDIRIZZO
                ,D_ANAG_PROVINCIA
                ,D_ANAG_COMUNE
                ,D_COMU_DESCRIZIONE
                ,D_COMU_SIGLA_PROVINCIA
                ,D_ANAG_PRESSO
                ,D_GEST_CODICE
                ,D_GEST_NOME
                ,D_CLPA_EVENTO
                ,D_CLPA_CLASSE
                ,D_CLPA_DAL
                ,D_CLPA_AL
                ,D_CLPA_RIFERIMENTO
                ,D_CALM_DAL_RETRIBUZIONE
                ,D_CALM_AL_RETRIBUZIONE
                ,D_CALM_DATA_01
                ,D_CALM_DATA_02
                ,D_CALM_IMPORTO_03
                ,D_CALM_GG_03
                ,D_CALM_IMPORTO_04
                ,D_CALM_GG_04
                ,D_CALM_IMPORTO_05
                ,D_CALM_GG_06
                ,D_CALM_IMPORTO_07
                ,D_CALM_GG_07
                ,D_CALM_DATO1_08
                ,D_CALM_DATO2_08
                ,D_CALM_DATO1_12
                ,D_CALM_DAL_08
                ,D_CALM_AL_08
                ,D_CALM_IMPORTO_08
                ,D_CALM_DATO1_09
                ,D_CALM_DATO2_09
                ,D_CALM_DAL_09
                ,D_CALM_AL_09
                ,D_CALM_IMPORTO_09
                ,D_CALM_DATO1_10
                ,D_CALM_DATO2_10
                ,D_CALM_DAL_10
                ,D_CALM_AL_10
                ,D_CALM_IMPORTO_10
                ,D_CALM_DATO1_11
                ,D_CALM_DATO2_11
                ,D_CALM_DAL_11
                ,D_CALM_AL_11
                ,D_CALM_IMPORTO_11
                ,D_CALM_DATO1_13
                ,D_CALM_DATO2_13
                ,D_CALM_DAL_13
                ,D_CALM_AL_13
                ,D_CALM_IMPORTO_13
                ,D_CALM_DATO1_14
                ,D_CALM_DATO2_14
                ,D_CALM_DAL_14
                ,D_CALM_AL_14
                ,D_CALM_IMPORTO_14
                ,D_CALM_DATO1_15
                ,D_CALM_DATO2_15
                ,D_CALM_DAL_15
                ,D_CALM_AL_15
                ,D_CALM_IMPORTO_15
            FROM DUAL
          ;
        END LOOP;
        CLOSE MALATTIE;
      END;
  PROCEDURE CALCOLO
      IS
      BEGIN
         BEGIN
            DELETE_TAB;
            INSERT_CALM;
            COMMIT;
         END;
      END;
  PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO        IN NUMBER) is
	begin
               IF PRENOTAZIONE != 0 THEN
                  BEGIN  -- PRELEVA UTENTE DA DEPOSITARE IN CAMPI GLOBAL
                     SELECT UTENTE
                          , AMBIENTE
                          , ENTE
                          , GRUPPO_LING
                       INTO W_UTENTE
                          , W_AMBIENTE
                          , W_ENTE
                          , W_LINGUA
                       FROM A_PRENOTAZIONI
                      WHERE NO_PRENOTAZIONE = PRENOTAZIONE
                     ;
                  EXCEPTION
                     WHEN OTHERS THEN NULL;
                  END;
               END IF;
               W_PRENOTAZIONE := PRENOTAZIONE;
               ERRORE := to_char(null);
               -- MEMORIZZATO IN CASO DI AZZERAMENTO PER ROLLBACK
               -- VIENE RIAZZERATO IN FORM CHIAMANTE PER EVITARE TRASACTION COMPLETED
               CALCOLO;  -- ESECUZIONE DEL CALCOLO PLIQUIDAZIONE MALATTIE
               IF W_PRENOTAZIONE != 0 THEN
                  IF SUBSTR(ERRORE,6,1) = '8' THEN
                     UPDATE A_PRENOTAZIONI
                        SET ERRORE = 'P05808'
                      WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
                     ;
                     COMMIT;
                  ELSIF
                     SUBSTR(ERRORE,6,1) = '9' THEN
                     UPDATE A_PRENOTAZIONI
                        SET ERRORE       = 'P05809'
                          , PROSSIMO_PASSO = 91
                      WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
                     ;
                     COMMIT;
                  END IF;
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  BEGIN
                     ROLLBACK;
                     IF W_PRENOTAZIONE != 0 THEN
                        UPDATE A_PRENOTAZIONI
                           SET ERRORE       = '*ABORT*'
                             , PROSSIMO_PASSO = 99
                        WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
                        ;
                        COMMIT;
                     END IF;
                  EXCEPTION
                     WHEN OTHERS THEN
NULL;
                  END;
            END;
END;
/

