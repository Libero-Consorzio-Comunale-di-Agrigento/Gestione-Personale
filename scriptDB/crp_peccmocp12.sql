CREATE OR REPLACE PACKAGE peccmocp12 IS
/******************************************************************************
 NOME:        PECCMOCP12
 DESCRIZIONE: Calcolo VOCI Fiscali Liq - Previsione
              Calcolo VOCI Fiscali Anz - Previsione
              Calcolo VOCI Fiscali Det - Previsione
 
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1.1  25/07/2007  AM     Adeguamento per gestione RADI + gestione det. senza automatismo
******************************************************************************/

revisione varchar2(30) := '1.1 del 25/07/2007';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

PROCEDURE voci_fisc_liq
(
 p_ci         NUMBER
,p_al         DATE    -- Data di Termine o Fine Anno
,p_anno       NUMBER
,p_mese       NUMBER
,p_mensilita  VARCHAR2
,p_fin_ela    DATE
--
, P_tfr_totale       NUMBER
, P_ipn_liq          NUMBER
, P_ratei_anz        NUMBER
, P_rid_liq          NUMBER
, P_rtp_liq          NUMBER
, P_ipn_liq_res      NUMBER
, P_ipt_liq_mp       NUMBER
, P_ipt_liq_ap       NUMBER
, P_alq_liq_mp       NUMBER
, P_perc_irpef_liq   NUMBER
--Valori di ritorno
, P_alq_liq         IN OUT NUMBER
, P_ipt_liq         IN OUT NUMBER
--Parametri per Trace
,p_trc    IN     NUMBER     --Tipo di Trace
,p_prn    IN     NUMBER     --Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     --Numero di Passo procedurale
,p_prs    IN OUT NUMBER     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
);
PROCEDURE voci_fisc_anz
( P_ci              NUMBER
, P_fin_ela          DATE
, P_base_ratei       VARCHAR2
, P_gg_anz_t   IN OUT NUMBER
, P_gg_anz_i   IN OUT NUMBER
, P_gg_anz_r   IN OUT NUMBER
);
  PROCEDURE voci_fisc_det
(
 p_ci            NUMBER
,p_ci_lav_pr      VARCHAR2
,p_al            DATE    --Data di Termine o Fine Anno
,p_anno          NUMBER
,p_mese          NUMBER
,p_mensilita      VARCHAR2
,p_fin_ela       DATE
,p_tipo          VARCHAR2
,p_conguaglio     NUMBER
,p_base_ratei     VARCHAR2
,p_base_det       VARCHAR2
,p_mesi_irpef     NUMBER
,p_base_cong      VARCHAR2
,p_scad_cong      VARCHAR2
,p_rest_cong      VARCHAR2
,p_effe_cong      VARCHAR2
,p_rate_addizionali NUMBER
,p_detrazioni_ap    VARCHAR2
,p_spese         NUMBER
,p_ulteriori      NUMBER
,p_tipo_ulteriori VARCHAR2
,p_gg_lav_ac      NUMBER
,p_gg_det_ac      NUMBER
,p_ipn_tot_ac     NUMBER
,p_ipt_tot_ac     NUMBER
,p_ipn_terzi      NUMBER
,p_ass_terzi      NUMBER
,p_imp_det_fis IN OUT NUMBER
,p_imp_det_con IN OUT NUMBER
,p_imp_det_fig IN OUT NUMBER
,p_imp_det_alt IN OUT NUMBER
,p_imp_det_spe IN OUT NUMBER
,p_imp_det_ult IN OUT NUMBER
--Voci parametriche
, P_det_con      VARCHAR2
, P_det_fig      VARCHAR2
, P_det_alt      VARCHAR2
, P_det_spe      VARCHAR2
, P_det_ult      VARCHAR2
--Per il calcolo delle detrazioni per spese a scaglioni
, P_ipn_ord      NUMBER
, P_ipn_tot_ass_ac NUMBER
, P_ipn_ass       NUMBER
, p_somme_od   IN   NUMBER
, p_somme_od_ac IN  NUMBER
--Parametri per Trace
,p_trc    IN     NUMBER     --Tipo di Trace
,p_prn    IN     NUMBER     --Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     --Numero di Passo procedurale
,p_prs    IN OUT NUMBER     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
);
END;
/

CREATE OR REPLACE PACKAGE BODY peccmocp12 IS
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

--Determinazione dell'Aliquota e Imposta di Liquidazione Anzianita`
PROCEDURE voci_fisc_liq
(
 p_ci         NUMBER
,p_al         DATE    -- Data di Termine o Fine Anno
,p_anno       NUMBER
,p_mese       NUMBER
,p_mensilita  VARCHAR2
,p_fin_ela    DATE
--
, P_tfr_totale       NUMBER
, P_ipn_liq          NUMBER
, P_ratei_anz        NUMBER
, P_rid_liq          NUMBER
, P_rtp_liq          NUMBER
, P_ipn_liq_res      NUMBER
, P_ipt_liq_mp       NUMBER
, P_ipt_liq_ap       NUMBER
, P_alq_liq_mp       NUMBER
, P_perc_irpef_liq   NUMBER
--Valori di ritorno
, P_alq_liq         IN OUT NUMBER
, P_ipt_liq         IN OUT NUMBER
--Parametri per Trace
,p_trc    IN     NUMBER     --Tipo di Trace
,p_prn    IN     NUMBER     --Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     --Numero di Passo procedurale
,p_prs    IN OUT NUMBER     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
) IS
BEGIN
  BEGIN  --Calcolo Aliquota e Imposta
    SELECT
     DECODE( P_perc_irpef_liq
           , NULL,
     NVL( ROUND( ( ( ( DECODE( P_tfr_totale
                             , 0, P_ipn_liq_res
                                , P_tfr_totale ) * 12 / P_ratei_anz )
                     - scfi.scaglione
                   ) * scfi.aliquota / 100 + scfi.imposta
                 )
                 * 100
                 / GREATEST( 1, DECODE( P_tfr_totale
                                      , 0, P_ipn_liq_res
                                         , P_tfr_totale
                                      ) * 12 / P_ratei_anz )
               , 2 )
        , 0 )
                 , P_perc_irpef_liq
           )
    , GREATEST
      ( 0
      , NVL( ( GREATEST( P_ipn_liq - nvl(P_rid_liq,0) - nvl(P_rtp_liq,0)
                     , 0
                     ) + P_ipn_liq_res
              ) * DECODE( P_perc_irpef_liq
                        , NULL,
                  ROUND( ( ( ( DECODE( P_tfr_totale
                                     , 0, P_ipn_liq_res
                                        , P_tfr_totale
                                     ) * 12 / P_ratei_anz )
                           - scfi.scaglione
                           ) * scfi.aliquota / 100 + scfi.imposta )
                         * 100
                         / GREATEST( 1, DECODE( P_tfr_totale
                                              , 0, P_ipn_liq_res
                                                 , P_tfr_totale
                                              ) * 12 / P_ratei_anz )
                       , 2 )
                              , P_perc_irpef_liq
/* modifica del 18/12/2000 */
                        )
                / 100
            , 0 )
       ) - P_ipt_liq_mp - P_ipt_liq_ap
      INTO P_alq_liq
         , P_ipt_liq
       FROM SCAGLIONI_FISCALI scfi
             WHERE scfi.scaglione =
                  (SELECT MAX(scaglione)
                     FROM SCAGLIONI_FISCALI
                    WHERE scaglione <= DECODE( P_tfr_totale
                                             , 0, P_ipn_liq_res
                                                , P_tfr_totale
                                             ) * 12 / P_ratei_anz
                      AND P_al+1 BETWEEN nvl(dal,to_date(2222222,'j'))
                                   AND NVL(al ,TO_DATE(3333333,'j'))
                  )
               AND P_al+1      BETWEEN nvl(scfi.dal,to_date(2222222,'j'))
                                   AND NVL(scfi.al ,TO_DATE(3333333,'j'))
     ;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
         P_alq_liq := P_alq_liq_mp;
         P_ipt_liq := 0;
  END;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     peccmocp.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
--Totalizza Giorni di Anzianita`
--
PROCEDURE voci_fisc_anz
( P_ci              NUMBER
, P_fin_ela          DATE
, P_base_ratei       VARCHAR2
, P_gg_anz_t   IN OUT NUMBER
, P_gg_anz_i   IN OUT NUMBER
, P_gg_anz_r   IN OUT NUMBER
) IS
BEGIN
         SELECT NVL
                ( SUM
                  ( DECODE
                    ( P_base_ratei
                    , 'G', SUM( GREATEST(pere.gg_fis,pere.gg_con) )
                         , ( ROUND( ( SUM( GREATEST(pere.gg_fis,pere.gg_con)
                                         * DECODE(pere.competenza,'A',1,'C',1,0)
                                         ) - 1
                                    ) / 30
                                  )
                           + ROUND( ( SUM( GREATEST(pere.gg_fis,pere.gg_con)
                                         * DECODE(pere.competenza,'P',1,0)
                                         ) + 1
                                    ) / 30
                                  )
                           ) * 30
                    )
                  )
                , 0
                )
              , NVL
                ( SUM
                  ( DECODE
                    ( P_base_ratei
                    , 'G', SUM( GREATEST(pere.gg_fis,pere.gg_con) )
                         - SUM( GREATEST(pere.gg_fis,pere.gg_con)
                              * DECODE(ABS(pere.rap_ore),1,0,1)
                              )
                         , ( ROUND( ( SUM( GREATEST(pere.gg_fis,pere.gg_con)
                                         * DECODE(pere.competenza,'A',1,'C',1,0)
                                         ) - 1
                                    ) / 30
                                  )
                           + ROUND( ( SUM( GREATEST(pere.gg_fis,pere.gg_con)
                                         * DECODE(pere.competenza,'P',1,0)
                                         ) + 1
                                    ) / 30
                                  )
                           ) * 30
                         - ( ROUND( ( SUM( GREATEST(pere.gg_fis,pere.gg_con)
                                         * DECODE(ABS(pere.rap_ore),1,0,1)
                                         * DECODE(pere.competenza,'A',1,'C',1,0)
                                         ) - 1
                                    ) / 30
                                  )
                           + ROUND( ( SUM( GREATEST(pere.gg_fis,pere.gg_con)
                                         * DECODE(ABS(pere.rap_ore),1,0,1)
                                         * DECODE(pere.competenza,'P',1,0)
                                         ) + 1
                                    ) / 30
                                  )
                           ) * 30
                    )
                  )
                , 0
                )
              , NVL
                ( SUM
                  ( DECODE
                    ( P_base_ratei
                    , 'G', SUM( pere.gg_fis
                              * DECODE(ABS(pere.rap_ore),1,0,1)
                              )
                         , ( ROUND( ( SUM( pere.gg_fis
                                         * DECODE(ABS(pere.rap_ore),1,0,1)
                                         * DECODE(pere.competenza,'A',1,'C',1,0)
                                         ) - 1
                                    ) / 30
                                  )
                           + ROUND( ( SUM( pere.gg_fis
                                         * DECODE(ABS(pere.rap_ore),1,0,1)
                                         * DECODE(pere.competenza,'P',1,0)
                                         ) + 1
                                    ) / 30
                                  )
                           ) * 30
                    ) * SUM( pere.gg_fis
                           * DECODE( ABS(pere.rap_ore)
                                   , 1, 0
                                      , ABS(pere.rap_ore)
                                   )
                           )
                      / DECODE( SUM( pere.gg_fis
                                   * DECODE( ABS(pere.rap_ore)
                                           , 1, 0
                                              , 1
                                           )
                                   )
                              , 0, 1
                                 , SUM( pere.gg_fis
                                      * DECODE( ABS(pere.rap_ore)
                                              , 1, 0
                                                 , 1
                                              )
                                      )
                              )
                  )
                , 0
                )
    INTO P_gg_anz_t
       , P_gg_anz_i
       , P_gg_anz_r
    FROM PERIODI_RETRIBUTIVI_BP pere
   WHERE pere.ci         = P_ci
     AND pere.periodo     = P_fin_ela
     AND pere.competenza IN ('P','C','A')
     AND pere.SERVIZIO    = 'Q'
   GROUP BY pere.anno,pere.mese
  ;
END;
--Assestamento Detrazioni Fiscali di Imposta
--
PROCEDURE voci_fisc_det
(
 p_ci            NUMBER
,p_ci_lav_pr      VARCHAR2
,p_al            DATE    --Data di Termine o Fine Anno
,p_anno          NUMBER
,p_mese          NUMBER
,p_mensilita      VARCHAR2
,p_fin_ela       DATE
,p_tipo          VARCHAR2
,p_conguaglio     NUMBER
,p_base_ratei     VARCHAR2
,p_base_det       VARCHAR2
,p_mesi_irpef     NUMBER
,p_base_cong      VARCHAR2
,p_scad_cong      VARCHAR2
,p_rest_cong      VARCHAR2
,p_effe_cong      VARCHAR2
,p_rate_addizionali NUMBER
,p_detrazioni_ap    VARCHAR2
,p_spese         NUMBER
,p_ulteriori      NUMBER
,p_tipo_ulteriori VARCHAR2
,p_gg_lav_ac      NUMBER
,p_gg_det_ac      NUMBER
,p_ipn_tot_ac     NUMBER
,p_ipt_tot_ac     NUMBER
,p_ipn_terzi      NUMBER
,p_ass_terzi      NUMBER
,p_imp_det_fis IN OUT NUMBER
,p_imp_det_con IN OUT NUMBER
,p_imp_det_fig IN OUT NUMBER
,p_imp_det_alt IN OUT NUMBER
,p_imp_det_spe IN OUT NUMBER
,p_imp_det_ult IN OUT NUMBER
--Voci parametriche
, P_det_con      VARCHAR2
, P_det_fig      VARCHAR2
, P_det_alt      VARCHAR2
, P_det_spe      VARCHAR2
, P_det_ult      VARCHAR2
--Per il calcolo delle detrazioni per spese a scaglioni
, P_ipn_ord      NUMBER
, P_ipn_tot_ass_ac NUMBER
, P_ipn_ass       NUMBER
, p_somme_od      NUMBER
, p_somme_od_ac   NUMBER

--Parametri per Trace
,p_trc    IN     NUMBER     --Tipo di Trace
,p_prn    IN     NUMBER     --Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     --Numero di Passo procedurale
,p_prs    IN OUT NUMBER     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
) IS
D_val_det_con    INFORMAZIONI_EXTRACONTABILI.det_con%TYPE;
D_val_det_fig    INFORMAZIONI_EXTRACONTABILI.det_fig%TYPE;
D_val_det_alt    INFORMAZIONI_EXTRACONTABILI.det_alt%TYPE;
D_val_det_spe    INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_val_det_ult    INFORMAZIONI_EXTRACONTABILI.det_ult%TYPE;
D_p_imp_det      INFORMAZIONI_EXTRACONTABILI.det_ult%TYPE;
D_imp_det       INFORMAZIONI_EXTRACONTABILI.det_ult%TYPE;
D_imponibile    NUMBER;
D_reddito_dip    NUMBER;
BEGIN
/* Inizio Modifica del 20/12/2002*/
/*
  select decode(p_conguaglio,0,p_ipn_ord - P_ipn_ass + p_somme_od, p_ipn_tot_ac - p_ipn_tot_ass_ac + p_ipn_terzi 
                - p_ass_terzi + p_somme_od_ac)
    into D_imponibile
    from dual
  ;
*/
  D_reddito_dip := 0;
  IF NVL(P_effe_cong,P_scad_cong) IN ('M','A')
/*
In *PREVISIONE* e` sempre ora di conguaglio
     AND P_mese                     = 12
     AND P_tipo                     IN ( 'S', 'N' )
*/
     AND P_anno >= 2003
     OR  P_conguaglio       != 0
     AND NVL(P_effe_cong,' ') != 'N'
     AND P_anno >= 2003
     OR  NVL(P_effe_cong,' ') = 'M'
     AND P_anno >= 2003 THEN 
--     D_imponibile := p_ipn_tot_ac + p_ipn_terzi + p_somme_od_ac;
     D_imponibile := p_ipn_tot_ac + p_ipn_terzi;
--     D_reddito_dip := p_ipn_tot_ac + p_ipn_terzi + p_somme_od_ac - p_ipn_tot_ass_ac - p_ass_terzi;
     D_reddito_dip := p_ipn_tot_ac + p_ipn_terzi - p_ipn_tot_ass_ac - p_ass_terzi;
   ELSE
--     D_imponibile := p_ipn_ord + p_somme_od;
     D_imponibile := p_ipn_ord ;
--     D_reddito_dip := p_ipn_ord + p_somme_od - p_ipn_ass;
     D_reddito_dip := p_ipn_ord - p_ipn_ass;
   END IF;
  IF P_anno <= 2002 and p_conguaglio = 0 THEN
    D_imponibile := D_imponibile - p_somme_od;
  ELSIF P_anno <= 2002 and p_conguaglio != 0 THEN
    D_imponibile := D_imponibile - p_somme_od_ac;
  END IF;
  PECCMOCP_AUTOFAM.VOCI_AUTO_FAM  -- Emissione voci di Carico Familiare
                          -- e altre Detrazioni
        ( P_ci, P_al
        , P_anno, P_mese, P_mensilita, P_fin_ela
        , P_tipo, P_conguaglio
        , P_base_ratei, P_base_det
        , P_spese, P_ulteriori, P_tipo_ulteriori
        , to_number(null)
        , P_det_con, P_det_fig, P_det_alt, P_det_spe, P_det_ult,'D'
        , D_imponibile, D_reddito_dip
        , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
        );
/* Fine Modifica del 20/12/2002*/
  IF NVL(P_spese,0) =  99 AND P_tipo = 'N' THEN
  BEGIN
     INSERT INTO CALCOLI_CONTABILI
         ( ci, voce, sub
         , riferimento
         , arr
         , input
         , estrazione
         , tar
         , imp
         )
     SELECT P_ci, P_det_spe, '*'
         , LEAST( P_al, MAX(pere.al) )
         , DECODE( pere.mese, P_mese, '', 'C')
         , 'C'
         , 'AF'
         , NVL( MAX( SCDF.detrazione / 12 ) ,0)
         , NVL( MAX( SCDF.detrazione / 360 ) * SUM(pere.gg_fis) ,0)
       FROM SCAGLIONI_DETRAZIONE_FISCALE SCDF
         , PERIODI_RETRIBUTIVI_BP pere
      WHERE SCDF.tipo = 'SP'
        AND SCDF.scaglione =
          (SELECT MAX(scaglione)
             FROM SCAGLIONI_DETRAZIONE_FISCALE
            WHERE tipo = 'SP'
              AND scaglione <=
                 GREATEST(P_ipn_ord-P_ipn_ass,0)*P_mesi_irpef
              AND P_fin_ela BETWEEN dal
                             AND NVL(al ,TO_DATE(3333333,'j'))
          )
        AND P_fin_ela BETWEEN SCDF.dal
                       AND NVL(SCDF.al ,TO_DATE(3333333,'j'))
        AND pere.ci         = P_ci
        AND pere.periodo     = P_fin_ela
        AND pere.anno+0      = P_anno
        AND pere.competenza IN ('P','C','A')
        AND pere.SERVIZIO    = 'Q'
     GROUP BY pere.anno,pere.mese
     HAVING SUM(pere.gg_fis) != 0
     ;
  END;
  END IF;
  IF NVL(P_effe_cong,' ') != 'M' THEN
     BEGIN  --Annulla eventuale valore presente in Det.Ult. Fissa
           --e in Det.Spe. Fissa
        P_stp := 'VOCI_FISC_DET-01';
        UPDATE INFORMAZIONI_EXTRACONTABILI
          SET det_ult  = NULL
            , det_spe  = NULL
        WHERE ci       = P_ci
          AND anno     = P_anno
          AND (   det_ult IS NOT NULL
               OR det_spe IS NOT NULL
              )
        ;
        peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF;
/* Calcolo se anno < 2003 */
  IF  NVL(P_effe_cong,P_scad_cong) IN ('M','A')
/*
In *PREVISIONE* e` sempre ora di conguaglio
  AND P_mese                     = 12
  AND P_tipo                     IN ( 'S', 'N' )
*/
  AND P_anno < 2003
  OR  P_conguaglio       != 0
  AND NVL(P_effe_cong,' ') != 'N'
  AND P_anno < 2003
--OR  P_base_cong         = 'P'
  OR  NVL(P_effe_cong,' ') = 'M'
  AND P_anno < 2003
  THEN
  BEGIN  --Esegue Ricalcolo Detrazioni Fiscali
        --se mese di conguaglio
        --oppure
        --se Cessazione, Interruzzione o Ripresa
        --oppure
        --se conguaglio Mensile per Individuo
     IF NVL(P_spese,0) !=  0 THEN
        BEGIN  --Applicazione Correttivo a SPESE PRODUZIONE
              --solo se Spese di RAPPORTI_RETRIBUTIVI sono != 0
              --[ 0 = non vuole Spese Produz.]
          P_stp := 'VOCI_FISC_DET-02';
          UPDATE INFORMAZIONI_EXTRACONTABILI inex
          SET det_spe =
          (SELECT defi.importo * 12
                             / 365
                             * P_gg_det_ac
             FROM DETRAZIONI_FISCALI  defi
            WHERE defi.tipo       = 'SP'
              AND defi.numero      = P_spese
              AND defi.codice      = '*'
              AND P_fin_ela  BETWEEN nvl(defi.dal,to_date(2222222,'j'))
                              AND NVL(defi.al ,TO_DATE(3333333,'j'))
          )
           WHERE ci   = P_ci
             AND anno = P_anno
          ;
          peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;
        IF NVL(P_spese,0) != 0 AND NVL(P_spese,0) <= 50 OR
          NVL(P_spese,0)  = 99 THEN
        BEGIN  --Applicazione Conguaglio a SPESE PRODUZIONE
          P_stp := 'VOCI_FISC_DET-02.1';
UPDATE INFORMAZIONI_EXTRACONTABILI inex
SET det_spe =
(SELECT
 NVL( MAX( SCDF.detrazione
          / 365
     /* Vecchio calcolo
            ( to_number(to_char(to_date( '3112'||to_char(inex.anno)
                             ,'ddmmyyyy'),'j'))
             -to_number(to_char(to_date( '3112'||to_char(inex.anno-1)
                             ,'ddmmyyyy'),'j'))
            )
     */
          * P_gg_det_ac
        )
     ,0)
  FROM SCAGLIONI_DETRAZIONE_FISCALE SCDF
 WHERE SCDF.tipo = 'SP'
   AND SCDF.scaglione =
      (SELECT MAX(scaglione)
        FROM SCAGLIONI_DETRAZIONE_FISCALE
        WHERE tipo = 'SP'
         AND scaglione <= P_ipn_tot_ac + P_ipn_terzi
                      - P_ass_terzi - P_ipn_tot_ass_ac
         AND P_fin_ela BETWEEN nvl(dal,to_date(2222222,'j'))
                         AND NVL(al ,TO_DATE(3333333,'j'))
      )
   AND P_fin_ela BETWEEN nvl(SCDF.dal,to_date(2222222,'j'))
                   AND NVL(SCDF.al ,TO_DATE(3333333,'j'))
)
 WHERE ci   = P_ci
  AND anno = P_anno
  AND EXISTS (SELECT 'x' FROM SCAGLIONI_DETRAZIONE_FISCALE
              WHERE tipo = 'SP'
               AND P_fin_ela BETWEEN nvl(dal,to_date(2222222,'j'))
                               AND NVL(al ,TO_DATE(3333333,'j'))
            )
          ;
          Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;
     END IF;
     END IF;
     IF NVL(P_ulteriori,9) !=  0 AND
        P_tipo_ulteriori IS NOT NULL THEN
        BEGIN  --Applicazione Correttivo ad ULTERIORI DETRAZIONI
              --solo se Ulteriori di RAPPORTI_RETRIBUTIVI sono != 0
              --[ 0 = non vuole Ult.Detrazioni]
          P_stp := 'VOCI_FISC_DET-03';
UPDATE INFORMAZIONI_EXTRACONTABILI inex
SET det_ult =
(SELECT
 NVL( MAX( LEAST
          ( SCDF.detrazione
          , GREATEST
            ( scdf2.detrazione
            , scdf2.scaglione - NVL( scdf2.imposta
                                , scdf2.scaglione + SCDF.detrazione
                                )
                            + SCDF.detrazione
                            - ( P_ipn_tot_ac
                             + P_ipn_terzi - P_ass_terzi
                             - P_ipt_tot_ac)
            )
          ) / 365
            * DECODE( P_tipo_ulteriori
                   , 'RP', 365
                         , P_gg_det_ac
                   )
/* ---Precedente sistema di rapporto ---
          ) / 12
            * decode( P_base_det
                   , 'G', P_gg_lav_ac / 30
                   , 'M', ceil(P_gg_lav_ac / 30)
                       , round(P_gg_lav_ac / 30 )
                   )
*/
        )
     ,0)
  FROM SCAGLIONI_DETRAZIONE_FISCALE SCDF
     , SCAGLIONI_DETRAZIONE_FISCALE scdf2
 WHERE SCDF.tipo = P_tipo_ulteriori
   AND SCDF.scaglione =
      (SELECT MAX(scaglione)
        FROM SCAGLIONI_DETRAZIONE_FISCALE
        WHERE tipo = P_tipo_ulteriori
         AND (   scaglione < scdf2.scaglione
              OR scaglione = 0 AND
                scdf2.scaglione = 0
             )
         AND P_fin_ela BETWEEN nvl(dal,to_date(2222222,'j'))
                         AND NVL(al ,TO_DATE(3333333,'j'))
      )
   AND P_fin_ela BETWEEN nvl(SCDF.dal,to_date(2222222,'j'))
                   AND NVL(SCDF.al ,TO_DATE(3333333,'j'))
   AND scdf2.tipo = P_tipo_ulteriori
   AND scdf2.scaglione =
      (SELECT MAX(scaglione)
        FROM SCAGLIONI_DETRAZIONE_FISCALE
        WHERE tipo = P_tipo_ulteriori
         AND scaglione <= P_ipn_tot_ac
         AND P_fin_ela BETWEEN nvl(dal,to_date(2222222,'j'))
                         AND NVL(al ,TO_DATE(3333333,'j'))
      )
   AND P_fin_ela BETWEEN nvl(scdf2.dal,to_date(2222222,'j'))
                   AND NVL(scdf2.al ,TO_DATE(3333333,'j'))
)
 WHERE ci   = P_ci
  AND anno = P_anno
          ;
          peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;
     END IF;
     IF P_ci_lav_pr IS NOT NULL THEN
          BEGIN  --Detrae dal valore di Detrazioni calcolato
                --eventuale valore gia' percepito da precedente
                --Datore di Lavoro in INFORMAZIONI_FISCALI di CI_EREDE
             P_stp := 'VOCI_FISC_DET-04';
        UPDATE INFORMAZIONI_EXTRACONTABILI inex
          SET (det_ult,det_spe) =
             (SELECT NVL(inex.det_ult,0) - NVL(SUM(mofi.det_ult),0)
                  , NVL(inex.det_spe,0) - NVL(SUM(mofi.det_spe),0)
               FROM MOVIMENTI_FISCALI mofi
               WHERE anno = P_anno
/* modifica del 08/03/99 */
                AND ci  IN
               (SELECT ci_erede FROM RAPPORTI_DIVERSI radi
                WHERE ci = P_ci
/* modifica del 25/07/2007 */
                  AND rilevanza = 'L'
                  AND anno = P_anno
/* sostituita la vecchia lettura con il nuovo test sulla rilevanza
                  AND EXISTS
                     (SELECT'x'
                       FROM RAPPORTI_INDIVIDUALI
                      WHERE ni = (SELECT ni FROM RAPPORTI_INDIVIDUALI
                                  WHERE ci = P_ci)
                        AND ci = radi.ci_erede
                        AND rapporto IN
                          (SELECT codice FROM CLASSI_RAPPORTO
                            WHERE presenza = 'NO')
                     )
 fine modifica del 25/07/2007 */
               )
/* fine modifica del 08/03/99 */
             )
        WHERE ci   = P_ci
          AND anno = P_anno
             ;
          peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
          END;
        END IF;
  --END IF;       Spostato prima dello step precedente
  END;
/* calcolo dal 2003 in poi */

/* modifica del 03/12/2004 */
/*
  ELIMINATO LO STEP: MOFI del mese non è ancora stato prodotto, lo step non ha senso
  ELSIF  NVL(P_effe_cong,P_scad_cong) IN ('M','A')
-- In *PREVISIONE* e` sempre ora di conguaglio
--       AND P_mese                     = 12
--       AND P_tipo                     IN ( 'S', 'N' )
         AND P_anno >= 2003
         AND NVL(P_effe_cong,' ') != 'M'
         OR  P_conguaglio       != 0
         AND NVL(P_effe_cong,' ') != 'N'
         AND P_anno >= 2003
         AND NVL(P_effe_cong,' ') != 'M'
--OR  P_base_cong         = 'P'
--         OR  NVL(P_effe_cong,' ') = 'M'
--         AND P_anno >= 2003
     THEN 
     UPDATE INFORMAZIONI_EXTRACONTABILI inex
        SET det_ult = (SELECT NVL(SUM(mofi.det_ult),0)
                         FROM MOVIMENTI_FISCALI mofi
                        WHERE anno = P_anno
                          AND mese = P_mese
                          AND mensilita = P_mensilita
                          AND ci   = P_ci)
        WHERE ci   = P_ci
          AND anno = P_anno
     ;
*/
/* fine modifica del 03/12/2004 */
  END IF;
  IF  NVL(P_effe_cong,P_scad_cong) IN ('M','A')
/*
In *PREVISIONE* e` sempre ora di conguaglio
  AND P_mese                     = 12
  AND P_tipo                     IN ( 'S', 'N' )
*/
  OR  P_conguaglio       != 0
  OR  NVL(P_effe_cong,' ') = 'M'
  THEN
     BEGIN  --Emette Detrazioni Fiscali Fisse
        P_stp := 'VOCI_FISC_DET-05';
        BEGIN  --Preleva valore detrazioni fisse
          SELECT det_con
               , det_fig
               , det_alt
               , det_spe
               , det_ult
            INTO D_val_det_con
               , D_val_det_fig
               , D_val_det_alt
               , D_val_det_spe
               , D_val_det_ult
            FROM INFORMAZIONI_EXTRACONTABILI
           WHERE ci   = P_ci
             AND anno = P_anno
          ;
        END;
        IF D_val_det_con IS NOT NULL AND  
           P_det_con     IS NOT NULL THEN  --Detrazioni CONIUGE
          BEGIN  --Preleva valore progressivo precedente
             SELECT NVL(SUM(prco.p_imp),0)
               INTO D_p_imp_det
               FROM progressivi_contabili prco
              WHERE prco.ci       = P_ci
               AND prco.anno      = P_anno
               AND prco.mese      = P_mese
               AND prco.MENSILITA = P_mensilita
               AND prco.voce      = P_det_con
             ;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   D_p_imp_det := 0;
          END;
          BEGIN  --Preleva valore mese corrente
             SELECT NVL(SUM(caco.imp),0)
               INTO D_imp_det
               FROM CALCOLI_CONTABILI caco
              WHERE caco.ci       = P_ci
               AND caco.voce      = P_det_con
             ;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   D_imp_det := 0;
          END;
          BEGIN  --Inserisce voce detrazione a conguaglio
             INSERT INTO CALCOLI_CONTABILI
                 ( ci, voce, sub
                 , riferimento
                 , input
                 , estrazione
                 , imp
                 )
             VALUES( P_ci, P_det_con, '*'
                  , P_al
                  , 'C'
                  , 'AF'
                  , D_val_det_con - D_p_imp_det - D_imp_det
                  )
             ;
          END;
        END IF;
        IF D_val_det_fig IS NOT NULL AND   
           P_det_fig     IS NOT NULL THEN  --Detrazioni FIGLI
          BEGIN  --Preleva valore progressivo precedente
             SELECT NVL(SUM(prco.p_imp),0)
               INTO D_p_imp_det
               FROM progressivi_contabili prco
              WHERE prco.ci       = P_ci
               AND prco.anno      = P_anno
               AND prco.mese      = P_mese
               AND prco.MENSILITA = P_mensilita
               AND prco.voce      = P_det_fig
             ;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   D_p_imp_det := 0;
          END;
          BEGIN  --Preleva valore mese corrente
             SELECT NVL(SUM(caco.imp),0)
               INTO D_imp_det
               FROM CALCOLI_CONTABILI caco
              WHERE caco.ci       = P_ci
               AND caco.voce      = P_det_fig
             ;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   D_imp_det := 0;
          END;
          BEGIN  --Inserisce voce detrazione a conguaglio
             INSERT INTO CALCOLI_CONTABILI
                 ( ci, voce, sub
                 , riferimento
                 , input
                 , estrazione
                 , imp
                 )
             VALUES( P_ci, P_det_fig, '*'
                  , P_al
                  , 'C'
                  , 'AF'
                  , D_val_det_fig - D_p_imp_det - D_imp_det
                  )
             ;
          END;
        END IF;
        IF D_val_det_alt IS NOT NULL AND  
           P_det_alt     IS NOT NULL THEN  --Detrazioni ALTRI
          BEGIN  --Preleva valore progressivo precedente
             SELECT NVL(SUM(prco.p_imp),0)
               INTO D_p_imp_det
               FROM progressivi_contabili prco
              WHERE prco.ci       = P_ci
               AND prco.anno      = P_anno
               AND prco.mese      = P_mese
               AND prco.MENSILITA = P_mensilita
               AND prco.voce      = P_det_alt
             ;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   D_p_imp_det := 0;
          END;
          BEGIN  --Preleva valore mese corrente
             SELECT NVL(SUM(caco.imp),0)
               INTO D_imp_det
               FROM CALCOLI_CONTABILI caco
              WHERE caco.ci       = P_ci
               AND caco.voce      = P_det_alt
             ;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   D_imp_det := 0;
          END;
          BEGIN  --Inserisce voce detrazione a conguaglio
             INSERT INTO CALCOLI_CONTABILI
                 ( ci, voce, sub
                 , riferimento
                 , input
                 , estrazione
                 , imp
                 )
             VALUES( P_ci, P_det_alt, '*'
                  , P_al
                  , 'C'
                  , 'AF'
                  , D_val_det_alt - D_p_imp_det - D_imp_det
                  )
             ;
          END;
        END IF;
        IF D_val_det_spe IS NOT NULL AND   
           P_det_spe     IS NOT NULL THEN  --Detrazioni SPESE
          BEGIN  --Preleva valore progressivo precedente
             SELECT NVL(SUM(prco.p_imp),0)
               INTO D_p_imp_det
               FROM progressivi_contabili prco
              WHERE prco.ci       = P_ci
               AND prco.anno      = P_anno
               AND prco.mese      = P_mese
               AND prco.MENSILITA = P_mensilita
               AND prco.voce      = P_det_spe
             ;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   D_p_imp_det := 0;
          END;
          BEGIN  --Preleva valore mese corrente
             SELECT NVL(SUM(caco.imp),0)
               INTO D_imp_det
               FROM CALCOLI_CONTABILI caco
              WHERE caco.ci       = P_ci
               AND caco.voce      = P_det_spe
             ;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   D_imp_det := 0;
          END;
          BEGIN  --Inserisce voce detrazione a conguaglio
             INSERT INTO CALCOLI_CONTABILI
                 ( ci, voce, sub
                 , riferimento
                 , input
                 , estrazione
                 , imp
                 )
             VALUES( P_ci, P_det_spe, '*'
                  , P_al
                  , 'C'
                  , 'AF'
                  , D_val_det_spe - D_p_imp_det - D_imp_det
                  )
             ;
          END;
        END IF;

--        Lo step viene eseguito sempre e non solo se esiste un valore fisso, perchè
--        come importo del mese è stato prodotto il TOTALE spettante e deve quindi
--        essere recuperato il già attribuito nei mesi precedenti
--
--        IF D_val_det_ult IS NOT NULL THEN  --Detrazioni ULTERIORI
          BEGIN  --Preleva valore progressivo precedente
             SELECT NVL(SUM(prco.p_imp),0)
               INTO D_p_imp_det
               FROM progressivi_contabili prco
              WHERE prco.ci       = P_ci
               AND prco.anno      = P_anno
               AND prco.mese      = P_mese
               AND prco.MENSILITA = P_mensilita
               AND prco.voce      = P_det_ult
             ;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   D_p_imp_det := 0;
          END;
          BEGIN  --Preleva valore mese corrente
             SELECT NVL(SUM(caco.imp),0)
               INTO D_imp_det
               FROM CALCOLI_CONTABILI caco
              WHERE caco.ci       = P_ci
               AND caco.voce      = P_det_ult
             ;
          EXCEPTION
              WHEN NO_DATA_FOUND THEN
                   D_imp_det := 0;
          END;
          BEGIN  --Inserisce voce detrazione a conguaglio
             INSERT INTO CALCOLI_CONTABILI
                 ( ci, voce, sub
                 , riferimento
                 , input
                 , estrazione
                 , imp
                 )
             VALUES( P_ci, P_det_ult, '*'
                  , P_al
                  , 'C'
                  , 'AF'
/* modifica del 03/12/2004 */
/* in caso di forzatura di valori su AINEX: tiene il valore forzato e recupera tutto quanto attribuito,
   come progressivo precedente o come mese corrente
   in caso di valori nulli su AINEX: in peccmocp.autofam è stato calcolato ed inserito su CACO lo spettante TOTALE
   deve quindi essere recuperato quanto attribuito come progressivo precedente
*/
--                  , D_val_det_ult - D_p_imp_det
                  , decode( P_effe_cong
                          , 'M', decode( D_val_det_ult
                                       , '', D_p_imp_det *-1
                                           , D_val_det_ult - D_p_imp_det - D_imp_det
                                       )
                               , D_p_imp_det *-1
                          )
                  )
             ;
          END;
--        END IF;
        peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF;
  BEGIN  --Totalizza Detrazioni Fiscali mensili
     P_stp := 'VOCI_FISC_DET-06';
     SELECT NVL( SUM( caco.imp ), 0 )
         , NVL( SUM( DECODE(caco.voce, P_det_con, caco.imp, 0) ), 0 )
         , NVL( SUM( DECODE(caco.voce, P_det_fig, caco.imp, 0) ), 0 )
         , NVL( SUM( DECODE(caco.voce, P_det_alt, caco.imp, 0) ), 0 )
         , NVL( SUM( DECODE(caco.voce, P_det_spe, caco.imp, 0) ), 0 )
         , NVL( SUM( DECODE(caco.voce, P_det_ult, caco.imp, 0) ), 0 )
       INTO P_imp_det_fis
         , P_imp_det_con
         , P_imp_det_fig
         , P_imp_det_alt
         , P_imp_det_spe
         , P_imp_det_ult
       FROM CALCOLI_CONTABILI caco
      WHERE caco.ci+0 = P_ci
        AND caco.voce IN  (SELECT codice
                          FROM VOCI_ECONOMICHE voec
                         WHERE voec.specifica = 'DET_DIV'
                        UNION
                        SELECT P_det_con
                          FROM dual
                        UNION
                        SELECT  P_det_fig
                          FROM dual
                        UNION
                        SELECT P_det_alt
                          FROM dual
                        UNION
                        SELECT P_det_spe
                          FROM dual
                        UNION
                        SELECT P_det_ult
                          FROM dual
                      )
     ;
     peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
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

