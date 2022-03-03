CREATE OR REPLACE PACKAGE peccmocp8 IS
/******************************************************************************
 NOME:        PECCMOCP8
 DESCRIZIONE: Calcolo VOCI TFR         - Previsione
              Calcolo VOCI Imponibile  - Previsione
 
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
******************************************************************************/

revisione varchar2(30) := '4.1 del 15/12/2004';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

PROCEDURE voci_tfr
(
  P_ci          NUMBER
, P_al          DATE    -- Data di Termine o Fine Anno
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
,p_al           DATE    -- Data di Termine o Fine Anno
,p_anno         NUMBER
,p_mese         NUMBER
,p_mensilita     VARCHAR2
,p_fin_ela       DATE
,p_tipo         VARCHAR2
,p_conguaglio    NUMBER
,p_mens_codice   VARCHAR2
,p_periodo       VARCHAR2
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

CREATE OR REPLACE PACKAGE BODY peccmocp8 IS
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
,P_al          DATE    -- Data di Termine o Fine Anno
,P_anno        NUMBER
,P_mese        NUMBER
,P_mensilita   VARCHAR2
,P_fin_ela     DATE
--  Voci parametriche
,P_riv_tfr     VARCHAR2
,P_ret_tfr     VARCHAR2
,P_qta_tfr     VARCHAR2
,P_rit_tfr     VARCHAR2
,P_rit_riv     VARCHAR2
,P_lor_tfr     VARCHAR2
,P_lor_tfr_00  VARCHAR2
,P_lor_riv     VARCHAR2
--Parametri per Trace
,p_trc    IN     NUMBER --Tipo di Trace
,p_prn    IN     NUMBER --Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER --Numero di Passo procedurale
,p_prs    IN OUT NUMBER --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2   --Step elaborato
,p_tim    IN OUT VARCHAR2   --Time impiegato in secondi
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
        peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
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
        WHERE anno   = P_anno
          AND P_anno = TO_CHAR(P_al - 14, 'yyyy')
          AND mese   = TO_CHAR(P_al - 14, 'mm')
        ;
        peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
            D_alq := 0;
     END;
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
         (SELECT DISTINCT anno,mese FROM PERIODI_RETRIBUTIVI_BP
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
     /*Calcola la rivalutazione sul fondo liquidato per ogni mese
 di servizio successivo a quello di liquidazione*/
     IF P_mese != 1 THEN
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
     /*Calcola la rivalutazione spettante come differenza tra:
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
        peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
       END;
     END;
  END IF;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     peccmocp.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
  --Valorizzazione Voci di Imponibile
--
PROCEDURE voci_imponibile
(
 p_ci           NUMBER
,p_anno_ret      NUMBER
,p_al           DATE    --Data di Termine o Fine Anno
,p_anno         NUMBER
,p_mese         NUMBER
,p_mensilita     VARCHAR2
,p_fin_ela       DATE
,p_tipo         VARCHAR2
,p_conguaglio    NUMBER
,p_mens_codice   VARCHAR2
,p_periodo       VARCHAR2
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
  BEGIN  --Preleva dati dell'individuo
     P_stp := 'VOCI_IMPONIBILE-01';
     SELECT SUM(NVL(pere.gg_rat,0))
          , SUM(NVL(pere.gg_rid,0))
          , MAX(pere.rateo_continuativo)
       INTO D_gg_rat
          , D_gg_rid
          , D_rateo_continuativo
       FROM PERIODI_RETRIBUTIVI_BP pere
      WHERE  pere.ci      = P_ci
        AND  pere.periodo = P_fin_ela
/*In *PREVISIONE*  somma tutti i giorni fiscali
        AND TO_NUMBER(TO_CHAR(pere.mese)||TO_CHAR(pere.anno))
                     =
            TO_NUMBER( TO_CHAR(P_fin_ela,'mmyyyy') )
*/
     ;
     peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  --Trattamento singola Voce IMPONIBILE
        --Totalizzazione, Suddivisione in base Fiscale
     P_stp := 'VOCI_IMPONIBILE-02';
     D_dep_voce := NULL;
     D_app_voce := NULL;
     D_app_sub  := NULL;
     FOR   X  IN
        (SELECT
 esvo.voce, esvo.sub, max(esvo.trattamento) trattamento
, pere.ruolo, rifu.funzionale, posi.part_time
, NVL(imvo.al,TO_DATE('3333333','j')) imvo_al
, MAX(least(nvl(imvo.al,P_al),pere.al,P_al)) riferimento   --28/04/2004 - 09/07/2004
-- , MAX(caco.riferimento) riferimento
, MAX(NVL( least(imvo.al, P_al)
         , DECODE( SIGN( TO_NUMBER(TO_CHAR( caco.competenza,'yyyy'))
                       - TO_NUMBER(TO_CHAR( caco.riferimento,'yyyy'))
                       )
                 ,1 , caco.competenza
                    , least(P_al,pere.al)
                  )
          )
      ) competenza                       -- 28/04/2004 - 09/07/2004
--, MAX(NVL(caco.competenza,caco.riferimento)) competenza
, esvo.richiesta
, NVL( SUM( DECODE( tovo.tipo
               , 'E', DECODE( voec.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100) / 100
        * DECODE(covo.fiscale
               ,'C',1,'R',1,'X',1,'F',1,'G',1,'D',1,'N',1,0)
        * DECODE(NVL(caco.arr,'C'),'C',1,0)
        * DECODE(SIGN(pere.rap_ore),-1,-1,1)
        * DECODE(pere.competenza,'P',-1,1)
        / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
        )
    , 0 ) ipn_c
, NVL( SUM( DECODE( tovo.tipo
               , 'E', DECODE( voec.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100) / 100
        * DECODE(covo.fiscale,'S',1,0)
        * DECODE(NVL(caco.arr,'C'),'C',1,0)
        * DECODE(SIGN(pere.rap_ore),-1,-1,1)
        * DECODE(pere.competenza,'P',-1,1)
        / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
        )
    , 0 ) ipn_s
, NVL( SUM( DECODE( tovo.tipo
               , 'E', DECODE( voec.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100 ) / 100
        * DECODE(covo.fiscale,'C',1,'X',1,'R',1,'F',1,'S',1
                           ,'P',1,'Y',1,'G',1,'D',1,'N',1,0)
        * DECODE(NVL(caco.arr,'C')
               ,'P',1,DECODE(covo.fiscale,'P',1,'Y',1,0))
        * DECODE(SIGN(pere.rap_ore),-1,-1,1)
        * DECODE(pere.competenza,'P',-1,1)
        / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
        )
    , 0 ) ipn_p
, NVL( SUM( DECODE( tovo.tipo
               , 'E', DECODE( voec.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100) / 100
        * DECODE(covo.fiscale,'Z',1,'L',1,'A',1,0)
        * DECODE(SIGN(pere.rap_ore),-1,-1,1)
        * DECODE(pere.competenza,'P',-1,1)
        / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
        )
    , 0 ) ipn_l
, NVL( SUM( DECODE( tovo.tipo
               , 'E', DECODE( voec.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100) / 100
        * DECODE(covo.fiscale,'E',1,'T',1,0)
        * DECODE(SIGN(pere.rap_ore),-1,-1,1)
        * DECODE(pere.competenza,'P',-1,1)
        / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
        )
    , 0 ) ipn_e
, NVL( SUM( DECODE( tovo.tipo
               , 'E', DECODE( voec.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100) / 100
        * DECODE(covo.fiscale,'F',1,0)
        * DECODE(SIGN(pere.rap_ore),-1,-1,1)
        * DECODE(pere.competenza,'P',-1,1)
        / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
        )
    , 0 ) ipn_t
, NVL( SUM( DECODE( tovo.tipo
               , 'E', DECODE( voec.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100) / 100
        * DECODE(covo.fiscale,'X',1,0)
        * DECODE(NVL(caco.arr,'C'),'C',1,0)
        * DECODE(SIGN(pere.rap_ore),-1,-1,1)
        * DECODE(pere.competenza,'P',-1,1)
        / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
        )
    , 0 ) ipn_a
, NVL( SUM( DECODE( tovo.tipo
               , 'E', DECODE( voec.classe
                           , 'R', caco.imp
                               , NVL(caco.ipn_eap, caco.imp)
                           )
                    , caco.imp
               )
        * NVL(tovo.per_tot, 100) / 100
        * DECODE(covo.fiscale,'Y',1,'X',1,0)
        * DECODE(NVL(caco.arr,'C'),'P',1,DECODE(covo.fiscale,'Y',1,0))
        * DECODE(SIGN(pere.rap_ore),-1,-1,1)
        * DECODE(pere.competenza,'P',-1,1)
        / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
        )
    , 0 ) ipn_ap
    , MAX(DECODE(qual.cat_minimale
           ,'',DECODE(SIGN(ABS(NVL(pere.rap_ore,0))-1),-1,min_gg_pt
                                                   ,min_gg)
           ,1 ,DECODE(posi.part_time,'SI',min_gg_1_pt
                                     ,min_gg_1)
           ,2 ,DECODE(posi.part_time,'SI',min_gg_2_pt
                                     ,min_gg_2)
           ,3 ,DECODE(posi.part_time,'SI',min_gg_3_pt
                                     ,min_gg_3)))  minim_gg
    , caco.sede_del, caco.anno_del, caco.numero_del, caco.delibera  -- modifica del 28/04/2004
 FROM CONTABILITA_VOCE       covo
    , IMPONIBILI_VOCE        imvo
    , ESTRAZIONI_VOCE        esvo
    , VOCI_ECONOMICHE        voec
    , TOTALIZZAZIONI_VOCE     tovo
    , RIPARTIZIONI_FUNZIONALI rifu
    , POSIZIONI              posi
    , QUALIFICHE             qual
    , PERIODI_RETRIBUTIVI_BP pere
/* modifica del 28/04/2004 */
    , PERIODI_GIURIDICI       pegi
/* fine modifica del 28/04/2004 */
    , CALCOLI_CONTABILI       caco
 WHERE covo.voce       = caco.voce||''
   AND covo.sub        = caco.sub
   AND imvo.voce       = voec.codice||''
   AND voec.codice      = esvo.voce||''
   AND voec.classe||''  = 'I'
   AND esvo.voce       = tovo.voce_acc||''
   AND tovo.voce       = caco.voce||''
   AND NVL(tovo.sub, caco.sub) = caco.sub
/* modifica del 15/12/2004 */
   and NVL(caco.ipn_eap, caco.imp) is not null
/* fine modifica del 15/12/2004 */
   AND caco.voce IN
      (SELECT DISTINCT voce FROM TOTALIZZAZIONI_VOCE
         where voce > ' '--TOTALIZZAZIONI_VOCE
       )
   AND rifu.SETTORE (+) = pere.SETTORE+0
   AND rifu.sede    (+) = NVL(pere.sede,0)
   AND posi.codice (+)  = pere.posizione
   AND qual.numero (+)  = pere.qualifica
   AND pere.ci         = caco.ci+0
   AND pere.periodo     = P_fin_ela
   AND (    pere.competenza IN ('C','A')
        AND caco.input       = UPPER(caco.input)
        OR  pere.competenza  = 'P'
        AND caco.input      != UPPER(caco.input)
        OR  pere.competenza IN ('C','A')
        AND caco.input      != UPPER(caco.input)
        AND NOT EXISTS
          (SELECT 'x'
             FROM PERIODI_RETRIBUTIVI_BP
            WHERE ci         = P_ci
              AND periodo     = P_fin_ela
              AND competenza  = 'P'
              AND caco.riferimento
                      BETWEEN dal AND al
          )
       )
  AND pere.SERVIZIO IN ('Q','I')
  AND NOT EXISTS
          (SELECT 'x'
             FROM PERIODI_RETRIBUTIVI_BP
            WHERE ci         = P_ci
              AND periodo     = P_fin_ela
              AND anno+0      = pere.anno
              AND mese       = pere.mese
              AND al         = pere.al
              AND DECODE(competenza,'P','P','C')
                            = DECODE(pere.competenza,'P','P','C')
              AND pere.SERVIZIO = 'Q'
              AND SERVIZIO = 'N'
          )
/* modifica del 28/04/2004 */
   and pegi.ci(+)        = pere.ci
   and pegi.rilevanza(+) = 'P'
   and pere.al     between nvl(pegi.dal (+), to_date(2222222,'j'))
                       and nvl(pegi.al (+) , to_date(3333333,'j'))
/* fine modifica del 28/04/2004 */
   AND caco.ci+0       = P_ci
   AND caco.riferimento
       BETWEEN NVL(covo.dal,TO_DATE(2222222,'j'))
          AND NVL(covo.al ,TO_DATE(3333333,'j'))
   AND caco.riferimento
       BETWEEN NVL(imvo.dal,TO_DATE(2222222,'j'))
          AND NVL(imvo.al ,TO_DATE(3333333,'j'))
   AND caco.riferimento
       BETWEEN NVL(tovo.dal,TO_DATE(2222222,'j'))
          AND NVL(tovo.al ,TO_DATE(3333333,'j'))
   AND caco.riferimento
       BETWEEN pere.dal
          AND pere.al
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
   AND esvo.gestione||' '||esvo.contratto||' '||
       esvo.condizione||' '||esvo.trattamento||' '||
       DECODE(esvo.richiesta,'I','1','2')
       =
(SELECT MAX(esv2.gestione||' '||esv2.contratto||' '||
          esv2.condizione||' '||esv2.trattamento||' '||
          DECODE(esv2.richiesta,'I','1','2')
         )
  FROM ESTRAZIONI_VOCE esv2
 WHERE esv2.voce          = tovo.voce_acc
   AND pere.gestione    LIKE esv2.gestione
   AND pere.contratto   LIKE esv2.contratto
   AND pere.trattamento LIKE esv2.trattamento
   AND (   esv2.condizione = 'S'
        OR esv2.condizione = 'F' AND P_mese = 12 AND
                                 P_tipo = 'N'
                              /*mese di PERE in *PREVISIONE*/
        OR P_mens_codice LIKE esv2.condizione
        OR SUBSTR(esv2.condizione,1,1) = 'P' AND
          SUBSTR(esv2.condizione,2,1) = P_periodo
        OR esv2.condizione = 'C' AND P_conguaglio = 2
        OR esv2.condizione = 'RA' AND P_conguaglio = 3
        OR esv2.condizione = 'I' AND P_conguaglio IN (1,2,3)
        OR esv2.condizione = 'N' AND P_anno != P_anno_ret
        OR esv2.condizione = 'M' AND P_tipo       = 'N' AND
                                 pere.gg_fis != 0
        OR esv2.condizione = 'R' AND P_tipo       = 'N' AND
          D_gg_rat       > 14
/* modifica del 19/06/02 */
or esv2.condizione = 'RC' and exists
        (select 'x'
           from periodi_retributivi_bp
          where ci          = P_ci
            and periodo     = P_fin_ela
            and to_char(al,'mmyyyy') = to_char(pere.al,'mmyyyy')
            and decode(competenza,'P','P','C')
              = decode(pere.competenza,'P','P','C')
            and rateo_continuativo = 1
        )
/* fine modifica del 19/06/02 */
        OR esv2.condizione = 'G' AND
          D_gg_rid       > 0   AND
/* modifica del 20/01/99 */
          P_tipo        != 'S'
/* fine modifica del 20/01/99 */
       )
)
 GROUP BY esvo.voce, esvo.sub, imvo.al
        , DECODE( imvo.al
               ,NULL , NULL
                   , DECODE( SIGN( TO_NUMBER(TO_CHAR( caco.competenza
                                                 ,'yyyy'))
                                -TO_NUMBER(TO_CHAR( caco.riferimento
                                                 ,'yyyy'))
                               )
                           ,1 , TO_CHAR(caco.competenza,'yyyy')
                             , NULL
                          )
               )
/* modifica del 29/11/2004 */
--        , esvo.trattamento, esvo.richiesta
        , decode(esvo.trattamento,'%',null,pere.trattamento)
        , esvo.richiesta
/* fine modifica del 29/11/2004 */
        , pere.ruolo, rifu.funzionale
        , posi.part_time
/* modifica del 28/04/2004 */
        , pegi.al
        , caco.sede_del, caco.anno_del, caco.numero_del, caco.delibera
/* fine modifica del 28/04/2004 */
/* modifica del 01/12/2004 */
        , decode (voec.specie, 'T', least(nvl(imvo.al,P_al),pere.al,P_al), null)
/* fine modifica del 01/12/2004 */
        ) LOOP
       P_stp := 'VOCI_IMPONIBILE-02';
       Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     --Rapporto Orario solo per Part-Time
     IF NVL(D_app_voce,' ') != x.voce OR
        NVL(D_app_sub,' ')  != x.sub  THEN
        D_app_voce := x.voce;
        D_app_sub  := x.sub;
        D_rif_prec := TO_DATE('2222222','j');
        D_rif_ini  := TO_DATE('2222222','j');
     END IF;
     IF D_rif_prec != x.imvo_al THEN
        D_rif_ini := D_rif_prec+1;
        D_rif_prec := x.imvo_al;
     END IF;
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
         , PERIODI_RETRIBUTIVI_BP pere
      WHERE posi.codice (+)  = pere.posizione
        AND rifu.SETTORE (+) = pere.SETTORE+0
        AND rifu.sede    (+) = NVL(pere.sede,0)
        AND pere.ci         = P_ci
        AND pere.periodo     = P_fin_ela
        AND pere.dal        < x.imvo_al
        AND pere.al         > D_rif_ini
        AND pere.trattamento       LIKE x.trattamento
        AND NVL(pere.ruolo,' ')       = NVL(x.ruolo,' ')
        AND NVL(rifu.funzionale,' ')  = NVL(x.funzionale,' ')
        AND NVL(posi.part_time,' ')   = NVL(x.part_time,' ')
     ;
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
          IF NVL(x.richiesta,'C') = 'I' THEN
             BEGIN  --Verifica presenza di richiesta Individuale
               P_stp := 'VOCI_IMPONIBILE-03';
               SELECT 'x'
                 INTO w_dummy
                 FROM CALCOLI_CONTABILI
                WHERE voce       = x.voce
                  AND ci        = P_ci
                  AND estrazione = 'i'
               ;
           peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
             EXCEPTION
               WHEN TOO_MANY_ROWS THEN
                  NULL;
             END;
          END IF;
          IF NVL(D_dep_voce,' ') != x.voce THEN
             BEGIN  --Totalizzazione dell'Imponibile complessivo della
                   --Voce Contabile per calcolo Minimale Contributivo
                   --ecludendo la parte imponibile per Liquidazione
             D_dep_voce := x.voce;
             P_stp := 'VOCI_IMPONIBILE-03.1';
     SELECT NVL( SUM( DECODE
                    ( tovo.tipo
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
       WHERE covo.voce              = caco.voce||''
        AND covo.sub              = caco.sub
        AND caco.riferimento
                            BETWEEN NVL(covo.dal,TO_DATE(2222222,'j'))
                               AND NVL(covo.al ,TO_DATE(3333333,'j'))
        AND voec.codice            = caco.voce||''
        AND tovo.voce              = caco.voce||''
        AND NVL(tovo.sub, caco.sub) = caco.sub
        AND tovo.voce_acc||''       = x.voce
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
     ;
            peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
             END;
          END IF;
          BEGIN  --Calcolo Imponibile Totale con Assestamento al
                -- Massimale, Minimale
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
                    ) *
                SIGN( x.ipn_c + x.ipn_s + x.ipn_p + x.ipn_e )
                  , NVL(imvo.max_ipn,9999999999)
                  ) + x.ipn_l
                    * NVL(imvo.moltiplica,1)
                    / NVL(imvo.divide,1)
                    * NVL(imvo.per_ipn,100) / 100
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
 WHERE imvo.voce = x.voce
   AND x.riferimento
       BETWEEN NVL(imvo.dal,TO_DATE(2222222,'j'))
          AND NVL(imvo.al ,TO_DATE(3333333,'j'))
             ;
          peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
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
 P_ci, x.voce, x.sub
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
          peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
          END;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN  --Voce non Valorizzabile
             NULL;
        END tratta_voce;
       END IF;
     END LOOP;
  END;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     peccmocp.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
END;
/

