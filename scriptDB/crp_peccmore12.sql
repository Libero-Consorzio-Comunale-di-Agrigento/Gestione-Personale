CREATE OR REPLACE PACKAGE Peccmore12 IS
/******************************************************************************
 NOME:        Peccmore12
 DESCRIZIONE: Calcolo VOCI Fiscali Liq
              Calcolo VOCI Fiscali Anz
              Calcolo VOCI Fiscali Det
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1    23/12/2004 MF     Riferimenti al Package GP4_CACO.
 1.1  14/02/2005 NN     Emette le detrazioni fiscali fisse solo se la voce e'
                        significativa, il giro viene effettuato anche per le
                        deduzioni ma la voce non e valorizzata.
 4    05/01/2007 AM     Adeguamento alla Legge Finanziaria 2007; in particolare
                        nella proc. voci_fisc_det
 4.1  15/01/2007 ML     Emissione detrazioni familiari per differenza
                        (annuale - progressivo attribuito) in conguaglio
 4.2  18/01/2007 ML     Attivazione deltrazione figlio in assenza del coniuge (A19233).
 4.3  22/01/2007 ML     Modificata valorizzazione rilevanza per determinazione
                        regime di calcolo (deduzioni / detrazioni) - (A19344)
 4.4  24/01/2007 ML     Modifica attribuzione 1 per detrazioni DD, DP, P2 in caso
                        di conguaglio con imponibile maggiore scaglione (A18405.2)
 4.5  25/01/2007 ML     NO_DATA_FOUND in caso di detrazioni DA (mancava lo scaglione 10)
                        Rilevato da test.
 4.6  03/02/2007 ML     Emissione segnalazione in caso di attribuzione detrazione
                        del coniuge per il primo figlio (A19455).
 4.7  22/03/2007 ML     Gestione dell'aumento non rapportato per le detrazioni per spese (A20236)
 4.8  25/07/2007 AM     Adeguata la lettura di RADI con il campo rilevanza
******************************************************************************/
revisione varchar2(30) := '4.8 del 25/07/2007';
FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);
PROCEDURE stampa_det_ac
( P_ci              NUMBER
, P_det_ft_ac       NUMBER
, P_det_fc_ac       NUMBER
, P_prn             NUMBER
);
PROCEDURE voci_fisc_liq
(
 p_ci         NUMBER
,p_al         DATE    -- Data di Termine o Fine Mese
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
,p_al            DATE    --Data di Termine o Fine Mese
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
,p_tipo_Spese   VARCHAR2
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
,p_det_spe_ac  IN OUT NUMBER
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
CREATE OR REPLACE PACKAGE BODY Peccmore12 IS
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
PROCEDURE stampa_det_ac
( P_ci              NUMBER
, P_det_ft_ac       NUMBER
, P_det_fc_ac       NUMBER
, P_prn             NUMBER
) IS
BEGIN
  DECLARE
  D_riga            number;
  D_pas_stampa      number;
  D_nominativo      varchar2(40);
BEGIN
  D_pas_stampa := 4;
  BEGIN
    select substr(cognome||'  '||nome,1,40)
      into D_nominativo
      from rapporti_individuali
     where ci = P_ci;
  END;
  BEGIN
    select max(riga)
      into D_riga
      from a_appoggio_stampe
     where no_prenotazione = P_prn
       and no_passo        = D_pas_stampa
       and riga            > 100000
     group by no_prenotazione;
  EXCEPTION WHEN NO_DATA_FOUND THEN
            D_riga := 100001;
            insert into a_appoggio_stampe
                   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
            values (P_prn, D_pas_stampa, 1, D_riga,'   ');
            D_riga := D_riga + 1;
            insert into a_appoggio_stampe
                   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
            values (P_prn, D_pas_stampa, 1, D_riga,'*** ASSEGNAZIONE DETRAZIONE DEL CONIUGE PER IL PRIMO FIGLIO ***');
            D_riga := D_riga + 1;
             insert into a_appoggio_stampe
                   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
            values (P_prn, D_pas_stampa, 1, D_riga,'   ');
             D_riga := D_riga + 1;
             insert into a_appoggio_stampe
                   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
             values (P_prn, D_pas_stampa, 1, D_riga,'   ');
             D_riga := D_riga + 1;
             insert into a_appoggio_stampe
                   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
             values (P_prn, D_pas_stampa, 1, D_riga
                    , lpad(' ',3)||
                      lpad('Cod.Ind.',10,' ')||'  '||
                      rpad('Nominativo',40,' ')||'  '||
                      lpad('Det.Coniuge',15,' ')||'  '||
                      lpad('Det. 1 Figlio',15,' ')
                    );
             D_riga := D_riga + 1;
             insert into a_appoggio_stampe
                   (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
             values (P_prn, D_pas_stampa, 1, D_riga,lpad('-',132,'-'));
  END;
  D_riga := D_riga + 1;
  insert into a_appoggio_stampe
         (NO_PRENOTAZIONE, NO_PASSO, PAGINA, RIGA, TESTO)
  values (P_prn, D_pas_stampa, 1, D_riga
         , lpad(' ',3)||
           lpad(to_char(P_ci),10,' ')||'  '||
           rpad(D_nominativo,40,' ')||'  '||
           lpad(to_char(P_det_fc_ac),15,' ')||'  '||
           lpad(to_char(P_det_ft_ac),15,' ')
         );
 END;
END;
PROCEDURE voci_fisc_liq
(
 p_ci         NUMBER
,p_al         DATE    -- Data di Termine o Fine Mese
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
-- dbms_output.put_line('P_tfr_totale :'||P_tfr_totale);
-- dbms_output.put_line('P_ratei_anz :'||P_ratei_anz);
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
                      AND P_al+1 BETWEEN dal
                                   AND NVL(al ,TO_DATE(3333333,'j'))
                  )
               AND P_al+1      BETWEEN scfi.dal
                                   AND NVL(scfi.al ,TO_DATE(3333333,'j'))
     ;
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
         P_alq_liq := P_alq_liq_mp;
         P_ipt_liq := 0;
  END;
-- dbms_output.put_line('P_alq_liq :'||P_alq_liq);
-- dbms_output.put_line('P_ipt_liq :'||P_ipt_liq);
-- dbms_output.put_line('P_ipn_liq :'||P_ipn_liq);
-- dbms_output.put_line('P_rid_liq :'||P_rid_liq);
-- dbms_output.put_line('P_rtp_liq :'||P_rtp_liq);
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     Peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
--  Totalizza Giorni di Anzianita`
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
    FROM PERIODI_RETRIBUTIVI pere
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
,p_al            DATE    --Data di Termine o Fine Mese
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
,p_tipo_spese    VARCHAR2
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
,p_det_spe_ac  IN OUT NUMBER
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
D_val_min_altre_det    INFORMAZIONI_EXTRACONTABILI.det_ult%TYPE;
D_val_scaglione_10     INFORMAZIONI_EXTRACONTABILI.det_ult%TYPE;
D_p_imp_det      INFORMAZIONI_EXTRACONTABILI.det_ult%TYPE;
D_imp_det        INFORMAZIONI_EXTRACONTABILI.det_ult%TYPE;
D_aumento        INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_SPE_AC     INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_SPE        INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_CON        INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_FIG        INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_FIGLI      INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_ALT        INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_SPE_MP     INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_CON_MP     INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_FIG_MP     INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_ALT_MP     INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_per        MOVIMENTI_FISCALI.ded_per%TYPE;
D_DET_per_AC     MOVIMENTI_FISCALI.ded_per%TYPE;
D_DET_CON_AC     INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_FC_AC      INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_FT_AC      INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_FIG_AC     INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_DET_ALT_AC     INFORMAZIONI_EXTRACONTABILI.det_spe%TYPE;
D_imponibile     NUMBER;
D_reddito_dip    NUMBER;
D_tipo_calcolo   varchar2(1);
D_gg_det         NUMBER;
D_attribuzione   NUMBER;
D_tempo_determinato VARCHAR2(2);
D_conguaglio     number;
--D_nr_figli       NUMBER;
BEGIN
  D_reddito_dip := 0;
  IF  P_anno >= 2003
  AND GP4_RARE.is_mese_conguaglio(P_ci, P_fin_ela, P_tipo, P_conguaglio)
  THEN
     D_imponibile := p_ipn_tot_ac + p_ipn_terzi;
     D_reddito_dip := p_ipn_tot_ac + p_ipn_terzi - p_ipn_tot_ass_ac - p_ass_terzi;
  ELSE
     D_reddito_dip := p_ipn_ord - p_ipn_ass;
     IF P_anno < 2003 and p_conguaglio = 0 THEN
        D_imponibile := D_imponibile - p_somme_od;
     ELSIF P_anno < 2003 and p_conguaglio != 0 THEN
        D_imponibile := D_imponibile - p_somme_od_ac;
     ELSE
        D_imponibile := p_ipn_ord ;
     END IF;
  END IF;
  BEGIN
  select decode( GP4_RARE.get_val_conv_det_fam(P_ci, P_fin_ela)
                         , null , decode( GP4_RARE.get_val_conv_ded_fam(P_ci, P_fin_ela)
                                        , null, decode( greatest(P_anno,2005)
                                                      , 2005, 'D'
                                                            , ' ')   -- Detrazioni ante 2005
                                              , 'E')
                                 , 'F'
                          )
    into D_tipo_calcolo
    from dual
  ;
  END;
  IF D_tipo_calcolo = 'F' THEN
     GP4_RARE.set_ipn_det_fis_fam(P_ci, P_fin_ela
                                 , p_ipn_tot_ac + p_ipn_terzi
                                 , 'A');
  END IF;
-- dbms_output.put_Line('Sono nel CMORE12 e lancio PECCMORE_autofam.VOCI_AUTO_FAM con D_imponibile = '||D_imponibile);
  PECCMORE_autofam.VOCI_AUTO_FAM  -- Emissione voci di Carico Familiare
                                  -- e altre Detrazioni ante 2005 o L. Finanziaria 2007
        ( P_ci, P_al
        , P_anno, P_mese, P_mensilita, P_fin_ela
        , P_tipo, P_conguaglio
        , P_base_ratei, P_base_det
        , P_spese, P_tipo_spese, P_ulteriori, P_tipo_ulteriori
        , to_number(null)
        , P_det_con, P_det_fig, P_det_alt
        , P_det_spe, P_det_ult, D_tipo_calcolo
        , D_imponibile, D_reddito_dip
        , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
        );
  IF NVL(P_effe_cong,' ') != 'M' THEN
     BEGIN  --Annulla eventuale valore presente in Det.Ult. Fissa e in Det.Spe. Fissa
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
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF;
/* ----------------------------------------------------------------------------------------
   TRATTAMENTO DETRAZIONI FINO AL 2002: spese di produzione e ulteriori detrazioni
   ----------------------------------------------------------------------------------------  */
  IF  P_anno < 2003 THEN
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
         , PERIODI_RETRIBUTIVI pere
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
  IF GP4_RARE.is_mese_conguaglio(P_ci, P_fin_ela, P_tipo, P_conguaglio)
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
              AND P_fin_ela  BETWEEN defi.dal
                              AND NVL(defi.al ,TO_DATE(3333333,'j'))
          )
           WHERE ci   = P_ci
             AND anno = P_anno
          ;
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
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
                 AND P_fin_ela BETWEEN dal
                                 AND NVL(al ,TO_DATE(3333333,'j'))
              )
           AND P_fin_ela BETWEEN SCDF.dal
                           AND NVL(SCDF.al ,TO_DATE(3333333,'j'))
        )
         WHERE ci   = P_ci
          AND anno = P_anno
          AND EXISTS (SELECT 'x' FROM SCAGLIONI_DETRAZIONE_FISCALE
                      WHERE tipo = 'SP'
                       AND P_fin_ela BETWEEN dal
                                       AND NVL(al ,TO_DATE(3333333,'j'))
                    )
        ;
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
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
              AND P_fin_ela BETWEEN dal AND NVL(al ,TO_DATE(3333333,'j'))
           )
       AND P_fin_ela BETWEEN SCDF.dal AND NVL(SCDF.al ,TO_DATE(3333333,'j'))
        AND scdf2.tipo = P_tipo_ulteriori
        AND scdf2.scaglione =
           (SELECT MAX(scaglione)
             FROM SCAGLIONI_DETRAZIONE_FISCALE
             WHERE tipo = P_tipo_ulteriori
              AND scaglione <= P_ipn_tot_ac
              AND P_fin_ela BETWEEN dal AND NVL(al ,TO_DATE(3333333,'j'))
           )
        AND P_fin_ela BETWEEN scdf2.dal AND NVL(scdf2.al ,TO_DATE(3333333,'j'))
     )
      WHERE ci   = P_ci
       AND anno = P_anno
     ;
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
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
             )
        WHERE ci   = P_ci
          AND anno = P_anno
          ;
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;
     END IF;
  END;
  END IF;
  END IF;
/* -------------------------------------------------------------------------------------------
   FINE TRATTAMENTO DETRAZIONI FINO AL 2002
   -------------------------------------------------------------------------------------------  */
   BEGIN
     select tempo_determinato
       into D_tempo_determinato
       from posizioni
      where codice = (select posizione
                        from rapporti_giuridici
                       where ci = p_ci);
   EXCEPTION WHEN NO_DATA_FOUND THEN D_tempo_determinato := null;
   END;
-- dbms_output.put_line('D_attribuzione '||D_attribuzione);
  IF D_tipo_calcolo = 'F'
  THEN -- calcola il valore delle altre detrazioni annuale
     D_attribuzione := GP4_RARE.get_attribuzione_spese(P_ci);
-- dbms_output.put_line('P_fin_ela '||P_fin_ela||' P_tipo_spese '||P_tipo_spese||' P_spese '||P_spese);
     IF P_tipo_spese != 'DA' THEN
        D_val_scaglione_10 := GP4_DEFI.get_scaglione_10(P_fin_ela,'*',P_tipo_spese, P_ci
                                                       , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                                                       );
     END IF;
  BEGIN
--     D_det_per_ac  := GP4_RARE.get_det_per_spe
--                      ( P_ci, P_fin_ela
--                      , D_ipn_tot_ded_ac, D_ipn_tot_ass_ded_ac, D_somme_od_ded_ac
--                      , 'A');
     IF GP4_RARE.is_mese_conguaglio(P_ci, P_fin_ela, P_tipo, P_conguaglio) THEN
        D_conguaglio := 1;
     ELSE D_conguaglio := 0;
     END IF;
     D_aumento := GP4_DEFI.get_imp_aum
                           ( P_anno, P_mese, '*', P_tipo_spese
                           , P_spese, ''
                           , p_ipn_tot_ac + p_ipn_terzi
                           , D_conguaglio
                           , 1
                           , P_ci,'A'                                     -- 23/03/2005
                           , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);   -- 23/03/2005
dbms_output.put_line('*****P_tipo_spese:'||P_tipo_spese||' P_spese '||P_spese||' P_conguaglio '||P_conguaglio);
dbms_output.put_line('*****D_aumento:'||D_aumento);
     D_det_spe_ac  := GP4_RARE.get_det_spe
                      ( P_ci, P_fin_ela, P_anno, P_mese, P_spese, P_tipo_spese
                      , p_ipn_tot_ac + p_ipn_terzi
                      , 'A', p_conguaglio, D_tipo_calcolo
                      , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                      );
     D_gg_det  := GP4_RARE.get_giorni_detrazioni(P_ci, P_fin_ela, 'A');
-- dbms_output.put_line('*****P_det_spe_ac '||P_det_spe_ac||' D_attribuzione '||D_attribuzione);
 dbms_output.put_line('*****Faccio get_det_spe annuali gg:'||D_gg_det||' P_mesi_irpef '||P_mesi_irpef);
     select nvl(e_round((  D_det_spe_ac
                         / decode( P_tipo_spese
                                 , 'DA', decode( nvl(D_attribuzione,0)
                                               , 0, 365
                                                  , 1)
                                       , 365)
                        ) * decode( P_tipo_spese
                                  , 'DA', decode( nvl(D_attribuzione,0)
                                                , 0, least(365,D_gg_det)
                                                   , 1)
                                        , least(365,D_gg_det))
                       , 'I'),0) 
                       -- + nvl(D_aumento,0)
       into P_det_spe_ac
       from dual
      ;
      IF nvl(P_det_spe_ac,0) != 0 THEN
         P_det_spe_ac := P_det_spe_ac + nvl(D_aumento,0);
      END IF;
 dbms_output.put_line('D_det_spe_ac '||D_det_spe_ac);
 dbms_output.put_line('*****P_det_spe_ac '||P_det_spe_ac);
     IF  GP4_RARE.is_mese_conguaglio(P_ci, P_fin_ela, P_tipo, P_conguaglio)
--     IF P_conguaglio != 0
     THEN  -- Se si tratta di mese di Conguaglio Fiscale
           -- Determina Valori di Detrazione come conguaglio tra i valori annuali e quanto gia attribuito
        IF D_attribuzione = 1 and
           nvl(P_ipn_tot_ac,0)+nvl(P_ipn_terzi,0) < D_val_scaglione_10 THEN
           IF P_tipo_spese = 'DD' THEN
              D_val_min_altre_det := GP4_DEFI.get_val_min_det_dip(P_fin_ela);
              IF D_tempo_determinato = 'SI' THEN
                 D_val_min_altre_det := D_val_min_altre_det * 2;
              END IF;
           ELSIF P_tipo_spese = 'DP' THEN
              D_val_min_altre_det := GP4_DEFI.get_val_min_det_pen1(P_fin_ela);
           ELSIF P_tipo_spese = 'P2' THEN
              D_val_min_altre_det := GP4_DEFI.get_val_min_det_pen2(P_fin_ela);
                 ELSE
                 D_val_min_altre_det := 0;
           END IF;
           P_det_spe_ac        := greatest(P_det_spe_ac,D_val_min_altre_det);
        END IF;
-- dbms_output.put_line('1^ D_val_min_altre_det '||D_val_min_altre_det||' P_det_spe_ac '||P_det_spe_ac||' P_det_spe '||P_det_spe);
        GP4_CACO.set_input('C');
        GP4_CACO.set_estrazione('AF');
        IF P_det_spe_ac IS NOT NULL AND   --Detrazioni SPESE
           P_det_spe    IS NOT NULL THEN
        D_det_spe_mp := GP4_CACO.get_imp_mp(P_ci, P_anno, P_mese, P_mensilita, P_det_spe);
        D_det_spe  := GP4_CACO.get_imp(P_ci, P_det_spe);
        D_det_per  := D_det_per_ac;
-- dbms_output.put_line('xxxxSPESE: '||to_char(P_det_spe_ac - D_det_spe_mp -D_det_spe));
        GP4_CACO.insert_voce( P_ci, P_det_spe, '*', P_al
                            , P_det_spe_ac - D_det_spe_mp -D_det_spe);
        END IF;
        GP4_RARE.LKP_det_fis_fam( P_ci, P_fin_ela
                                , D_det_con_ac, D_det_fc_ac, D_det_ft_ac, D_det_fig_ac, D_det_alt_ac
                                );
-- dbms_output.put_line('xxxx FC: '||D_det_fc_ac );
        IF D_det_con_ac IS NOT NULL AND   --Detrazioni CONIUGE
           P_det_con    IS NOT NULL THEN
        D_det_con_mp := GP4_CACO.get_imp_mp(P_ci, P_anno, P_mese, P_mensilita, P_det_con);
        D_det_con  := GP4_CACO.get_imp(P_ci, P_det_con);
--        D_det_per  := D_det_per_ac;
       GP4_CACO.insert_voce( P_ci, P_det_con, '*', P_al
                            , D_det_con_ac - D_det_con_mp -D_det_con);
        END IF;
        IF D_det_fig_ac IS NOT NULL AND   --Detrazioni FIGLI
           P_det_fig    IS NOT NULL THEN
        D_det_fig_mp := GP4_CACO.get_imp_mp(P_ci, P_anno, P_mese, P_mensilita, P_det_fig);
        D_det_fig    := GP4_CACO.get_imp(P_ci, P_det_fig);
        D_det_figli  := nvl(D_det_fig_ac,0) -
                        nvl(D_det_ft_ac,0) +
                        greatest(nvl(D_det_ft_ac,0),nvl(D_det_fc_ac,0));
        IF greatest(nvl(D_det_ft_ac,0),nvl(D_det_fc_ac,0)) = nvl(D_det_fc_ac,0) THEN
           stampa_det_ac(P_ci, D_det_ft_ac, D_det_fc_ac, P_prn);
        END IF;
-- dbms_output.put_line('xxxx D_det_fig_ac '||D_det_fig_ac||' -D_det_ft_ac: '||D_det_ft_ac||'...D_det_fc_ac '||D_det_fc_ac );
-- dbms_output.put_line('xxxx inserisco D_det_figli: '||D_det_figli||' - D_det_fig_mp '||D_det_fig_mp||' - D_det_fig '||D_det_fig );
--       D_det_per  := D_det_per_ac;
        GP4_CACO.insert_voce( P_ci, P_det_fig, '*', P_al
                            , D_det_figli - D_det_fig_mp -D_det_fig);
        END IF;
        IF D_det_alt_ac IS NOT NULL AND   --Detrazioni ALTRI
           P_det_alt    IS NOT NULL THEN
        D_det_alt_mp := GP4_CACO.get_imp_mp(P_ci, P_anno, P_mese, P_mensilita, P_det_alt);
        D_det_alt  := GP4_CACO.get_imp(P_ci, P_det_alt);
--        D_det_per  := D_det_per_ac;
        GP4_CACO.insert_voce( P_ci, P_det_alt, '*', P_al
                            , D_det_alt_ac - D_det_alt_mp -D_det_Alt);
        END IF;
-- dbms_output.put_line('xxxxFIGLI: '||D_det_fig_ac);
     ELSE  -- Se mensilita senza Conguaglio Fiscale
           -- Ottiene Valori di Detrazioni Mensili
--        IF (D_ipt_tot_ac > 0 and p_tipo = 'N')
--        THEN
--           D_det_per  := GP4_RARE.get_det_per_spe
--                         ( P_ci, P_fin_ela
--                         , D_ipn_ord_ded, D_ipn_ass_ded, D_somme_od_ded -- modifica del 10/03/2005
--                         , 'M');
           D_det_spe  := GP4_RARE.get_det_spe
                         ( P_ci, P_fin_ela, P_anno, P_mese, P_spese, P_tipo_spese
                         , D_imponibile
                         , 'M', P_conguaglio, D_tipo_calcolo
                         , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                         );
          D_gg_det  := GP4_RARE.get_giorni_detrazioni(P_ci, P_fin_ela, 'M');
          select nvl(e_round((  D_det_spe
                              / decode( P_tipo_spese
                                      , 'DA', decode( nvl(D_attribuzione,0)
                                               , 0, 365, 1)
                                            , 365)
                             ) * decode( P_tipo_spese
                                       , 'DA', decode( nvl(D_attribuzione,0)
                                                , 0, least(365,D_gg_det)
                                                      , 0)
                                             , least(365,D_gg_det))
                            , 'I'),0)
            into D_det_spe
            from dual
          ;
-- dbms_output.put_line('D_det_spe mensili '||D_det_spe||' D_attribuzione '||D_attribuzione);
-- dbms_output.put_line('D_det_spe mensili '||D_det_spe||' voce '||P_det_spe||' P_tipo_spese '||P_tipo_spese);
--        END IF;
     END IF;
     P_stp := 'VOCI_FISC_DET-02';
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  END IF;
  IF  GP4_RARE.is_mese_conguaglio(P_ci, P_fin_ela, P_tipo, P_conguaglio) THEN
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
        -- Emissione Voci Detrazione Fiscale a Saldo:
        --
        -- Preleva valore progressivo precedente
        -- Preleva valore mese corrente
        -- Inserisce voce detrazione a conguaglio
        --
        GP4_CACO.set_input('C');
        GP4_CACO.set_estrazione('AF');
        IF D_val_det_con IS NOT NULL AND   --Detrazioni CONIUGE
           P_det_con     IS NOT NULL THEN  -- 14/02/2005
           D_p_imp_det := GP4_CACO.get_imp_mp(P_ci, P_anno, P_mese, P_mensilita, P_det_con);
           D_imp_det   := GP4_CACO.get_imp(P_ci, P_det_con);
           GP4_CACO.insert_voce(P_ci, P_det_con, '*', P_al
                               , D_val_det_con - D_p_imp_det - D_imp_det);
        END IF;
-- dbms_output.put_line('D_val_det_fig '||D_val_det_fig);
        IF D_val_det_fig IS NOT NULL AND   --Detrazioni FIGLI
           P_det_fig     IS NOT NULL THEN  -- 14/02/2005
           D_p_imp_det := GP4_CACO.get_imp_mp(P_ci, P_anno, P_mese, P_mensilita, P_det_fig);
           D_imp_det   := GP4_CACO.get_imp(P_ci, P_det_fig);
-- dbms_output.put_line('D_val_det_fig '||D_val_det_fig);
-- dbms_output.put_line('D_p_imp_det '||D_p_imp_det);
-- dbms_output.put_line('D_imp_det '||D_imp_det);
-- dbms_output.put_line('importo voce '||D_val_det_fig - D_p_imp_det - D_imp_det);
           GP4_CACO.insert_voce(P_ci, P_det_fig, '*', P_al
                               , D_val_det_fig - D_p_imp_det - D_imp_det);
        END IF;
        IF D_val_det_alt IS NOT NULL AND   --Detrazioni ALTRI
           P_det_alt     IS NOT NULL THEN  -- 14/02/2005
           D_p_imp_det := GP4_CACO.get_imp_mp(P_ci, P_anno, P_mese, P_mensilita, P_det_alt);
           D_imp_det   := GP4_CACO.get_imp(P_ci, P_det_alt);
           GP4_CACO.insert_voce
           (P_ci, P_det_alt, '*', P_al
           , D_val_det_alt - D_p_imp_det - D_imp_det);
        END IF;
-- dbms_output.put_line('2^ D_val_det_spe '||D_val_det_spe);
        IF D_val_det_spe IS NOT NULL AND   --Detrazioni SPESE
           P_det_spe     IS NOT NULL THEN  -- 14/02/2005
           D_p_imp_det := GP4_CACO.get_imp_mp(P_ci, P_anno, P_mese, P_mensilita, P_det_spe);
           D_imp_det   := GP4_CACO.get_imp(P_ci, P_det_spe);
           GP4_CACO.insert_voce
           (P_ci, P_det_spe, '*', P_al
           , D_val_det_spe - D_p_imp_det - D_imp_det);
        END IF;
--        Lo step viene eseguito sempre e non solo se esiste un valore fisso, perche
--        come importo del mese e stato prodotto il TOTALE spettante e deve quindi
--        essere recuperato il gia attribuito nei mesi precedenti
--
/* - In caso di forzatura di valori su AINEX: tiene il valore forzato
     e recupera tutto quanto attribuito, come progressivo precedente o come mese corrente
   - In caso di valori nulli su AINEX: in peccmore.autofam e stato calcolato
     ed inserito su CACO lo spettante TOTALE
     deve quindi essere recuperato quanto attribuito come progressivo precedente
*/
        D_p_imp_det := GP4_CACO.get_imp_mp(P_ci, P_anno, P_mese, P_mensilita, P_det_ult);
        D_imp_det   := GP4_CACO.get_imp(P_ci, P_det_ult);
        IF P_effe_cong  = 'M' AND D_val_det_ult is null
        OR P_effe_cong != 'M'
        THEN
           GP4_CACO.insert_voce
           ( P_ci, P_det_ult, '*', P_al, D_p_imp_det *-1);
        ELSE
           GP4_CACO.insert_voce
           ( P_ci, P_det_ult, '*', P_al, D_val_det_ult - D_p_imp_det - D_imp_det);
        END IF;
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
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
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
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
