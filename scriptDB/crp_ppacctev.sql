CREATE OR REPLACE PACKAGE ppacctev IS
/******************************************************************************
 NOME:          P
 DESCRIZIONE:   
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000             
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
  PROCEDURE MAIN		(P_PRENOTAZIONE IN NUMBER,
		  			 PASSO        IN NUMBER);
END;
/

CREATE OR REPLACE PACKAGE BODY ppacctev IS
	W_UTENTE	VARCHAR2(10);
	W_AMBIENTE	VARCHAR2(10);
	W_ENTE		VARCHAR2(10);
	W_LINGUA	VARCHAR2(1);
	W_PRENOTAZIONE	NUMBER(10);
	errore		varchar2(6);
	-- errpasso	varchar2(80);
	P_DAL		DATE;
        P_AL		DATE;
	P_OPZIONE	VARCHAR2(1);
	P_CONTRATTO	VARCHAR2(5);
	P_LIVELLO	VARCHAR2(4);
	P_POSIZIONE	VARCHAR2(4);
	P_ATTIVITA	VARCHAR2(4);
	P_QUALIFICA	VARCHAR2(8);
	P_DI_RUOLO	VARCHAR2(2);
	P_FIGURA	VARCHAR2(8);
	P_GESTIONE	VARCHAR2(4);
	P_SETTORE	VARCHAR2(15);
	P_SEDE		VARCHAR2(8);
	P_RUOLO		VARCHAR2(4);
	P_RAPPORTO	VARCHAR2(4);
	P_GRUPPO	VARCHAR2(12);
	P_FATTORE	VARCHAR2(6);
	P_ASSISTENZA	VARCHAR2(6);
	P_CDC		VARCHAR2(8);
	P_FASCIA	VARCHAR2(2);
      -- INSERIMENTO REGISTRAZIONI DI CATEGORIA PER INDIVIDUI IDONEI
       FUNCTION VERSIONE  RETURN VARCHAR2 IS
      BEGIN
    RETURN 'V1.0 del 20/01/2003';
      END VERSIONE;
      PROCEDURE FASE_1 IS
      BEGIN
        INSERT INTO CALCOLO_PROSPETTI_PRESENZA
              (PRENOTAZIONE
              ,TIPO_RECORD
              ,PRPA_SEQUENZA        -- CONTIENE LA SEQUENZA DELLA CATEGORIA
              ,PRPA_CODICE          -- CONTIENE IL CODICE DELLA CATEGORIA
              ,SEDE_CODICE
              ,CECO_CODICE
              ,GEST_CODICE
              ,SETT_CODICE
              ,RAIN_COGNOME
              ,RAIN_NOME
              ,RAIN_CI
              ,PSPA_CONTRATTO
              ,PSPA_DAL_RAPPORTO    -- RIEMPITO DA SYSDATE PERCHE` NOT NULL
              ,GES_01               -- CONTIENE GESTIONE DELLA CATEGORIA
              ,COD_02               -- CONTIENE LIVELLO
              ,COD_03               -- CONTIENE QUALIFICA
              ,COD_04               -- CONTIENE INDICATORE DI RUOLO/NO RUOLO
              ,COD_05               -- CONTIENE POSIZIONE
              ,COD_06               -- CONTIENE FIGURA
              ,COD_07               -- CONTIENE ATTIVITA`
              ,COD_08               -- CONTIENE RUOLO
              ,COD_09               -- CONTIENE RAPPORTO
              ,COD_10               -- CONTIENE GRUPPO (CHAR 1-10)
              ,COD_11               -- CONTIENE GRUPPO (CHAR(11-12)
              ,COD_12               -- CONTIENE FASCIA
              ,COD_13               -- CONTIENE FATTORE PRODUTTIVO
              ,COD_14               -- CONTIENE ASSISTENZA
              ,COD_15               -- CONTIENE SEDE DEL PERIODO DI PRESENZA
              ,COD_16               -- CONTIENE CDC  DEL PERIODO DI PRESENZA
              )
        SELECT W_PRENOTAZIONE
              ,'01'
              ,CTEV.SEQUENZA
              ,CTEV.CODICE
              ,SEDE.CODICE
              ,EVPA.CDC
              ,GEST.CODICE
              ,SETT.CODICE
              ,RAIN.COGNOME
              ,RAIN.NOME
              ,RAIN.CI
              ,PSPA.CONTRATTO
              ,SYSDATE
              ,CTEV.GESTIONE
              ,QUGI.LIVELLO
              ,QUGI.CODICE
              ,POSI.RUOLO
              ,PEGI.POSIZIONE
              ,FIGI.CODICE
              ,PEGI.ATTIVITA
              ,QUGI.RUOLO
              ,RAIN.RAPPORTO
              ,SUBSTR(RAIN.GRUPPO,1,10)
              ,SUBSTR(RAIN.GRUPPO,11,2)
              ,GEST.FASCIA
              ,NVL(RAPA.FATTORE_PRODUTTIVO
                  ,DECODE(PEGI.TIPO_RAPPORTO,'TD',QUAL.FATTORE_TD
                                                 ,QUAL.FATTORE
                         )
                  )
              ,NVL(RAPA.ASSISTENZA,TRPR.ASSISTENZA)
              ,SEDP.CODICE
              ,RIFU.CDC
          FROM TRATTAMENTI_PREVIDENZIALI     TRPR
              ,RAPPORTI_RETRIBUTIVI          RARE
              ,RIPARTIZIONI_FUNZIONALI       RIFU
              ,SEDI                          SEDE
              ,SEDI                          SEDP
              ,SETTORI                       SETT
              ,GESTIONI                      GEST
              ,QUALIFICHE_GIURIDICHE         QUGI
              ,QUALIFICHE                    QUAL
              ,FIGURE_GIURIDICHE             FIGI
              ,POSIZIONI                     POSI
              ,PERIODI_GIURIDICI             PEGI
              ,RAPPORTI_PRESENZA             RAPA
              ,RAPPORTI_INDIVIDUALI          RAIN
              ,CAUSALI_EVENTO                CAEV
              ,CATEGORIE_EVENTO              CTEV
              ,TOTALIZZAZIONE_CAUSALI        TOCA
              ,EVENTI_PRESENZA               EVPA
              ,PERIODI_SERVIZIO_PRESENZA     PSPA
         WHERE EVPA.DAL                  <= P_AL
           AND NVL(EVPA.AL,TO_DATE('3333333','J'))
                                         >=
               NVL(P_DAL,TO_DATE('2222222','J'))
           AND EVPA.DAL             BETWEEN PSPA.DAL
                                        AND NVL(PSPA.AL,TO_DATE('3333333','J'))
           AND EVPA.CI                    = PSPA.CI
           AND TOCA.CAUSALE               = EVPA.CAUSALE
           AND RAIN.CI                    = PSPA.CI
           AND RAPA.CI                    = PSPA.CI
           AND RAPA.DAL                   = PSPA.DAL_RAPPORTO
           AND CTEV.CODICE                = TOCA.CATEGORIA
           AND CAEV.CODICE                = EVPA.CAUSALE
           AND DECODE(P_OPZIONE,'E','E',CAEV.QUALIFICAZIONE)
                                          = P_OPZIONE
           AND PEGI.CI                (+) = PSPA.CI
           AND PEGI.RILEVANZA         (+) = PSPA.RILEVANZA
           AND PEGI.DAL               (+) = PSPA.DAL_PERIODO
           AND QUAL.NUMERO            (+) = PSPA.QUALIFICA
           AND QUGI.NUMERO            (+) = PSPA.QUALIFICA
           AND QUGI.DAL               (+) = PSPA.DAL_QUALIFICA
           AND FIGI.NUMERO            (+) = PSPA.FIGURA
           AND FIGI.DAL               (+) = PSPA.DAL_FIGURA
           AND SETT.NUMERO            (+) = PSPA.SETTORE
           AND SEDP.NUMERO            (+) = PSPA.SEDE
           AND SEDE.NUMERO            (+) = EVPA.SEDE
           AND RIFU.SETTORE           (+) = PSPA.SETTORE
           AND RIFU.SEDE              (+) = NVL(PSPA.SEDE_CDC,0)
           AND GEST.CODICE            (+) = SETT.GESTIONE
           AND POSI.CODICE            (+) = PEGI.POSIZIONE
           AND RARE.CI                (+) = PSPA.CI
           AND TRPR.CODICE            (+) = RARE.TRATTAMENTO
           AND (    RAIN.CC                IS NULL
                OR  RAIN.CC                IS NOT NULL
                AND EXISTS
                    (SELECT 'X'
                       FROM A_COMPETENZE COMP
                      WHERE COMP.AMBIENTE   = W_AMBIENTE
                        AND COMP.ENTE       = W_ENTE
                        AND COMP.UTENTE     = W_UTENTE
                        AND COMP.COMPETENZA = 'CI'
                        AND COMP.OGGETTO    = RAIN.CC
                    )
               )
           AND EXISTS
               (SELECT 'X'
                  FROM CLASSI_RAPPORTO   CLRA
                 WHERE CLRA.CODICE          = RAIN.RAPPORTO
                   AND CLRA.PRESENZA        = 'SI'
               )
           AND (    PSPA.UFFICIO           IS NULL
                OR  PSPA.UFFICIO           IS NOT NULL
                AND EXISTS
                    (SELECT 'X'
                       FROM A_COMPETENZE COMP
                      WHERE COMP.AMBIENTE   = W_AMBIENTE
                        AND COMP.ENTE       = W_ENTE
                        AND COMP.UTENTE     = W_UTENTE
                        AND COMP.COMPETENZA = PSPA.UFFICIO
                        AND COMP.OGGETTO    = 'UFFICIO_PRESENZA'
                    )
               )
        ;
      END;
      -- ELIMINAZIONE DEGLI INDIVIDUI CHE NON HANNO ATTRIBUTI
      -- CORRISPONDENTI ALLA COLLETTIVITA` SELEZIONATA ED
      -- EMISSIONE REGISTRAZIONI DI CATEGORIA DEFINITIVE
      PROCEDURE FASE_2 IS
      CURSOR INDI IS
      SELECT CAPA.RAIN_CI
            ,CAPA.PRPA_CODICE
        FROM CALCOLO_PROSPETTI_PRESENZA CAPA
       WHERE CAPA.PRENOTAZIONE = W_PRENOTAZIONE
         AND CAPA.TIPO_RECORD  = '01'
       ORDER BY CAPA.RAIN_CI
      ;
      D_CI               NUMBER(8);
      D_CATEGORIA          VARCHAR2(8);
      CURSOR CAPA IS
      SELECT NVL(CAPA.SEDE_CODICE,CAPA.COD_15)
            ,NVL(CAPA.CECO_CODICE,CAPA.COD_16)
            ,CAPA.GEST_CODICE
            ,CAPA.SETT_CODICE
            ,CAPA.PSPA_CONTRATTO
            ,CAPA.COD_02
            ,CAPA.COD_03
            ,CAPA.COD_04
            ,CAPA.COD_05
            ,CAPA.COD_06
            ,CAPA.COD_07
            ,CAPA.COD_08
            ,CAPA.COD_09
            ,CAPA.COD_10||CAPA.COD_11
            ,CAPA.COD_12
            ,CAPA.COD_13
            ,CAPA.COD_14
        FROM CALCOLO_PROSPETTI_PRESENZA CAPA
       WHERE CAPA.PRENOTAZIONE             = W_PRENOTAZIONE
         AND CAPA.RAIN_CI                  = D_CI
         AND CAPA.PRPA_CODICE              = D_CATEGORIA
         AND CAPA.TIPO_RECORD              = '01'
      ;
      D_OK                 VARCHAR2(2);
      D_CONTRATTO          VARCHAR2(4);
      D_LIVELLO            VARCHAR2(4);
      D_QUALIFICA          VARCHAR2(8);
      D_DI_RUOLO           VARCHAR2(2);
      D_POSIZIONE          VARCHAR2(4);
      D_FIGURA             VARCHAR2(8);
      D_ATTIVITA           VARCHAR2(4);
      D_GESTIONE           VARCHAR2(4);
      D_SETTORE            VARCHAR2(15);
      D_SEDE               VARCHAR2(8);
      D_RUOLO              VARCHAR2(4);
      D_RAPPORTO           VARCHAR2(4);
      D_GRUPPO             VARCHAR2(12);
      D_FASCIA             VARCHAR2(2);
      D_CDC                VARCHAR2(8);
      D_FATTORE            VARCHAR2(6);
      D_ASSISTENZA         VARCHAR2(6);
      D_MIN_GG           NUMBER(4);
      D_GES_CATEGORIA      VARCHAR2(1);
      D_MOTIVO             VARCHAR2(8);
      D_CAUSALE            VARCHAR2(8);
      D_GES_CAUSALE        VARCHAR2(1);
      D_DAL_EVPA           DATE   ;
      D_AL_EVPA            DATE   ;
      D_EVENTO           NUMBER(10);
      D_VALORE           NUMBER;
      D_SEQ_CATEGORIA    NUMBER(3);
      D_COGNOME            VARCHAR2(36);
      D_NOME               VARCHAR2(36);
      CURSOR  TOCA IS
      SELECT  DECODE(TOCA.GESTIONE,'G',
              (NVL(EVPA.AL,TO_DATE('3333333','J'))
               - EVPA.DAL + 1),EVPA.VALORE)
              * DECODE(TOCA.SEGNO,'-',-1,1) *
              DECODE(CTEV.GESTIONE||CAEV.GESTIONE
                    ,'HG',NVL(PSPA.MIN_GG,0)
                    ,'OG',NVL(PSPA.MIN_GG,0)
                         ,1
                    ) /
             DECODE(CTEV.GESTIONE||CAEV.GESTIONE
                    ,'GH',NVL(PSPA.MIN_GG,1)
                    ,'GO',NVL(PSPA.MIN_GG,1)
                         ,1
                    )
             ,CTEV.GESTIONE
             ,EVPA.CAUSALE
             ,CAEV.GESTIONE
             ,EVPA.EVENTO
             ,EVPA.DAL
             ,EVPA.AL
             ,PSPA.MIN_GG
             ,CTEV.SEQUENZA
             ,RAIN.COGNOME
             ,RAIN.NOME
             ,EVPA.MOTIVO
        FROM  CAUSALI_EVENTO            CAEV
             ,CATEGORIE_EVENTO          CTEV
             ,SEDI                      SEDR
             ,SEDI                      SEDE
             ,SETTORI                   SETT
             ,RIPARTIZIONI_FUNZIONALI   RIFU
             ,RAPPORTI_PRESENZA         RAPA
             ,RAPPORTI_INDIVIDUALI      RAIN
             ,EVENTI_PRESENZA           EVPA
             ,MESI                      MESE
             ,TOTALIZZAZIONE_CAUSALI    TOCA
             ,PERIODI_SERVIZIO_PRESENZA PSPA
       WHERE  EVPA.CI           = PSPA.CI
         AND  RAIN.CI           = PSPA.CI
         AND  RAPA.CI           = PSPA.CI
         AND  RAPA.DAL          = PSPA.DAL_RAPPORTO
         AND  RIFU.SEDE     (+) = NVL(PSPA.SEDE_CDC,0)
         AND  RIFU.SETTORE  (+) = PSPA.SETTORE
         AND  SETT.NUMERO   (+) = PSPA.SETTORE
         AND  CAEV.CODICE       = EVPA.CAUSALE
         AND DECODE(P_OPZIONE,'E','E',CAEV.QUALIFICAZIONE)
                                = P_OPZIONE
         AND  CTEV.CODICE       = TOCA.CATEGORIA
         AND  EVPA.CAUSALE      = TOCA.CAUSALE
         AND  NVL(EVPA.MOTIVO,' ')
                             LIKE TOCA.MOTIVO
         AND  EVPA.DAL    BETWEEN PSPA.DAL AND
                          NVL(PSPA.AL,TO_DATE('3333333','J'))
         AND  EVPA.RIFERIMENTO
                          BETWEEN
                          NVL(CTEV.DAL,TO_DATE('2222222','J'))
                          AND
                          NVL(CTEV.AL ,TO_DATE('3333333','J'))
         AND  (    TO_CHAR(TOCA.RIFERIMENTO_MM)||
                   TO_CHAR(TOCA.RIFERIMENTO_GG)
                               IS NULL
               OR  TO_CHAR(TOCA.RIFERIMENTO_MM)||
                   TO_CHAR(TOCA.RIFERIMENTO_GG)
                               IS NOT NULL
               AND MESE.FIN_MESE - EVPA.DAL + 1
                               <=
                   NVL(TOCA.RIFERIMENTO_MM,0) * 30 +
                   NVL(TOCA.RIFERIMENTO_GG,0)
              )
         AND  SEDR.NUMERO (+)   = NVL(PSPA.SEDE,0)
         AND  SEDE.NUMERO (+)   = NVL(EVPA.SEDE,0)
         AND  NVL(SEDE.CODICE,NVL(SEDR.CODICE,' '))
                             LIKE CTEV.SEDE
         AND  NVL(EVPA.CDC,NVL(RAPA.CDC,NVL(RIFU.CDC,' ')))
                             LIKE CTEV.CDC
         AND  DECODE
              (CTEV.OPZIONE
              ,'M',TO_CHAR(ADD_MONTHS(EVPA.DAL
                                     ,DECODE(CAEV.RIFERIMENTO
                                            ,'P',1,0)
                                     )
                          ,'YYYYMM'
                          )
              ,'A',TO_CHAR(ADD_MONTHS(EVPA.DAL
                                     ,DECODE(CAEV.RIFERIMENTO
                                             ,'P',1,0)
                                     )
                          ,'YYYY'
                          )
              ,'T',TO_CHAR(MESE.FIN_MESE,'YYYY')
              ,'P',TO_CHAR(ADD_MONTHS(EVPA.DAL
                                     ,DECODE(CAEV.RIFERIMENTO
                                            ,'P',1,0)
                                     )
                          ,'YYYY'
                          )
                  ,NULL
              )                 =
              DECODE
              (CTEV.OPZIONE
              ,'M',TO_CHAR(MESE.FIN_MESE,'YYYYMM')
              ,'A',TO_CHAR(MESE.FIN_MESE,'YYYY')
              ,'T',TO_CHAR(MESE.FIN_MESE,'YYYY')
              ,'P',TO_CHAR(TO_NUMBER(TO_CHAR(MESE.FIN_MESE
                                            ,'YYYY'))-1)
                  ,NULL
              )
         AND  PSPA.CI                  = D_CI
         AND  TOCA.CATEGORIA           = D_CATEGORIA
         AND  MESE.ANNO                = TO_NUMBER(TO_CHAR(
                                         P_AL,'YYYY'))
         AND  MESE.MESE                = TO_NUMBER(TO_CHAR(
                                         P_AL,'MM'))
      ;
      BEGIN
        OPEN INDI;
        LOOP
          FETCH INDI INTO D_CI,D_CATEGORIA;
          EXIT  WHEN INDI%NOTFOUND;
          D_OK := 'NO';
          OPEN CAPA;
          LOOP
            FETCH CAPA INTO D_SEDE,D_CDC,D_GESTIONE,D_SETTORE,D_CONTRATTO,
                            D_LIVELLO,D_QUALIFICA,D_DI_RUOLO,D_POSIZIONE,
                            D_FIGURA,D_ATTIVITA,D_RUOLO,D_RAPPORTO,D_GRUPPO,
                            D_FASCIA,D_FATTORE,D_ASSISTENZA;
            EXIT  WHEN CAPA%NOTFOUND;
            IF  NVL(D_CONTRATTO ,' ')     LIKE NVL(P_CONTRATTO ,'%')
            AND NVL(D_LIVELLO   ,' ')     LIKE NVL(P_LIVELLO   ,'%')
            AND NVL(D_QUALIFICA ,' ')     LIKE NVL(P_QUALIFICA ,'%')
            AND NVL(D_DI_RUOLO  ,' ')     LIKE NVL(P_DI_RUOLO  ,'%')
            AND NVL(D_POSIZIONE ,' ')     LIKE NVL(P_POSIZIONE ,'%')
            AND NVL(D_FIGURA    ,' ')     LIKE NVL(P_FIGURA    ,'%')
            AND NVL(D_ATTIVITA  ,' ')     LIKE NVL(P_ATTIVITA  ,'%')
            AND NVL(D_GESTIONE  ,' ')     LIKE NVL(P_GESTIONE  ,'%')
            AND NVL(D_SETTORE   ,' ')     LIKE NVL(P_SETTORE   ,'%')
            AND NVL(D_SEDE      ,' ')     LIKE NVL(P_SEDE      ,'%')
            AND NVL(D_RUOLO     ,' ')     LIKE NVL(P_RUOLO     ,'%')
            AND NVL(D_RAPPORTO  ,' ')     LIKE NVL(P_RAPPORTO  ,'%')
            AND NVL(D_GRUPPO    ,' ')     LIKE NVL(P_GRUPPO    ,'%')
            AND NVL(D_FASCIA    ,' ')     LIKE NVL(P_FASCIA    ,'%')
            AND NVL(D_CDC       ,' ')     LIKE NVL(P_CDC       ,'%')
            AND NVL(D_FATTORE   ,' ')     LIKE NVL(P_FATTORE   ,'%')
            AND NVL(D_ASSISTENZA,' ')     LIKE NVL(P_ASSISTENZA,'%')
                                          THEN
                D_OK := 'SI';
                EXIT;
            END IF;
          END LOOP;
          CLOSE CAPA;
          IF D_OK = 'SI' THEN
            OPEN TOCA;
            LOOP
              FETCH TOCA INTO D_VALORE,D_GES_CATEGORIA,D_CAUSALE,D_GES_CAUSALE,
                              D_EVENTO,D_DAL_EVPA,D_AL_EVPA,D_MIN_GG,
                              D_SEQ_CATEGORIA,D_COGNOME,D_NOME,D_MOTIVO;
              EXIT  WHEN TOCA%NOTFOUND;
              IF  NVL(D_VALORE,0) != 0 THEN
                  INSERT INTO CALCOLO_PROSPETTI_PRESENZA
                        (PRENOTAZIONE
                        ,TIPO_RECORD
                        ,PRPA_SEQUENZA        -- CONTIENE SEQ. CATEGORIA
                        ,PRPA_CODICE          -- CONTIENE COD. CATEGORIA
                        ,PRPA_DESCRIZIONE     -- CONTIENE GES. CATEGORIA
                        ,SEDE_SEQUENZA        -- CONTIENE MINUTI GG.
                        ,RAIN_COGNOME
                        ,RAIN_NOME
                        ,RAIN_CI
                        ,PSPA_DAL_RAPPORTO    -- CONTIENE SYSDATE
                        ,DAL                  -- CONTIENE DAL EVENTO
                        ,AL                   -- CONTIENE AL  EVENTO
                        ,COD_01               -- CONTIENE CAUSALE EVENTO
                        ,GES_01               -- CONTIENE GESTIONE CAUSALE
                        ,VAL_01               -- CONTIENE VALORE EVENTO IN UM
                                              -- DELLA GESTIONE DELLA CATEGORIA
                        ,COD_02               -- CONTIENE MOTIVO DI EVENTO
                        ,VAL_02               -- CONTIENE NUMERO DI EVENTO
                        )
                 SELECT  W_PRENOTAZIONE
                        ,'02'
                        ,D_SEQ_CATEGORIA
                        ,D_CATEGORIA
                        ,D_GES_CATEGORIA
                        ,D_MIN_GG
                        ,D_COGNOME
                        ,D_NOME
                        ,D_CI
                        ,SYSDATE
                        ,D_DAL_EVPA
                        ,D_AL_EVPA
                        ,D_CAUSALE
                        ,D_GES_CAUSALE
                        ,D_VALORE
                        ,D_MOTIVO
                        ,D_EVENTO
                   FROM  DUAL
                 ;
              END IF;
            END LOOP;
            CLOSE TOCA;
          END IF;
          DELETE FROM CALCOLO_PROSPETTI_PRESENZA CAPA
           WHERE CAPA.PRPA_CODICE      = D_CATEGORIA
             AND CAPA.RAIN_CI          = D_CI
             AND CAPA.PRENOTAZIONE     = W_PRENOTAZIONE
             AND CAPA.TIPO_RECORD      = '01'
            ;
        END LOOP;
        CLOSE INDI;
      END;
-- PULIZIA TABELLA DI LAVORO
      PROCEDURE DELETE_TAB IS
      BEGIN
        DELETE FROM CALCOLO_PROSPETTI_PRESENZA
         WHERE PRENOTAZIONE = W_PRENOTAZIONE;
      END;
-- PROCEDURA GENERALE DI CALCOLO
      PROCEDURE CALCOLO IS
      BEGIN
         IF P_AL IS NULL THEN
            BEGIN
              SELECT RIPA.FIN_MES
                INTO P_AL
                FROM RIFERIMENTO_PRESENZA RIPA
               WHERE RIPA.RIPA_ID = 'RIPA'
                 AND ROWNUM       < 2
              ;
            EXCEPTION
              WHEN NO_DATA_FOUND THEN
                P_AL := TO_DATE(TO_CHAR(SYSDATE,'DDMMYYYY'),'DDMMYYYY');
            END;
         END IF;
         BEGIN
            DELETE_TAB;
            FASE_1;
            FASE_2;
	    COMMIT;
         END;
      END;
      -- RICEZIONE PARAMETRI INDICATI
      PROCEDURE SELEZIONA_PARAMETRI IS
      BEGIN
         BEGIN
           SELECT TO_DATE(PARA.VALORE,'DD/MM/YYYY')
             INTO P_DAL
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_DAL'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_DAL            := NULL;
         END;
         BEGIN
           SELECT TO_DATE(PARA.VALORE,'DD/MM/YYYY')
             INTO P_AL
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_AL'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_AL               := NULL;
         END;
         BEGIN
           SELECT SUBSTR(PARA.VALORE,1,1)
             INTO P_OPZIONE
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_OPZIONE'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_OPZIONE        := 'E';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,4),'%')
             INTO P_CONTRATTO
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_CONTRATTO'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_CONTRATTO      := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,4),'%')
             INTO P_LIVELLO
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_LIVELLO'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_LIVELLO        := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,8),'%')
             INTO P_QUALIFICA
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_QUALIFICA'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_QUALIFICA      := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,2),'%')
             INTO P_DI_RUOLO
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_DI_RUOLO'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_DI_RUOLO       := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,4),'%')
             INTO P_POSIZIONE
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_POSIZIONE'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_POSIZIONE      := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,8),'%')
             INTO P_FIGURA
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_FIGURA'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_FIGURA         := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,4),'%')
             INTO P_ATTIVITA
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_ATTIVITA'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_ATTIVITA       := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,4),'%')
             INTO P_GESTIONE
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_GESTIONE'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_GESTIONE       := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,15),'%')
             INTO P_SETTORE
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_SETTORE'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_SETTORE        := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,8),'%')
             INTO P_SEDE
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_SEDE'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_SEDE           := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,4),'%')
             INTO P_RUOLO
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_RUOLO'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_RUOLO          := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,4),'%')
             INTO P_RAPPORTO
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_RAPPORTO'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_RAPPORTO       := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,12),'%')
             INTO P_GRUPPO
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_GRUPPO'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_GRUPPO         := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,2),'%')
             INTO P_FASCIA
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_FASCIA'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_FASCIA         := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,8),'%')
             INTO P_CDC
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_CDC'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_CDC            := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,6),'%')
             INTO P_FATTORE
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_FATTORE'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_FATTORE        := '%';
         END;
         BEGIN
           SELECT NVL(SUBSTR(PARA.VALORE,1,6),'%')
             INTO P_ASSISTENZA
             FROM A_PARAMETRI PARA
            WHERE PARA.NO_PRENOTAZIONE = W_PRENOTAZIONE
              AND PARA.PARAMETRO       = 'P_ASSISTENZA'
           ;
         EXCEPTION
           WHEN NO_DATA_FOUND OR TOO_MANY_ROWS THEN
             P_ASSISTENZA     := '%';
         END;
      END;
  PROCEDURE MAIN		(P_PRENOTAZIONE IN NUMBER,
		  			 PASSO        IN NUMBER) is
  begin
IF P_PRENOTAZIONE != 0 THEN
                  BEGIN  -- PRELEVA UTENTE DA DEPOSITARE IN CAMPI GLOBAL
                     SELECT UTENTE
                          , AMBIENTE
                          , ENTE
                          , GRUPPO_LING
                       INTO W_UTENTE
                          , w_AMBIENTE
                          , W_ENTE
                          , W_LINGUA
                       FROM A_PRENOTAZIONI
                      WHERE NO_PRENOTAZIONE = P_PRENOTAZIONE
                     ;
                  EXCEPTION
                     WHEN OTHERS THEN NULL;
                  END;
               END IF;
               W_PRENOTAZIONE := P_PRENOTAZIONE;
               ERRORE := to_char(null);
               -- MEMORIZZATO IN CASO DI AZZERAMENTO PER ROLLBACK
               SELEZIONA_PARAMETRI;
               -- VIENE RIAZZERATO IN FORM CHIAMANTE PER EVITARE TRASACTION COMPLETED
               CALCOLO;  -- ESECUZIONE DEL CALCOLO
               IF w_PRENOTAZIONE != 0 THEN
                  IF SUBSTR(errore,6,1) = '8' THEN
                     UPDATE A_PRENOTAZIONI
                        SET ERRORE = 'P05808'
                      WHERE NO_PRENOTAZIONE = w_PRENOTAZIONE
                     ;
                     COMMIT;
                  ELSIF
                     SUBSTR(errore,6,1) = '9' THEN
                     UPDATE A_PRENOTAZIONI
                        SET ERRORE       = 'P05809'
                          , PROSSIMO_PASSO = 91
                      WHERE NO_PRENOTAZIONE = w_PRENOTAZIONE
                     ;
                     COMMIT;
                  END IF;
               END IF;
            EXCEPTION
               WHEN OTHERS THEN
                  BEGIN
                     ROLLBACK;
                     IF w_PRENOTAZIONE != 0 THEN
                        UPDATE A_PRENOTAZIONI
                           SET ERRORE       = '*ABORT*'
                             , PROSSIMO_PASSO = 99
                        WHERE NO_PRENOTAZIONE = w_PRENOTAZIONE
                        ;
                        COMMIT;
                     END IF;
                  EXCEPTION
                     WHEN OTHERS THEN
			null;
                  END;
            END;
END;
/

