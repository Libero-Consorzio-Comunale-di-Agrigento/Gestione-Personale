CREATE OR REPLACE PACKAGE peccmocp2 IS
/******************************************************************************
 NOME:        PECCMOCP2
 DESCRIZIONE: Calcolo VOCI Automatiche
              Calcolo VOCI Auto Fam.
              
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
******************************************************************************/

revisione varchar2(30) := '0 del 12/07/2004';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

  PROCEDURE voci_automatiche
(
  p_ci         NUMBER
, p_al         DATE    -- Data di Termine o Fine Mese
, p_anno       NUMBER
, p_mese       NUMBER
, p_mensilita   VARCHAR2
, p_fin_ela     DATE
, p_tipo       VARCHAR2
, p_conguaglio  NUMBER
, p_base_ratei  VARCHAR2
, p_base_det    VARCHAR2
, p_spese       NUMBER
, p_ulteriori   NUMBER
, p_tipo_ulteriori VARCHAR2
, p_ass_fam     VARCHAR2
, p_det_con     VARCHAR2
, p_det_fig     VARCHAR2
, p_det_alt     VARCHAR2
, p_det_spe     VARCHAR2
, p_det_ult     VARCHAR2
-- Parametri per Trace
, p_trc    IN     NUMBER     -- Tipo di Trace
, p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
, p_pas    IN     NUMBER     -- Numero di Passo procedurale
, p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
, p_stp    IN OUT VARCHAR2       -- Step elaborato
, p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
);
END;
/

CREATE OR REPLACE PACKAGE BODY Peccmocp2 IS
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

-- Valorizzazione Voci Automatiche iniziali
--
-- Determinazione delle voci Automatiche di Assenza
--                                   di Presenza
--                                   di Assegno Familiare
--                                   di Detrazione Fiscale
PROCEDURE voci_automatiche
(
 p_ci         NUMBER
, p_al         DATE    -- Data di Termine o Fine Mese
, p_anno       NUMBER
, p_mese       NUMBER
, p_mensilita   VARCHAR2
, p_fin_ela     DATE
, p_tipo       VARCHAR2
, p_conguaglio  NUMBER
, p_base_ratei  VARCHAR2
, p_base_det    VARCHAR2
, p_spese       NUMBER
, p_ulteriori   NUMBER
, p_tipo_ulteriori VARCHAR2
, p_ass_fam     VARCHAR2
, p_det_con     VARCHAR2
, p_det_fig     VARCHAR2
, p_det_alt     VARCHAR2
, p_det_spe     VARCHAR2
, p_det_ult     VARCHAR2
-- Parametri per Trace
, p_trc    IN     NUMBER     -- Tipo di Trace
, p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
, p_pas    IN     NUMBER     -- Numero di Passo procedurale
, p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
, p_stp    IN OUT VARCHAR2       -- Step elaborato
, p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
) IS
D_voce           VARCHAR2(10);  -- Deposito codice voce
D_qta            number;    -- Deposito quantita`
BEGIN
  <<voci_auto>>
  BEGIN  -- Emissione delle Voci AUTOMATICHE
     IF p_tipo != 'S' THEN  -- In caso di mensilita` Speciale
                         --  non emette voci di Assenza
                         --                di Presenza
                         --              e di Ratei
        BEGIN  -- Determinazione delle voci FISSE di Assenza
          P_stp := 'VOCI_AUTOMATICHE-01';
INSERT INTO CALCOLI_CONTABILI
( ci, voce, sub
, riferimento
, arr
, input
, estrazione
, qualifica, tipo_rapporto, ore
, qta
)
SELECT
 P_ci, voec.codice, '*'
, MAX(pere.al)
, DECODE( pere.anno
              , P_anno, DECODE( TO_CHAR(pere.periodo,'yyyymm')
                              , TO_CHAR(pere.al,'yyyymm'), NULL 
                                        , 'C'
                     )
              , 'P'
       )
, DECODE( p_tipo
       , 'A' , '*'  -- voci utili solo nel calcolo
            , 'C'
       )
, 'AP'  -- voci Automatiche di Presenza e Assenza
, pere.qualifica, pere.tipo_rapporto, pere.ore
, SUM( DECODE( voec.automatismo
           , 'GG_100', pere.gg_100
           , 'GG_80' , pere.gg_80
           , 'GG_66' , pere.gg_66
           , 'GG_50' , pere.gg_50
           , 'GG_30' , pere.gg_30
           , 'GG_SA' , pere.gg_sa
                    , NULL
           )
    )
 FROM CONTABILITA_VOCE covo
    , VOCI_ECONOMICHE voec
    , PERIODI_RETRIBUTIVI_BP pere
 WHERE covo.voce       = voec.codice||''
  AND covo.sub       = '*'
  AND P_al      BETWEEN NVL(covo.dal,TO_DATE(2222222,'j'))
                  AND NVL(covo.al ,TO_DATE(3333333,'j'))
  AND (   voec.automatismo = 'GG_100' AND pere.gg_100 != 0
       OR voec.automatismo = 'GG_80'  AND pere.gg_80  != 0
       OR voec.automatismo = 'GG_66'  AND pere.gg_66  != 0
       OR voec.automatismo = 'GG_50'  AND pere.gg_50  != 0
       OR voec.automatismo = 'GG_30'  AND pere.gg_30  != 0
       OR voec.automatismo = 'GG_SA'  AND pere.gg_sa  != 0
      )
  AND (   pere.gg_100 != 0
       OR pere.gg_80  != 0
       OR pere.gg_66  != 0
       OR pere.gg_50  != 0
       OR pere.gg_30  != 0
       OR pere.gg_sa  != 0
      )
  AND pere.periodo     = P_fin_ela
  AND pere.ci         = P_ci
  AND pere.competenza IN ('P','C','A')
GROUP BY voec.codice, pere.anno,to_char(pere.al,'yyyy')
             , DECODE( TO_CHAR(pere.periodo,'yyyymm')
                     , TO_CHAR(pere.al,'yyyymm'), NULL
					 , 'C'
             )
      , pere.qualifica, pere.tipo_rapporto, pere.ore
;
     Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;
        BEGIN  -- Determinazione delle voci FISSE di Presenza
          P_stp := 'VOCI_AUTOMATICHE-02';
INSERT INTO CALCOLI_CONTABILI
( ci, voce, sub
, riferimento
, arr
, input
, estrazione
, qualifica, tipo_rapporto, ore
, qta
)
SELECT
 P_ci, voec.codice, '*'
, MAX(pere.al)
, DECODE( pere.anno
              , P_anno, DECODE( TO_CHAR(pere.periodo,'yyyymm')
                              , TO_CHAR(pere.al,'yyyymm'), NULL
							  , 'C'
                              )
              , 'P'
       )
, DECODE( p_tipo
       , 'A' , '*'  -- voci utili solo nel calcolo
       , 'C'
       )
, 'AP'  -- voci Automatiche di Presenza e Assenza
, pere.qualifica, pere.tipo_rapporto, pere.ore
, SUM( DECODE( voec.automatismo
           , 'GG_CON' , pere.gg_con
           , 'GG_LAV' , pere.gg_lav
           , 'GG_PRE' , pere.gg_pre
           , 'GG_INP' , pere.gg_inp
           , 'ST_INP' , pere.st_inp
           , 'GG_AF'  , pere.gg_af
           , 'GG_FIS' , pere.gg_fis
           , 'GG_RID' , pere.gg_rid
           , 'GG_RAP' , pere.gg_rap
           , 'RAP_GG' , pere.rap_gg
           , 'GG_DET' , pere.gg_det
                     , NULL
           )
    )
 FROM CONTABILITA_VOCE covo
    , VOCI_ECONOMICHE voec
    , PERIODI_RETRIBUTIVI_BP pere
 WHERE covo.voce       = voec.codice||''
  AND covo.sub       = '*'
  AND P_al      BETWEEN NVL(covo.dal,TO_DATE(2222222,'j'))
                  AND NVL(covo.al ,TO_DATE(3333333,'j'))
  AND (   voec.automatismo = 'GG_CON'  AND pere.gg_con  != 0
       OR voec.automatismo = 'GG_LAV'  AND pere.gg_lav  != 0
       OR voec.automatismo = 'GG_PRE'  AND pere.gg_pre  != 0
       OR voec.automatismo = 'GG_INP'  AND pere.gg_inp  != 0
       OR voec.automatismo = 'ST_INP'  AND pere.st_inp  != 0
       OR voec.automatismo = 'GG_AF'   AND pere.gg_af   != 0
       OR voec.automatismo = 'GG_FIS'  AND pere.gg_fis  != 0
       OR voec.automatismo = 'GG_RID'  AND pere.gg_rid  != 0
       OR voec.automatismo = 'GG_RAP'  AND pere.gg_rap  != 0
       OR voec.automatismo = 'RAP_GG'  AND pere.rap_gg  != 0
       OR voec.automatismo = 'GG_DET'  AND pere.gg_det  != 0
      )
  AND pere.periodo     = P_fin_ela
  AND pere.ci         = P_ci
  AND pere.competenza IN ('P','C','A')
GROUP BY voec.codice, pere.anno,to_char(pere.al,'yyyy')
             , DECODE( TO_CHAR(pere.periodo,'yyyymm')
                     , to_char(pere.al,'yyyymm'), null                                 , 'C'
             )
      , pere.qualifica, pere.tipo_rapporto, pere.ore
;
          Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;
        DECLARE D_qta  NUMBER;
                D_voce VARCHAR2(10);
        BEGIN  -- Determinazione della voce FISSA di Rapporto Ore
          P_stp := 'VOCI_AUTOMATICHE-03a';
SELECT max(voec.codice)
     , sum(decode( sum(pere.gg_fis)  -- una sola voce in *PREVISIONE*
                 , 0, max(pere.rap_ore)
                    , sum( abs(pere.rap_ore) * pere.gg_fis)
                    / abs(sum(pere.gg_fis))
                 )
          )
  INTO D_voce
     , D_qta
  FROM contabilita_voce      covo
     , voci_economiche       voec
     , periodi_retributivi_bp pere
 WHERE covo.voce       = voec.codice||''
   AND covo.sub        = '*'
   AND P_al     between nvl(covo.dal,to_date(2222222,'j'))
                    and nvl(covo.al ,to_date(3333333,'j'))
   AND voec.automatismo = 'RAP_ORE'
   AND pere.ci         = P_ci
   AND pere.periodo     = P_fin_ela
   AND pere.competenza in ('P','C','A')
 GROUP BY pere.anno,pere.mese,to_char(pere.al,'mm')
     , voec.codice  -- una sola voce in *PREVISIONE*
;
        IF D_voce is not null THEN
INSERT INTO CALCOLI_CONTABILI
( ci, voce, sub
, riferimento
, arr
, input
, estrazione
, qta
)
SELECT
 P_ci, D_voce, '*'
, P_al
, null
, DECODE( p_tipo
       , 'A' , '*'  -- voci utili solo nel calcolo
       , 'C'
       )
, 'AP'  -- voci Automatiche di Presenza Assenza
, D_qta
 FROM dual
;
        END IF;
          Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;
        BEGIN  -- Determinazione della voce FISSA di Ratei
              -- una sola voce in *PREVISIONE*
          P_stp := 'VOCI_AUTOMATICHE-03';
         /*
         in *PREVISIONE*
         inserita "select" e poi "insert" con "values" con ARR null
         */
SELECT
  MAX(voec.codice)
, SUM
( DECODE( P_base_ratei
       --   Attribuzione a Giorni
       , 'G',       SUM( pere.gg_rat )
       --   Attribuzione a Rateo su Giorni Fiscali
       , 'M', ( CEIL (SUM( pere.gg_rat
                      * DECODE(pere.competenza,'A',1,'C',1,0)
                      ) / 30
                   ) + FLOOR( SUM( pere.gg_rat
                               * DECODE(pere.competenza,'P',1,0)
                               ) / 30
                           )
             ) * ( ROUND( SUM( pere.gg_fis
                           * DECODE(pere.competenza,'A',1,'C',1,0)
                           ) / 30
                      ) + ROUND( SUM( pere.gg_fis
                                   * DECODE(pere.competenza,'P',1,0)
                                   ) / 30
                              )
                )
       --   Attribuzione a Rateo su Giorni Rateo eventualmente ridotti
       , 'R', ROUND( SUM( pere.gg_rat
                      * DECODE(pere.competenza,'A',1,'C',1,0)
                      ) / 30
                 ) + ROUND( SUM( pere.gg_rat
                             * DECODE(pere.competenza,'P',1,0)
                             ) / 30
                         )
       , 'N', ROUND( SUM( pere.gg_rat
                      * DECODE(pere.competenza,'A',1,'C',1,0)
                      ) / 30.1
                 ) + ROUND( SUM( pere.gg_rat
                             * DECODE(pere.competenza,'P',1,0)
                             ) / 30.1
                         )
       ) * SUM( DECODE( P_base_ratei
                    ,'N', 1
                       , ABS(pere.rap_ore) ) * pere.gg_rat )
        / DECODE( SUM(pere.gg_rat)
               , 0, 1
                  , SUM(pere.gg_rat)
               )
)
 INTO D_voce
    , D_qta
 FROM CONTABILITA_VOCE covo
    , VOCI_ECONOMICHE voec
    , PERIODI_RETRIBUTIVI_BP pere
 WHERE covo.voce       = voec.codice||''
  AND covo.sub        = '*'
  AND P_al       BETWEEN NVL(covo.dal,TO_DATE(2222222,'j'))
                   AND NVL(covo.al ,TO_DATE(3333333,'j'))
  AND voec.automatismo = 'RATEI'
  AND pere.ci         = P_ci
  AND pere.periodo     = P_fin_ela
  AND pere.competenza IN ('P','C','A')
  AND pere.SERVIZIO    = 'Q'
 GROUP BY pere.anno,pere.mese
        ,voec.codice
;
          IF  D_voce is not null
          AND nvl(D_qta,0) != 0
          THEN
INSERT INTO CALCOLI_CONTABILI
( ci, voce, sub
, riferimento
, arr
, input
, estrazione
, qta
)
VALUES
( P_ci, D_VOCE, '*'
, P_al
, null
, DECODE( p_tipo
       , 'A' , '*'  -- voci utili solo nel calcolo
       , 'C'
       )
, 'AP'  -- voci Automatiche di Presenza Assenza
, D_qta
)
;
          END IF;
          Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;
     END IF;
     Peccmocp.VOCI_TOTALE  -- Totalizzazione delle voci Automatiche
                   -- di Presenza e Assenza
        (P_ci, P_al, P_fin_ela, P_tipo, 'AP'
            , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
        );
     Peccmocp_autofam.VOCI_AUTO_FAM  -- Emissione voci di Carico Familiare
                  -- e altre Detrazioni
        ( P_ci, P_al
             , P_anno, P_mese, P_mensilita, P_fin_ela
             , P_tipo, P_conguaglio
             , P_base_ratei, P_base_det
             , P_spese, P_ulteriori, P_tipo_ulteriori
             , P_ass_fam
/* Inizio Modifica del 20/12/2002*/
             , P_det_con, P_det_fig, P_det_alt, P_det_spe, P_det_ult,'A',to_number(null),to_number(null)
/* Fine Modifica del 20/12/2002*/
             , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
        );
  END voci_auto;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     Peccmocp.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
END;
/


