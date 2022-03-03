CREATE OR REPLACE PACKAGE pecepeel IS
/******************************************************************************
 NOME:          PECEPEEL   
 DESCRIZIONE:   Eliminazione delle retribuzioni
 ARGOMENTI:   
 RITORNA:     

 ECCEZIONI:   

 ANNOTAZIONI:  

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    20/01/2003 
 1.1 11/04/2007  CB     Aggiunto il controllo sul codice di competenza di RAIN sul C_SEL_RAGI            
******************************************************************************/

  FUNCTION  VERSIONE              RETURN VARCHAR2;

  PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO        IN NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY pecepeel IS
w_prenotazione number(10);
W_PASSO	NUMBER(5);
  errore	 varchar2(6);
  errpasso	 varchar2(30);
    w_utente	        varchar2(10);
  w_ambiente	    varchar2(10);
  w_ente	        varchar2(10);
    
    FUNCTION VERSIONE  RETURN VARCHAR2 IS
    BEGIN
    RETURN 'V1.1 del 11/04/2004';
    END VERSIONE;
    
    -- ANNULLO DATI RETRIBUTIVI INDIVIDUALI
      --
      PROCEDURE ANNULLO_INDIVIDUALE
      ( P_CI          NUMBER
      , P_ANNO        NUMBER
      , P_MESE        NUMBER
      , P_MENSILITA   VARCHAR2
      , P_FIN_ELA     DATE
      -- PARAMETRI PER TRACE
      , P_TRC    IN     NUMBER     -- TIPO DI TRACE
      , P_PRN    IN     NUMBER     -- NUMERO DI PRENOTAZIONE ELABORAZIONE
      , P_PAS    IN     NUMBER     -- NUMERO DI PASSO PROCEDURALE
      , P_PRS    IN OUT NUMBER     -- NUMERO PROGRESSIVO DI SEGNALAZIONE
      , P_STP    IN OUT VARCHAR2       -- STEP ELABORATO
      , P_TIM    IN OUT VARCHAR2       -- TIME IMPIEGATO IN SECONDI
      ) IS
      D_RATE_PAG NUMBER(4);
      D_IMP_PAG  NUMBER(10);
      D_ULT_ANNO      MOVIMENTI_FISCALI.ANNO%TYPE;
      D_ULT_MESE      MOVIMENTI_FISCALI.MESE%TYPE;
      D_ULT_MENSILITA MOVIMENTI_FISCALI.MENSILITA%TYPE;
      BEGIN
         BEGIN  -- ULTIMA ELABORAZIONE
            P_STP := 'ANNULLO_INDIVIDUA-00';
            SELECT MAX(ANNO)
              INTO D_ULT_ANNO
              FROM MOVIMENTI_FISCALI MOFI
             WHERE CI        = P_CI
            ;
            SELECT MAX(MESE)
              INTO D_ULT_MESE
              FROM MOVIMENTI_FISCALI MOFI
             WHERE CI        = P_CI
               AND MOFI.ANNO = D_ULT_ANNO
            ;
            SELECT MAX(MENSILITA)
              INTO D_ULT_MENSILITA
              FROM MOVIMENTI_FISCALI MOFI
             WHERE CI        = P_CI
               AND MOFI.ANNO = D_ULT_ANNO
               AND MOFI.MESE = D_ULT_MESE
            ;
            trace.LOG_TRACE(P_TRC,P_PRN,P_PAS,P_PRS,P_STP,SQL%ROWCOUNT,P_TIM);
         END;
         BEGIN  -- ELIMINAZIONE DEI VALORI FISCALI MENSILI
            P_STP := 'ANNULLO_INDIVIDUA-01';
            DELETE FROM MOVIMENTI_FISCALI
             WHERE CI        = P_CI
               AND ANNO      = P_ANNO
               AND MESE      = P_MESE
               AND MENSILITA = P_MENSILITA
            ;
            trace.LOG_TRACE(P_TRC,P_PRN,P_PAS,P_PRS,P_STP,SQL%ROWCOUNT,P_TIM);
         END;
         BEGIN  -- ELIMINAZIONE DEI PRECEDENTI MOVIMENTI
                -- GENERATI DAL CALCOLO ( INPUT IN 'R', 'C', 'A' )
            P_STP := 'ANNULLO_INDIVIDUA-02';
            DELETE MOVIMENTI_CONTABILI
             WHERE CI        = P_CI
               AND ANNO      = P_ANNO
               AND MESE      = P_MESE
               AND MENSILITA = P_MENSILITA
               AND UPPER(INPUT) IN ( 'R', 'C', 'A')
            ;
            trace.LOG_TRACE(P_TRC,P_PRN,P_PAS,P_PRS,P_STP,SQL%ROWCOUNT,P_TIM);
         END;
         BEGIN  -- ANNULA DATI CALCOLATI SU VARIABILI
            P_STP := 'ANNULLO_INDIVIDUA-03';
            UPDATE MOVIMENTI_CONTABILI
               SET TAR     = NULL
                 , QTA     = NULL
                 , IMP     = NULL
                 , IPN_P   = NULL
                 , IPN_EAP = NULL
             WHERE CI        = P_CI
               AND ANNO      = P_ANNO
               AND MESE      = P_MESE
               AND MENSILITA = P_MENSILITA
            ;
            trace.LOG_TRACE(P_TRC,P_PRN,P_PAS,P_PRS,P_STP,SQL%ROWCOUNT,P_TIM);
         END;
         BEGIN  -- ELIMINAZIONE DEI PERIODI RETRIBUTIVI DEL MESE
                -- SE NON ESISTONO ALTRE MENSILITA` IN MOVIMENTI FISCALI
            P_STP := 'ANNULLO_INDIVIDUA-04';
            DELETE FROM PERIODI_RETRIBUTIVI
             WHERE CI        = P_CI
               AND PERIODO   = P_FIN_ELA
               AND NOT EXISTS
                  (SELECT 'X'
                     FROM MOVIMENTI_FISCALI
                    WHERE CI         = P_CI
                      AND ANNO       = P_ANNO
                      AND MESE       = P_MESE
                      AND MENSILITA NOT LIKE '*%'
                  )
            ;
            trace.LOG_TRACE(P_TRC,P_PRN,P_PAS,P_PRS,P_STP,SQL%ROWCOUNT,P_TIM);
         END;
         BEGIN  -- RICALCOLA DATA FINE DI VOCI A RATE
                -- SOLO SE SI STA ANNULLANDO L'ULTIMA MENSILITA` ELABORATA
            IF P_ANNO      = D_ULT_ANNO      AND
               P_MESE      = D_ULT_MESE      AND
               P_MENSILITA = D_ULT_MENSILITA THEN
            P_STP := 'ANNULLO_INDIVIDUA-05';
            trace.LOG_TRACE(P_TRC,P_PRN,P_PAS,P_PRS,P_STP,SQL%ROWCOUNT,P_TIM);
            FOR CURR IN
               (SELECT VOCE
                     , SUB
                     , RATE_TOT
                     , ROWID
                  FROM INFORMAZIONI_RETRIBUTIVE INRE
                 WHERE CI              = P_CI
                   AND TIPO            = 'R'
                   AND P_FIN_ELA BETWEEN NVL(DAL,TO_DATE(2222222,'J'))
                                     AND NVL(AL ,TO_DATE(3333333,'J'))
               ) LOOP
               BEGIN  -- PRELEVA RATE PAGATE FINO A ULTIMA MENSILITA`
                  SELECT NVL(SUM(P_QTA),0), NVL(SUM(P_IMP),0)
                    INTO D_RATE_PAG, D_IMP_PAG
                    FROM PROGRESSIVI_CONTABILI
                   WHERE VOCE      = CURR.VOCE
                     AND SUB       = CURR.SUB
                     AND CI        = P_CI
                     AND ANNO      = D_ULT_ANNO
                     AND MESE      = D_ULT_MESE
                     AND MENSILITA = D_ULT_MENSILITA
                  ;
               END;
               BEGIN  -- RICALCOLA DATA FINE
                  UPDATE INFORMAZIONI_RETRIBUTIVE
                     SET AL = ADD_MONTHS( P_FIN_ELA
                                        , ABS(CURR.RATE_TOT)
                                        - ABS(D_RATE_PAG)
                                        - 1
                                        )
                   WHERE ROWID = CURR.ROWID
                  ;
               END;
            END LOOP;
            END IF;
         END;
      EXCEPTION
         WHEN OTHERS THEN
            trace.ERR_TRACE( P_TRC, P_PRN, P_PAS, P_PRS, P_STP, 0, P_TIM );
            RAISE ;
      END;
-- ANNULLO PERIODO DI ELABORAZIONE
      --
      -- PROCEDURA DI ANNULLO MOVIMENTI RETRIBUTIVI DEL PERIODO ATTUALE
      --
      PROCEDURE ANNULLO
      IS
      -- DATI PER GESTIONE TRACE
      D_TRC           NUMBER(1);  -- TIPO DI TRACE
      D_PRN           NUMBER(6);  -- NUMERO DI PRENOTAZIONE
      D_PAS           NUMBER(2);  -- NUMERO DI PASSO PROCEDURALE
      D_PRS           NUMBER(10); -- NUMERO PROGRESSIVO DI SEGNALAZIONE
      D_STP           VARCHAR2(30);   -- IDENTIFICAZIONE DELLO STEP IN OGGETTO
      D_CNT           NUMBER(5);  -- COUNT DELLE ROW TRATTATE
      D_TIM           VARCHAR2(5);    -- TIME IMPIEGATO IN SECONDI
      D_TIM_CI        VARCHAR2(5);    -- TIME IMPIEGATO IN SECONDI DEL COD.IND.
      D_TIM_TOT       VARCHAR2(5);    -- TIME IMPIEGATO IN SECONDI TOTALE
      --
      -- DATI PER DEPOSITO INFORMAZIONI GENERALI
      D_ANNO          MOVIMENTI_FISCALI.ANNO%TYPE;
      D_MESE          MOVIMENTI_FISCALI.MESE%TYPE;
      D_MENSILITA     MOVIMENTI_FISCALI.MENSILITA%TYPE;
      D_FIN_ELA       DATE;
      --
      CURSOR C_SEL_RAGI
      ( P_CI_START NUMBER
      ) IS
      SELECT ragi.ROWID
           , ragi.CI
        FROM RAPPORTI_GIURIDICI RAGI,
		     rapporti_individuali rain
       WHERE ragi.CI IN (SELECT CI
                      FROM MOVIMENTI_FISCALI MOFI
                     WHERE MOFI.ANNO      = D_ANNO
                       AND MOFI.MESE      = D_MESE
                       AND MOFI.MENSILITA = D_MENSILITA
                       AND CI             > P_CI_START
                   )
		  and ragi.ci  = rain.ci
		  and (rain.cc is null
		       or exists
			   (select 'x'
			    from   a_competenze
				where  ente       = w_ente
				and    ambiente   = w_ambiente
				and    utente     = w_utente
				and    competenza ='CI'
				and    oggetto    = rain.cc
				)
			)
		   order by ragi.ci
      ;
      CURSOR C_UPD_RAGI
      ( P_ROWID VARCHAR2
      , P_CI NUMBER
      ) IS
      SELECT 'X'
        FROM RAPPORTI_GIURIDICI
       WHERE ROWID     = P_ROWID
         AND CI        = P_CI
         FOR UPDATE OF FLAG_ELAB NOWAIT
      ;
      D_ROW_RAGI            C_UPD_RAGI%ROWTYPE;
      BEGIN
         BEGIN  -- ASSEGNAZIONI INIZIALI PER TRACE
            D_PRN := W_PRENOTAZIONE;
            D_PAS := W_PASSO;
            IF D_PRN = 0 THEN
               D_TRC := 1;
               DELETE FROM A_SEGNALAZIONI_ERRORE
                WHERE NO_PRENOTAZIONE = D_PRN
                  AND PASSO           = D_PAS
               ;
            ELSE
               D_TRC := NULL;
            END IF;
            BEGIN  -- PRELEVA NUMERO MAX DI SEGNALAZIONE
               SELECT NVL(MAX(PROGRESSIVO),0)
                 INTO D_PRS
                 FROM A_SEGNALAZIONI_ERRORE
                WHERE NO_PRENOTAZIONE = D_PRN
                  AND PASSO           = D_PAS
               ;
            END;
         END;
         BEGIN  -- SEGNALAZIONE INIZIALE
            D_STP     := 'PECEPEEL-START';
            D_TIM     := TO_CHAR(SYSDATE,'SSSSS');
            D_TIM_TOT := TO_CHAR(SYSDATE,'SSSSS');
            trace.LOG_TRACE(0,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM);
            COMMIT;
         END;
         BEGIN  -- PERIODO IN ELABORAZIONE
            D_STP := 'ANNULLO-01';
            SELECT RIRE.ANNO, RIRE.MESE, RIRE.MENSILITA
                 , RIRE.FIN_ELA
              INTO D_ANNO, D_MESE, D_MENSILITA
                 , D_FIN_ELA
              FROM RIFERIMENTO_RETRIBUZIONE RIRE
            ;
            trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
         END;
         <<CICLO_CI>>
         DECLARE
         D_DEP_CI   NUMBER;  -- CODICE INDIVIDUALE PER RIPRISTINO LOOP
         D_CI_START NUMBER;  -- CODICE INDIVIDUALE PARTENZA LOOP
         D_COUNT_CI NUMBER;  -- CONTATORE CICLICO INDIVIDUI TRATTATI
         --
         BEGIN  -- CICLO SU INDIVIDUI
            D_DEP_CI   := 0;  -- INIZIALIZZAZIONE CODICE INDIVIDUALE RIPRISTINO
            D_CI_START := 0;  -- ATTIVAZIONE INIZIALE PARTENZA CICLO INDIVIDUI
            D_COUNT_CI := 0;  -- AZZERAMENTO INIZIALE CONTATORE INDIVIDUI
            LOOP  -- RIPRISTINO CICLO SU INDIVIDUI:
                  -- - IN CASO DI LOOP CICLICO PER RILASCIO ROLLBACK_SEGMENTS
            FOR RAGI IN C_SEL_RAGI (D_CI_START)
            LOOP
            <<TRATTA_CI>>
            BEGIN
               D_COUNT_CI := D_COUNT_CI + 1;
               D_TIM_CI := TO_CHAR(SYSDATE,'SSSSS');
               BEGIN  -- ALLOCAZIONE INDIVIDUO
                  D_STP    := 'ANNULLO-03';
                  OPEN C_UPD_RAGI (RAGI.ROWID,RAGI.CI);
                  FETCH C_UPD_RAGI INTO D_ROW_RAGI;
                  IF C_UPD_RAGI%NOTFOUND THEN
                     RAISE TIMEOUT_ON_RESOURCE;
                  END IF;
               EXCEPTION
                  WHEN OTHERS THEN
                     RAISE TIMEOUT_ON_RESOURCE;
               END;
               BEGIN  -- ELABORAZIONE INDIVIDUO
                  ANNULLO_INDIVIDUALE  -- ANNULLO DATI RETRIBUTIVI INDIVIDUALI
                     ( RAGI.CI
                              , D_ANNO, D_MESE, D_MENSILITA, D_FIN_ELA
                              , D_TRC, D_PRN, D_PAS, D_PRS, D_STP, D_TIM
                     );
               END;
               BEGIN  -- RILASCIO INDIVIDUO ANNULLATO
                  D_STP := 'ANNULLO-04';
                  UPDATE RAPPORTI_GIURIDICI
                     SET FLAG_ELAB = NULL
                       , CONG_IND  = 0
                   WHERE CURRENT OF C_UPD_RAGI
                  ;
                  trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
                  CLOSE C_UPD_RAGI;
               END;
               BEGIN  -- TRACE PER FINE INDIVIDUO
                  D_STP := 'COMPLETE #'||TO_CHAR(RAGI.CI);
                  trace.LOG_TRACE(2,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM_CI);
               END;
               BEGIN  -- VALIDAZIONE INDIVIDUO ELABORATO
                  COMMIT;
               END;
            EXCEPTION
               WHEN TIMEOUT_ON_RESOURCE THEN
                  D_STP := '!!! REJECT #'||TO_CHAR(RAGI.CI);
                  trace.LOG_TRACE(8,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM_CI);
                  errore := 'P05808';   -- SEGNALAZIONE IN ELABORAZIONE
                  COMMIT;
            END TRATTA_CI;
            D_TRC := NULL;  -- DISATTIVA TRACE DETTAGLIATA DOPO PRIMO INDIVIDUO
            BEGIN  -- USCITA DAL CICLO OGNI 10 INDIVIDUI
                   -- PER RILASCIO ROLLBACK_SEGMENTS DI READ_CONSISTENCY
                   -- CURSOR DI SELECT SU RAPPORTI_GIURIDICI
               IF D_COUNT_CI = 10 THEN
                  D_COUNT_CI := 0;
                  D_DEP_CI   := RAGI.CI;  -- ATTIVAZIONE RIPRISTINO LOOP
                  EXIT;                   -- USCITA DAL LOOP
               END IF;
            END;
            END LOOP;  -- FINE LOOP SU CICLO INDIVIDUI
            IF D_DEP_CI = 0 THEN
               EXIT;
            ELSE
               D_CI_START := D_DEP_CI;
               D_DEP_CI   := 0;
            END IF;
            END LOOP;  -- FINE LOOP SU RIPRISTINO CICLO INDIVIDUI
            BEGIN  -- OPERAZIONI FINALI PER TRACE
               D_STP := 'PECEPEEL-STOP';
               trace.LOG_TRACE(2,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM_TOT);
               IF errore != 'P05808' THEN  -- SEGNALAZIONE
                  errore := 'P05802';      -- ELABORAZIONE COMPLETATA
               END IF;
               COMMIT;
            END;
         END CICLO_CI;
      EXCEPTION
         WHEN OTHERS THEN
            trace.ERR_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM);
            errore := 'P05809';   -- ERRORE IN ELABORAZIONE
            errpasso := D_STP;      -- STEP ERRATO
      END;
  PROCEDURE MAIN		(PRENOTAZIONE IN NUMBER,
		  			 PASSO        IN NUMBER) is
  begin
     IF prenotazione != 0 THEN
      BEGIN  --Preleva utente da depositare in campi Global
         select utente
              , ambiente
              , ente
           into w_utente
              , w_ambiente
              , w_ente
           from a_prenotazioni
          where no_prenotazione = prenotazione
         ;
      EXCEPTION
         WHEN OTHERS THEN null;
      END;
   END IF;
		w_PRENOTAZIONE := PRENOTAZIONE;
		W_PASSO	   := PASSO;
            ERRORE         := to_char(null);
               -- MEMORIZZATO IN CASO DI AZZERAMENTO PER ROLLBACK
               -- VIENE RIAZZERATO IN FORM CHIAMANTE PER EVITARE TRASACTION COMPLETED
               ANNULLO;  -- ESECUZIONE DELL'ANNULLO PERIODO

               IF w_PRENOTAZIONE != 0 THEN
                  IF errore = 'P05808' THEN
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

