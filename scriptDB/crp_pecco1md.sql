CREATE OR REPLACE PACKAGE Pecco1md IS
/******************************************************************************
 NOME:          PECCO1MD Archiviazione Quadro INPS del CUD
 DESCRIZIONE:
      Viene eseguita come secondo passo dell'archiviazione INPS del CUD,
      dopo CAO1M.
      Tratta gli individui gia' registrati su DENUNCIA_O1_INPS
 ARGOMENTI:
      Aggiornamento dei campi di DENUNCIA_O1_INPS relativi all'ex quadro D
      dell'O1/M
 RITORNA:

 ECCEZIONI:

 ANNOTAZIONI:

 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ --------------------------------------------------------
 1    30/06/2000
 1.1  22/12/2004 MS     Modifica per Att. 8892
 1.2  07/03/2005 MS       Modifica per att. 10041
 1.3  14/03/2005 MM		Attività 10248
******************************************************************************/

FUNCTION  VERSIONE              RETURN VARCHAR2;
PROCEDURE MAIN      (PRENOTAZIONE IN NUMBER, PASSO        IN NUMBER);
PROCEDURE CARICA ( P_tipo_elab IN    VARCHAR2,
                   D_anno      IN    NUMBER,
                   P_ci        IN    NUMBER,
                   P_cess_dal  IN    DATE,
                   P_cess_al   IN    DATE,
                   P_ruolo     IN    VARCHAR2,
                   P_gestione  IN    VARCHAR2,
                   P_retribuzione IN VARCHAR2,
                   P_ente      IN    VARCHAR2,
                   P_utente    IN    VARCHAR2,
                   P_ambiente  IN    VARCHAR2);
PROCEDURE ASSENZE (P_giorno     IN  DATE,
                   D_anno      IN    NUMBER,
                   P_ci         IN  NUMBER,
                   P_assistenza IN  VARCHAR2,
                   P_causale    OUT VARCHAR2,
                   P_dal        OUT DATE,
                   P_al         OUT DATE,
                   P_evento     OUT NUMBER,
                   P_assenza    OUT VARCHAR2,
                   P_per_ret    OUT NUMBER,
                   P_tipo       OUT VARCHAR2,
                   P_giorni     OUT NUMBER);
PROCEDURE RETRIBUZIONE (P_ci         IN  NUMBER,
                   D_anno      IN    NUMBER,
                        P_giorno     IN  DATE,
                        P_contratto  IN  VARCHAR2,
                        P_per_ret    IN  NUMBER,
                        P_tipo_ret   IN  VARCHAR2,
                        P_importo    IN OUT NUMBER,
                        P_imp_acce   IN OUT NUMBER);
END;
/
CREATE OR REPLACE PACKAGE BODY Pecco1md IS
w_prenotazione  NUMBER(10);
W_PASSO         NUMBER(5);
ERRORE          VARCHAR2(6);
err_passo       VARCHAR2(30);
D_dummy         VARCHAR2(2);
D_tipo          VARCHAR2(1);
D_ANNO          RIFERIMENTO_FINE_ANNO.ANNO%TYPE;
D_ci            NUMBER(8);
D_dal           DATE;
D_al            DATE;
D_ruolo         VARCHAR2(1);
D_retribuzione  VARCHAR2(1);
P_assestamento  VARCHAR2(1);
P_spezza        VARCHAR2(1);
V_valore2       number;
V_valore3       number;
V_valore_p2     number;
V_valore_p3     number;
V_valore_pap    number;

D_gestione      VARCHAR2(4);
D_ente          VARCHAR2(4);
D_utente        VARCHAR2(8);
D_ambiente      VARCHAR2(8);

 FUNCTION VERSIONE  RETURN VARCHAR2 IS
 BEGIN
    RETURN 'V1.3 del 14/03/2005';
 END VERSIONE;
PROCEDURE MAIN   (prenotazione  IN NUMBER, PASSO          IN NUMBER) IS
ERRORE VARCHAR2(6);

BEGIN
  W_PRENOTAZIONE := PRENOTAZIONE;
  W_PASSO        := PASSO;
  ERRORE         := TO_CHAR(NULL);

   BEGIN  -- Anno in elaborazione
      select valore
        into D_anno
        from a_parametri
       where no_prenotazione = prenotazione
         and parametro    = 'P_ANNO'
      ;
    EXCEPTION WHEN NO_DATA_FOUND THEN
      SELECT RIFA.ANNO
        INTO D_ANNO
        FROM RIFERIMENTO_FINE_ANNO rifa
      WHERE rifa.rifa_id = 'RIFA'
      ;
     COMMIT;
   END;

  BEGIN
    SELECT valore
     INTO D_tipo
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro    = 'P_TIPO'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN D_tipo := 'P';
  END;
  BEGIN
    SELECT valore
     INTO D_ci
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro    = 'P_CI'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN D_ci := '';
  END;
  BEGIN
    SELECT TO_DATE(valore,DECODE(NVL(LENGTH(TRANSLATE(valore,'a0123456789/','a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
     INTO D_dal
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro    = 'P_DAL'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN D_dal := '';
  END;
  BEGIN
    SELECT TO_DATE(valore,DECODE(NVL(LENGTH(TRANSLATE(valore,'a0123456789/','a')),0),0,'dd/mm/yyyy','dd-mon-yy'))
     INTO D_al
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro    = 'P_AL'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN D_al := '';
  END;
  BEGIN
    SELECT valore
     INTO D_ruolo
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro    = 'P_RUOLO'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN D_ruolo := '';
  END;
  BEGIN
    SELECT valore
     INTO D_retribuzione
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro    = 'P_RETRIBUZIONE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN D_retribuzione := 'F';
  END;
  BEGIN
    SELECT valore
     INTO P_assestamento
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro    = 'P_ASSESTAMENTO'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN P_assestamento := null;
  END;

  BEGIN
    SELECT valore
     INTO P_spezza
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro    = 'P_SPEZZA'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN P_spezza := null;
  END;

  BEGIN
    SELECT valore
     INTO D_gestione
      FROM a_parametri
     WHERE no_prenotazione = prenotazione
       AND parametro    = 'P_GESTIONE'
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN D_gestione := '%';
  END;
  BEGIN
    SELECT ENTE
         , utente
         , ambiente
     INTO D_ente
         ,D_utente
        ,D_ambiente
      FROM a_prenotazioni
     WHERE no_prenotazione = prenotazione
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN D_ente     := '%';
                                    D_utente   := '%';
                           D_ambiente := '%';
  END;
  CARICA (D_tipo, D_anno, D_ci, D_dal, D_al, D_ruolo, D_gestione, D_retribuzione, D_ente, D_utente, D_ambiente);
   IF W_PRENOTAZIONE != 0 THEN
      IF errore = 'P05808' THEN
         UPDATE A_PRENOTAZIONI
            SET ERRORE = 'P05808'
          WHERE NO_PRENOTAZIONE = W_PRENOTAZIONE
         ;
        COMMIT;
      ELSIF
         SUBSTR(errore,6,1) = '9' THEN
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
PROCEDURE ASSENZE (P_giorno     IN  DATE,
                   D_anno      IN    NUMBER,
                   P_ci         IN  NUMBER,
               P_assistenza IN  VARCHAR2,
                 P_causale    OUT VARCHAR2,
               P_dal        OUT DATE,
               P_al         OUT DATE,
               P_evento     OUT NUMBER,
               P_assenza    OUT VARCHAR2,
               P_per_ret    OUT NUMBER,
               P_tipo       OUT VARCHAR2,
               P_giorni     OUT NUMBER) IS
ERRORE VARCHAR2(6);
BEGIN
  P_causale := NULL;
  BEGIN
    SELECT  evpa.causale
           ,evpa.dal
           ,evpa.al
            ,evpa.evento
            ,caev.Assenza
            ,caev.retribuzione_azienda
      INTO  P_causale
            ,P_dal
           ,P_al
           ,P_evento
            ,P_assenza
            ,P_per_ret
      FROM  EVENTI_PRESENZA           evpa
           ,periodi_servizio_presenza pspa
           ,CAUSALI_EVENTO            caev
     WHERE  evpa.input      = 'V'
      AND  causale        <> 'XXXXXXXX'
       AND  caev.codice     = evpa.causale
       AND  pspa.ci         = evpa.ci
        AND  pspa.ci         = P_ci
       AND  P_giorno
               BETWEEN pspa.dal
                  AND NVL(pspa.al,TO_DATE(3333333,'j'))
       AND  P_giorno
              BETWEEN evpa.dal
                  AND evpa.al
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  IF P_causale IS NOT NULL THEN
  P_tipo := 'ASS';
  BEGIN
    SELECT  P_tipo||'MAL'
      INTO  P_tipo
      FROM  dual
     WHERE  EXISTS
           ( SELECT 'x'
               FROM  EVENTI_PRESENZA       evpa
                    ,VOCI_ECONOMICHE       voec
                    ,VOCI_CONTABILI_EVENTO vcev
              WHERE  P_ci           = evpa.ci
                AND  P_giorno BETWEEN evpa.dal
                                  AND evpa.al
                AND  vcev.causale   = evpa.causale
                AND  evpa.input     = 'V'
                AND  voec.codice    = vcev.voce
               AND  voec.specifica = 'CUDO1M_S2M'
           )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT  P_tipo||'MAL1'
      INTO  P_tipo
      FROM  dual
     WHERE  EXISTS
           ( SELECT 'x'
               FROM  EVENTI_PRESENZA       evpa
                    ,VOCI_ECONOMICHE       voec
                    ,VOCI_CONTABILI_EVENTO vcev
              WHERE  P_ci           = evpa.ci
                AND  P_giorno BETWEEN evpa.dal
                                  AND evpa.al
                AND  vcev.causale   = evpa.causale
                AND  evpa.input     = 'V'
                AND  voec.codice    = vcev.voce
              AND  voec.specifica = 'CUDO1M_S1M'
           )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT  P_tipo||'MAT'
      INTO  P_tipo
      FROM  dual
     WHERE  EXISTS
           ( SELECT 'x'
               FROM  EVENTI_PRESENZA       evpa
                    ,VOCI_ECONOMICHE       voec
                    ,VOCI_CONTABILI_EVENTO vcev
              WHERE  P_ci           = evpa.ci
                AND  P_giorno BETWEEN evpa.dal
                                  AND evpa.al
                AND  vcev.causale   = evpa.causale
                AND  evpa.input     = 'V'
                AND  voec.codice    = vcev.voce
             AND  voec.specifica = 'CUDO1M_S2T'
           )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT  P_tipo||'MAT1'
      INTO  P_tipo
      FROM  dual
     WHERE  EXISTS
           ( SELECT 'x'
               FROM  EVENTI_PRESENZA       evpa
                    ,VOCI_ECONOMICHE       voec
                    ,VOCI_CONTABILI_EVENTO vcev
              WHERE  P_ci           = evpa.ci
                AND  P_giorno BETWEEN evpa.dal
                                  AND evpa.al
                AND  vcev.causale   = evpa.causale
                AND  evpa.input     = 'V'
                AND  voec.codice    = vcev.voce
               AND  voec.specifica = 'CUDO1M_S1T'
           )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT  P_tipo||'DOS'
      INTO  P_tipo
      FROM  dual
     WHERE  EXISTS
           ( SELECT 'x'
               FROM  EVENTI_PRESENZA       evpa
                    ,VOCI_ECONOMICHE       voec
                    ,VOCI_CONTABILI_EVENTO vcev
              WHERE  P_ci           = evpa.ci
                AND  P_giorno BETWEEN evpa.dal
                                  AND evpa.al
                AND  vcev.causale   = evpa.causale
                AND  evpa.input     = 'V'
                AND  voec.codice    = vcev.voce
               AND  voec.specifica = 'CUDO1M_DS'
           )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT  P_tipo||'M53'
      INTO  P_tipo
      FROM  dual
     WHERE  EXISTS
           ( SELECT 'x'
               FROM  EVENTI_PRESENZA       evpa
                    ,VOCI_ECONOMICHE       voec
                    ,VOCI_CONTABILI_EVENTO vcev
              WHERE  P_ci           = evpa.ci
                AND  P_giorno BETWEEN evpa.dal
                                  AND evpa.al
                AND  vcev.causale   = evpa.causale
                AND  evpa.input     = 'V'
                AND  voec.codice    = vcev.voce
               AND  voec.specifica = 'CUDO1M_S25'
           )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT  P_tipo||'M531'
      INTO  P_tipo
      FROM  dual
     WHERE  EXISTS
           ( SELECT 'x'
               FROM  EVENTI_PRESENZA       evpa
                    ,VOCI_ECONOMICHE       voec
                    ,VOCI_CONTABILI_EVENTO vcev
              WHERE  P_ci           = evpa.ci
                AND  P_giorno BETWEEN evpa.dal
                                  AND evpa.al
                AND  vcev.causale   = evpa.causale
                AND  evpa.input     = 'V'
                AND  voec.codice    = vcev.voce
               AND  voec.specifica = 'CUDO1M_S15'
           )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN                                  -- Casella 50
    SELECT  P_tipo||'M1511'
      INTO  P_tipo
      FROM  dual
     WHERE  EXISTS
           ( SELECT 'x'
               FROM  EVENTI_PRESENZA       evpa
                    ,VOCI_ECONOMICHE       voec
                    ,VOCI_CONTABILI_EVENTO vcev
              WHERE  P_ci           = evpa.ci
                AND  P_giorno BETWEEN evpa.dal
                                  AND evpa.al
                AND  vcev.causale   = evpa.causale
                AND  evpa.input     = 'V'
                AND  voec.codice    = vcev.voce
               AND  voec.specifica = 'CUDO1M_S50'
           )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN                                 -- Casella 51
    SELECT  P_tipo||'M151'
      INTO  P_tipo
      FROM  dual
     WHERE  EXISTS
           ( SELECT 'x'
               FROM  EVENTI_PRESENZA       evpa
                    ,VOCI_ECONOMICHE       voec
                    ,VOCI_CONTABILI_EVENTO vcev
              WHERE  P_ci           = evpa.ci
                AND  P_giorno BETWEEN evpa.dal
                                  AND evpa.al
                AND  vcev.causale   = evpa.causale
                AND  evpa.input     = 'V'
                AND  voec.codice    = vcev.voce
               AND  voec.specifica = 'CUDO1M_S51'
           )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT  P_tipo||'M88'
      INTO  P_tipo
      FROM  dual
     WHERE  EXISTS
           ( SELECT 'x'
               FROM  EVENTI_PRESENZA       evpa
                    ,VOCI_ECONOMICHE       voec
                    ,VOCI_CONTABILI_EVENTO vcev
              WHERE  P_ci           = evpa.ci
                AND  P_giorno BETWEEN evpa.dal
                                  AND evpa.al
                AND  vcev.causale   = evpa.causale
                AND  evpa.input     = 'V'
                AND  voec.codice    = vcev.voce
                AND  voec.specifica = 'CUDO1M_S28'
           )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  BEGIN
    SELECT  P_tipo||'M881'
      INTO  P_tipo
      FROM  dual
     WHERE  EXISTS
           ( SELECT 'x'
               FROM  EVENTI_PRESENZA       evpa
                    ,VOCI_ECONOMICHE       voec
                    ,VOCI_CONTABILI_EVENTO vcev
              WHERE  P_ci           = evpa.ci
                AND  P_giorno BETWEEN evpa.dal
                                  AND evpa.al
                AND  vcev.causale   = evpa.causale
                AND  evpa.input     = 'V'
                AND  voec.codice    = vcev.voce
               AND  voec.specifica = 'CUDO1M_S18'
           )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
/* La CIG non viene gestita in quanto non abbiamo realta nelle quali possa trovare applicazione.
   Questa parte di codice e stata commentata per non appesantire inutilmente i tempi di esecuzione
  BEGIN
    SELECT  P_tipo||'CIG'
      INTO  P_tipo
      FROM  dual
     WHERE  EXISTS
           ( SELECT 'x'
               FROM  EVENTI_PRESENZA       evpa
                    ,VOCI_ECONOMICHE       voec
                    ,VOCI_CONTABILI_EVENTO vcev
              WHERE  P_ci           = evpa.ci
                AND  P_giorno BETWEEN evpa.dal
                                  AND evpa.al
                AND  vcev.causale   = evpa.causale
                AND  evpa.input     = 'V'
                AND  voec.codice    = vcev.voce
             AND  voec.specifica IN (SELECT 'CUDO1M_S1C' FROM dual
                                      UNION
                               SELECT 'CUDO1M_S2C' FROM dual
                                       )
           )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
*/
  BEGIN
    SELECT al-dal+1
      INTO P_giorni
       FROM CLASSI_PRESENZA clpa
     WHERE evento = (SELECT classe
                       FROM EVENTI_PRESENZA
                     WHERE evento = P_evento
                  )
    ;
  EXCEPTION WHEN NO_DATA_FOUND THEN NULL;
  END;
  END IF;
END;
PROCEDURE CARICA  (P_tipo_elab IN    VARCHAR2,
                   D_anno      IN    NUMBER,
                   P_ci        IN    NUMBER,
               P_cess_dal  IN    DATE,
               P_cess_al   IN    DATE,
               P_ruolo     IN    VARCHAR2,
               P_gestione  IN    VARCHAR2,
               P_retribuzione IN VARCHAR2,
               P_ente      IN    VARCHAR2,
               P_utente    IN    VARCHAR2,
               P_ambiente  IN    VARCHAR2) IS
-- DATI PER GESTIONE TRACE
D_TRC           NUMBER(1);  -- TIPO DI TRACE
D_PRN           NUMBER(6);  -- NUMERO DI PRENOTAZIONE
D_PAS           NUMBER(2);  -- NUMERO DI PASSO PROCEDURALE
D_PRS           NUMBER(10); -- NUMERO PROGRESSIVO DI SEGNALAZIONE
D_STP           VARCHAR2(40);   -- IDENTIFICAZIONE DELLO STEP IN OGGETTO
D_CNT           NUMBER(5);  -- COUNT DELLE ROW TRATTATE
D_TIM           VARCHAR2(5);    -- TIME IMPIEGATO IN SECONDI
D_TIM_TOT       VARCHAR2(5);    -- TIME IMPIEGATO IN SECONDI IN TOTALE
--
-- DATI PER DEPOSITO INFORMAZIONI GENERALI
--
D_sett          DENUNCIA_O1_INPS.sett_d%TYPE;
D_stato_sett    VARCHAR2(2);
D_voci          NUMBER;
D_inizio_sett   DATE;
d_fine_sett     DATE;
D_sett_rid      DENUNCIA_O1_INPS.sett_d%TYPE;
D_causale       EVENTI_PRESENZA.causale%TYPE;
D_evento        EVENTI_PRESENZA.evento%TYPE;
D_dal           EVENTI_PRESENZA.dal%TYPE;
D_al            EVENTI_PRESENZA.dal%TYPE;
D_assenza       VARCHAR2(8);
D_sede          NUMBER;
D_calendario    CALENDARI.calendario%TYPE;
D_per_ret       CAUSALI_EVENTO.max_qta%TYPE;
D_assistenza    VOCI_CONTABILI_EVENTO.assistenza%TYPE;
D_contratto     CONTRATTI.codice%TYPE;
D_ore_lav       PERIODI_GIURIDICI.ore%TYPE;
D_rap_ore       NUMBER;
D_da_mese       NUMBER;
D_a_mese        NUMBER;
D_gg_lavoro     CONTRATTI_STORICI.gg_lavoro%TYPE;
D_specie        VOCI_CONTABILI_EVENTO.specie%TYPE;
D_sett1_mal     DENUNCIA_O1_INPS.sett1_mal_d%TYPE;
D_sett2_mal     DENUNCIA_O1_INPS.sett2_mal_d%TYPE;
D_sett1_mat     DENUNCIA_O1_INPS.sett1_mat_d%TYPE;
D_sett2_mat     DENUNCIA_O1_INPS.sett2_mat_d%TYPE;
D_sett1_m53     DENUNCIA_O1_INPS.sett1_m53_d%TYPE;
D_sett2_m53     DENUNCIA_O1_INPS.sett2_m53_d%TYPE;
D_sett1_m151     DENUNCIA_O1_INPS.sett1_m53_d%TYPE;        -- Casella 50
D_sett2_m151     DENUNCIA_O1_INPS.sett2_m53_d%TYPE;        -- Casella 51
D_sett1_m88     DENUNCIA_O1_INPS.sett1_m88_d%TYPE;
D_sett2_m88     DENUNCIA_O1_INPS.sett2_m88_d%TYPE;
D_sett1_cig     DENUNCIA_O1_INPS.sett1_cig_d%TYPE;
D_sett2_cig     DENUNCIA_O1_INPS.sett2_cig_d%TYPE;
D_sett_ds       DENUNCIA_O1_INPS.SETT2_DDS_D%TYPE;
D_importo_rid   DENUNCIA_O1_INPS.importo_rid_d%TYPE;
D_importo_cig   DENUNCIA_O1_INPS.importo_cig_d%TYPE;
D_anticipazioni DENUNCIA_O1_INPS.importo_cig_d%TYPE;
D_imp_gg        DENUNCIA_O1_INPS.importo_rid_d%TYPE;
D_imp_acce      DENUNCIA_O1_INPS.importo_rid_d%TYPE;
D_giorno        DATE;
D_festivita     NUMBER;
D_dep_festivita NUMBER;
D_giorni_ass    NUMBER;
D_giorni_s1     NUMBER;
D_giorni        NUMBER;
D_dep_giorni    NUMBER;
D_tipo_ass      VARCHAR2(12);
D_dep_tipo_ass  VARCHAR2(12);
--
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
     D_TRC := 0;
      BEGIN  -- PRELEVA NUMERO MAX DI SEGNALAZIONE
         SELECT NVL(MAX(PROGRESSIVO),0)
           INTO D_PRS
           FROM A_SEGNALAZIONI_ERRORE
          WHERE NO_PRENOTAZIONE = D_PRN
            AND PASSO           = D_PAS
         ;
      END;
   END;
   D_giorno := TO_DATE('19000101','yyyymmdd');
   BEGIN  -- SEGNALAZIONE INIZIALE
      D_STP     := 'Pecco1md-START';
      D_TIM     := TO_CHAR(SYSDATE,'SSSSS');
      D_TIM_TOT := TO_CHAR(SYSDATE,'SSSSS');
      Trace.LOG_TRACE(0,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM);
      COMMIT;
   END;
   BEGIN  -- Prima domenica dell'anno
      D_STP := 'Prima domenica';
      SELECT NEXT_DAY(TO_DATE(TO_CHAR(D_ANNO)||'0101','yyyymmdd')-1,'sunday')
        INTO D_giorno
        FROM dual
      ;
      Trace.LOG_TRACE(0,D_PRN,D_PAS,D_PRS,D_STP||' '||TO_CHAR(D_giorno,'dd/mm/yyyy'),SQL%ROWCOUNT,D_TIM);
     COMMIT;
   BEGIN  -- Loop sui dipendenti
      D_STP := 'Inizio loop su individui';
     Trace.LOG_TRACE(0,D_PRN,D_PAS,D_PRS,D_STP||' '||TO_CHAR(D_giorno,'dd/mm/yyyy'),SQL%ROWCOUNT,D_TIM);
      D_STP := 'Parametri '||P_ci||' '||P_gestione||' '||P_tipo_elab||' '||P_ruolo||' '||P_retribuzione;
     Trace.LOG_TRACE(0,D_PRN,D_PAS,D_PRS,D_STP||' '||TO_CHAR(D_giorno,'dd/mm/yyyy'),SQL%ROWCOUNT,D_TIM);
     COMMIT;
-- dbms_output.put_Line('Inizio!!!!');

     FOR INDI IN
     ( SELECT ci
             ,gestione
             ,GREATEST( NVL(dal,TO_DATE(TO_CHAR(d_anno)||'0101','yyyymmdd'))
                       ,TO_DATE(TO_CHAR(d_anno)||'0101','yyyymmdd')
                  )                                           dal
             ,NVL(al,TO_DATE(TO_CHAR(d_anno)||'1231','yyyymmdd')) al
           ,dal                                                 dal_upd
          FROM DENUNCIA_O1_INPS d1is
         WHERE anno = d_anno
           AND d1is.istituto         = 'INPS'
           and d1is.ci      = nvl(P_ci,d1is.ci)
           AND d1is.gestione      LIKE P_gestione
           AND (        P_tipo_elab   = 'T'
                OR (P_tipo_elab = 'S' AND d1is.ci = P_ci
                   )
                OR (    P_tipo_elab = 'C'
                    AND EXISTS (SELECT 'x' FROM PERIODI_GIURIDICI
                                              , RIFERIMENTO_RETRIBUZIONE
                                 WHERE rire_id   = 'RIRE'
                                   AND rilevanza = 'P'
                                   AND ci        = d1is.ci
                                   AND al  BETWEEN NVL(P_cess_dal,ini_ela)
                                               AND NVL(P_cess_al,fin_ela)
                                )
                   )
                OR NOT EXISTS
                  (SELECT 'x' FROM DENUNCIA_O1_INPS
                    WHERE anno     = d1is.anno
                      AND ci       = d1is.ci
                      AND gestione = d1is.gestione
                      AND (   NVL(tipo_agg,' ')   = DECODE(P_tipo_elab
                                                          ,'C',NVL(tipo_agg,' ')
                                                           ,P_tipo_elab)
                        OR (P_tipo_elab     = 'P' AND
                            tipo_agg IS NOT NULL
                           )
                       )
               )
            )
        AND (    NVL(P_ruolo,'%') = '%'
             OR  EXISTS (SELECT 'x' FROM PERIODI_RETRIBUTIVI
                          WHERE periodo
                               BETWEEN TO_DATE('01'||D_anno,'mmyyyy')
                                   AND LAST_DAY(TO_DATE('12'||D_anno,'mmyyyy'))
                            AND competenza IN ('P','C','A')
                            AND SERVIZIO   IN ('Q','I','N')
                            AND gestione LIKE NVL('','%')
                            AND ci          = d1is.ci
                            AND posizione  IN
                               (SELECT codice FROM POSIZIONI
                                 WHERE di_ruolo != 'R')
                        )
            )
        AND EXISTS
           (SELECT 'x'
                       FROM RAPPORTI_INDIVIDUALI rain
             WHERE rain.ci = ci
               AND (   rain.CC IS NULL
                    OR EXISTS
                      (SELECT 'x'
                         FROM a_competenze
                        WHERE ENTE        = P_ente
                          AND ambiente    = P_ambiente
                          AND utente      = P_utente
                          AND competenza  = 'CI'
                          AND oggetto     = rain.CC
                      )
                   )
           )
        AND (  NVL(d1is.IMPORTO_RID_D,0) +
               NVL(d1is.SETT_D,0)        +
               NVL(d1is.SETT1_MAL_D,0)   +
               NVL(d1is.SETT2_MAL_D,0)   +
               NVL(d1is.SETT1_MAT_D,0)   +
               NVL(d1is.SETT2_MAT_D,0)   +
               NVL(d1is.SETT1_M88_D,0)   +
               NVL(d1is.SETT2_M88_D,0)   +
               NVL(d1is.SETT1_DL151_D,0) +
               NVL(d1is.SETT2_DL151_D,0) +
               NVL(d1is.SETT2_DDS_D,0)   +
               NVL(d1is.SETT1_M53_D,0)   +
               NVL(d1is.SETT2_M53_D,0)   = 0
         )
        AND EXISTS
           ( SELECT 'x'
               FROM  EVENTI_PRESENZA           evpa
                    ,periodi_servizio_presenza pspa
                    ,CAUSALI_EVENTO            caev
                    ,VOCI_CONTABILI_EVENTO     vcev
              WHERE  evpa.ci         = d1is.ci
              AND  evpa.input      = 'V'
                AND  caev.codice     = evpa.causale
                AND  pspa.ci         = evpa.ci
                AND  NVL(d1is.dal,TO_DATE(TO_CHAR(d_anno)||'0101','yyyymmdd')) <= NVL(pspa.al,TO_DATE(3333333,'j'))
              AND  NVL(d1is.al,TO_DATE(TO_CHAR(d_anno)||'1231','yyyymmdd'))  >= pspa.dal
                AND  NVL(d1is.dal,TO_DATE(TO_CHAR(d_anno)||'0101','yyyymmdd')) <= evpa.al
              AND  NVL(d1is.al,TO_DATE(TO_CHAR(d_anno)||'1231','yyyymmdd'))  >= evpa.dal
                AND  vcev.causale    = evpa.causale
              AND  vcev.gestione   = 'S'
           )
     ORDER BY ci,dal
     ) LOOP
-- dbms_output.put_Line('Ciclo CI '||INDI.ci);
        D_STP := 'Ciclo su individui ci: '||TO_CHAR(INDI.ci);
         Trace.LOG_TRACE(0,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
        COMMIT;
       BEGIN
        BEGIN
        D_sett_rid    := 0;
        D_sett1_mal   := 0;
        D_sett2_mal   := 0;
        D_sett1_mat   := 0;
        D_sett2_mat   := 0;
        D_sett1_m53   := 0;
        D_sett2_m53   := 0;
        D_sett1_m151  := 0;
        D_sett2_m151  := 0;
        D_sett1_m88   := 0;
        D_sett2_m88   := 0;
        D_importo_rid := 0;
        D_sett_ds     := 0;
        D_stato_sett  := '';
        D_tipo_ass    := '';
        D_giorno      := INDI.dal;
        IF (TO_CHAR(D_giorno,'day') = 'sunday') THEN D_sett := 0;
                                                ELSE D_sett := 1;
          END IF;
        D_inizio_sett := GREATEST(NEXT_DAY(D_giorno -7,'sunday'),INDI.dal);
         D_fine_sett   := LEAST(NEXT_DAY(D_giorno -1,'saturday'),INDI.al);
        WHILE D_giorno <= INDI.al-1 LOOP
        D_STP := 'Giorni anno '||D_giorno;
         Trace.LOG_TRACE(0,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
        COMMIT;
         D_voci       := 0;
         D_giorni_ass := 0;
         D_giorni_s1  := 0;
            IF TO_CHAR(D_giorno,'day') LIKE 'sunday%' THEN
            D_sett        := D_sett + 1 ;
            D_stato_sett  := '';
            D_inizio_sett := GREATEST(NEXT_DAY(D_giorno -7,'sunday'),INDI.dal);
            D_fine_sett   := LEAST(NEXT_DAY(D_giorno -1,'saturday'),INDI.al);
         END IF;
            /* Determino il codice assistenziale dell'individuo */
            BEGIN
              SELECT pspa.assistenza
                 ,pspa.contratto
               ,pspa.ore
               ,cost.gg_lavoro
               ,round(pspa.ore / cost.ore_lavoro,9)
               ,pspa.sede
               ,SEDI.calendario
                INTO D_assistenza
                ,D_contratto
               ,D_ore_lav
               ,D_gg_lavoro
               ,D_rap_ore
               ,D_sede
               ,D_calendario
                FROM periodi_servizio_presenza pspa
                ,SEDI                      SEDI
                ,CONTRATTI_STORICI         cost
               WHERE pspa.ci         = INDI.ci
              AND cost.contratto  = pspa.contratto
                 AND D_giorno  BETWEEN pspa.dal
                                   AND NVL(pspa.al,TO_DATE(3333333,'j'))
                 AND D_giorno  BETWEEN cost.dal
                                   AND NVL(cost.al,TO_DATE(3333333,'j'))
             AND SEDI.numero (+)     = pspa.sede
              ;
            EXCEPTION WHEN NO_DATA_FOUND THEN D_assistenza := 'A1';
            END;
            IF D_sede IS NULL THEN D_calendario := '*';
            END IF;
         /* Verifico se ci sono assenze nella settimana */
         BEGIN
              SELECT  COUNT(*)
              INTO  d_voci
                FROM  EVENTI_PRESENZA           evpa
                     ,VOCI_CONTABILI_EVENTO     vcev
               WHERE  evpa.input      = 'V'
                 AND  INDI.ci         = evpa.ci
                 AND  vcev.causale    = evpa.causale
                 AND  vcev.assistenza = D_assistenza
                 AND  vcev.specie     IN (SELECT '<' FROM dual
                                           UNION
                                         SELECT '>' FROM dual
                                            UNION
                                   SELECT '2' FROM dual
                                      )
                 AND  D_inizio_sett <= evpa.al
             AND  D_fine_sett   >= evpa.dal
              ;
          EXCEPTION WHEN NO_DATA_FOUND THEN
                 D_STP := 'settimana: '||TO_CHAR(D_sett)||' '||D_giorno;
                     Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
                 COMMIT;
                      NULL;
                   WHEN TOO_MANY_ROWS THEN
                 D_STP := 'settimana: '||TO_CHAR(D_sett)||' '||D_giorno;
                     Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
                 COMMIT;
                      NULL;
         END;
              IF D_voci > 0   THEN
                BEGIN
              D_voci := 0;
              D_dep_tipo_ass  := '';
              D_dep_giorni    := 0;
              D_festivita     := 0;
              D_dep_festivita := 0;
--dbms_output.put_Line('ciclo settimana : '||D_giorno||' '||D_fine_sett);
              WHILE D_giorno < D_fine_sett LOOP
        D_STP := 'Giorni settimana '||D_giorno;
         Trace.LOG_TRACE(0,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
        COMMIT;
               D_dep_festivita := D_festivita;
                BEGIN
                 SELECT NVL(MAX(1),0)
                   INTO D_dep_festivita
                  FROM CALENDARI cale
                  WHERE (    cale.calendario = D_calendario
                         AND cale.anno       = TO_NUMBER(TO_CHAR(D_giorno,'yyyy'))
                        AND cale.mese       = TO_NUMBER(TO_CHAR(D_giorno,'mm'))
                        AND SUBSTR(cale.giorni,TO_NUMBER(TO_CHAR(D_giorno,'dd')),1) IN
                           (SELECT 'D' FROM dual
                            UNION
                           SELECT 'S' FROM dual
                          )
                      )
                    OR D_giorno = TO_DATE('0411'||cale.anno,'ddmmyyyy')
                 ;
               EXCEPTION WHEN NO_DATA_FOUND THEN D_dep_festivita := D_festivita;
               END;
               IF D_festivita = 0 THEN
                  D_festivita := D_dep_festivita;
               END IF;
                BEGIN
                 D_dep_tipo_ass := D_tipo_ass;
                 D_dep_giorni   := D_giorni;
-- dbms_output.put_Line('Assenze: giorno - '||D_giorno||' ci - '||INDI.ci);
                      ASSENZE (D_giorno, D_anno, INDI.ci, D_assistenza,
                          D_causale, D_dal, D_al, D_evento, D_assenza, D_per_ret, D_tipo_ass, D_giorni);
                      IF D_causale IS NULL THEN
                   D_giorni   := D_dep_giorni;
                   D_tipo_ass := D_dep_tipo_ass;
                   D_per_ret := 100;
                  IF D_gg_lavoro > 26 OR TO_CHAR(D_giorno,'day') NOT LIKE 'sunday%' THEN
                      RETRIBUZIONE (INDI.ci, D_anno, D_giorno , D_contratto, D_per_ret, D_retribuzione, D_imp_gg, D_imp_acce);
                      D_importo_rid := D_importo_rid + (D_rap_ore * NVL(D_imp_gg,0)) + D_imp_acce;
                  END IF;
                       D_giorno      := D_giorno + 1;
                   D_STP := D_causale||' '||D_tipo_ass||' '||d_per_ret||' '||d_importo_rid||' '||TO_CHAR((D_rap_ore * NVL(D_imp_gg,0)) + D_imp_acce);
                     Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
                 COMMIT;
                 ELSE
                  IF D_gg_lavoro > 26 OR TO_CHAR(D_giorno,'day') NOT LIKE  'sunday%' THEN
                      RETRIBUZIONE (INDI.ci, D_anno, D_giorno , D_contratto, D_per_ret, D_retribuzione, D_imp_gg, D_imp_acce);
                      D_importo_rid := D_importo_rid + (D_rap_ore * NVL(D_imp_gg,0)) + D_imp_acce;
                        END IF;
                   D_giorni_ass  := D_giorni_ass + (100 - D_per_ret)/100;
                  IF D_tipo_ass LIKE '%1%' THEN
                    D_giorni_s1 := D_giorni_s1 + 1;
                  END IF;
                       D_giorno      := D_giorno + 1;
                   D_STP := D_causale||' '||D_tipo_ass||' '||d_per_ret||' '||d_importo_rid||' '||TO_CHAR((D_rap_ore * NVL(D_imp_gg,0)) + D_imp_acce);
                     Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
                 COMMIT;
                 END IF;
                    END;
               IF D_giorno = D_fine_sett THEN
                   D_dep_festivita := d_festivita;
                    BEGIN
                     SELECT NVL(MAX(1),0)
                       INTO D_dep_festivita
                      FROM CALENDARI cale
                      WHERE (    cale.calendario = D_calendario
                             AND cale.anno       = TO_NUMBER(TO_CHAR(D_giorno,'yyyy'))
                            AND cale.mese       = TO_NUMBER(TO_CHAR(D_giorno,'mm'))
                            AND SUBSTR(cale.giorni,TO_NUMBER(TO_CHAR(D_giorno,'dd')),1) IN
                               (SELECT 'D' FROM dual
                                UNION
                               SELECT 'S' FROM dual
                              )
                          )
                        OR D_giorno = TO_DATE('0411'||cale.anno,'ddmmyyyy')
                     ;
                   EXCEPTION WHEN NO_DATA_FOUND THEN D_dep_festivita := D_festivita;
                   END;
                  IF D_festivita = 0 THEN
                     D_festivita := D_dep_festivita;
                  END IF;
                 D_dep_tipo_ass := D_tipo_ass;
                 D_dep_giorni   := D_giorni;
                      ASSENZE (D_giorno, D_anno, INDI.ci, D_assistenza,
                          D_causale, D_dal, D_al, D_evento, D_assenza, D_per_ret, D_tipo_ass, D_giorni);
                      D_giorni   := D_dep_giorni;
                      IF D_causale IS NULL THEN
                      D_tipo_ass := D_dep_tipo_ass;
                   D_per_ret := 100;
                  IF D_gg_lavoro > 26 OR TO_CHAR(D_giorno,'day') NOT LIKE 'sunday%' THEN
                      RETRIBUZIONE (INDI.ci, D_anno, D_giorno , D_contratto, D_per_ret, D_retribuzione, D_imp_gg, D_imp_acce);
                      D_importo_rid := D_importo_rid + (D_rap_ore * NVL(D_imp_gg,0)) + D_imp_acce;
                        END IF;
                 ELSE
                  IF D_gg_lavoro > 26 OR TO_CHAR(D_giorno,'day') NOT LIKE 'sunday%' THEN
                      RETRIBUZIONE (INDI.ci, D_anno, D_giorno , D_contratto, D_per_ret, D_retribuzione, D_imp_gg, D_imp_acce);
                      D_importo_rid := D_importo_rid + (D_rap_ore * NVL(D_imp_gg,0)) + D_imp_acce;
                        END IF;
                   D_giorni_ass  := D_giorni_ass + (100 - D_per_ret)/100;
                  IF D_tipo_ass LIKE '%1%' THEN
                    D_giorni_s1 := D_giorni_s1 + 1;
                  END IF;
                      END IF;
                   D_STP := D_giorno||' '||D_tipo_ass||' '||d_per_ret||' '||d_importo_rid;
                     Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
                 COMMIT;
               END IF;
                  END LOOP; -- Giorni della settimana
              IF P_retribuzione <> 'I' AND D_giorni_ass < 7 THEN
               D_sett_rid   := D_sett_rid + 1;
               IF D_tipo_ass LIKE '%DOS%' THEN
                 D_sett_ds := D_sett_ds + 1;
                END IF;
               IF D_tipo_ass LIKE '%MAL%' AND D_giorni >= 7 THEN
                 D_sett2_mal := D_sett2_mal + 1;
               END IF;
               IF D_tipo_ass LIKE '%MAT%' THEN --AND D_giorni >= 7 THEN
                 D_sett2_mat := D_sett2_mat + 1;
               END IF;
               IF D_tipo_ass LIKE '%M53%' THEN --AND D_giorni >= 7 THEN
                 D_sett2_m53 := D_sett2_m53 + 1;
               END IF;
               IF D_tipo_ass LIKE '%M151%' THEN --AND D_giorni >= 7 THEN
                 D_sett2_m151 := D_sett2_m151 + 1;
               END IF;
               IF D_tipo_ass LIKE '%M88%' THEN --AND D_giorni >= 7 THEN
                 D_sett2_m88 := D_sett2_m88 + 1;
               END IF;
                   D_STP := D_giorno||' x '||D_sett2_m53||' '||D_festivita||' '||D_giorni_ass||' '||D_giorni||' '||d_sett_rid||' '
                          ||d_sett2_mal||' '||d_sett1_mal||' '||d_sett2_mat||' '||d_sett1_mat||' '||d_sett_ds;
                     Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
                 COMMIT;
               ELSIF P_retribuzione <> 'I' AND D_giorni_ass >= 7 THEN
                /* Settimana interamente coperta */
               IF D_tipo_ass LIKE '%MAL%' THEN
                 IF D_festivita = 0 THEN
                   D_sett1_mal := D_sett1_mal + 1;
                 ELSE
                      D_sett2_mal := D_sett2_mal + 1;
                   D_sett_rid  := D_sett_rid + 1;
                 END IF;
               END IF;
               IF D_tipo_ass LIKE '%MAT%' THEN
                 IF D_festivita = 0 THEN
                   D_sett1_mat := D_sett1_mat + 1;
                 ELSE
                      D_sett2_mat := D_sett2_mat + 1;
                   D_sett_rid  := D_sett_rid + 1;
                 END IF;
               END IF;
               IF D_tipo_ass LIKE '%M53%' THEN
                 IF D_festivita = 0 THEN
                   D_sett1_m53 := D_sett1_m53 + 1;
                 ELSE
                      D_sett2_m53 := D_sett2_m53 + 1;
                   D_sett_rid  := D_sett_rid + 1;
                 END IF;
               END IF;
               IF D_tipo_ass LIKE '%M151%' THEN
                 IF D_festivita = 0 THEN
                   D_sett1_m151 := D_sett1_m151 + 1;
                 ELSE
                      D_sett2_m151 := D_sett2_m151 + 1;
                   D_sett_rid  := D_sett_rid + 1;
                 END IF;
               END IF;
               IF D_tipo_ass LIKE '%M88%' THEN
                 IF D_festivita = 0 THEN
                   D_sett1_m88 := D_sett1_m88 + 1;
                 ELSE
                      D_sett2_m88 := D_sett2_m88 + 1;
                   D_sett_rid  := D_sett_rid + 1;
                 END IF;
               END IF;
                   D_STP := D_giorno||' '||D_festivita||' '||D_giorni_ass||' '||D_giorni||' '||d_sett_rid||
                          ' '||d_sett2_mal||' '||d_sett1_mal||' '||d_sett2_mat||' '||d_sett1_mat||' '||d_sett_ds;
                     Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
                 COMMIT;
              END IF;
              IF P_retribuzione = 'I' AND D_giorni_s1 < 7 THEN
               D_sett_rid   := D_sett_rid + 1;
               IF D_tipo_ass LIKE '%DOS%' THEN
                 D_sett_ds := D_sett_ds + 1;
                END IF;
               IF D_tipo_ass LIKE '%MAL%' AND D_giorni >= 7 THEN
                 D_sett2_mal := D_sett2_mal + 1;
               END IF;
               IF D_tipo_ass LIKE '%MAT%' then --AND D_giorni >= 7 THEN
                 D_sett2_mat := D_sett2_mat + 1;
               END IF;
               IF D_tipo_ass LIKE '%M53%' THEN --AND D_giorni >= 7 THEN
                 D_sett2_m53 := D_sett2_m53 + 1;
               END IF;
               IF D_tipo_ass LIKE '%M151%' then --AND D_giorni >= 7 THEN
                 D_sett2_m151 := D_sett2_m151 + 1;
               END IF;
               IF D_tipo_ass LIKE '%M88%' then --AND D_giorni >= 7 THEN
                 D_sett2_m88 := D_sett2_m88 + 1;
               END IF;
                   D_STP := D_giorno||' x '||D_sett2_m53||' '||D_festivita||' '||D_giorni_s1||' '||d_sett_rid||' '
                          ||d_sett2_mal||' '||d_sett1_mal||' '||d_sett2_mat||' '||d_sett1_mat||' '||d_sett_ds;
                     Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
                 COMMIT;
               ELSIF P_retribuzione = 'I' AND D_giorni_s1 >= 7 THEN
                /* Settimana interamente coperta */
               IF D_tipo_ass LIKE '%MAL%' THEN
                 IF D_festivita = 0 THEN
                   D_sett1_mal := D_sett1_mal + 1;
                 ELSE
                      D_sett2_mal := D_sett2_mal + 1;
                   D_sett_rid  := D_sett_rid + 1;
                 END IF;
               END IF;
               IF D_tipo_ass LIKE '%MAT%' THEN
                 IF D_festivita = 0 THEN
                   D_sett1_mat := D_sett1_mat + 1;
                 ELSE
                      D_sett2_mat := D_sett2_mat + 1;
                   D_sett_rid  := D_sett_rid + 1;
                 END IF;
               END IF;
               IF D_tipo_ass LIKE '%M53%' THEN
                 IF D_festivita = 0 THEN
                   D_sett1_m53 := D_sett1_m53 + 1;
                 ELSE
                      D_sett2_m53 := D_sett2_m53 + 1;
                   D_sett_rid  := D_sett_rid + 1;
                 END IF;
               END IF;
               IF D_tipo_ass LIKE '%M151%' THEN
                 IF D_festivita = 0 THEN
                   D_sett1_m151 := D_sett1_m151 + 1;
                 ELSE
                      D_sett2_m151 := D_sett2_m151 + 1;
                   D_sett_rid  := D_sett_rid + 1;
                 END IF;
               END IF;
               IF D_tipo_ass LIKE '%M88%' THEN
                 IF D_festivita = 0 THEN
                   D_sett1_m88 := D_sett1_m88 + 1;
                 ELSE
                      D_sett2_m88 := D_sett2_m88 + 1;
                   D_sett_rid  := D_sett_rid + 1;
                 END IF;
               END IF;
                   D_STP := D_giorno||' x '||D_sett2_m53||' '||D_festivita||' '||D_giorni_s1||' '||d_sett_rid||
                          ' '||d_sett2_mat||' '||d_sett1_mat||' '||d_sett2_mat||' '||d_sett1_mat||' '||d_sett_ds;
                     Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
                 COMMIT;
              END IF;
            END;
              d_giorno := d_giorno + 1;
           ELSE
                 d_giorno := d_fine_sett + 1;
              END IF;
          END LOOP; -- Giorni
      END;
      END;
        D_STP := 'Scrive D1IS: sett_d '||D_sett_rid;
         Trace.LOG_TRACE(0,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
        COMMIT;
      IF P_retribuzione = 'I' THEN
      -- Determinare le mensilita da considerare in base al periodo dell'O1/M che stiamo calcolando
         d_da_mese := TO_NUMBER(TO_CHAR(INDI.dal,'mm'));
        d_a_mese  := TO_NUMBER(TO_CHAR(INDI.al,'mm'));
        BEGIN
          SELECT NVL(SUM(imp),0)
           INTO D_anticipazioni
           FROM MOVIMENTI_CONTABILI moco
          WHERE anno = d_anno
            AND ci   = INDI.ci
               AND moco.riferimento BETWEEN INDI.dal
                                     AND INDI.al
            AND (voce,sub) IN (SELECT voce,sub
                                 FROM ESTRAZIONE_RIGHE_CONTABILI
                           WHERE estrazione = 'DENUNCIA_O1_INPS'
                             AND colonna    = 'ANT_INPS'
                            AND d_anno     BETWEEN TO_NUMBER(TO_CHAR(dal,'yyyy'))
                                               AND TO_NUMBER(TO_CHAR(NVL(al,TO_DATE(3333333,'j')),'yyyy'))
                         )
          ;
        EXCEPTION WHEN NO_DATA_FOUND THEN D_anticipazioni := 0;
        END;
                   D_STP := 'Totali '||D_importo_rid||' '||d_anticipazioni;
                     Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
                 COMMIT;
        D_importo_rid := D_importo_rid - D_anticipazioni;
      END IF;
  /* Aggiornamento dei campi della tabella DENUNCIA_O1_INPS con i valori calcolati.
     Assestamento delle settimane del quadro B
     Riduciamo le settimane già calcolate della quantità delle
     diverse settimane 1
  */
      UPDATE DENUNCIA_O1_INPS x
      SET (   SETT_D
             ,IMPORTO_RID_D
            ,SETT1_MAL_D
            ,SETT2_MAL_D
            ,SETT1_MAT_D
            ,SETT2_MAT_D
            ,SETT1_M88_D
            ,SETT2_M88_D
            ,SETT2_DDS_D
               ,SETT1_M53_D
               ,SETT2_M53_D
               ,SETT1_DL151_D
               ,SETT2_DL151_D
               ,SETTIMANE                                -- settimane del quadro B
			   ,GIORNI                                   -- giorni    del quadro B
         ) = (SELECT  D_sett_rid
                     ,D_importo_rid
                  ,D_sett1_mal
                  ,D_sett2_mal
                  ,D_sett1_mat
                  ,D_sett2_mat
                  ,D_sett1_m88
                  ,D_sett2_m88
                  ,D_sett_ds
                  ,D_sett1_m53
                  ,D_sett2_m53
                  ,D_sett1_m151
                  ,D_sett2_m151
                  ,greatest( 0
                            ,  nvl(x.settimane,0)
                             - nvl(D_sett1_mal,0)
                             - nvl(D_sett1_mat,0)
                             - nvl(D_sett1_m88,0)
                             - nvl(D_sett1_m53,0)
                             - nvl(D_sett1_m151,0)
                           )
                  ,greatest( 0
                            ,  nvl(x.giorni,0)
                             - nvl(D_sett1_mal,0) * 6
                             - nvl(D_sett1_mat,0) * 6
                             - nvl(D_sett1_m88,0) * 6
                             - nvl(D_sett1_m53,0) * 6
                             - nvl(D_sett1_m151,0) * 6
                           )
                   FROM  dual
            )
       WHERE  ci                = INDI.ci
         AND  NVL(dal,INDI.dal_upd) = INDI.dal_upd
         AND  gestione          = INDI.GESTIONE
         AND  anno              = d_anno
       ;
     COMMIT;
      END LOOP; -- Individui
 IF P_assestamento = 'X' THEN
     BEGIN
     update denuncia_o1_inps x
     set importo_c1 = nvl(importo_c1,0)
       , importo_pen_c1 = ''
       , tipo_c1 = 'Z4'
       , importo_c2 = ''
       , importo_c3 = ''
       , importo_c4 = ''
       , importo_pen_c2 = ''
       , importo_pen_c3 = ''
       , importo_pen_c4 = ''
       , tipo_c2 = ''
       , tipo_c3 = ''
       , tipo_c4 = ''
       , dal_c1 = ''
       , dal_c2 = ''
       , dal_c3 = ''
       , dal_c4 = ''
       , al_c1 = ''
       , al_c2 = ''
       , al_c3 = ''
       , al_c4 = ''
     where anno = D_anno
       and ci in ( select ci
                     from periodi_retributivi pere
                    where pere.periodo between to_date('0101'||D_anno,'ddmmyyyy')
                                           and to_date('3112'||D_anno,'ddmmyyyy')
                      and trattamento = 'R96'
                 );
     update denuncia_o1_inps x
        set dal_c2 = to_date('0101'||to_char(D_anno-1),'ddmmyyyy')
           , al_c2 = to_date('3112'||to_char(D_anno-1),'ddmmyyyy')
       where anno  = D_anno
         and tipo_c2 = 'X4'
         and nvl(importo_c2,0) + nvl(importo_pen_c2,0) != 0
     ;
     update denuncia_o1_inps x
     set dal_c3 = to_date('0101'||to_char(D_anno-2),'ddmmyyyy')
       , al_c3 = to_date('3112'||to_char(D_anno-2),'ddmmyyyy')
     where anno = D_anno
       and tipo_c1 = 'X4'
       and tipo_c2 = 'X4'
       and tipo_c3 = 'X4'
     ;
	 END;
  END IF; -- fine assestamento

IF P_spezza = 'X' THEN
/* modifica del 04/03/05 */
BEGIN
<<SPEZZA>>
     for CUR_CI in
     ( select distinct ci, anno, dal, al
         from denuncia_o1_inps d1is
        where anno = D_anno
          and tipo_c1 = 'X4'
          and exists ( select 'x' from denuncia_o1_inps
                       where ci = d1is.ci
                          and anno = d1is.anno
                          and tipo_c2 = 'X4'
                          and tipo_c3 = 'X4'
                      )
     )
     loop
--dbms_output.put_line('CI : '||cur_ci.ci);
     V_valore2 := 0;
     V_valore3 := 0;
     V_valore_p2 := 0;
     V_valore_p3 := 0;
      BEGIN
      select round( sum( vaca.valore
                      *decode(to_char(riferimento,'yyyy'),D_anno-1,1,0) )
                     / max(nvl(esvc.arrotonda,0.01))
                   ) * max(nvl(esvc.arrotonda,0.01))                       retr_2
           , round ( sum( vaca.valore
                      *decode(to_char(riferimento,'yyyy'),D_anno-1,1,0) )
                   / nvl(max( nvl(esvc.arrotonda,0.01)),1)
               )  * nvl(max(nvl(esvc.arrotonda,0.01)),1)                       pens_2
           , round( sum( vaca.valore
                      *decode(to_char(riferimento,'yyyy'),D_anno,0,D_anno-1,0,1))
                     / max(nvl(esvc.arrotonda,0.01))
                   ) * max(nvl(esvc.arrotonda,0.01))                       retr_3
           , round ( sum( vaca.valore
                    * decode(to_char(riferimento,'yyyy'),D_anno,0,D_anno-1,0,1))
                   / nvl(max( nvl(esvc.arrotonda,0.01)),1)
                   )  * nvl(max(nvl(esvc.arrotonda,0.01)),1)                       pens_3
         into V_valore2, V_valore_p2, V_valore3, V_valore_p3
         from valori_contabili_annuali vaca
            , estrazione_valori_contabili esvc
        where vaca.estrazione = 'DENUNCIA_O1_INPS'
          and vaca.colonna  = 'QC_ARR_AP'
          and vaca.ci = CUR_CI.ci
          and anno = CUR_CI.anno
          and vaca.mese       = 12
          and vaca.mensilita  = (select max(mensilita) from mensilita
                                  where mese = 12
                                    and tipo in ('S','N','A'))
          and esvc.estrazione     = vaca.estrazione
          and esvc.colonna        = vaca.colonna
          and greatest( nvl(vaca.riferimento,to_date('2222222','j'))
                      , least( to_date('01'||to_char(CUR_CI.anno),'mmyyyy')
                             , nvl(CUR_CI.al,to_date('3333333','j'))
                            )
                     ) between CUR_CI.dal
                           and nvl(CUR_CI.al,to_date('3333333','j'))
          and nvl(vaca.valore,0) != 0
          and last_day ( to_date( lpad(vaca.moco_mese,2,'0') || CUR_CI.anno ,'mmyyyy') )
              between CUR_CI.dal
                           and nvl(CUR_CI.al,to_date('3333333','j'))
          and  nvl(vaca.riferimento,to_date('2222222','j'))
               between esvc.dal and nvl(esvc.al,to_date('3333333','j'))
         ;
        END;
-- dbms_output.put_line('1/2/3: '||V_valore1||'/'||V_valore2||'/'||V_valore3);
        BEGIN
        update denuncia_o1_inps d1is
           set importo_c3 = nvl(V_valore3,0)
             , importo_c2 = nvl(V_valore2,0)
             , importo_c1 = importo_c1 - nvl(V_valore2,0) - nvl(V_valore3,0)
             , importo_pen_c3 = nvl(V_valore_p3,0)
             , importo_pen_c2 = nvl(V_valore_p2,0)
             , importo_pen_c1 = importo_pen_c1 - nvl(V_valore_p2,0)- nvl(V_valore_p3,0)
        where anno = D_anno
          and tipo_c1 = 'X4'
          and ci = CUR_CI.ci
          and dal = CUR_CI.dal
          and al = CUR_CI.al
          and exists ( select 'x' from denuncia_o1_inps
                       where ci = d1is.ci
                          and anno = d1is.anno
                          and tipo_c2 = 'X4'
                          and tipo_c3 = 'X4'
                      )
         ;
        commit;
        END;
      END LOOP; -- cur_ci
/* modifica per Acft */
  for CUR_CI1 in
     ( select distinct ci, dal, al
         from denuncia_o1_inps d1is
        where anno = D_anno
          and dal = ( select max(dal)
                       from denuncia_o1_inps
                      where anno = d1is.anno
                        and ci = d1is.ci
                    )
     )
     LOOP
       V_valore_pap := 0;
        BEGIN
          select sum(nvl(imp,0))
            into V_valore_pap
            from movimenti_contabili
           where ci = CUR_CI1.ci
             and anno = D_anno + 1
             and mese = 1
             and mensilita != '*AP'
             and voce = 'CPAP'
             and to_char(riferimento,'yyyy') = D_anno;
        EXCEPTION WHEN NO_DATA_FOUND THEN
           V_valore_pap := null;
        END;
        BEGIN
        update denuncia_o1_inps d1is
           set importo_cc = nvl(importo_cc,0) + nvl(V_valore_pap,0)
             , importo_c1 = nvl(importo_c1,0) + nvl(V_valore_pap,0)
             , importo_pen_c1 = nvl(importo_pen_c1,0) + nvl(V_valore_pap,0)
        where anno = D_anno
          and tipo_c1 = 'X4'
          and ci = CUR_CI1.ci
          and dal = CUR_CI1.dal
          and al = CUR_CI1.al
         ;
        update denuncia_o1_inps d1is
           set importo_cc = nvl(importo_cc,0) + nvl(V_valore_pap,0)
             , importo_c1 = nvl(importo_c1,0) + nvl(V_valore_pap,0)
        where anno = D_anno
          and tipo_c1 = 'Z4'
          and ci = CUR_CI1.ci
          and dal = CUR_CI1.dal
          and al = CUR_CI1.al
         ;
        commit;
        END;
    END LOOP; --cur_ci1
/* fine modifica per ACFT */
   END SPEZZA;
/* fine modifica del 04/03/2005 */
END IF; -- controllo p_spezza
IF P_assestamento = 'X' or P_spezza = 'X' THEN
     BEGIN
     update denuncia_o1_inps x
     set importo_c1 = round(importo_c1)
       , importo_c2 = round(importo_c2)
       , importo_c3 = round(importo_c3)
       , importo_c4 = round(importo_c4)
       , importo_pen_c1 = round(importo_pen_c1)
       , importo_pen_c2 = round(importo_pen_c2)
       , importo_pen_c3 = round(importo_pen_c3)
       , importo_pen_c4 = round(importo_pen_c4)
     where anno = D_anno
     ;
     update denuncia_o1_inps x
     set importo_c1 = round(importo_c1)
       , importo_c2 = round(importo_c2)
       , importo_c3 = round(importo_c3)
       , importo_c4 = round(importo_c4)
       , importo_pen_c1 = round(importo_pen_c1)
       , importo_pen_c2 = round(importo_pen_c2)
       , importo_pen_c3 = round(importo_pen_c3)
       , importo_pen_c4 = round(importo_pen_c4)
     where anno = D_anno
     ;
     END;
     update denuncia_o1_inps x
        set tipo_c1 = ''
          , importo_c1= '', importo_pen_c1 = ''
          , dal_c1 = ''
          , al_c1 = ''
     where anno = D_anno
       and nvl(importo_c1,0) + nvl(importo_pen_c1,0) = 0
     ;
     update denuncia_o1_inps x
        set tipo_c2 = ''
          , importo_c2 = '' , importo_pen_c2 = ''
          , dal_c2 = ''
          , al_c2 = ''
     where anno = D_anno
       and nvl(importo_c2,0) + nvl(importo_pen_c2,0) = 0
     ;
     update denuncia_o1_inps x
        set tipo_c3 = ''
          , importo_c3 = '', importo_pen_c3 = ''
          , dal_c3 = ''
          , al_c3 = ''
     where anno = D_anno
       and nvl(importo_c3,0) + nvl(importo_pen_c3,0) = 0
     ;
     update denuncia_o1_inps x
        set tipo_c4 = ''
          , importo_c4 = '', importo_pen_c4 = ''
          , dal_c4 = ''
          , al_c4 = ''
     where anno = D_anno
       and nvl(importo_c4,0) + nvl(importo_pen_c4,0) = 0
     ;
    commit;
 END IF;
   END;
   BEGIN  --
      D_STP := 'CARICA-03';
      Trace.LOG_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,SQL%ROWCOUNT,D_TIM);
   END;
   BEGIN  -- CICLO SU MOVIMENTI DI BILANCIO
      D_STP := 'CARICA-04';
      BEGIN  -- OPERAZIONI FINALI PER TRACE
         D_STP := 'Pecco1md-STOP';
         Trace.LOG_TRACE(1,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM_TOT);
         IF errore != 'P05808' THEN  -- SEGNALAZIONE
            errore := 'P05802';      -- ELABORAZIONE COMPLETATA
         END IF;
        COMMIT;
      END;
   END;
EXCEPTION
   WHEN OTHERS THEN
      Trace.ERR_TRACE(D_TRC,D_PRN,D_PAS,D_PRS,D_STP,0,D_TIM);
      errore := 'P05809';   -- ERRORE IN ELABORAZIONE
      err_passo := D_stp;   -- Step errato
END;
END;
PROCEDURE retribuzione (P_ci         IN  NUMBER,
                   D_anno      IN    NUMBER,
                      P_giorno     IN  DATE,
                  P_contratto  IN  VARCHAR2,
                  P_per_ret    IN  NUMBER,
                  P_tipo_ret   IN  VARCHAR2,
                  P_importo    IN OUT NUMBER,
                  P_imp_acce   IN OUT NUMBER) IS
P_anno       NUMBER;
D_mese       NUMBER;
D_mensilita  VARCHAR2(3);
D_stp        VARCHAR2(80);
D_tim        DATE;
D_Prs        NUMBER;
D_fisse      NUMBER;
D_accessorie NUMBER;
--
BEGIN
  D_fisse      := 0;
  D_accessorie := 0;
  P_importo    := NULL;
  IF P_importo IS NULL THEN
    BEGIN
        SELECT (SUM(inre.tariffa)/MAX(cost.gg_lavoro))/100*P_per_ret --percentuale da altra fonte (CAEV)
         INTO D_fisse
         FROM INFORMAZIONI_RETRIBUTIVE inre
             ,CONTRATTI_STORICI        cost
        WHERE P_giorno  BETWEEN NVL(inre.dal,TO_DATE(2222222,'j'))
                            AND NVL(inre.al,TO_DATE(3333333,'j'))
          AND inre.ci         = P_ci
          AND inre.voce      IN (SELECT voce
                                  FROM TOTALIZZAZIONI_VOCE
                           WHERE voce_acc IN
                                (SELECT voce FROM ESTRAZIONE_RIGHE_CONTABILI
                                WHERE estrazione = 'DENUNCIA_O1_INPS'
                                  AND colonna    = 'IMP_INPS'
                               )
                         )
          AND cost.contratto  = P_contratto
          AND P_giorno  BETWEEN NVL(cost.dal,TO_DATE(2222222,'j'))
                            AND NVL(cost.al,TO_DATE(3333333,'j'))
       ;
   EXCEPTION WHEN NO_DATA_FOUND THEN D_fisse := 0;
   END;
   P_importo := D_fisse;
   IF P_tipo_ret = 'E' THEN/* Calcolo anche le competenze accessorie */
        BEGIN
          SELECT TO_NUMBER(TO_CHAR(P_giorno,'yyyy'))
               ,mese
              ,MENSILITA
           INTO P_anno
               ,D_mese
              ,D_mensilita
           FROM MENSILITA
          WHERE mese = TO_NUMBER(TO_CHAR(P_giorno,'mm'))
            AND tipo = 'N'
         ;
            SELECT NVL((SUM(moco.imp)/MAX(cost.gg_lavoro)),0)/100*P_per_ret --percentuale da altra fonte (CAEV)
             INTO D_accessorie
             FROM MOVIMENTI_CONTABILI moco
                 ,CONTRATTI_STORICI   cost
            WHERE moco.anno       = P_anno
            AND moco.mese       = D_mese
            AND moco.MENSILITA  = D_mensilita
              AND moco.ci         = P_ci
               AND moco.voce      IN (SELECT voce
                                       FROM TOTALIZZAZIONI_VOCE
                                WHERE voce_acc IN
                                     (SELECT voce FROM ESTRAZIONE_RIGHE_CONTABILI
                                     WHERE estrazione = 'DENUNCIA_O1_INPS'
                                       AND colonna    = 'IMP_INPS'
                                    )
                              )
            AND moco.input     IN (SELECT 'A' FROM dual UNION SELECT 'P' FROM dual UNION SELECT 'I' FROM dual)
              AND cost.contratto  = P_contratto
              AND P_giorno  BETWEEN NVL(cost.dal,TO_DATE(2222222,'j'))
                                AND NVL(cost.al,TO_DATE(3333333,'j'))
           ;
       EXCEPTION WHEN NO_DATA_FOUND THEN D_accessorie := 0;
       END;
   END IF; -- controllo P_tipo_ret
   P_imp_acce := D_accessorie;
  END IF; -- controllo su  P_importo
END RETRIBUZIONE;
END;
/
