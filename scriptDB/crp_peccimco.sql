CREATE OR REPLACE package PECCIMCO is
/******************************************************************************
 NOME:          PECCIMCO
 DESCRIZIONE:   CARICAMENTO IMPUTAZIONE CONTABILE
 ARGOMENTI:
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000
 1.2  23/12/2002 MS     Aggiunti Parametri di Selezione (rif. difetto 1213)
 1.3  22/12/2003 MS     Modifica per Nuova Integrazione con CF4: primo rilascio
 1.4  28/04/2004 MS     Modifica per Nuova Integrazione con CF4: secondo rilascio
 1.5  09/09/2004 MS     Modifica per attivita 7278
 1.6  09/09/2004 MS     Modifica per attivita 7422
 1.7  13/10/2004 MS     Modifica per attivita 7725
 1.8  18/05/2005 MS     Modifica per attivita 11211
 2    28/06/2005 CB     Gestione codice_siope
 2.1  02/11/2005 MS     Aggiunta utente e data aggiornamento
 2.2  03/03/2006 MS     Mod.gestione causale con nuovo parametro (att.15170/15172)
 2.3  22/03/2006 MS     Esclusione capitoli a 0 con nuovo parametro ( Att. 15414 )
 2.4  19/05/2006 MS     Nuovo parametro divisione ( Att. 16041 )
 2.5  24/07/2006 MS     Sistemazione Errore Unique Constraint su segnalazioni ( A17081 )
 2.6  12/03/2007 MS     Nuovo valore del parametro Descrizione Causale ( A20096 )
******************************************************************************/
FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN (PRENOTAZIONE IN NUMBER, PASSO        IN NUMBER);
end;
/
CREATE OR REPLACE package body PECCIMCO is
w_prenotazione	number(10);
W_PASSO     NUMBER(5);
P_ERRORE    VARCHAR2(6);
V_stringa   VARCHAR2(200);
err_passo   varchar2(30);
 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V2.6 del 12/03/2007';
 END VERSIONE;
procedure CIMCO_TRACE (P_TRC IN NUMBER,
		  	     P_PRN IN NUMBER,
			     P_PAS IN NUMBER,
			     P_PRS IN OUT NUMBER,
			     P_STP IN varchar2,
			     P_CNT IN NUMBER) is
BEGIN
 IF P_TRC IS NOT NULL THEN
   IF P_TRC = 0 THEN  -- SEGNALAZIONE DI START
-- dbms_output.put_line('start: '||P_PRS);
      INSERT INTO A_SEGNALAZIONI_ERRORE
      ( NO_PRENOTAZIONE, PASSO, PROGRESSIVO, ERRORE, PRECISAZIONE )
      SELECT P_PRN,P_PAS,P_PRS,'P05800',
             RPAD(SUBSTR(P_STP,1,50),50)
        FROM DUAL
      WHERE NOT EXISTS (SELECT 'X' FROM A_SEGNALAZIONI_ERRORE
                          WHERE NO_PRENOTAZIONE = P_PRN
                            AND PASSO  = P_PAS
                            AND ERRORE = 'P05800'
                            AND PRECISAZIONE = RPAD(SUBSTR(P_STP,1,50),50)
                        );
-- dbms_output.put_line('inserimento 0' || sql%ROWCOUNT);
   ELSIF
      P_TRC = 1 THEN  -- TRACE DI SINGOLO STEP
      P_PRS := nvl(P_PRS,0)+1;
-- dbms_output.put_line('inserimento 1 ');
      INSERT INTO A_SEGNALAZIONI_ERRORE
      ( NO_PRENOTAZIONE, PASSO, PROGRESSIVO, ERRORE, PRECISAZIONE )
      SELECT P_PRN,P_PAS,P_PRS,'P05801',
             RPAD(SUBSTR(P_STP,1,50),50)
        FROM DUAL
      WHERE NOT EXISTS (SELECT 'X' FROM A_SEGNALAZIONI_ERRORE
                          WHERE NO_PRENOTAZIONE = P_PRN
                            AND PASSO  = P_PAS
                            AND ERRORE = 'P05801'
                            AND PRECISAZIONE = RPAD(SUBSTR(P_STP,1,50),50)
                        );
-- dbms_output.put_line('inserimento 1 effettuato');
   ELSIF
      P_TRC = 2 THEN  -- SEGNALAZIONE DI STOP
      select max(progressivo)
        into P_PRS
        from A_SEGNALAZIONI_ERRORE
       WHERE NO_PRENOTAZIONE = P_PRN;
-- dbms_output.put_line('stop');
      INSERT INTO A_SEGNALAZIONI_ERRORE
      ( NO_PRENOTAZIONE, PASSO, PROGRESSIVO, ERRORE, PRECISAZIONE )
      SELECT P_PRN,P_PAS,nvl(P_PRS, 1000000)+1,'P05802',
             RPAD(SUBSTR(P_STP,1,50),50)
        FROM DUAL
      WHERE NOT EXISTS (SELECT 'X' FROM A_SEGNALAZIONI_ERRORE
                          WHERE NO_PRENOTAZIONE = P_PRN
                            AND PASSO  = P_PAS
                            AND ERRORE = 'P05802'
                            AND PRECISAZIONE = RPAD(SUBSTR(P_STP,1,50),50)
                        );
   ELSIF
      P_TRC = 8 THEN  -- PER WARNING
-- dbms_output.put_line('inserimento 2 : '||P_ERRORE);
-- dbms_output.put_line('prog / errore4: '||nvl(P_PRS,1)||' '||nvl(P_CNT,0));
      INSERT INTO A_SEGNALAZIONI_ERRORE
      ( NO_PRENOTAZIONE, PASSO, PROGRESSIVO, ERRORE, PRECISAZIONE )
      SELECT P_PRN,P_PAS,nvl(P_PRS,1)+nvl(P_CNT,0),P_ERRORE,
             RPAD(SUBSTR(P_STP,1,50),50)
        FROM DUAL
      WHERE NOT EXISTS (SELECT 'X' FROM A_SEGNALAZIONI_ERRORE
                          WHERE NO_PRENOTAZIONE = P_PRN
                            AND PASSO  = P_PAS
                            AND ERRORE = P_ERRORE
                            AND PRECISAZIONE = RPAD(SUBSTR(P_STP,1,50),50)
                        );
-- dbms_output.put_line('inserimento 2 effettuato ');
-- dbms_output.put_line('inserimento 8' || sql%ROWCOUNT);
   END IF;
 END IF;
END;

PROCEDURE CARICA	is
-- DATI PER GESTIONE TRACE
D_TRC           NUMBER(2);  -- TIPO DI TRACE
D_PRN           NUMBER(6);  -- NUMERO DI PRENOTAZIONE
D_PAS           NUMBER(2);  -- NUMERO DI PASSO PROCEDURALE
D_PRS           NUMBER(10); -- NUMERO PROGRESSIVO DI SEGNALAZIONE
D_STP           varchar2(200);   -- IDENTIFICAZIONE DELLO STEP IN OGGETTO
D_CNT           NUMBER(5);       -- CONTATORE PER ORDINAMENTO SEGNALAZIONI
D_TIM           varchar2(5);    -- TIME IMPIEGATO IN SECONDI
D_ERRORE1       NUMBER(10) := 0;       -- CONTATORE PER ERRORE P05996
D_ERRORE2       NUMBER(10) := 0;       -- CONTATORE PER ERRORE P05995
D_ERRORE3       NUMBER(10) := 0;       -- CONTATORE PER ERRORE P05808
D_ERRORE4       NUMBER(10) := 0;       -- CONTATORE PER ERRORE P05994
D_ERRORE5       NUMBER(10) := 0;       -- CONTATORE PER ERRORE P05987
D_ERRORE6       NUMBER(10) := 0;       -- CONTATORE PER ERRORE P05999
D_ERRORE7       NUMBER(10) := 0;       -- CONTATORE PER ERRORE P06714
D_ERRORE8       NUMBER(10) := 0;       -- CONTATORE PER ERRORE P05763
D_ERRORE9       NUMBER(10) := 0;       -- CONTATORE PER ERRORE P06716
D_ERRORE10      NUMBER(10) := 0;       -- CONTATORE PER ERRORE P01130

--
-- DATI PER DEPOSITO INFORMAZIONI GENERALI
D_ANNO          MOVIMENTI_FISCALI.ANNO%TYPE;
D_MESE          MOVIMENTI_FISCALI.MESE%TYPE;
D_MENSILITA     MOVIMENTI_FISCALI.MENSILITA%TYPE;
D_CODICE_MENS   MENSILITA.CODICE%TYPE;

P_UTENTE        VARCHAR2(8) := '';
D_FIN_ELA       DATE;
D_SEZIONE       VARCHAR2(4);
D_DIVISIONE     VARCHAR2(4);
D_FUNZIONALE    VARCHAR2(1);
D_ALIMENTA      VARCHAR2(1);
P_ESCLUDI       VARCHAR2(1);
D_CAUSALE       VARCHAR2(1);
D_DATA          DATE;
D_IMPORTO       NUMBER;
D_STRINGA       VARCHAR2(200);
--
D_SECOLO        NUMBER(2);
D_GESTIONE      NUMBER(4);
D_IMPEGNO       IMPUTAZIONI_CONTABILI.IMPEGNO%TYPE;
D_ANNO_IMPEGNO  IMPUTAZIONI_CONTABILI.ANNO_IMPEGNO%TYPE;
D_SUB           IMPUTAZIONI_CONTABILI.SUB%TYPE;
D_ANNO_SUB      IMPUTAZIONI_CONTABILI.ANNO_SUB%TYPE;
D_SOGGETTO      IMPUTAZIONI_CONTABILI.SOGGETTO%TYPE;
D_NUM_QUIETANZA IMPUTAZIONI_CONTABILI.NUM_QUIETANZA%TYPE;
V_IMPEGNO       IMPUTAZIONI_CONTABILI.IMPEGNO%TYPE;
V_ANNO_IMPEGNO  IMPUTAZIONI_CONTABILI.ANNO_IMPEGNO%TYPE;
V_SUB           IMPUTAZIONI_CONTABILI.SUB%TYPE;
V_ANNO_SUB      IMPUTAZIONI_CONTABILI.ANNO_SUB%TYPE;

BEGIN
   BEGIN  -- ASSEGNAZIONI INIZIALI PER TRACE
      D_PRN := W_prenOTAZIONE;
      D_PAS := W_passo;
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
-- dbms_output.put_line('Prog Monica: '||D_PRS);
      END;
   END;
   BEGIN  -- SEGNALAZIONE INIZIALE
      D_STP     := 'PECCIMCO-START';
      D_TIM     := TO_CHAR(SYSDATE,'SSSSS');
      CIMCO_TRACE(0,D_PRN,D_PAS,D_PRS,D_STP,0);
      commit;
   END;
   BEGIN  -- ACQUISIZIONE PARAMETRI DI ELABORAZIONE
      D_STP := 'CARICA-01';
     BEGIN
      SELECT VALORE
        INTO D_FUNZIONALE
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_FUNZIONALE';
     EXCEPTION WHEN NO_DATA_FOUND THEN D_FUNZIONALE := null;
     END;
-- dbms_output.put_line('Funzionale');
     BEGIN
      SELECT VALORE
        INTO D_ALIMENTA
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_ALIMENTA';
     EXCEPTION WHEN NO_DATA_FOUND THEN D_ALIMENTA := null;
     END;
-- dbms_output.put_line('Alimenta');
     BEGIN
      SELECT VALORE
        INTO P_ESCLUDI
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_ESCLUDI';
     EXCEPTION WHEN NO_DATA_FOUND THEN P_ESCLUDI := null;
     END;
     BEGIN
      SELECT VALORE
        INTO D_CAUSALE
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_CAUSALE';
     EXCEPTION WHEN NO_DATA_FOUND THEN D_CAUSALE := null;
     END;
-- dbms_output.put_line('Causale');
     BEGIN
      SELECT VALORE
        INTO D_SEZIONE
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_SEZIONE';
     EXCEPTION WHEN NO_DATA_FOUND THEN D_SEZIONE := '%';
     END;
-- dbms_output.put_line('Sezione');
     BEGIN
      SELECT VALORE
        INTO D_DIVISIONE
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_DIVISIONE';
     EXCEPTION WHEN NO_DATA_FOUND THEN D_DIVISIONE := '%';
     END;
-- dbms_output.put_line('Divisione');
     BEGIN
      SELECT VALORE
        INTO D_ANNO
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_ANNO';
     EXCEPTION WHEN NO_DATA_FOUND THEN
	 select ANNO
	   into D_ANNO
	   from riferimento_retribuzione;
     END;
-- dbms_output.put_line('Anno:'||D_anno);
-- dbms_output.put_line('Pren: '||D_prn);
     BEGIN
      SELECT SUBSTR(VALORE,1,4)
        INTO D_CODICE_MENS
        FROM A_PARAMETRI
       WHERE NO_PRENOTAZIONE = D_PRN
         AND PARAMETRO       = 'P_MENSILITA';
     EXCEPTION WHEN NO_DATA_FOUND THEN
  	 select MENSILITA
	   into D_MENSILITA
	   from riferimento_retribuzione;
     END;
-- dbms_output.put_line('mens: '||D_mensilita);
     BEGIN
     select MENS.MESE, MENS.MENSILITA
       into D_mese
          , D_mensilita
       from riferimento_retribuzione rire
          , mensilita                mens
      where rire.rire_id    = 'RIRE'
        and (   mens.codice  = D_CODICE_MENS
         or     mens.mensilita = rire.mensilita
           and  mens.mese      = rire.mese
           and D_CODICE_MENS is null
           )
    ;
-- dbms_output.put_line('mese: '||D_mese);
     EXCEPTION WHEN NO_DATA_FOUND THEN null;
     END;
   BEGIN  -- DATA DI LIQUIDAZIONE
      D_STP := 'CARICA-02';
      SELECT TO_DATE( TO_CHAR(MENS.GIORNO)||'/'||
                      TO_CHAR(MENS.MESE_LIQ)||'/'||
                      TO_CHAR( D_ANNO
                             + GREATEST( 0, SIGN( MENS.MESE
                                                - MENS.MESE_LIQ
                                                )
                                       )
                             )
                    , 'DD/MM/YYYY'
                    )
        INTO D_DATA
        FROM MENSILITA MENS
       WHERE MENS.MESE = D_MESE
         AND MENS.MENSILITA = D_mensilita
      ;
    EXCEPTION WHEN OTHERS THEN
-- dbms_output.put_line('Non trovata la mensilita');
	D_STP := 'Aquisizione data di Liquidazione';
        p_errore := 'P6110';
        D_PRS := nvl(D_PRS,0) + 1 ;
      CIMCO_TRACE(8,D_PRN,D_PAS,D_PRS,D_STP,1);
	raise;
    END;
-- dbms_output.put_line('Data: '||D_DATA||' Prog: '||D_PRS);
   END;
/* Estrazione utente di elaborazione */

   BEGIN
      select utente
        into P_utente
        from a_prenotazioni
       where no_prenotazione = D_PRN
      ;
   EXCEPTION WHEN NO_DATA_FOUND THEN P_utente := 'CIMCO';
   END;

   BEGIN  -- ANNULLA PRECEDENTE IMPUTAZIONE CON STESSA IMPUTAZIONE
      D_STP := 'CARICA-03';
      DELETE FROM IMPUTAZIONI_CONTABILI
       WHERE DATA = D_DATA
  	 AND SEZIONE LIKE D_SEZIONE
  	 AND DIVISIONE LIKE D_DIVISIONE
      ;
-- dbms_output.put_line('Cancellato');
   END;
   <<CICLO_BIL>>
   BEGIN  -- CICLO SU MOVIMENTI DI BILANCIO
      D_STP := 'CARICA-04';
      FOR CURB IN
         (SELECT MOBI.DIVISIONE             DIVISIONE
		   , MOBI.SEZIONE               SEZIONE
               , COBI.TIPO                  TIPO
               , MOBI.RISORSA_INTERVENTO    RISORSA_INTERVENTO
               , MOBI.CAPITOLO              CAPITOLO
               , MOBI.ARTICOLO              ARTICOLO
               , MOBI.IMPEGNO               IMPEGNO
               , MOBI.ANNO_IMPEGNO          ANNO_IMPEGNO
               , MOBI.SUB_IMPEGNO           SUB_IMPEGNO
               , MOBI.ANNO_SUB_IMPEGNO      ANNO_SUB_IMPEGNO
               , MOBI.CONTO      CONTO
               , decode(D_FUNZIONALE
			     ,'X',MOBI.FUNZIONALE
				   ,null) FUNZIONALE
               , MOBI.SEDE_DEL   SEDE_DEL
               , MOBI.ANNO_DEL   ANNO_DEL
               , MOBI.NUMERO_DEL NUMERO_DEL
               , NVL(MOBI.ISTITUTO, 'DD') ISTITUTO
               , NVL(SUM( MOBI.IMPORTO
                    * DECODE(COBI.TIPO,'E',-1,1)
                    ),0) IMPORTO
               , MAX(COBI.COSTO) COSTO
               , SUBSTR( MAX( decode ( D_causale
                                     , 'R', COBI.DESCRIZIONE||' '||RUOL.DESCRIZIONE
                                     , 'N', COBI.DESCRIZIONE||' '||COBI.NOTE
                                     , 'C', COBI.CODICE||' '||COBI.NOTE
                                          , COBI.DESCRIZIONE
                                     )
                             )
                       , 1, 60
                       ) CAUSALE
               , MOBI.CODICE_SIOPE
             FROM MOVIMENTI_BILANCIO MOBI
                , RUOLI              RUOL
                , CODICI_BILANCIO    COBI
           WHERE MOBI.ANNO      = D_ANNO
             AND MOBI.MESE      = D_MESE
             AND MOBI.MENSILITA = D_MENSILITA
             AND RUOL.CODICE    = MOBI.RUOLO
             AND COBI.CODICE    = MOBI.BILANCIO
             and ( nvl(P_ESCLUDI,' ') != 'X' 
                or P_ESCLUDI = 'X' 
               and nvl(MOBI.RISORSA_INTERVENTO,0) != '0'
               and nvl(MOBI.CAPITOLO,0) != '0'
               and nvl(MOBI.ARTICOLO,0) != '0'
                 )
             AND nvl(MOBI.SEZIONE,'%')  LIKE '%' ||D_SEZIONE||'%'
             AND nvl(MOBI.DIVISIONE,'%')  LIKE '%' ||D_DIVISIONE||'%'
          GROUP BY MOBI.DIVISIONE
		     , MOBI.SEZIONE
                 , COBI.TIPO
                 , MOBI.RISORSA_INTERVENTO, MOBI.CAPITOLO, MOBI.ARTICOLO
                 , MOBI.IMPEGNO, MOBI.ANNO_IMPEGNO, MOBI.SUB_IMPEGNO, MOBI.ANNO_SUB_IMPEGNO
                 , MOBI.CONTO
                 , decode(D_FUNZIONALE
			     ,'X',MOBI.FUNZIONALE
				   ,null)
                 , MOBI.SEDE_DEL, MOBI.ANNO_DEL, MOBI.NUMERO_DEL
                 , MOBI.ISTITUTO
                 , MOBI.RUOLO
                 , MOBI.BILANCIO
                 , MOBI.CODICE_SIOPE
         ) LOOP
-- dbms_output.put_line(D_ANNO||' '||D_MESE||' '||D_MENSILITA||'Div: '||CURB.DIVISIONE||' Sez: '||CURB.SEZIONE);
         <<TRATTA_BIL>>
         BEGIN
            BEGIN  -- DETERMINA GESTIONE DI BILANCIO
               D_STP := 'CARICA-05';
               IF CURB.CONTO IS NULL THEN
                  D_GESTIONE := D_ANNO;
               ELSE
                  IF TO_NUMBER(SUBSTR(TO_CHAR(D_ANNO),3,2))
                     <
                     TO_NUMBER(CURB.CONTO) THEN
                     D_SECOLO := TO_NUMBER(SUBSTR(TO_CHAR(D_ANNO),1,2))
                               + 1;
                  ELSE
                     D_SECOLO := TO_NUMBER(SUBSTR(TO_CHAR(D_ANNO),1,2));
                  END IF;
                  D_GESTIONE := TO_NUMBER
                                  ( TO_CHAR(D_SECOLO)||
                                    LPAD( TO_CHAR(TO_NUMBER(CURB.CONTO))
                                        , 2, '0'
                                       )
                                  );
               END IF;
            EXCEPTION
               WHEN OTHERS THEN  -- CONTO NON NUMERICO
               IF CURB.CONTO = 'C' THEN
                    D_GESTIONE := D_ANNO;
               ELSE
                    D_GESTIONE := D_ANNO - 1;
               END IF;
            END;
-- dbms_output.put_line('GEST: '||D_GESTIONE);
            BEGIN  -- DETERMINAZIONE SOGGETTO FISCALE
               D_STP := 'CARICA-06';
               SELECT NVL(ISCR.SOGGETTO,0)
                    , NUM_QUIETANZA
                 INTO D_SOGGETTO
                    , D_NUM_QUIETANZA
                 FROM ISTITUTI_CREDITO ISCR
                WHERE ISCR.CODICE = CURB.ISTITUTO
               ;
            EXCEPTION
               WHEN OTHERS THEN
                    D_SOGGETTO := 0;
                    D_NUM_QUIETANZA := null;
            END;
-- dbms_output.put_line('SOGG: '||D_SOGGETTO);
     IF D_ALIMENTA = 'X' THEN
       BEGIN
       <<ALIMENTAZIONE>>
       D_IMPEGNO := NULL;
       D_ANNO_IMPEGNO := NULL;
       D_SUB := NULL;
       D_ANNO_SUB := NULL;
            IF CURB.IMPEGNO is NULL AND CURB.ANNO_IMPEGNO is null
             THEN  -- DETERMINAZIONE IMPEGNO DI SPESA / ACCERTAMENTO DI ENTRATA
              BEGIN
              <<CARICA_07>>
                 D_STP := 'CARICA-07';
                 SELECT NUMERO_IMP_ACC,  ANNO_IMP_ACC
                   INTO D_IMPEGNO, D_ANNO_IMPEGNO
                   FROM ACC_IMP_CONTABILITA     BILA
                  WHERE NVL(BILA.DIVISIONE,'%') = NVL(CURB.DIVISIONE,'%')
                    AND BILA.ESERCIZIO          = D_ANNO
                    AND BILA.RISORSA_INTERVENTO = CURB.RISORSA_INTERVENTO
                    AND BILA.CAPITOLO           = CURB.CAPITOLO
                    AND BILA.ARTICOLO           = CURB.ARTICOLO
                    AND BILA.ANNO_IMP_ACC       = D_GESTIONE
		            AND BILA.E_S		      = CURB.TIPO
                    AND NVL(BILA.SEDE_DEL,NVL(CURB.SEDE_DEL,' '))  = NVL(CURB.SEDE_DEL,' ')
                    AND NVL(BILA.ANNO_DEL,NVL(CURB.ANNO_DEL,0))    = NVL(CURB.ANNO_DEL,0)
                    AND NVL(BILA.NUMERO_DEL,NVL(CURB.NUMERO_DEL,0))  = NVL(CURB.NUMERO_DEL,0)
                    AND NVL(BILA.SOGGETTO,D_SOGGETTO)               = D_SOGGETTO
                   -- AND NVL(BILA.CODICE_SIOPE,0) = NVL(CURB.CODICE_SIOPE,0)    
                         -- da scommentare non appena il CF4 aggiunge il codice_siope nella sua tabella --
                 ;
              EXCEPTION -- SE NE TROVA PIU` DI UNO O NESSUNO
               WHEN NO_DATA_FOUND THEN
                    D_IMPEGNO       := NULL;
                    D_ANNO_IMPEGNO  := NULL;
                    D_CNT     := 1000;
                    p_errore  := 'P05996';
                    D_STP := ' Per Imputazione : '||CURB.RISORSA_INTERVENTO||'.'||CURB.CAPITOLO||'/'||CURB.ARTICOLO;
-- dbms_output.put_line('Prog: '||D_PRS);
                    D_ERRORE1 := D_ERRORE1 + 1;
                    CIMCO_TRACE(8,D_PRN,D_PAS,D_ERRORE1,D_STP,D_CNT);
-- dbms_output.put_line('Errore1');
	         WHEN TOO_MANY_ROWS THEN
                   D_IMPEGNO  := NULL;
                   D_ANNO_IMPEGNO  := NULL;
                   D_CNT      := 3000;
                   p_errore   := 'P05995';
                   D_STP := ' Per Imputazione : '||CURB.RISORSA_INTERVENTO||'.'||CURB.CAPITOLO||'/'||CURB.ARTICOLO;
-- dbms_output.put_line('Prog: '||D_PRS);
                    D_ERRORE2 := D_ERRORE2 + 1;
                   CIMCO_TRACE(8,D_PRN,D_PAS,D_ERRORE2,D_STP,D_CNT);
-- dbms_output.put_line('Errore2');
   	         WHEN OTHERS THEN
                    D_IMPEGNO    := NULL;
                    D_ANNO_IMPEGNO  := NULL;
                    D_CNT        := 5000;
                    p_errore := 'P05808';
                    D_STP := 'INPUT ??? #'||CURB.RISORSA_INTERVENTO||'.'||CURB.CAPITOLO||'/'||CURB.ARTICOLO;
-- dbms_output.put_line('Prog: '||D_PRS);
                    D_ERRORE3 := D_ERRORE3 + 1;
                   CIMCO_TRACE(8,D_PRN,D_PAS,D_ERRORE3,D_STP,D_CNT);
-- dbms_output.put_line('Errore3');
              END CARICA_07;
		  IF D_IMPEGNO IS NOT NULL
                 THEN
		     p_errore := 'P05994';
		     D_CNT    := 7000;
		     D_STP := ' Per Imputazione : '||CURB.RISORSA_INTERVENTO||'.'||CURB.CAPITOLO||'/'||CURB.ARTICOLO||' - Imp / Acc:'||D_IMPEGNO;
-- dbms_output.put_line('Prog: '||D_PRS);
-- dbms_output.put_line('Errore 4 prima: '||D_errore4);
                     D_ERRORE4 := D_ERRORE4 + 1;
-- dbms_output.put_line('Errore 4 dopo: '||D_errore4);
                   CIMCO_TRACE(8,D_PRN,D_PAS,D_ERRORE4,D_STP,D_CNT);
-- dbms_output.put_line('Segnala');
              END IF; -- d_impegno
            ELSE -- impegno gia presente su MOBI
                BEGIN
                select NUMERO_IMP_ACC,  ANNO_IMP_ACC
                  into V_IMPEGNO, V_ANNO_IMPEGNO
                  from ACC_IMP_CONTABILITA     BILA
                 WHERE NVL(BILA.DIVISIONE,'%') = NVL(CURB.DIVISIONE,'%')
                   AND BILA.ESERCIZIO          = D_ANNO
                   AND BILA.RISORSA_INTERVENTO = CURB.RISORSA_INTERVENTO
                   AND BILA.CAPITOLO           = CURB.CAPITOLO
                   AND BILA.ARTICOLO           = CURB.ARTICOLO
                   AND BILA.ANNO_IMP_ACC       = D_GESTIONE
                   AND BILA.E_S		     = CURB.TIPO
                   AND NVL(BILA.SEDE_DEL,NVL(CURB.SEDE_DEL,' '))  = NVL(CURB.SEDE_DEL,' ')
                   AND NVL(BILA.ANNO_DEL,NVL(CURB.ANNO_DEL,0))    = NVL(CURB.ANNO_DEL,0)
                   AND NVL(BILA.NUMERO_DEL,NVL(CURB.NUMERO_DEL,0))  = NVL(CURB.NUMERO_DEL,0)
                   AND NVL(BILA.SOGGETTO,D_SOGGETTO)              = D_SOGGETTO;
                   --AND NVL(BILA.CODICE_SIOPE,0)= NVL(CURB.CODICE_SIOPE,0);
                   -- da scommentare non appena il CF4 aggiunge il codice_siope nella sua tabella --
                EXCEPTION
                   WHEN NO_DATA_FOUND THEN
                        V_IMPEGNO      := NULL;
                        V_ANNO_IMPEGNO := NULL;
                   WHEN TOO_MANY_ROWS THEN
                        V_IMPEGNO      := NULL;
                        V_ANNO_IMPEGNO := NULL;
                END;
-- dbms_output.put_line('Impegno ADS: '||nvl(CURB.IMPEGNO,0)||' Impegno CF4: '||nvl(V_IMPEGNO,0));
                IF  nvl(V_IMPEGNO,0) != nvl(CURB.IMPEGNO,0) AND
                    nvl(V_ANNO_IMPEGNO,0) != nvl(CURB.ANNO_IMPEGNO,0)
 			  THEN
			  p_errore := 'P05987';
			  D_CNT    := 9000;
		        D_STP := ' Per Imputazione : '||CURB.RISORSA_INTERVENTO||'.'||CURB.CAPITOLO||'/'||CURB.ARTICOLO||' - Imp / Acc:'||CURB.IMPEGNO;
                    D_ERRORE5 := D_ERRORE5 + 1;
                    CIMCO_TRACE(8,D_PRN,D_PAS,D_ERRORE5,D_STP,D_CNT);
               END IF; -- controllo
            END IF; -- curb_impegno
-- Controllo sul Sub-Impegno
            IF CURB.TIPO = 'S' AND CURB.SUB_IMPEGNO is NULL AND CURB.ANNO_SUB_IMPEGNO is null
             THEN -- DETERMINAZIONE SUB/IMPEGNO DI SPESA
              BEGIN  -- DETERMINAZIONE SUB IMPEGNO
              <<CARICA_08>>
                 D_STP := 'CARICA-08';
                 SELECT NUMERO_SUBIMP,  ANNO_SUBIMP
                   INTO D_SUB, D_ANNO_SUB
                   FROM SUBIMP_CONTABILITA     SUB
                  WHERE NVL(SUB.DIVISIONE,'%') = NVL(CURB.DIVISIONE,'%')
                    AND SUB.ESERCIZIO          = D_ANNO
                    AND SUB.RISORSA_INTERVENTO = CURB.RISORSA_INTERVENTO
                    AND SUB.CAPITOLO           = CURB.CAPITOLO
                    AND SUB.ARTICOLO           = CURB.ARTICOLO
                    AND SUB.NUMERO_IMP         = CURB.IMPEGNO
                    AND SUB.ANNO_IMP           = CURB.ANNO_IMPEGNO
                    AND SUB.ANNO_SUBIMP        = D_GESTIONE
                  --  AND SUB.CODICE_SIOPE       = CURB.CODICE_SIOPE
                  -- da scommentare non appena il CF4 aggiunge il codice_siope nella sua tabella --
	            AND SUB.E_S		           = 'S'
                    AND SUB.SEDE_DEL           = CURB.SEDE_DEL
                    AND SUB.ANNO_DEL           = CURB.ANNO_DEL
                    AND SUB.NUMERO_DEL         = CURB.NUMERO_DEL
                    AND SUB.SOGGETTO           = D_SOGGETTO
                 ;
               EXCEPTION
                    WHEN NO_DATA_FOUND THEN NULL;
                    WHEN TOO_MANY_ROWS THEN NULL;
             END CARICA_08;
           END IF; -- sub_impegno
     END ALIMENTAZIONE;
   END IF; -- d_alimenta
   V_stringa := null;
       BEGIN -- controllo su quietanza
         select substr(qtn.soggetto||'/'||qtn.num_quietanza||'-'||descrizione,1,200)
           into V_stringa
           from quietanze_contabilita qtn
          where soggetto = D_SOGGETTO
            and NUM_QUIETANZA = D_NUM_QUIETANZA
            and nvl(scadenza,to_date('3333333','j')) < D_DATA;
       EXCEPTION
            WHEN NO_DATA_FOUND THEN NULL;
            WHEN TOO_MANY_ROWS THEN NULL;
       END;
       IF V_stringa is not null THEN
	    P_ERRORE := 'P06714';
	    D_CNT    := 13000;
	    D_STP    := ' per : '||V_stringa;
          D_ERRORE7 := D_ERRORE7 + 1;
          CIMCO_TRACE(8,D_PRN,D_PAS,D_ERRORE7,D_STP,D_CNT);
       END IF;
            BEGIN  -- CARICA NUOVA IMPUTAZIONE
               D_STP := 'CARICA-09';
               INSERT INTO IMPUTAZIONI_CONTABILI
               ( DATA
               , DIVISIONE
 	         , SEZIONE
               , ESERCIZIO
               , E_S
               , RISORSA_INTERVENTO, CAPITOLO, ARTICOLO, GESTIONE
               , FUNZIONALE
               , SEDE_DEL, ANNO_DEL, NUMERO_DEL
               , IMPEGNO, ANNO_IMPEGNO, SUB, ANNO_SUB
               , IMPORTO
               , SOGGETTO
               , NUM_QUIETANZA
               , COSTO
               , CAUSALE
               , CODICE_SIOPE
               , UTENTE
               , DATA_AGG
               )
               VALUES
               ( D_DATA
               , NVL(CURB.DIVISIONE,'%')
               , NVL(CURB.SEZIONE,'%')
               , D_ANNO
               , NVL(CURB.TIPO,'S')
               , nvl(CURB.RISORSA_INTERVENTO,'0')
               , substr(rtrim(ltrim(CURB.CAPITOLO)),1,8)
               , CURB.ARTICOLO, D_GESTIONE
               , CURB.FUNZIONALE
               , CURB.SEDE_DEL, CURB.ANNO_DEL, CURB.NUMERO_DEL
               , nvl(CURB.IMPEGNO,D_IMPEGNO)
               , decode( nvl( nvl(CURB.IMPEGNO,D_IMPEGNO),0 )
                       , 0, null
                          , nvl(CURB.ANNO_IMPEGNO,nvl(D_ANNO_IMPEGNO,D_GESTIONE))
                       )
               , nvl(CURB.SUB_IMPEGNO,D_SUB)
               , nvl(CURB.ANNO_SUB_IMPEGNO,D_ANNO_SUB)
               , CURB.IMPORTO
               , D_SOGGETTO
               , D_NUM_QUIETANZA
               , NVL(CURB.COSTO,'R')
               , CURB.CAUSALE
               , CURB.CODICE_SIOPE
               , P_UTENTE
               , SYSDATE
               )
              ;
             END;
         END TRATTA_BIL;
         IF length(rtrim(ltrim(CURB.capitolo))) > 8 THEN
		   	 P_ERRORE := 'P05763';
			 D_CNT    := 15000;
                   D_STP := ' Per Imputazione : '||CURB.RISORSA_INTERVENTO||'.'||
                              CURB.CAPITOLO||'/'||CURB.ARTICOLO;
-- dbms_output.put_line('Prog: '||D_PRS);
                   D_ERRORE8 := D_ERRORE8 + 1;
                   CIMCO_TRACE(8,D_PRN,D_PAS,D_ERRORE8,D_STP,D_CNT);
         END IF;
         IF length(rtrim(ltrim(nvl(CURB.ANNO_DEL,'9999')))) != 4 THEN
		   	 P_ERRORE := 'P01130';
			 D_CNT    := 19000;
                   D_STP := ' - Verificare Anno della Del:'||CURB.SEDE_DEL||'-'||CURB.NUMERO_DEL||'/'||CURB.ANNO_DEL;
-- dbms_output.put_line('Prog: '||D_PRS);
                   D_ERRORE10 := D_ERRORE10 + 1;
                   CIMCO_TRACE(8,D_PRN,D_PAS,D_ERRORE10,D_STP,D_CNT);
         END IF;
        commit;
      END LOOP; -- CURB
-- Controlli per Importi negativi
		 BEGIN
             D_IMPORTO := 0;
             V_stringa := null;
             D_stringa := null;
                SELECT to_char(DATA,'ddmmyyyy')||'-'||lpad(GESTIONE,4,0)
                       ||'-'||RISORSA_INTERVENTO||'.'||CAPITOLO||'/'||ARTICOLO||' Imp/Acc: '||IMPEGNO||'/'||ANNO_IMPEGNO
                       ||' Sub: '||SUB||'/'||ANNO_SUB||' Sogg. '||lpad(SOGGETTO,9,0)||' Cod. SIOPE: '||CODICE_SIOPE
                       ||' Del: '||ANNO_DEL||'-'||SEDE_DEL||'-'||NUMERO_DEL||' '||CAUSALE
                     , SUM(NVL(IMPORTO,0))
	            INTO D_STRINGA, D_IMPORTO
	            FROM IMPUTAZIONI_CONTABILI
		     WHERE ESERCIZIO 	= D_ANNO
		       AND DATA		= D_DATA
                       AND nvl(SEZIONE,'%') LIKE '%' ||D_SEZIONE||'%'
                       AND nvl(DIVISIONE,'%') LIKE '%' ||D_DIVISIONE||'%'
                GROUP BY  to_char(DATA,'ddmmyyyy')||'-'||lpad(GESTIONE,4,0)
                       ||'-'||RISORSA_INTERVENTO||'.'||CAPITOLO||'/'||ARTICOLO||' Imp/Acc: '||IMPEGNO||'/'||ANNO_IMPEGNO
                       ||' Sub: '||SUB||'/'||ANNO_SUB||' Sogg. '||lpad(SOGGETTO,9,0)||' Cod. SIOPE: '||CODICE_SIOPE
                       ||' Del: '||ANNO_DEL||'-'||SEDE_DEL||'-'||NUMERO_DEL||' '||CAUSALE
		    HAVING SUM(NVL(IMPORTO,0)) < 0;
             EXCEPTION
                  WHEN NO_DATA_FOUND THEN NULL;
-- dbms_output.put_line('excp1');
                  WHEN TOO_MANY_ROWS THEN NULL;
-- dbms_output.put_line('excp2');
             END;
-- dbms_output.put_line('NEG: '||D_IMPORTO);
-- dbms_output.put_line(V_stringa);
		  IF D_IMPORTO < 0 THEN
-- dbms_output.put_line('imp negativo ');
                   V_stringa := '('||D_IMPORTO||') Per imputazione: '||substr(D_stringa,15);
		   	 P_ERRORE := 'P05999';
			 D_CNT    := 11000;
			 D_STP    := V_stringa;
-- dbms_output.put_line('Prog: '||D_PRS);
                   D_ERRORE6 := D_ERRORE6 + 1;
                   CIMCO_TRACE(8,D_PRN,D_PAS,D_ERRORE6,D_STP,D_CNT);
             END IF;
          BEGIN
/* controllo record non completi */
		 BEGIN
             D_stringa := null;
                SELECT RISORSA_INTERVENTO||'.'||CAPITOLO||'/'||ARTICOLO||' Imp/Acc: '||IMPEGNO||'/'||ANNO_IMPEGNO
                       ||' Sub: '||SUB||'/'||ANNO_SUB
	            INTO D_STRINGA
	            FROM IMPUTAZIONI_CONTABILI
		     WHERE ESERCIZIO 	= D_ANNO
		       AND DATA		= D_DATA
                       AND nvl(SEZIONE,'%') LIKE '%' ||D_SEZIONE||'%'
                       AND nvl(DIVISIONE,'%') LIKE '%' ||D_DIVISIONE||'%'
                   AND ( IMPEGNO IS NULL AND ANNO_IMPEGNO IS NOT NULL
                      OR IMPEGNO IS NOT NULL AND ANNO_IMPEGNO IS NULL
                      OR SUB IS NULL AND ANNO_SUB IS NOT NULL
                      OR SUB IS NOT NULL AND ANNO_SUB IS NULL
                       )
                GROUP BY RISORSA_INTERVENTO||'.'||CAPITOLO||'/'||ARTICOLO||' Imp/Acc: '||IMPEGNO||'/'||ANNO_IMPEGNO
                       ||' Sub: '||SUB||'/'||ANNO_SUB
                 ;
             EXCEPTION
                  WHEN NO_DATA_FOUND THEN NULL;
                  WHEN TOO_MANY_ROWS THEN NULL;
             END;
               IF D_stringa is not null THEN
		   	 P_ERRORE := 'P06716';
			 D_CNT    := 17000;
			 D_STP    := ' Per imputazione: '||D_stringa;
                   D_ERRORE9 := D_ERRORE9 + 1;
                 CIMCO_TRACE(8,D_PRN,D_PAS,D_ERRORE9,D_STP,D_CNT);
               END IF;
          END;
      BEGIN
        delete from imputazioni_contabili
         where nvl(importo,0) = 0
           and esercizio = D_anno
           and data = D_data;
      commit;
      END;
      BEGIN  -- OPERAZIONI FINALI PER TRACE
         D_STP := 'PECCIMCO-STOP';
         D_prs := 1;
         CIMCO_TRACE(2,D_PRN,D_PAS,D_PRS,D_STP,0);
         IF p_errore not in ('P05763','P05808','P05987','P05996','P05994','P05995','P05999','P06714')
		  THEN  -- SEGNALAZIONE
            p_errore := 'P05802';      -- ELABORAZIONE COMPLETATA
         END IF;
        COMMIT;
      END;
   END CICLO_BIL;
EXCEPTION
   WHEN OTHERS THEN
      D_TIM     := TO_CHAR(SYSDATE,'SSSSS');
-- dbms_output.put_line('Prog: '||D_PRS);
      TRACE.ERR_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM);
      p_errore := 'P05809';   -- ERRORE IN ELABORAZIONE
      err_passo := D_stp;   -- Step errato
END;
PROCEDURE MAIN	(prenotazione  IN number, PASSO   IN number) is
BEGIN
  W_PRENOTAZIONE := PRENOTAZIONE;
  W_PASSO	     := PASSO;
  P_ERRORE       := to_char(null);

  CARICA;  -- ESECUZIONE DEL CARICAMENTO IMPUTAZIONI CONTABILI
   IF W_PRENOTAZIONE != 0 THEN
      IF p_errore in ('P05763','P05808','P05987','P05996','P05994','P05995','P05999','P06714')
	   THEN
         UPDATE A_PRENOTAZIONI
            SET ERRORE = 'P05808'
          WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
         ;
        Commit;
      ELSIF
         SUBSTR(p_errore,6,1) = '9' THEN
         UPDATE A_PRENOTAZIONI
            SET ERRORE       = 'P05809'
              , PROSSIMO_PASSO = 91
          WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
         ;
         Commit;
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
		null;
      END;
END;
end;
/
