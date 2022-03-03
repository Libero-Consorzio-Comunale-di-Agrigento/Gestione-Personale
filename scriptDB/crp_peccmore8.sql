CREATE OR REPLACE PACKAGE Peccmore8 IS
/******************************************************************************
 NOME:        Peccmore8
 DESCRIZIONE: Calcolo VOCI TFR
              Calcolo VOCI Imponibile
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1    28/04/2004 MF     Inserimento Group By su:
                        - eventuale data AL di Rapporto di Lavoro
                        - estremi delibera in determinazione degli Imponibili
                        (VOCI_IMPONIBILE-02) comprensivi del TIPO delibera.
 2    09/07/2004 NN     Uniformate date di riferimento e competenza anche
                        in caso di imponibili per delibera.
 3    29/11/2004 AM     in caso di conguaglio giuridico con contestuale cambio del
                        trattamento previdenziale, non effettuava correttamente i
                        recuperi di ritenuta
 4    01/12/2004 NN     Attivato frazionamento Imponibili sulla base del flag.
 4.1  15/12/2004 AM     modifiche per miglior utilizzo degli indici
 4.2  03/01/2005 MM	modifiche alle condizioni di accesso a mesi per determinare
                        l'ALQ_TFR dei cessati a dicembre liquidati a gennaio
 4.3  18/02/2005 AM NN  calcolo dei minimali: modificata la determinazione del periodo
                        da cui estrae i giorni per rapportare il minimale: prima analizzava
                        i periodi per le storicità di IMVO, adesso analizza i periodi
                        sulla base di quanto determinato dal cursore (la specie T
                        potrebbe determinare riferimenti inferiori alla storicità di IMVO).
                        Inoltre vincolata l'applicazione del minimale / massimale alla
                        presenza di un ipn_tot diverso da zero
 4.4 14/04/2005 AM      Scomposizione degli imponibili con specie 'T' anche per voci
                        comunicate da variabili senza contestuale conguaglio giuridico (quindi senza
                        il relativo PERE)
 4.5 23/05/2005 NN      Nel caso di imponibili con specie = 'T' (frazionati x riferimento),
                        le voci con classe = 'C' (tranne se con specie = 'T' e rapporto != 'O')
                        totalizzate in essi, vengono comunque sommate e NON mantengono
                        il riferimento originario (es. voci di 13A).
 4.6 10/06/2005 NN      Nel caso di imponibile derivato solo da fiscale = 'L' viene raddoppiato
                        il valore.
 4.7 30/06/2005 NN      Nel trattamento degli imponibili, legge pere con il periodo di temp_caco_pere,
                        solo per voci con specie = 'T'.
 4.8 01/07/2005 NN      Calcolo dei minimali : nel caso di minimale giornaliero, non proporzionava
                        gli importi di eventuali più record della stessa voce di imponibile al totale,
                        quindi allineava erroneamente tutti gli importi al minimale, non solo la loro somma.
 4.9 27/07/2005 NN      Non venivano totalizzate nell'imponibile voci con riferimento di un mese previsto
                        in pere, ma non compreso nel dal/al (es. rif.voce=31/12, pere: dal=01/12 al = 24/12)
4.10 07/09/2005 NN      Gestione tabella imponibili_assenza per corretta contribuzione in base alla
                        tipologia dell'assenza e all'istituto (voce).
4.11 27/10/2005 NN      Assestava al minimale anche se imponibile negativo.
4.12 09/11/2005 NN      Nel trattamento degli imponibili, legge pere con il periodo di temp_caco_pere,
                        ANCHE per voci con specie NON 'T'.
4.13 16/11/2005 NN      Smembrata join per calcolo imponibili utilizzando la table temp_pere_ipn.
4.14 19/12/2005 NN      Il trattamento previdenziale deve sempre essere quello valido alla data di
                        elaborazione.
4.15 12/01/2006 NN-AM   Non trattava voci con riferimento non compreso in nessun record di pere
                        (ad es. voci di 13A recuperate dopo aver indicato la cessazione).
 5   25/01/2006 NN-AM   Smembrato cursore "X" per calcolo imponibili: 1^ (CUR_IMVO) cursore definisce gli ipn
                        che devono essere calcolati per il dipendente, il calcolo rimane nel cursore X che
                        però tratta 1 solo ipn alla volta. Inoltre spostati su TEPI alcuni valori precalcolati
 5.1 15/06/2006 NN      La modifica del 12/01 ha provocato l'errato calcolo degli imponibili in caso di incarico.
                        Corretta la join tra caco e pere.
 5.2 22/06/2006 ML      Modificato il cursore (A16730).
 5.3 06/09/2006 AM      Mod. il calcolo ipn in caso di solo ipn_l e centesimi in ipn_c
 5.4 28/11/2006 AM      Mod. per la gestione della delibera (con scorporo contributi) da DCOVO
 5.5 18/01/2007 AM      In alcun casi di conguaglio di conguaglio i rec. in recupero (input minuscoli)
                        venivano associati a 2 record di PERE; il caso si è reso possibile a seguito della mod.
                        del  15/06/2006  che ha tolto la condizine di caco.riferimento between pere.dal e pere.al
                        dalla query principale: va quindi riproposta nel caso ristretto del rec. 'P'
 5.6 04/04/2007 MM      Allo step VOCI_TFR-02, modificata la select dell'aliquota d_alq da MESI. Se l'aliquota del
                        mese è 0, preleva l'aliquota più recente non nulla e diversa da 0, in pratica la massima
                        aliquota dei mesi precedenti nell'ambito dell'anno (come già fa sulla PECCRTFR). (A6557)
 5.7 02/05/2007 NN      Modificato cursore imponibili per riportare la competenza delle voci anche nel caso di
                        specie = 'T' (Att. 9942).
 5.8 27/09/2007 NN      Gestito il nuovo campo pere.delibera
**************************************************************************************************************/
revisione varchar2(30) := '5.8 del 27/09/2007';
FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);
PROCEDURE voci_tfr
(
  P_ci          NUMBER
, P_al          DATE    -- Data di Termine o Fine Mese
, P_anno        NUMBER
, P_mese        NUMBER
, P_mensilita   VARCHAR2
, P_fin_ela     DATE
--  Voci parametriche
, P_riv_tfr     VARCHAR2
, P_ret_tfr     VARCHAR2
, P_qta_tfr     VARCHAR2
, P_rit_tfr     VARCHAR2
, P_rit_riv     VARCHAR2
, P_lor_tfr     VARCHAR2
, P_lor_tfr_00     VARCHAR2
, P_lor_riv     VARCHAR2
-- Parametri per Trace
,p_trc    IN     NUMBER     -- Tipo di Trace
,p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
);
  PROCEDURE voci_imponibile
(
 p_ci           NUMBER
,p_anno_ret      NUMBER
,p_al           DATE    -- Data di Termine o Fine Mese
,p_anno         NUMBER
,p_mese         NUMBER
,p_mensilita     VARCHAR2
,p_fin_ela       DATE
,p_tipo         VARCHAR2
,p_conguaglio    NUMBER
,p_mens_codice   VARCHAR2
,p_periodo       VARCHAR2
,p_cassa_competenza VARCHAR2    -- 02/05/2007
-- Parametri per Trace
,p_trc    IN     NUMBER     -- Tipo di Trace
,p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
);
END;
/
CREATE OR REPLACE PACKAGE BODY Peccmore8 IS
form_trigger_failure EXCEPTION;
FUNCTION VERSIONE  RETURN varchar2 IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
   RETURN 'V1.'||revisione;
END VERSIONE;
--Valorizzazione Voci di Trattamento Fine Rapporto
PROCEDURE voci_tfr
(
  P_ci          NUMBER
, P_al          DATE    -- Data di Termine o Fine Mese
, P_anno        NUMBER
, P_mese        NUMBER
, P_mensilita   VARCHAR2
, P_fin_ela     DATE
--  Voci parametriche
, P_riv_tfr     VARCHAR2
, P_ret_tfr     VARCHAR2
, P_qta_tfr     VARCHAR2
, P_rit_tfr     VARCHAR2
, P_rit_riv     VARCHAR2
, P_lor_tfr     VARCHAR2
, P_lor_tfr_00     VARCHAR2
, P_lor_riv     VARCHAR2
-- Parametri per Trace
,p_trc    IN     NUMBER     -- Tipo di Trace
,p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
) IS
D_imp                CALCOLI_CONTABILI.imp%TYPE;
D_riduce_qta_tfr     CALCOLI_CONTABILI.imp%TYPE;
D_alq                NUMBER;
BEGIN
  IF P_ret_tfr IS NOT NULL THEN
     BEGIN  --Acquisizione Valore di Retribuzione per TFR del mese
        P_stp := 'VOCI_TFR-01';
        SELECT NVL(SUM(imp),0)
         INTO D_imp
         FROM CALCOLI_CONTABILI
        WHERE ci    = P_ci
          AND voce  = P_ret_tfr
        ;
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
            D_imp := 0;
     END;
  END IF;
  IF P_riv_tfr IS NOT NULL
  OR P_qta_tfr IS NOT NULL
  OR P_lor_tfr IS NOT NULL
  OR P_lor_tfr_00 IS NOT NULL
  OR P_lor_riv IS NOT NULL THEN
     BEGIN  --Preleva Aliquota Rivalutazione ISTAT
        P_stp := 'VOCI_TFR-02';
        SELECT NVL(alq_tfr,0)
         INTO D_alq
         FROM MESI
        WHERE anno   = nvl(TO_CHAR(P_al - 14, 'yyyy'),P_anno)
          AND mese   = nvl(TO_CHAR(P_al - 14, 'mm'),P_mese)
        ;
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
            D_alq := 0;
     END;
     IF D_alq = 0 THEN
		   BEGIN
		     select max(nvl(alq_tfr,0))
			     into D_alq
			     from mesi
			    where anno = P_anno
			      and mese <= P_mese
			      and mese < to_char(P_al - 14, 'mm')
			 ;
		   EXCEPTION
		     WHEN no_data_found THEN D_alq := 0;
		   END;
     END IF;
     -- dbms_output.put_line('------ Calcolo rivalutazione ------  D_alq '||D_alq);
     DECLARE
     D_fdo_tfr_ap          NUMBER;
     D_fdo_tfr_ap_liq      NUMBER;
     D_fdo_tfr_2000        NUMBER;
     D_fdo_tfr_2000_liq    NUMBER;
     D_riv_tfr             NUMBER;
     D_riv_tfr_liq         NUMBER;
     D_riv_tfr_ap          NUMBER;
     D_riv_tfr_ap_liq      NUMBER;
     D_ret_tfr             NUMBER;
     D_qta_tfr_ac          NUMBER;
     D_qta_tfr_ac_liq      NUMBER;
     D_riv_tfr_assenze     NUMBER;
     D_riv_tfr_liquidato   NUMBER;
     D_riv_tfr_liquidato_ap NUMBER;
     D_riv_tfr_mese        NUMBER;
     D_tfr_liq_rif_ap      NUMBER;
   BEGIN
     BEGIN  --Emissione voci mensili per calcolo TFR
        P_stp := 'VOCI_TFR-03';
       SELECT NVL(SUM(prfi.fdo_tfr_ap),0)
            , NVL(SUM(prfi.fdo_tfr_ap_liq),0)
            , NVL(SUM(prfi.fdo_tfr_2000),0)
            , NVL(SUM(prfi.fdo_tfr_2000_liq),0)
            , NVL(SUM(prfi.riv_tfr),0)
            , NVL(SUM(prfi.riv_tfr_liq),0)
            , NVL(SUM(prfi.riv_tfr_ap),0)
            , NVL(SUM(prfi.riv_tfr_ap_liq),0)
            , NVL(SUM(prfi.ret_tfr),0)
            , NVL(SUM(prfi.qta_tfr_ac),0)
            , NVL(SUM(prfi.qta_tfr_ac_liq),0)
         INTO D_fdo_tfr_ap
            , D_fdo_tfr_ap_liq
            , D_fdo_tfr_2000
            , D_fdo_tfr_2000_liq
            , D_riv_tfr
            , D_riv_tfr_liq
            , D_riv_tfr_ap
            , D_riv_tfr_ap_liq
            , D_ret_tfr
            , D_qta_tfr_ac
            , D_qta_tfr_ac_liq
         FROM progressivi_fiscali prfi
        WHERE prfi.ci          = P_ci
          AND prfi.anno        = P_anno
          AND prfi.mese        = P_mese
          AND prfi.MENSILITA    = P_mensilita
        ;
     END;
    BEGIN
-- dbms_output.put_line('------ Calcolo rivalutazione ------  D_fdo_tfr_ap '||D_fdo_tfr_ap);
-- dbms_output.put_line('------ Calcolo rivalutazione ------  D_fdo_tfr_ap_liq '||D_fdo_tfr_ap_liq);
-- dbms_output.put_line('------ Calcolo rivalutazione ------  D_fdo_tfr_2000 '||D_fdo_tfr_2000);
-- dbms_output.put_line('------ Calcolo rivalutazione ------  D_fdo_tfr_2000_liq '||D_fdo_tfr_2000_liq);
-- dbms_output.put_line('------ Calcolo rivalutazione ------  D_riv_tfr '||D_riv_tfr);
-- dbms_output.put_line('------ Calcolo rivalutazione ------  D_riv_tfr_liq '||D_riv_tfr_liq);
-- dbms_output.put_line('------ Calcolo rivalutazione ------  D_riv_tfr_ap '||D_riv_tfr_ap);
-- dbms_output.put_line('------ Calcolo rivalutazione ------  D_riv_tfr_ap_liq '||D_riv_tfr_ap_liq);
-- dbms_output.put_line('------ Calcolo rivalutazione ------  D_ret_tfr '||D_ret_tfr);
-- dbms_output.put_line('------ Calcolo rivalutazione ------  D_qta_tfr_ac '||D_qta_tfr_ac);
-- dbms_output.put_line('------ Calcolo rivalutazione ------  D_qta_tfr_ac_liq '||D_qta_tfr_ac_liq);
    SELECT NVL(E_Round(SUM((NVL(inex.fdo_tfr_ap,0)
                         +NVL(inex.fdo_tfr_2000,0)
                         +NVL(inex.riv_tfr_ap,0)
                         ) * (  mese.alq_tfr - NVL(mesep.alq_tfr,0) )
                        ),'I'),0)
     INTO D_riv_tfr_assenze
      FROM INFORMAZIONI_EXTRACONTABILI inex
        , MESI mese
        , MESI mesep
     WHERE inex.anno           = P_anno
      AND ci                 = P_ci
      AND mese.mese          <= P_mese
      AND (mese.anno,mese.mese)  IN
         (SELECT DISTINCT anno,mese FROM PERIODI_RETRIBUTIVI
           WHERE anno+0      = P_anno
             AND ci         = P_ci
             AND competenza IN ('p','c','a')
             AND per_gg      = 0
             AND cod_astensione IN
               (SELECT codice FROM ASTENSIONI WHERE rivalutazione_tfr = 0)
             AND periodo    <= LAST_DAY(TO_DATE(LPAD(TO_CHAR(P_mese),2,'0')
                                              ||TO_CHAR(P_anno)
                                          ,'mmyyyy'))
           GROUP BY anno,mese
          HAVING (   SUM(gg_per+gg_nsu) >= 15 AND
                    TO_CHAR(anno)||LPAD(TO_CHAR(mese),2,'0') !=
                    TO_CHAR(P_al,'yyyymm')
                 OR TO_NUMBER(TO_CHAR(P_al,'dd'))
                  - SUM(gg_per+gg_nsu) < 15 AND
                    TO_CHAR(anno)||LPAD(TO_CHAR(mese),2,'0') =
                    TO_CHAR(P_al,'yyyymm')
                )
         )
      AND mesep.anno(+)       = mese.anno
      AND mesep.mese(+)       = DECODE(mese.mese,1,0,mese.mese-1)
     ;
    EXCEPTION
 WHEN NO_DATA_FOUND THEN D_riv_tfr_assenze := 0;
    END;
-- dbms_output.put_line('------ Calcolo rivalutazione ------  D_riv_tfr_assenze '||D_riv_tfr_assenze);
    /* Calcola la rivalutazione sul fondo liquidato per ogni mese
 di servizio successivo a quello di liquidazione */
    IF P_mese != 1 THEN
-- dbms_output.put_line('Fin qua ci arriviamo..............................');
 BEGIN
 SELECT NVL(SUM((NVL(mofi.fdo_tfr_ap_liq,0)
                +NVL(mofi.fdo_tfr_2000_liq,0)
                +NVL(mofi.riv_tfr_ap_liq,0) - nvl(mofi.tfr_liq_rif_ap,0)
                ) * (  mese.alq_tfr - mesep.alq_tfr )),0)
   INTO D_riv_tfr_liquidato
   FROM MOVIMENTI_FISCALI mofi
      , MESI mese
      , MESI mesep
  WHERE mofi.anno            = P_anno
    AND ci                   = P_ci
    AND mofi.mese            < TO_CHAR(P_al - 14, 'mm')
    AND LPAD(TO_CHAR(mofi.mese),2)||RPAD(mofi.MENSILITA,3) <
        LPAD(TO_CHAR(P_mese),2)||RPAD(P_mensilita,3)
    AND (   NVL(mofi.fdo_tfr_ap_liq,0) != 0
         OR NVL(mofi.fdo_tfr_2000_liq,0) != 0
         OR NVL(mofi.riv_tfr,0) != 0
        )
    AND mese.anno            = P_anno
    AND P_anno               = TO_CHAR(P_al - 14, 'yyyy')
    AND mese.mese            = TO_CHAR(P_al - 14, 'mm')
    AND mesep.anno           = to_char(mofi.DATA_RICHIESTA_ANT,'yyyy')      --mofi.anno
    AND mesep.mese           = to_char(mofi.DATA_RICHIESTA_ANT,'mm')        --mofi.mese
 ;
 SELECT nvl(mofi.TFR_LIQ_RIF_AP,0) * mese.alq_tfr
   INTO D_riv_tfr_liquidato_ap
   FROM MOVIMENTI_FISCALI mofi
      , MESI mese
      , MESI mesep
  WHERE mofi.anno            = P_anno
    AND ci                   = P_ci
    AND mofi.mese            < TO_CHAR(P_al - 14, 'mm')
    AND LPAD(TO_CHAR(mofi.mese),2)||RPAD(mofi.MENSILITA,3) <
        LPAD(TO_CHAR(P_mese),2)||RPAD(P_mensilita,3)
    AND nvl(mofi.TFR_LIQ_RIF_AP,0) <> 0
    AND mese.anno            = P_anno
    AND P_anno               = TO_CHAR(P_al - 14, 'yyyy')
    AND mese.mese            = TO_CHAR(P_al - 14, 'mm')
    AND mesep.anno           = mofi.anno
    AND mesep.mese           = mofi.mese
 ;
 exception
   when no_data_found then D_riv_tfr_liquidato := 0;
                           D_riv_tfr_liquidato_ap := 0;
 END;
    ELSE
 D_riv_tfr_liquidato := 0;
    END IF;
-- dbms_output.put_line('------ Calcolo rivalutazione ------  D_riv_tfr_liquidato '||D_riv_tfr_liquidato);
-- dbms_output.put_line('------ Calcolo rivalutazione ------  D_riv_tfr_liquidato_ap '||D_riv_tfr_liquidato_ap);
    /* Calcola la rivalutazione spettante come differenza tra:
 - rivalutazione complessiva alla percentuale del mese in corso
 - rivalutazione sui periodi di assenza
 - rivalutazione sul TFR liquidato
 - rivalutazione gia' memorizzata sui progressivi
    */
    D_riv_tfr_mese   := ((D_fdo_tfr_ap+D_fdo_tfr_2000+D_riv_tfr_ap*.89
                         )  * D_alq)
                -  D_riv_tfr_assenze
                -  D_riv_tfr_liquidato
				-  D_riv_tfr_liquidato_ap
                -  D_riv_tfr ;
   /* Estrae voci con cui ridurre la Quota del TFR (specifica RI_QTA_TFR) */
     BEGIN
     SELECT NVL(SUM(imp),0)
       INTO D_riduce_qta_tfr
       FROM CALCOLI_CONTABILI
      WHERE ci = P_ci
        AND voce IN (SELECT codice FROM VOCI_ECONOMICHE
                      WHERE specifica = 'RI_QTA_TFR')
     ;
     END;
     BEGIN
     SELECT D_riduce_qta_tfr + NVL(SUM(p_imp),0)
       INTO D_riduce_qta_tfr
       FROM progressivi_contabili
      WHERE ci = P_ci
        AND anno = P_anno
        AND mese = P_mese
        AND MENSILITA = P_mensilita
        AND voce IN (SELECT codice FROM VOCI_ECONOMICHE
                      WHERE specifica = 'RI_QTA_TFR')
     ;
     END;
     BEGIN
-- dbms_output.put_line('Calcolo lordo ------ + D_fdo_tfr_ap '||D_fdo_tfr_ap);
-- dbms_output.put_line('Calcolo lordo ------ - D_fdo_tfr_ap_liq '||D_fdo_tfr_ap_liq);
-- dbms_output.put_line('Calcolo lordo ------ D_ret_tfr '||D_ret_tfr);
-- dbms_output.put_line('Calcolo lordo ------ D_imp '||D_imp);
-- dbms_output.put_line('Calcolo lordo ------ - D_qta_tfr_ac_liq '||D_qta_tfr_ac_liq);
-- dbms_output.put_line('Calcolo lordo ------ - D_riduce_qta_tfr '||D_riduce_qta_tfr);
        INSERT INTO CALCOLI_CONTABILI
        ( ci, voce, sub
        , riferimento
        , input
        , estrazione
        , tar
      , qta
      , imp
        )
     SELECT
       P_ci, voec.codice, '*'
     , P_al
     , 'C'
     , 'AF'
     , DECODE( voec.codice
             , P_rit_riv, D_riv_tfr_mese, '')
     , DECODE( voec.codice
             , P_rit_riv, 11, '')
     , DECODE( voec.codice
             , P_riv_tfr, D_riv_tfr_mese
             , P_rit_riv, E_Round( D_riv_tfr_mese * 11 / 100 , 'I')
             , P_qta_tfr, ( D_ret_tfr + D_imp
                          ) / 13.5
                        - D_qta_tfr_ac
                        - D_riduce_qta_tfr
             , P_lor_tfr, ( D_fdo_tfr_ap - D_fdo_tfr_ap_liq
                          )
                        + E_Round( ( D_ret_tfr + D_imp
                                 ) / 13.5
                               - D_qta_tfr_ac_liq
                               - D_riduce_qta_tfr
                               ,'I')
             , P_lor_tfr_00, D_fdo_tfr_2000 - D_fdo_tfr_2000_liq
             , P_lor_riv, ( D_riv_tfr_mese
                        + ( D_riv_tfr - D_riv_tfr_liq )
                        + ( D_riv_tfr_ap - D_riv_tfr_ap_liq ))* .89
             )
       FROM VOCI_ECONOMICHE     voec
             ,CONTABILITA_VOCE    covo
        WHERE voec.codice    IN ( P_riv_tfr
                                , P_qta_tfr
                                , P_lor_tfr
                                , P_lor_tfr_00
                                , P_lor_riv
                        , P_rit_riv
                                )
          AND covo.voce       = voec.codice||''
          AND covo.sub       = '*'
          AND P_al      BETWEEN NVL(covo.dal,TO_DATE('2222222','j'))
                          AND NVL(covo.al ,TO_DATE('3333333','j'))
        ;
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END;
  END IF;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     Peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
  --Valorizzazione Voci di Imponibile
--
PROCEDURE voci_imponibile
(
 p_ci           NUMBER
,p_anno_ret      NUMBER
,p_al           DATE    --Data di Termine o Fine Mese
,p_anno         NUMBER
,p_mese         NUMBER
,p_mensilita     VARCHAR2
,p_fin_ela       DATE
,p_tipo         VARCHAR2
,p_conguaglio    NUMBER
,p_mens_codice   VARCHAR2
,p_periodo       VARCHAR2
,P_cassa_competenza VARCHAR2
--Parametri per Trace
,p_trc    IN     NUMBER     --Tipo di Trace
,p_prn    IN     NUMBER     --Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     --Numero di Passo procedurale
,p_prs    IN OUT NUMBER     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
) IS
w_dummy VARCHAR2(1);
D_gg_rat      NUMBER;
D_gg_rid      NUMBER;
D_rateo_continuativo NUMBER;
D_gg_min_gg   NUMBER;
D_gg_min_ipn  NUMBER;
D_rif_prec    DATE;
D_rif_ini     DATE;
D_tar         CALCOLI_CONTABILI.tar%TYPE;
D_imp         CALCOLI_CONTABILI.imp%TYPE;
D_ipn_c       CALCOLI_CONTABILI.ipn_c%TYPE;
D_ipn_s       CALCOLI_CONTABILI.ipn_s%TYPE;
D_ipn_p       CALCOLI_CONTABILI.ipn_p%TYPE;
D_ipn_l       CALCOLI_CONTABILI.ipn_l%TYPE;
D_ipn_e       CALCOLI_CONTABILI.ipn_e%TYPE;
D_ipn_t       CALCOLI_CONTABILI.ipn_t%TYPE;
D_ipn_a       CALCOLI_CONTABILI.ipn_a%TYPE;
D_ipn_ap      CALCOLI_CONTABILI.ipn_ap%TYPE;
D_dep_voce    CALCOLI_CONTABILI.voce%TYPE;  --Voce Imponibile trattata
D_ipn_tot     CALCOLI_CONTABILI.ipn_c%TYPE; --Valore imponibile totale
D_sede_del    CALCOLI_CONTABILI.sede_del%TYPE;
D_anno_del    CALCOLI_CONTABILI.anno_del%TYPE;
D_numero_del  CALCOLI_CONTABILI.numero_del%TYPE;
D_delibera    CALCOLI_CONTABILI.delibera%TYPE; -- modifica del 28/04/2004
D_app_voce    CALCOLI_CONTABILI.voce%TYPE;
D_app_sub     CALCOLI_CONTABILI.sub%TYPE;
BEGIN
   BEGIN  -- Scarico degli estremi di Delibera da Periodi Retributivi e da Voci Contabili:
          -- -----------------------------------------------------------------------------
          -- trasferimento degli estremi di delibera indicati in tabella PERIODI_RETRIBUTIVI,
          -- o degli estremi di delibera indicati in tabella CONTABILITA_VOCI, ove presenti,
          -- su tutte le voci presenti nella tabella temporanea CALCOLI_CONTABILI.
    P_stp := 'VOCI_IMPONIBILE-00';
    FOR CURR IN
       (select rdre.sede, rdre.anno, rdre.numero, rdre.tipo
             , caco.rowid
          from periodi_retributivi        pere
             , voci_economiche            voec
             , contabilita_voce           covo
             , codici_bilancio            cobi
             , calcoli_contabili          caco
             , righe_delibera_retributiva rdre
         where caco.ci                = P_ci
           and cobi.codice            = covo.bilancio
           and voec.codice            = covo.voce
           and covo.voce              = caco.voce
           and covo.sub               = caco.sub
           and caco.riferimento between nvl(covo.dal, to_date(2222222,'j'))
                                    and nvl(covo.al , to_date(3333333,'j'))
           and pere.ci                = caco.ci
           and pere.periodo           = P_fin_ela
           and rdre.sede              = nvl(covo.sede_del,
                                            decode(cobi.imputazione_delibera, 'SI', pere.sede_del, null))
           and rdre.anno              = nvl(covo.anno_del,
                                            decode(cobi.imputazione_delibera, 'SI', pere.anno_del, null))
           and rdre.numero            = nvl(covo.numero_del,
                                            decode(cobi.imputazione_delibera, 'SI', pere.numero_del, null))
           and rdre.tipo              = nvl(decode(cobi.imputazione_delibera, 'SI', nvl(pere.delibera,'*'), null), '*')
           and rdre.bilancio          = cobi.codice
           and caco.numero_del        is null
           and caco.riferimento between pere.dal and pere.al
           and (   voec.classe           != 'R'
                or voec.classe            = 'R'
                and not exists
                   (select 'x'
                      from periodi_retributivi
                     where periodo     = pere.periodo
                       and ci          = pere.ci
                       and competenza in ('C','A')
                       and numero_del is null
                   )
               )
           and (    caco.input        = upper(caco.input)
                and pere.competenza  in ('C','A')
                or  caco.input       != upper(caco.input)
                and pere.competenza   = 'P'
                or  caco.input       != upper(caco.input)
                and pere.competenza  in ('C','A')
                and not exists
                   (select 'x' from periodi_retributivi
                     where periodo    = pere.periodo
                       and ci         = pere.ci
                       and competenza = 'P'
                       and caco.riferimento between dal and al)
               )
           for update
       )
      LOOP
      UPDATE calcoli_contabili caco
         SET sede_del           = CURR.sede
           , anno_del           = CURR.anno
           , numero_del         = CURR.numero
           , delibera           = CURR.tipo
       WHERE rowid      = CURR.rowid
      ;
      END LOOP;
      Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   END;
/* modifica del 02/05/2007 */
   BEGIN  -- Valorizza data di competenza se richiesto calcolo ritenute per cassa
          -- -----------------------------------------------------------------------------
          -- Valorizza il campo competenza di CALCOLI_CONTABILI con la data di elaborazione
          -- su tutte le voci che verranno totalizzate in un imponibile che prevede il
          -- calcolo della ritenuta per cassa per la storicità che comprende il riferimento
          -- della voce stessa. Il tutto solo se per l'individuo è stato richiesto un calcolo
          -- per cassa (flag della RELRE).
    P_stp := 'VOCI_IMPONIBILE-00.a';
    FOR CURR IN
       (select caco.rowid
          from IMPONIBILI_VOCE        imvo
             , TOTALIZZAZIONI_VOCE    tovo
             , VOCI_ECONOMICHE        voec
             , CALCOLI_CONTABILI      caco
         where caco.voce                       = tovo.voce
           and caco.sub                        = NVL(tovo.sub, caco.sub)
           and tovo.voce_acc                   = imvo.voce
           and voec.codice                     = caco.voce
           and caco.ci+0                       = P_ci
           and NVL(caco.ipn_eap, caco.imp) is not null
           and nvl(P_cassa_competenza,'NO')    = 'SI'
           and nvl(imvo.cassa_competenza,'NO') = 'SI'
           and (   caco.competenza is null
-- temporaneamente tolto (Annalena)
--                or voec.specifica in ('RGA13M','RGA13A')
                )
           and caco.riferimento between NVL(tovo.dal,TO_DATE(2222222,'j'))
                                    and NVL(tovo.al ,TO_DATE(3333333,'j'))
           and caco.riferimento between NVL(imvo.dal,TO_DATE(2222222,'j'))
                                    and NVL(imvo.al ,TO_DATE(3333333,'j'))
           and imvo.al is not null     -- la data competenza non serve x le voci dell'anno
           and caco.input not in ('I','B','D','P','M')  -- le variabili comunicate mantengono la competenza indicata
         for update
       )
      LOOP
      update calcoli_contabili caco
         set competenza = P_fin_ela
       where rowid      = CURR.rowid
      ;
      END LOOP;
      Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   END;
/* fine modifica del 02/05/2007 */
  BEGIN  --Preleva dati dell'individuo
     P_stp := 'VOCI_IMPONIBILE-01';
     SELECT SUM(NVL(pere.gg_rat,0))
          , SUM(NVL(pere.gg_rid,0))
          , MAX(pere.rateo_continuativo)
       INTO D_gg_rat
          , D_gg_rid
          , D_rateo_continuativo
       FROM PERIODI_RETRIBUTIVI pere
      WHERE  pere.ci      = P_ci
        AND  pere.periodo = P_fin_ela
        AND TO_NUMBER(TO_CHAR(pere.mese)||TO_CHAR(pere.anno))
                     =
            TO_NUMBER( TO_CHAR(P_fin_ela,'mmyyyy') )
     ;     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  --Trattamento singola Voce IMPONIBILE
        --Totalizzazione, Suddivisione in base Fiscale
     P_stp := 'VOCI_IMPONIBILE-02.1';
     D_dep_voce := NULL;
     D_app_voce := NULL;
     D_app_sub  := NULL;
/* modifica del 14/04/2005 */
      insert into TEMP_CACO_PERE
             ( ci, riferimento, periodo)
      select P_ci
           , caco.riferimento
           , nvl(max(periodo),P_fin_ela)
        from periodi_retributivi pere
           , calcoli_contabili caco
       where caco.ci      = P_ci
         and pere.ci (+)  = caco.ci
         and periodo (+) >= caco.riferimento
         and periodo (+) <= P_fin_ela
         and nvl(pere.competenza,'A') in ('C','A','P')
         and to_number(to_char(al(+),'yyyymm')) = to_number(to_char(caco.riferimento,'yyyymm'))
/* modifica del 27/07/2005 */
         and caco.riferimento between pere.dal (+) and pere.al (+)
/* fine modifica del 27/07/2005 */
         and (    nvl(tipo,' ') not in ('R','F')
              or
                  nvl(tipo,' ') in ('R','F')
              and not exists (select 'x'
                                from periodi_retributivi pere2
                               where pere2.ci      = P_ci
                                 and nvl(pere2.competenza,'A') in ('C','A','P')
                                 and to_number(to_char(pere2.al,'yyyymm')) = to_number(to_char(caco.riferimento,'yyyymm'))
                                 and nvl(tipo,' ') not in ('R','F')
                              )
             )
       group by P_ci, caco.riferimento
       ;
       Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
/* fine modifica del 14/04/2005 */
/* modifica del 16/11/2005 */
       P_stp := 'VOCI_IMPONIBILE-02.2';
      insert into TEMP_PERE_IPN
             ( caco_rowid, ci, periodo, dal, al, pegi_al, riferimento
             , ruolo, cod_astensione, rap_ore, competenza, intero, quota
             , gestione, contratto, trattamento, gg_fis, funzionale
             , part_time, cat_minimale, classe, specie, rapporto, fiscale
             , mol_ipn_c, mol_ipn_s, mol_ipn_p, mol_ipn_l, mol_ipn_e, mol_ipn_t, mol_ipn_a, mol_ipn_ap
             , assesta_segno
             )
      select caco.rowid, caco.ci, pere.periodo, pere.dal, pere.al, pegi.al, caco.riferimento
           , pere.ruolo, pere.cod_astensione, pere.rap_ore, pere.competenza, pere.intero, pere.quota
           , pere.gestione, pere.contratto, pere.trattamento, pere.gg_fis, rifu.funzionale
           , posi.part_time, qual.cat_minimale, voec2.classe, voec2.specie, covo.rapporto, covo.fiscale
           , DECODE(covo.fiscale,'C',1,'R',1,'X',1,'F',1,'G',1,'D',1,'N',1,0)  mol_ipn_c
           , DECODE(covo.fiscale,'S',1,0)  mol_ipn_s
           , DECODE(covo.fiscale,'C',1,'X',1,'R',1,'F',1,'S',1
                                      ,'P',1,'Y',1,'G',1,'D',1,'N',1,0)   mol_ipn_p
           , DECODE(covo.fiscale,'Z',1,'L',1,'A',1,0) mol_ipn_l
           , DECODE(covo.fiscale,'E',1,'T',1,0) mol_ipn_e
           , DECODE(covo.fiscale,'F',1,0)  mol_ipn_t
           , DECODE(covo.fiscale,'X',1,0)  mol_ipn_a
           , DECODE(covo.fiscale,'Y',1,'X',1,0) mol_ipn_ap
           , DECODE(SIGN(pere.rap_ore),-1,-1,1) * DECODE(pere.competenza,'P',-1,1)
       from RIPARTIZIONI_FUNZIONALI rifu
          , POSIZIONI              posi
          , QUALIFICHE             qual
          , PERIODI_RETRIBUTIVI    pere
          , CALCOLI_CONTABILI      caco
          , TEMP_CACO_PERE         tecp
          , VOCI_ECONOMICHE        voec2
          , CONTABILITA_VOCE       covo
          , PERIODI_GIURIDICI      pegi
      where rifu.SETTORE (+) = pere.SETTORE
        and rifu.sede    (+) = nvl(pere.sede,0)
        and posi.codice (+)  = pere.posizione
        and qual.numero (+)  = pere.qualifica
        and voec2.codice     = caco.voce||''
        and covo.voce        = caco.voce||''
        and covo.sub         = caco.sub
        and caco.riferimento
            BETWEEN NVL(covo.dal,TO_DATE(2222222,'j'))
                AND NVL(covo.al ,TO_DATE(3333333,'j'))
        and pegi.ci(+)        = pere.ci
        and pegi.rilevanza(+) = 'P'
        and pere.al     between nvl(pegi.dal (+), to_date(2222222,'j'))
                            and nvl(pegi.al (+) , to_date(3333333,'j'))
        and pere.ci = P_ci
        and tecp.ci = P_ci
        and caco.riferimento = tecp.riferimento
        and pere.periodo = tecp.periodo
        and caco.ci = tecp.ci
        and (    pere.competenza IN ('C','A')
             AND caco.input       = UPPER(caco.input)
             OR  pere.competenza  = 'P'
             AND caco.input      != UPPER(caco.input)
/* modifica del 18/01/2007 */
             AND caco.riferimento BETWEEN pere.dal AND pere.al
/* fine modifica del 18/01/2007 */
             OR  pere.competenza IN ('C','A')
             AND caco.input      != UPPER(caco.input)
             AND NOT EXISTS
               ( SELECT 'x'
                   FROM PERIODI_RETRIBUTIVI
                  WHERE ci         = P_ci
                    AND periodo    = tecp.periodo
                    AND caco.riferimento = tecp.riferimento
                    AND caco.ci    = tecp.ci
                    AND competenza  = 'P'
                    AND caco.riferimento
                            BETWEEN dal AND al
                )
            )
        and pere.SERVIZIO IN ('Q','I')
        AND NOT EXISTS
          ( SELECT 'x'
              FROM PERIODI_RETRIBUTIVI
             WHERE ci         = P_ci
               AND periodo    = tecp.periodo
               AND caco.riferimento = tecp.riferimento
               AND caco.ci    = tecp.ci
               AND anno+0      = pere.anno
               AND mese       = pere.mese
               AND al         = pere.al
               AND DECODE(competenza,'P','P','C')
                             = DECODE(pere.competenza,'P','P','C')
               AND pere.SERVIZIO = 'Q'
               AND SERVIZIO = 'N'
           )
/* modifica del 12/01/2006 */
/* modifica del 15/06/2006 */
        AND (  (    pere.servizio = 'I'
                and caco.riferimento BETWEEN pere.dal and pere.al)
             OR(    pere.servizio != 'I'
                and pere.dal = (select max(dal)
                                  from periodi_retributivi
                                 where ci = P_ci
                                   and periodo = pere.periodo
                                   and servizio = pere.servizio
                                   and (   competenza = 'P' and pere.competenza = 'P'
                                        or competenza in ('C','A') and pere.competenza != 'P'
                                       )
                                   and dal <= caco.riferimento ))
             )
/* fine modifica del 15/06/2006 */
/* fine modifica del 12/01/2006 */
       ;
       Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
/* fine modifica del 16/11/2005 */
/* modifica del 19/12/2005 */
--  Il trattamento previdenziale deve sempre essere quello valido alla data di elaborazione.
       P_stp := 'VOCI_IMPONIBILE-02.2a';
       update TEMP_PERE_IPN tepi
          set trattamento =
            ( select max(trattamento)
                from periodi_retributivi pere
               where ci = P_ci
                 and periodo = P_fin_ela
                 and tepi.riferimento between pere.dal
                                          and pere.al
                 and pere.competenza IN ('C','A') )
        where tepi.trattamento !=
            ( select max(trattamento)
                from periodi_retributivi pere
               where ci = P_ci
                 and periodo = P_fin_ela
                 and tepi.riferimento between pere.dal
                                          and pere.al
                 and pere.competenza IN ('C','A') )
        ;
       Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
/* fine modifica del 19/12/2005 */
       P_stp := 'VOCI_IMPONIBILE-02.3';
     FOR CUR_IMVO IN
        (SELECT
  esvo.voce, esvo.sub
, esvo.trattamento trattamento
, max(voec.specie) specie
, max(esvo.richiesta) richiesta
/* modifica del 22/06/2006 */
, esvo.gestione gestione
, esvo.contratto contratto
, esvo.condizione condizione
/* fine modifica del 22/06/2006 */
 FROM ESTRAZIONI_VOCE        esvo
    , VOCI_ECONOMICHE        voec
    , TEMP_PERE_IPN           tepi
 WHERE voec.codice||''  = esvo.voce
   AND voec.classe      = 'I'
   AND tepi.ci          = P_ci
   AND esvo.gestione||' '||esvo.contratto||' '||
       esvo.condizione||' '||esvo.trattamento||' '||
       DECODE(esvo.richiesta,'I','1','2')
       =
(SELECT MAX(esv2.gestione||' '||esv2.contratto||' '||
          esv2.condizione||' '||esv2.trattamento||' '||
          DECODE(esv2.richiesta,'I','1','2')
         )
  FROM ESTRAZIONI_VOCE esv2
 WHERE esv2.voce          = voec.codice
   AND tepi.gestione    LIKE esv2.gestione
   AND tepi.contratto   LIKE esv2.contratto
   AND tepi.trattamento LIKE esv2.trattamento
   AND (   esv2.condizione = 'S'
        OR esv2.condizione = 'F' AND P_mese = 12 AND
                                 P_tipo = 'N'
        OR P_mens_codice LIKE esv2.condizione
        OR SUBSTR(esv2.condizione,1,1) = 'P' AND
          SUBSTR(esv2.condizione,2,1) = P_periodo
        OR esv2.condizione = 'C' AND P_conguaglio = 2
        OR esv2.condizione = 'RA' AND P_conguaglio = 3
        OR esv2.condizione = 'I' AND P_conguaglio IN (1,2,3)
        OR esv2.condizione = 'N' AND P_anno != P_anno_ret
        OR esv2.condizione = 'M' AND P_tipo       = 'N' AND
                                 tepi.gg_fis != 0
        OR esv2.condizione = 'R' AND P_tipo       = 'N' AND
          D_gg_rat       > 14
        or esv2.condizione = 'RC' and exists
        (select 'x'
           from periodi_retributivi
          where ci          = P_ci
            and periodo     = P_fin_ela
            and to_char(al,'mmyyyy') = to_char(tepi.al,'mmyyyy')
            and decode(competenza,'P','P','C')
              = decode(tepi.competenza,'P','P','C')
            and rateo_continuativo = 1
        )
        OR esv2.condizione = 'G' AND
          D_gg_rid       > 0   AND
          P_tipo        != 'S'
       )
)
 GROUP BY esvo.voce, esvo.sub
        , esvo.trattamento
        , esvo.gestione
        , esvo.contratto
        , esvo.condizione
        ) LOOP
     FOR X  IN
        (SELECT
  tepi.ruolo, tepi.funzionale, tepi.part_time
, NVL(imvo.al,TO_DATE('3333333','j')) imvo_al
, MAX(least(nvl(imvo.al,P_al)
           ,decode(tepi.classe,'C'
                  ,decode(tepi.specie,'T'
                         ,decode(tepi.rapporto,'O',least(nvl(imvo.al,P_al),nvl(tepi.pegi_al,P_al)),tepi.al)
                         ,least(nvl(imvo.al,P_al),nvl(tepi.pegi_al,P_al)))
                  ,tepi.al)
           ,P_al)) riferimento
/* modifica del 02/05/2007 */
   , MAX(DECODE( nvl(imvo.cassa_competenza,'NO')
               , 'SI', DECODE( SIGN( TO_NUMBER(TO_CHAR( nvl(caco.competenza,caco.riferimento),'yyyy'))
                                   - TO_NUMBER(TO_CHAR( caco.riferimento,'yyyy'))
                                   )
                             ,1 , least(nvl(caco.competenza,caco.riferimento),P_fin_ela)
                                , least(caco.riferimento,P_fin_ela)
                             )
                     , NVL( least(imvo.al, P_al)
                           , DECODE( SIGN( TO_NUMBER(TO_CHAR( nvl(caco.competenza,caco.riferimento),'yyyy'))
                                         - TO_NUMBER(TO_CHAR( caco.riferimento,'yyyy'))
                                         )
                                   ,1 , caco.competenza
                                      , least(P_al,tepi.al)
                                    )
                          )
                  )
            ) competenza
/*
   , MAX(decode ( cur_imvo.specie, 'T',
              least(nvl(imvo.al,P_al)
                   ,decode(tepi.classe,'C'
                          ,decode(tepi.specie,'T'
                                 ,decode(tepi.rapporto,'O',least(nvl(imvo.al,P_al),nvl(tepi.pegi_al,P_al)),tepi.al)
                                 ,least(nvl(imvo.al,P_al),nvl(tepi.pegi_al,P_al)))
                          ,tepi.al)
                   ,P_al)
             , NVL( least(imvo.al, P_al)
                  , DECODE( SIGN( TO_NUMBER(TO_CHAR( caco.competenza,'yyyy'))
                                - TO_NUMBER(TO_CHAR( caco.riferimento,'yyyy'))
                                )
                          ,1 , caco.competenza
                             , least(P_al,tepi.al)
                           )
                   )
             )
      ) competenza
*/
/* fine modifica del 02/05/2007 */
, NVL( SUM( DECODE( DECODE( get_esiste_imas(cur_imvo.voce, tepi.cod_astensione, caco.riferimento)
                          , 0, tovo.tipo
                             , 'E'
                          )
               , 'E', DECODE( tepi.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
                  )
        * NVL(tovo.per_tot, 100) / 100
        * tepi.mol_ipn_c
        * DECODE(NVL(caco.arr,'C'),'C',1,0)
        * tepi.assesta_segno
        / NVL(tepi.intero,1) * NVL(tepi.QUOTA,1)
        )
    , 0 ) ipn_c
, NVL( SUM( DECODE( DECODE( get_esiste_imas(cur_imvo.voce, tepi.cod_astensione, caco.riferimento)
                          , 0, tovo.tipo
                             , 'E'
                          )
               , 'E', DECODE( tepi.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100) / 100
        * tepi.mol_ipn_s
        * DECODE(NVL(caco.arr,'C'),'C',1,0)
        * tepi.assesta_segno
        / NVL(tepi.intero,1) * NVL(tepi.QUOTA,1)
        )
    , 0 ) ipn_s
, NVL( SUM( DECODE( DECODE( get_esiste_imas(imvo.voce, tepi.cod_astensione, caco.riferimento)
                          , 0, tovo.tipo
                             , 'E'
                          )
               , 'E', DECODE( tepi.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100 ) / 100
        * tepi.mol_ipn_p
        * DECODE(NVL(caco.arr,'C')
               ,'P',1,DECODE(tepi.fiscale,'P',1,'Y',1,0))
        * tepi.assesta_segno
        / NVL(tepi.intero,1) * NVL(tepi.QUOTA,1)
        )
    , 0 ) ipn_p
, NVL( SUM( DECODE( DECODE( get_esiste_imas(imvo.voce, tepi.cod_astensione, caco.riferimento)
                          , 0, tovo.tipo
                             , 'E'
                          )
               , 'E', DECODE( tepi.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100) / 100
        * tepi.mol_ipn_l
        * tepi.assesta_segno
        / NVL(tepi.intero,1) * NVL(tepi.QUOTA,1)
        )
    , 0 ) ipn_l
, NVL( SUM( DECODE( DECODE( get_esiste_imas(imvo.voce, tepi.cod_astensione, caco.riferimento)
                          , 0, tovo.tipo
                             , 'E'
                          )
               , 'E', DECODE( tepi.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100) / 100
        * tepi.mol_ipn_e
        * tepi.assesta_segno
        / NVL(tepi.intero,1) * NVL(tepi.QUOTA,1)
        )
    , 0 ) ipn_e
, NVL( SUM( DECODE( DECODE( get_esiste_imas(imvo.voce, tepi.cod_astensione, caco.riferimento)
                          , 0, tovo.tipo
                             , 'E'
                          )
               , 'E', DECODE( tepi.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100) / 100
        * tepi.mol_ipn_t
        * tepi.assesta_segno
        / NVL(tepi.intero,1) * NVL(tepi.QUOTA,1)
        )
    , 0 ) ipn_t
, NVL( SUM( DECODE( DECODE( get_esiste_imas(imvo.voce, tepi.cod_astensione, caco.riferimento)
                          , 0, tovo.tipo
                             , 'E'
                          )
               , 'E', DECODE( tepi.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100) / 100
        * tepi.mol_ipn_a
        * DECODE(NVL(caco.arr,'C'),'C',1,0)
        * tepi.assesta_segno
        / NVL(tepi.intero,1) * NVL(tepi.QUOTA,1)
        )
    , 0 ) ipn_a
, NVL( SUM( DECODE( DECODE( get_esiste_imas(imvo.voce, tepi.cod_astensione, caco.riferimento)
                          , 0, tovo.tipo
                             , 'E'
                          )
               , 'E', DECODE( tepi.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100) / 100
        * tepi.mol_ipn_ap
        * DECODE(NVL(caco.arr,'C'),'P',1,DECODE(tepi.fiscale,'Y',1,0))
        * tepi.assesta_segno
        / NVL(tepi.intero,1) * NVL(tepi.QUOTA,1)
        )
    , 0 ) ipn_ap
    , MAX(DECODE(tepi.cat_minimale
           ,'',DECODE(SIGN(ABS(NVL(tepi.rap_ore,0))-1),-1,min_gg_pt
                                                   ,min_gg)
           ,1 ,DECODE(tepi.part_time,'SI',min_gg_1_pt
                                     ,min_gg_1)
           ,2 ,DECODE(tepi.part_time,'SI',min_gg_2_pt
                                     ,min_gg_2)
           ,3 ,DECODE(tepi.part_time,'SI',min_gg_3_pt
                                     ,min_gg_3)))  minim_gg
    , caco.sede_del, caco.anno_del, caco.numero_del, caco.delibera
 FROM IMPONIBILI_VOCE        imvo
    , TOTALIZZAZIONI_VOCE     tovo
    , CALCOLI_CONTABILI       caco
    , TEMP_PERE_IPN           tepi
 WHERE imvo.voce       = cur_imvo.voce
   AND cur_imvo.voce   = tovo.voce_acc
   AND tovo.voce||''   = caco.voce
   AND NVL(tovo.sub, caco.sub) = caco.sub
   and NVL(caco.ipn_eap, caco.imp) is not null
   AND tepi.ci         = P_ci
/* modifica del 22/06/2006 */
   AND tepi.trattamento like cur_imvo.trattamento
   AND tepi.gestione    like cur_imvo.gestione
   AND tepi.contratto   like cur_imvo.contratto
/* fine modifica del 22/06/2006 */
   AND caco.rowid = tepi.caco_rowid
   AND caco.ci+0      = P_ci
   AND caco.riferimento
       BETWEEN NVL(imvo.dal,TO_DATE(2222222,'j'))
          AND NVL(imvo.al ,TO_DATE(3333333,'j'))
   AND caco.riferimento
       BETWEEN NVL(tovo.dal,TO_DATE(2222222,'j'))
          AND NVL(tovo.al ,TO_DATE(3333333,'j'))
   AND NVL(caco.arr,' ') =
       DECODE( tovo.anno
            , 'C', DECODE
                  ( TO_CHAR(caco.riferimento,'yyyy')
                  , TO_CHAR(P_fin_ela,'yyyy'), NVL(caco.arr,' ')
                                          , NULL
                  )
            , 'P', DECODE
                  ( TO_CHAR(caco.riferimento,'yyyy')
                  , TO_CHAR(P_fin_ela,'yyyy'), NULL
                                          , NVL(caco.arr,' ')
                  )
            , 'M', ' '
            , 'A', caco.arr
                , NVL(caco.arr,' ')
            )
 GROUP BY imvo.al
        , decode (cur_imvo.specie, 'T'
                 , least(nvl(imvo.al,P_al)
                        ,decode(tepi.classe,'C'
                               ,decode(tepi.specie,'T'
                                      ,decode(tepi.rapporto,'O',least(nvl(imvo.al,P_al),nvl(tepi.pegi_al,P_al)),tepi.al)
                                      ,least(nvl(imvo.al,P_al),nvl(tepi.pegi_al,P_al)))
                               ,tepi.al)
                        ,P_al)
                 , null)
        , DECODE( imvo.al
               ,NULL , NULL
                   , DECODE( SIGN( TO_NUMBER(TO_CHAR( nvl(caco.competenza,caco.riferimento)
                                                 ,'yyyy'))
                                -TO_NUMBER(TO_CHAR( caco.riferimento
                                                 ,'yyyy'))
                               )
                           ,1 , TO_CHAR(nvl(caco.competenza,caco.riferimento),'yyyy')
                             , NULL
                          )
               )
        , decode(cur_imvo.trattamento,'%',null,tepi.trattamento)
        , tepi.ruolo, tepi.funzionale
        , tepi.part_time
        , tepi.pegi_al
        , caco.sede_del, caco.anno_del, caco.numero_del, caco.delibera
order by 5
        ) LOOP
       Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     --Rapporto Orario solo per Part-Time
-- dbms_output.put_line('CMORE8 Voce '||cur_imvo.voce||' competenza '||x.competenza||' ipn_c '||x.ipn_c);
     IF NVL(D_app_voce,' ') != cur_imvo.voce OR
        NVL(D_app_sub,' ')  != cur_imvo.sub  THEN
        D_app_voce := cur_imvo.voce;
        D_app_sub  := cur_imvo.sub;
        D_rif_prec := TO_DATE('2222222','j');
        D_rif_ini  := TO_DATE('2222222','j');
     END IF;
/* modifica del 18/02/2005 */
     IF D_rif_prec != x.riferimento THEN
        D_rif_ini := D_rif_prec+1;
        D_rif_prec := x.riferimento;
/* fine modifica del 18/02/2005 */
     END IF;
     P_stp := 'VOCI_IMPONIBILE-02.4';
     SELECT NVL(SUM(pere.gg_inp * DECODE( posi.part_time
                                , 'SI', ABS(pere.rap_ore)
                                     , 1
                                )
              ),0)
          ,NVL(SUM(NVL(pere.gg_fis,0)),0)
       INTO D_gg_min_gg
          ,D_gg_min_ipn
       FROM POSIZIONI posi
         , RIPARTIZIONI_FUNZIONALI rifu
         , PERIODI_RETRIBUTIVI pere
      WHERE posi.codice (+)  = pere.posizione
        AND rifu.SETTORE (+) = pere.SETTORE+0
        AND rifu.sede    (+) = NVL(pere.sede,0)
        AND pere.ci         = P_ci
        AND pere.periodo     = P_fin_ela
/* modifica del 18/02/2005 */
        AND pere.dal        <= D_rif_prec   -- x.imvo_al
        AND pere.al         >= D_rif_ini
/* fine modifica del 18/02/2005 */
        AND pere.trattamento       LIKE cur_imvo.trattamento
        AND NVL(pere.ruolo,' ')       = NVL(x.ruolo,' ')
        AND NVL(rifu.funzionale,' ')  = NVL(x.funzionale,' ')
        AND NVL(posi.part_time,' ')   = NVL(x.part_time,' ')
     ;
       Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
       IF x.ipn_c <> 0
       OR x.ipn_s <> 0
       OR x.ipn_p <> 0
       OR x.ipn_l <> 0
       OR x.ipn_e <> 0
       OR x.ipn_t <> 0
       OR x.ipn_a <> 0
       OR x.ipn_ap <> 0
       THEN
        <<tratta_voce>>
        BEGIN
          IF NVL(cur_imvo.richiesta,'C') = 'I' THEN
             BEGIN  --Verifica presenza di richiesta Individuale
               P_stp := 'VOCI_IMPONIBILE-03';
               SELECT 'x'
                 INTO w_dummy
                 FROM CALCOLI_CONTABILI
                WHERE voce       = cur_imvo.voce
                  AND ci        = P_ci
                  AND estrazione = 'i'
               ;
           Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
             EXCEPTION
               WHEN TOO_MANY_ROWS THEN
                  NULL;
             END;
          END IF;
          IF NVL(D_dep_voce,' ') != cur_imvo.voce THEN
             BEGIN  --Totalizzazione dell'Imponibile complessivo della
                   --Voce Contabile per calcolo Minimale Contributivo
                   --ecludendo la parte imponibile per Liquidazione
             D_dep_voce := cur_imvo.voce;
             P_stp := 'VOCI_IMPONIBILE-03.1';
     SELECT NVL( SUM( DECODE
/* modifica del 07/09/2005 */
--                    ( tovo.tipo
                      ( DECODE( get_esiste_imas(cur_imvo.voce, tepi.cod_astensione, caco.riferimento)
                              , 0, tovo.tipo
                                 , 'E'
                              )
/* fine modifica del 07/09/2005 */
                    , 'E', DECODE( voec.classe
                               , 'R', caco.imp
                                    , NVL(caco.ipn_eap, caco.imp)
                               )
                        , caco.imp
                    )
                  * NVL(tovo.per_tot, 100) / 100
                  * DECODE(covo.fiscale,'Z',0,'L',0,'A',0,1)
                  )
              , 0 )
       INTO D_ipn_tot
       FROM CONTABILITA_VOCE     covo
          , VOCI_ECONOMICHE      voec
          , TOTALIZZAZIONI_VOCE  tovo
          , CALCOLI_CONTABILI    caco
/* modifica del 07/09/2005 */
          , TEMP_PERE_IPN        tepi
/* fine modifica del 07/09/2005 */
       WHERE covo.voce              = caco.voce||''
        AND covo.sub              = caco.sub
        AND caco.riferimento
                            BETWEEN NVL(covo.dal,TO_DATE(2222222,'j'))
                               AND NVL(covo.al ,TO_DATE(3333333,'j'))
        AND voec.codice            = caco.voce||''
        AND tovo.voce              = caco.voce||''
        AND NVL(tovo.sub, caco.sub) = caco.sub
        AND tovo.voce_acc||''       = cur_imvo.voce
        AND caco.riferimento
                            BETWEEN NVL(tovo.dal,TO_DATE(2222222,'j'))
                               AND NVL(tovo.al ,TO_DATE(3333333,'j'))
/* modifica del 15/12/2004 */
        and NVL(caco.ipn_eap, caco.imp) is not null
/* fine modifica del 15/12/2004 */
        AND caco.ci               = P_ci
        AND NVL(caco.arr,' ')       =
            DECODE( tovo.anno
                 , 'C', DECODE
                       ( TO_CHAR(caco.riferimento,'yyyy')
                       , TO_CHAR(P_fin_ela,'yyyy'), NVL(caco.arr,' ')
                                               , NULL
                       )
                 , 'P', DECODE
                       ( TO_CHAR(caco.riferimento,'yyyy')
                       , TO_CHAR(P_fin_ela,'yyyy'), NULL
                                               , NVL(caco.arr,' ')
                       )
                 , 'M', ' '
                 , 'A', caco.arr
                      , NVL(caco.arr,' ')
                 )
/* modifica del 07/09/2005 */
   AND tepi.ci         = P_ci
   AND caco.rowid      = tepi.caco_rowid
/* fine modifica del 07/09/2005 */
     ;
            Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
             END;
          END IF;
          BEGIN  --Calcolo Imponibile Totale con Assestamento al
                --Massimale, Minimale
                --(ad esclusione dell'imponibile Liquidazione)
                --Assestamento, Imponibilita' e Arrotondamento
--tar            --Imponibile non Arrotondato
--imp            --Imponibile Totale
--ipn_c          --Imponibile Corrente
--ipn_s          --Imponibile Separato
--ipn_p          --Imponibile Anni Prec.
--ipn_l          --Imponibile Liquidazione
--ipn_e          --Imponibile Esente
--ipn_t          --Imponibile Trasferte
--ipn_a          --Imponibile Redditi Assimilati
--ipn_ap         --Imponibile Redditi Assimilati Anni Precedenti
             P_stp := 'VOCI_IMPONIBILE-04';
SELECT
 NVL( x.ipn_c + x.ipn_s + x.ipn_p + x.ipn_l + x.ipn_e, 0 )
, ROUND( DECODE( SIGN( ( x.ipn_c + x.ipn_s + x.ipn_p + x.ipn_e
                    ) * NVL(imvo.moltiplica,1)
                      / NVL(imvo.divide,1)
                  * NVL(imvo.per_ipn,100) / 100
                  )
/*         Assestamento al minimale contributivo del singolo
          Imponibile in proporzione sul totale imponibile
          per la stessa Voce Contabile
*/
            , 0 , ( x.ipn_c + x.ipn_s + x.ipn_p + x.ipn_e + x.ipn_l
                 ) * NVL(imvo.moltiplica,1)
                   / NVL(imvo.divide,1)
                   * NVL(imvo.per_ipn,100) / 100
/* modifica del 27/10/2005 */
--            , -1 , ( x.ipn_c + x.ipn_s + x.ipn_p + x.ipn_e + x.ipn_l
--                   ) * NVL(imvo.moltiplica,1)
--                     / NVL(imvo.divide,1)
--                     * NVL(imvo.per_ipn,100) / 100
/* fine modifica del 27/10/2005 */
/* modifica del 18/02/2005 */
               , decode( D_ipn_tot
                       , 0
               , ( x.ipn_c + x.ipn_s + x.ipn_p + x.ipn_e + x.ipn_l
                 ) * NVL(imvo.moltiplica,1)
                   / NVL(imvo.divide,1)
                   * NVL(imvo.per_ipn,100) / 100
/* fine modifica del 18/02/2005 */
               , LEAST
                  ( GREATEST
                    ( ABS
                      ( x.ipn_c + x.ipn_s + x.ipn_p + x.ipn_e
                      ) * NVL(imvo.moltiplica,1)
                       / NVL(imvo.divide,1)
                       * NVL(imvo.per_ipn,100) /100
                    , ( ABS
                       ( x.ipn_c + x.ipn_s + x.ipn_p + x.ipn_e
                       ) * NVL(imvo.moltiplica,1)
                         / NVL(imvo.divide,1)
                         * NVL(imvo.per_ipn,100) /100
                      ) * ( ( NVL(imvo.min_ipn,0)
                           ) / 30 * ABS(D_gg_min_ipn)
                                 * DECODE(P_tipo,'N',1,0)
                           * DECODE( x.ipn_c, 0, 0, 1)
                         ) / ( DECODE(D_ipn_tot,0,1,ABS(D_ipn_tot))
                             * NVL(imvo.moltiplica,1)
                             / NVL(imvo.divide,1)
                             * NVL(imvo.per_ipn,100) /100
                             )
                    , NVL(x.minim_gg,0) * ABS(D_gg_min_gg)
                                        * DECODE(P_tipo,'N',1,0)
/* Modifica del 01/07/2005 */
                                        * ABS(x.ipn_c + x.ipn_s + x.ipn_p + x.ipn_e)
                                        / DECODE(D_ipn_tot,0,1,ABS(D_ipn_tot))
/* Fine Modifica del 01/07/2005 */
                    ) *
                SIGN( x.ipn_c + x.ipn_s + x.ipn_p + x.ipn_e )
                  , NVL(imvo.max_ipn,9999999999)
                  )
                  ) +
/* Modifica del 10/06/2005 */
              DECODE( SIGN( ( x.ipn_c + x.ipn_s + x.ipn_p + x.ipn_e
                            ) * NVL(imvo.moltiplica,1)
                              / NVL(imvo.divide,1)
                              * NVL(imvo.per_ipn,100) / 100
                          )
                    , 0 , 0
/* Modifica del 06/09/2006 */
                        , decode( D_ipn_tot
                                , 0 , 0
/* Fine modifica del 06/09/2006 */
                                    , ( x.ipn_l
                                      * NVL(imvo.moltiplica,1)
                                      / NVL(imvo.divide,1)
                                      * NVL(imvo.per_ipn,100) / 100
                                      )
                                )
                    )
/* Fine Modifica del 10/06/2005 */
             ) / NVL(imvo.arr_ipn,0.01)
      ) * NVL(imvo.arr_ipn,0.01)
, ROUND( x.ipn_c * NVL(imvo.moltiplica,1)
               / NVL(imvo.divide,1)
               * NVL(imvo.per_ipn,100) / 100
               / NVL(imvo.arr_ipn,0.01)
      ) * NVL(imvo.arr_ipn,0.01)
, ROUND( x.ipn_s * NVL(imvo.moltiplica,1)
               / NVL(imvo.divide,1)
               * NVL(imvo.per_ipn,100) / 100
               / NVL(imvo.arr_ipn,0.01)
      ) * NVL(imvo.arr_ipn,0.01)
, ROUND( x.ipn_p * NVL(imvo.moltiplica,1)
               / NVL(imvo.divide,1)
               * NVL(imvo.per_ipn,100) / 100
               / NVL(imvo.arr_ipn,0.01)
      ) * NVL(imvo.arr_ipn,0.01)
, ROUND( x.ipn_l * NVL(imvo.moltiplica,1)
               / NVL(imvo.divide,1)
               * NVL(imvo.per_ipn,100) / 100
               / NVL(imvo.arr_ipn,0.01)
     ) * NVL(imvo.arr_ipn,0.01)
, ROUND( x.ipn_e * NVL(imvo.moltiplica,1)
               / NVL(imvo.divide,1)
               * NVL(imvo.per_ipn,100) / 100
               / NVL(imvo.arr_ipn,0.01)
      ) * NVL(imvo.arr_ipn,0.01)
, ROUND( x.ipn_t * NVL(imvo.moltiplica,1)
               / NVL(imvo.divide,1)
               * NVL(imvo.per_ipn,100) / 100
               / NVL(imvo.arr_ipn,0.01)
      ) * NVL(imvo.arr_ipn,0.01)
, ROUND( x.ipn_a * NVL(imvo.moltiplica,1)
               / NVL(imvo.divide,1)
               * NVL(imvo.per_ipn,100) / 100
               / NVL(imvo.arr_ipn,0.01)
      ) * NVL(imvo.arr_ipn,0.01)
, ROUND( x.ipn_ap * NVL(imvo.moltiplica,1)
               / NVL(imvo.divide,1)
               * NVL(imvo.per_ipn,100) / 100
               / NVL(imvo.arr_ipn,0.01)
      ) * NVL(imvo.arr_ipn,0.01)
  INTO D_tar
     , D_imp
     , D_ipn_c
     , D_ipn_s
     , D_ipn_p
     , D_ipn_l
     , D_ipn_e
     , D_ipn_t
     , D_ipn_a
     , D_ipn_ap
  FROM IMPONIBILI_VOCE imvo
 WHERE imvo.voce = cur_imvo.voce
   AND x.riferimento
       BETWEEN NVL(imvo.dal,TO_DATE(2222222,'j'))
          AND NVL(imvo.al ,TO_DATE(3333333,'j'))
             ;
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
          END;
          BEGIN  --Estrazione della Voce IMPONIBILE
                --con riallineamento degli Imponibili addizionali
             P_stp := 'VOCI_IMPONIBILE-05';
INSERT INTO CALCOLI_CONTABILI
( ci, voce, sub
, riferimento
, competenza
, input
, estrazione
, tar
, imp
, ipn_c, ipn_s, ipn_p, ipn_l, ipn_e, ipn_t, ipn_a, ipn_ap
, sede_del, anno_del, numero_del, delibera  -- modifica del 28/04/2004
)
VALUES(
 P_ci, cur_imvo.voce, cur_imvo.sub
, x.riferimento
, x.competenza
, 'C'
, 'I'
, D_tar
, D_imp
, DECODE( D_ipn_c
       , 0, 0
         , D_imp - D_ipn_s - D_ipn_p - D_ipn_l - D_ipn_e
       )
, DECODE( D_ipn_c + D_ipn_p
       , 0, D_imp - D_ipn_l - D_ipn_e
         , D_ipn_s
       )
, DECODE( D_ipn_c + D_ipn_s
       , 0, D_imp - D_ipn_l - D_ipn_e
         , D_ipn_p
       )
, D_ipn_l
, D_ipn_e
, D_ipn_t
, D_ipn_a
, D_ipn_ap
, x.sede_del, x.anno_del, x.numero_del, x.delibera
)
             ;
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
          END;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN  --Voce non Valorizzabile
             NULL;
        END tratta_voce;
       END IF;
     END LOOP; -- X
     END LOOP; -- CUR_IMVO
     delete from TEMP_CACO_PERE
      where ci = P_ci
     ;
     delete from TEMP_PERE_IPN
      where ci = P_ci
     ;
  END;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     Peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
END;
/
