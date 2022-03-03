CREATE OR REPLACE PACKAGE Peccmocp_autofam IS
/******************************************************************************
 NOME:        Peccmocp_autofam
 DESCRIZIONE: Calcolo VOCI Automatiche - Previsione
              Calcolo VOCI Auto Fam.   - Previsione
 
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
******************************************************************************/

revisione varchar2(30) := '0 del 12/07/2004';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

PROCEDURE voci_auto_fam
(
 p_ci         NUMBER
,p_al         DATE    -- Data di Termine o Fine Mese
,p_anno       NUMBER
,p_mese       NUMBER
,p_mensilita   VARCHAR2
,p_fin_ela     DATE
,p_tipo       VARCHAR2
,p_conguaglio  NUMBER
,p_base_ratei  VARCHAR2
,p_base_det    VARCHAR2
,p_spese       NUMBER
,p_ulteriori   NUMBER
,p_tipo_ulteriori VARCHAR2
,p_ass_fam     VARCHAR2
,p_det_con     VARCHAR2
,p_det_fig     VARCHAR2
,p_det_alt     VARCHAR2
,p_det_spe     VARCHAR2
,p_det_ult     VARCHAR2
,p_rilevanza   VARCHAR2
,p_imponibile  NUMBER
,p_reddito_dip  NUMBER
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

CREATE OR REPLACE PACKAGE BODY Peccmocp_autofam IS
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

-- Emissione voci automatiche di Carico Familiare e altre Detrazioni
--
PROCEDURE voci_auto_fam
(
 p_ci         NUMBER
,p_al         DATE    -- Data di Termine o Fine Mese
,p_anno       NUMBER
,p_mese       NUMBER
,p_mensilita   VARCHAR2
,p_fin_ela     DATE
,p_tipo       VARCHAR2
,p_conguaglio  NUMBER
,p_base_ratei  VARCHAR2
,p_base_det    VARCHAR2
,p_spese       NUMBER
,p_ulteriori   NUMBER
,p_tipo_ulteriori VARCHAR2
,p_ass_fam     VARCHAR2
,p_det_con     VARCHAR2
,p_det_fig     VARCHAR2
,p_det_alt     VARCHAR2
,p_det_spe     VARCHAR2
,p_det_ult     VARCHAR2
,p_rilevanza   VARCHAR2
,p_imponibile  NUMBER
,p_reddito_dip  NUMBER
-- Parametri per Trace
,p_trc    IN     NUMBER     -- Tipo di Trace
,p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
) IS
D_cong_af      NUMBER := 0; -- Indicatori Mese carico gia` Conguagliato
D_cong_cn      NUMBER := 0;
D_cong_fg      NUMBER := 0;
D_cong_al      NUMBER := 0;
D_cong_sp      NUMBER := 0;
D_cong_ud      NUMBER := 0;
D_divisore     NUMBER := 0;
D_conguaglio   NUMBER := 0;
D_mesi_irpef   NUMBER := 0;
D_scad_cong    VARCHAR(1);
D_effe_cong    VARCHAR(1);
BEGIN
  BEGIN -- Trattamento del Carico Familiare *PREVISIONE*
     select nvl(mesi_irpef,12),scad_cong
       into D_mesi_irpef,d_scad_cong
       from ente
     ;
   BEGIN
     select effe_cong
       into d_effe_cong
       from informazioni_extracontabili
      where ci = P_ci
        and anno = P_anno
     ;
   EXCEPTION
     WHEN NO_DATA_FOUND THEN
       d_effe_cong := null;   
   END;
     IF     NVL(d_effe_cong,d_scad_cong) IN ('M','A')
/*
In *PREVISIONE* e` sempre ora di conguaglio
        AND P_mese                     = 12
        AND P_tipo                     IN ( 'S', 'N' )
*/
        AND P_anno >= 2003
         OR P_conguaglio       != 0
        AND NVL(d_effe_cong,' ') != 'N'
        AND P_anno >= 2003
         OR NVL(d_effe_cong,' ') = 'M'
        AND P_anno >= 2003
     THEN 
        d_divisore := 12;
        d_conguaglio := 1;  
     ELSE
        d_divisore := 12;
        d_conguaglio := 0;  
     END IF;
     P_stp := 'VOCI_AUTO_FAM-01';
     FOR CURF IN
        (SELECT anno, mese
             , cond_fam, nucleo_fam, figli_fam
             , cond_fis, scaglione_coniuge, coniuge
             , scaglione_figli, figli, figli_dd, figli_mn, figli_mn_dd
             , figli_hh, figli_hh_dd, altri
             , giorni
          FROM CARICHI_FAMILIARI
         WHERE ci           = P_ci
/* Inizio Modifica del 20/12/2002*/
           and decode(P_rilevanza,'A',cond_fam,cond_fis) is not null
/* Fine Modifica del 20/12/2002*/
/* Eliminato per trattare conguagli di reddito anche su cong. fiscali successivi
           and (   exists
                          (select 'x' from carichi_familiari
                            where ci = P_ci
                              and anno = P_anno
                              and mese_att = P_mese )
                        or not exists
                          (select 'x' from periodi_retributivi_bp
                            where ci = P_ci
                             and to_char(periodo,'yyyy') = P_anno
                             and periodo < P_fin_ela
                             and conguaglio in (1,2) )
                        )
*/
           AND (anno,mese+0)  IN
              (SELECT DISTINCT anno, mese
                FROM CARICHI_FAMILIARI
               WHERE ci           = P_ci
                 AND (   anno      = P_anno   AND
                        mese+0    = P_mese   AND
                        -- TOLTO: mese_att  = P_mese   and
                        P_tipo    = 'N'
                        -- Tratta Carico mese corrente
                        -- solo se Mensilita` Normale
                     OR  anno      = P_anno   AND
                        mese+0    = P_mese   AND
                        P_mese    = 12       AND
                        P_tipo    = 'S'
                        -- Tratta Carico mese corrente
                        -- solo se Mensilita` Speciale di Dicembre
/* Inizio Modifica del 20/12/2002*/
                      OR anno      = P_anno   AND
/*
In *PREVISIONE* e` sempre ora di conguaglio
                        mese+0     < P_mese   AND
                        nvl(d_effe_cong,' ') != 'N' AND
                        d_conguaglio > 0 AND
*/
                        P_tipo   != 'A' 
                        -- Tratta le righe dell'intero anno se conguaglio fiscale
                      OR anno = P_anno
                      and giorni is null
                      and P_tipo    = 'N'
                      and mese in (select pere.mese 
                                          from periodi_retributivi_bp pere
                                         where pere.ci         = P_ci
                                           and pere.periodo     = P_fin_ela
                                           and pere.anno+0      = P_anno
                                           and to_char(pere.al,'yyyy') = P_anno
                                           and pere.competenza in ('P','C','A')
                                           and pere.servizio    = 'Q'
                                        )
                        -- Tratta Carico a conguaglio su mesi maggiori
                        -- in caso di Conguaglio Individuale
                        --   non di Ripresa per Arretrati
                        -- solo se Mensilita` non Aggiuntiva
                      OR anno      = P_anno   AND
                        mese_att  = P_mese   AND
                        mese_att  > mese+0   AND
                        P_tipo   != 'A' AND
                        (P_tipo != 'S' OR P_mese = 12)
                        -- Tratta Carico mese a conguaglio
                        -- solo se Mensilita` non Aggiuntiva
                        -- Se Mensilità Speciale solo se del mese 12
                      OR anno      = P_anno-1 AND
                        mese_att  = P_mese   AND
                        mese_att  < mese+0   AND
                        P_tipo   != 'A' AND
                        (P_tipo != 'S' OR P_mese = 12)
                        -- Tratta Carico mese a conguaglio
                        -- solo se Mensilita` non Aggiuntiva
                        -- Se Mensilità Speciale solo se del mese 12
                        -- Tratta le informazioni dell'anno precedente (ultimi mesi) sull'anno corrente
                     )
              )
         ORDER BY anno,mese
        ) LOOP
        P_stp := 'VOCI_AUTO_FAM-01';
        Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        BEGIN  -- Singola informazione di Carico Familiare
          IF  P_ass_fam IS NOT NULL and p_rilevanza = 'A' 
          --
          -- Determinazione Voci di ASSEGNI FAMILIARI
          --
          AND (   curf.nucleo_fam IS NOT NULL AND P_tipo = 'N'
               OR curf.mese != P_mese         -- Richesta Conguaglio
              )
          THEN
             BEGIN  -- Determinazione Voce di ASSEGNI FAMILIARI
               P_stp := 'VOCI_AUTO_FAM-02';
           Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
              Peccmocp3.VOCI_AUTO_FAM_AF  -- Assegno per Nucleo Familiare
                  (P_ci, P_al
                      , curf.anno, P_mese, P_mensilita, P_fin_ela
                      , P_ass_fam, curf.cond_fam, curf.nucleo_fam
                      , curf.figli_fam, curf.mese
                      , curf.giorni, D_cong_af
                      , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                  );
             END;
          END IF;  -- termina trattamento p_rilevanza 'A'
          IF curf.anno = P_anno and P_rilevanza = 'D' 
          --
          -- Determinazione Voci di DETRAZIONE FISCALE
          --              solo per Anno Corrente
          --
          THEN
            IF  P_det_con     IS NOT NULL
            AND (   NVL(curf.coniuge,0) != 0
                 OR curf.mese != P_mese         -- Richesta Conguaglio
                )
            THEN
               BEGIN
                 P_stp := 'VOCI_AUTO_FAM-03';
                 Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                 Peccmocp3.VOCI_AUTO_FAM_DF  -- Detrazione Coniuge
                    (P_ci, P_al
                        , curf.anno, P_mese, P_mensilita, P_fin_ela
                        , P_base_det
                        , P_det_con, curf.cond_fis, 'CN'
                        , curf.scaglione_coniuge, curf.coniuge
                        , curf.mese, curf.giorni, D_cong_cn,p_imponibile,12,d_conguaglio
                        , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                    );
               END;
            END IF;
            IF  P_det_fig     IS NOT NULL
            AND (   NVL(curf.figli,0) != 0
                 OR curf.mese != P_mese         -- Richesta Conguaglio
                )
            THEN
               BEGIN
                 P_stp := 'VOCI_AUTO_FAM-04';
                 Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                 Peccmocp3.VOCI_AUTO_FAM_DF  -- Detrazione Figli
                    (P_ci, P_al
                        , curf.anno, P_mese, P_mensilita, P_fin_ela
                        , P_base_det
                        , P_det_fig, curf.cond_fis, 'FG'
                        , curf.scaglione_figli ,curf.figli
                        , curf.mese, curf.giorni, D_cong_fg,p_imponibile,12,d_conguaglio
                        , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                    );
               END;
            END IF;
            IF  P_det_fig     IS NOT NULL
            AND (   NVL(curf.figli_dd,0) != 0
                 OR curf.mese != P_mese         -- Richesta Conguaglio
                )
            THEN
               BEGIN
                 P_stp := 'VOCI_AUTO_FAM-05';
                 Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                 Peccmocp3.VOCI_AUTO_FAM_DF  -- Detrazione Figli Doppia Detrazione
                    (P_ci, P_al
                        , curf.anno, P_mese, P_mensilita, P_fin_ela
                        , P_base_det
                        , P_det_fig, curf.cond_fis, 'FD'
                        , curf.scaglione_figli, curf.figli_dd
                        , curf.mese, curf.giorni, D_cong_fg,p_imponibile,12,d_conguaglio
                        , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                    );
               END;
            END IF;
            IF  P_det_fig     IS NOT NULL
            AND (   NVL(curf.figli_mn,0) != 0
                 OR curf.mese != P_mese         -- Richesta Conguaglio
                )
            THEN
               BEGIN
                 P_stp := 'VOCI_AUTO_FAM-05.1';
                 Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                 Peccmocp3.VOCI_AUTO_FAM_DF  -- Detrazione Figli Minori
                    (P_ci, P_al
                        , curf.anno, P_mese, P_mensilita, P_fin_ela
                        , P_base_det
                        , P_det_fig, curf.cond_fis, 'FM'
                        , curf.scaglione_figli, curf.figli_mn
                        , curf.mese, curf.giorni, D_cong_fg,p_imponibile,12,d_conguaglio
                        , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                    );
               END;
            END IF;
            IF  P_det_fig     IS NOT NULL
            AND (   NVL(curf.figli_mn_dd,0) != 0
                 OR curf.mese != P_mese          -- Richesta Conguaglio
                )
            THEN
               BEGIN
                  P_stp := 'VOCI_AUTO_FAM-05.2';
                  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                  Peccmocp3.VOCI_AUTO_FAM_DF  -- Detrazione Figli Minori Doppi
                     (P_ci, P_al
                          , curf.anno, P_mese, P_mensilita, P_fin_ela
                          , P_base_det
                          , P_det_fig, curf.cond_fis, 'MD'
                          , curf.scaglione_figli, curf.figli_mn_dd
                          , curf.mese, curf.giorni,D_cong_fg,p_imponibile,12,d_conguaglio
                          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                     );
               END;
            END IF;
            IF  P_det_fig     IS NOT NULL
            AND (   NVL(curf.figli_hh,0) != 0
                 OR curf.mese != P_mese          -- Richesta Conguaglio
                )
            THEN
               BEGIN
                  P_stp := 'VOCI_AUTO_FAM-05.3';
                  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                  Peccmocp3.VOCI_AUTO_FAM_DF  -- Detrazione Figli Handicappati
                     (P_ci, P_al
                          , curf.anno, P_mese, P_mensilita, P_fin_ela
                          , P_base_det
                          , P_det_fig, curf.cond_fis, 'FH'
                          , curf.scaglione_figli, curf.figli_hh
                          , curf.mese, curf.giorni,D_cong_fg,p_imponibile,12,d_conguaglio
                          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                     );
               END;
            END IF;
            IF  P_det_fig     IS NOT NULL
            AND (   NVL(curf.figli_hh_dd,0) != 0
                 OR curf.mese != P_mese          -- Richesta Conguaglio
                )
            THEN
               BEGIN
                  P_stp := 'VOCI_AUTO_FAM-05.4';
                  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                  Peccmocp3.VOCI_AUTO_FAM_DF  -- Detrazione Figli Minori Doppi
                     (P_ci, P_al
                          , curf.anno, P_mese, P_mensilita, P_fin_ela
                          , P_base_det
                          , P_det_fig, curf.cond_fis, 'HD'
                          , curf.scaglione_figli, curf.figli_hh_dd
                          , curf.mese, curf.giorni,D_cong_fg,p_imponibile,12,d_conguaglio
                          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                     );
               END;
            END IF;
            IF  P_det_alt     IS NOT NULL
            AND (   NVL(curf.altri,0) != 0
                 OR curf.mese != P_mese         -- Richesta Conguaglio
                )
            THEN
               BEGIN
                 P_stp := 'VOCI_AUTO_FAM-06';
                 Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                 Peccmocp3.VOCI_AUTO_FAM_DF  -- Detrazione Altri
                    (P_ci, P_al
                        , curf.anno, P_mese, P_mensilita, P_fin_ela
                        , P_base_det
                        , P_det_alt, curf.cond_fis, 'AL'
                        , curf.scaglione_figli, curf.altri
                        , curf.mese, curf.giorni, D_cong_al,p_imponibile,12,d_conguaglio
                        , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                    );
               END;
            END IF;
/* Vecchio calcolo delle detrazioni per altre detrazioni - ante 2003 
            IF  d_conguaglio   = 0
            AND curf.mese     != P_mese        -- Sole se richesta Conguaglio
            AND curf.cond_fis IS NOT NULL
            AND curf.giorni   IS NULL
            AND P_anno < 2003
            THEN
             IF P_det_spe IS NOT NULL AND P_spese != '99'
              THEN
                 BEGIN
                   P_stp := 'VOCI_AUTO_FAM-07';
                   Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                   Peccmocp3.VOCI_AUTO_FAM_DF  -- Detrazione Spese
                      (P_ci, P_al
                          , P_anno, P_mese, P_mensilita, P_fin_ela
                          , P_base_det
                          , P_det_spe, '*', 'SP', P_spese, ''
                          , curf.mese, NULL, D_cong_sp,p_imponibile,12,d_conguaglio
                          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                      );
                 END;
              END IF;
              IF P_det_ult IS NOT NULL AND NVL(P_ulteriori,0) != 0 AND P_reddito_dip != 0
              THEN
                 BEGIN
                   P_stp := 'VOCI_AUTO_FAM-08';
                   Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                   Peccmocp3.VOCI_AUTO_FAM_DF  -- Detrazione Ulteriori
                      (P_ci, P_al
                          , P_anno, P_mese, P_mensilita, P_fin_ela
                          , P_base_det
                          , P_det_ult, '*', P_tipo_ulteriori, P_ulteriori, ''
                          , curf.mese, NULL, D_cong_ud,p_reddito_dip,12,d_conguaglio
                          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                      );
                 END;
              END IF;
            END IF;
*/
          END IF; -- fine trattamento p_rilevanza = 'D'

        END;
     END LOOP;  -- cursore CURF

/* Vecchio calcolo delle detrazioni per SPESE DI PRODUZIONE - ante 2003 */
     IF  P_tipo         = 'N'           -- Se Mensilita` Normale
     AND P_det_spe      IS NOT NULL
     AND NVL(P_spese,0) != 0             -- Detrazioni di Spese del mese
     THEN
        BEGIN
          P_stp := 'VOCI_AUTO_FAM-09';
          Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
          select decode(p_conguaglio,0,12,1)
            into d_divisore
            from dual
          ;
          Peccmocp3.VOCI_AUTO_FAM_DF  -- Detrazione Spese
             (P_ci, P_al
                 , P_anno, P_mese, P_mensilita, P_fin_ela
                 , P_base_det
                 , P_det_spe, '*', 'SP',P_spese, ''
                 , P_mese, NULL, D_cong_sp,p_imponibile,12,P_conguaglio
                 , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
             );
        END;
     END IF;
/* fine vecchio calcolo delle detrazioni per SPESE DI PRODUZIONE - ante 2003 */

     IF P_reddito_dip       != 0        AND 
        P_rilevanza          = 'D'      AND
        P_det_ult           IS NOT NULL AND
        P_tipo               = 'N'      -- Se Mensilita` Normale
                                        -- Ulteriori Detrazioni del mese
     THEN 
       IF NVL(P_ulteriori,0) != 0
       OR NVL(d_effe_cong,d_scad_cong) IN ('M','A')      
/*
In *PREVISIONE* e` sempre ora di conguaglio
          AND P_mese                     = 12            
          AND P_tipo                     IN ( 'S', 'N' ) 
*/
       OR P_conguaglio       != 0 
          AND NVL(d_effe_cong,' ') != 'N'  
       OR NVL(d_effe_cong,' ') = 'M'
       THEN
         BEGIN
           P_stp := 'VOCI_AUTO_FAM-10';
           IF d_conguaglio = 1 THEN d_divisore := 1;
           END IF;     
           Peccmocp3.VOCI_AUTO_FAM_DF  -- Detrazione Ulteriori
              (P_ci, P_al
                   , P_anno, P_mese, P_mensilita, P_fin_ela
                   , P_base_det
                   , P_det_ult, '*', P_tipo_ulteriori
                   , P_ulteriori,''
                   , P_mese, NULL, D_cong_ud,p_reddito_dip,12,d_conguaglio
                   , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
              );
         END;
       END IF;
     END IF;

  END;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     Peccmocp.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
END;
/


