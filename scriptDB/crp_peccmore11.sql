CREATE OR REPLACE PACKAGE Peccmore11 IS
/******************************************************************************
 NOME:        Peccmore11
 DESCRIZIONE: Calcolo VOCI Imponibile Fiscale.
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    12/07/2004 __     Prima emissione.
 1    17/09/2004 MM	Modificata l'estrazione di riduzioni_tfr e detrazioni_tfr da
                        VALIDITA_FISCALE: usava come data il P_fin_ela anziche il P_al
 1.1  29/09/2004 MM	Richiesta di rettifica successiva:
                        l'estrazione di riduzioni_tfr e detrazioni_tfr da
                        VALIDITA_FISCALE va eseguita al P_al+1 (giorno successivo quello
                        di cessazione) anziche il P_al.
 2    17/12/2004 AM     In caso di deduzioni = 0 attribuiva ugualmente le deduzioni fisse.
 3    23/12/2004 MF     Introduzione Deduzioni Familiari.
                        Eliminata la procedure Calcolo_Deduzione.
                        Richiamo Package PECCMORE_AUTOFAM.
                        Riferimenti al Package GP4_RARE, GP4_CACO e GP4_INEX.
 3.1  03/02/2005 AM-NN  Assestamento differenza tra annuale e sommatoria del mensile.
 3.2  14/02/2005 AM     Corretta la determinazione delle deduzioni annue includendo quelle
                        per familiari.
 3.3  16/02/2005 AM-NN  Corretta l'esposizione dell'imponibile in caso di totale deduzioni
                        del mese negative
 3.4  02/03/2005 NN     In caso di conguaglio fiscale, la % mensile di deduzione (base e agg.)
                        deve essere uguale a quella annuale.
 3.5  10/03/2005 NN     Gestito imponibile x calcolo deduzioni comunicato in inex.
 3.6  23/03/2005 AM     Problemi vari su fiscale liquidazione: mancata applicaizone aliquote storiche
                        in caso di anticipazioni molto vecchie; errata esposizione dell'imponibile
                        su MOCO; errata memorizzazione dell'imponibile e delle riduzioni del mese
                        su MOFI; errata lettura della data di liquidazione.
 3.7  29/03/2005 AM     A completamento della mod. precedente: itrodotta la data D_rif_sca_tfr
                        anche per determniare la validita' fiscale per deduzioni e detrazioni TFR
 3.8  30/03/2005 NN     In caso di conguaglio fiscale, con deduzioni del mese maggiori
                        del reddito (per esempio per conguaglio di mesi in cui non erano
                        state calcolate), riporta nel mese le deduzioni totali e non
                        solo le deduzioni fino al raggiungimento dell'imponibile.
                        Aggiunto anche l'ipn. da terzi, che mancava.
 3.9  17/05/2005 NN     Gestita maggiorazione imponibile x calcolo deduzioni, comunicata in inex.
 3.10 09/06/2005 NN     Gestiti parametri per deduzioni carichi familiari annuali
 3.11 04/11/2005 NN     Le deduzioni coniuge / figli / altre non conteggiano eventuali importi gia
                        liquidati da Precedente Datore di Lavoro.
 3.12 29/12/2005 NN     Corretta la modifica del 30/03/2005, protetto l'ipn totale AC : nel caso sia
                        negativo si considera 0 (zero).
 4    05/01/2007 AM     Adeguamento alla Legge Finanziaria 2007
 4.1  15/01/2007 AM-ML  Attribuzione detrazioni altri redditi sul totale dell'imposta e non solo
                        sulla parte soggetta fiscale C
 4.2  18/01/2007 ML     Attivazione deltrazione figlio in assenza del coniuge (A19233).
 4.3  06/02/2007 ML     Modificata determinazione detrazioni godute (A19566).
*****************************************************************************/
revisione varchar2(30) := '4.3 del 06/02/2007';
FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);
PROCEDURE voci_fisc_ipt
(
 p_ci        NUMBER
,p_ci_lav_pr  VARCHAR2
,p_al        DATE    -- Data di Termine o Fine Mese
,p_anno       NUMBER
,p_mese       NUMBER
,p_mensilita  VARCHAR2
,p_fin_ela    DATE
,p_tipo       VARCHAR2
,p_conguaglio NUMBER
,p_base_ratei VARCHAR2
,p_base_det   VARCHAR2
,p_mesi_irpef NUMBER
,p_base_cong  VARCHAR2
,p_scad_cong  VARCHAR2
,p_rest_cong  VARCHAR2
,p_rate_addizionali NUMBER
,p_detrazioni_ap    VARCHAR2
--
,p_spese          NUMBER
,p_tipo_Spese     VARCHAR2
,p_ulteriori      NUMBER
,p_tipo_ulteriori VARCHAR2
,p_perc_irpef_ord NUMBER
,p_perc_irpef_sep NUMBER
,p_perc_irpef_liq NUMBER
,p_rid_tfr        NUMBER
,p_rid_rid_tfr    NUMBER
,p_effe_cong      VARCHAR2
,p_alq_ap         NUMBER
,p_ant_liq_ap     NUMBER
,p_ant_acc_ap     NUMBER
,p_ant_acc_2000   NUMBER
,p_ipt_liq_ap     NUMBER
,p_fdo_tfr_ap     NUMBER
,p_fdo_tfr_2000   NUMBER
,p_riv_tfr_ap     NUMBER
,p_gg_anz_c       NUMBER
,p_gg_anz_t_2000  NUMBER
,p_gg_anz_i_2000  NUMBER
,p_gg_anz_r_2000  NUMBER
,p_ult_mese       NUMBER
,p_ult_mensilita  VARCHAR2
,p_gg_lav_ac      NUMBER
,p_gg_det_ac      NUMBER
--
--  Voci parametriche
, P_det_con       VARCHAR2
, P_det_fig       VARCHAR2
, P_det_alt       VARCHAR2
, P_det_spe       VARCHAR2
, P_det_ult       VARCHAR2
, P_riv_tfr       VARCHAR2
, P_ret_tfr       VARCHAR2
, P_qta_tfr       VARCHAR2
, P_rit_tfr       VARCHAR2
, P_rit_riv       VARCHAR2
, P_cal_anz       VARCHAR2  -- Specifica di calcolo Anzianita`
--
-- Valori Progressivi di ritorno
,p_ipn_tot_ac IN OUT NUMBER
,p_ipt_tot_ac IN OUT NUMBER
,p_ipn_terzi         NUMBER
,p_ass_terzi         NUMBER
,p_ipn_tot_ass_ac IN OUT NUMBER
,p_ipt_tot_ass_ac IN OUT NUMBER
,p_det_fis_ac IN OUT NUMBER
,p_ipt_pag_mc IN OUT NUMBER
,p_ipt_pag_ac IN OUT NUMBER
,p_det_con_ac IN OUT NUMBER
,p_det_fig_ac IN OUT NUMBER
,p_det_alt_ac IN OUT NUMBER
,p_det_spe_ac IN OUT NUMBER
,p_det_ult_ac IN OUT NUMBER
,p_det_div_ac IN OUT NUMBER
,p_add_irpef_mp IN OUT NUMBER
,p_add_prov_mp  IN OUT NUMBER
,p_add_comu_mp  IN OUT NUMBER
,p_ipn_mp       IN OUT NUMBER
,p_det_god_mp   IN OUT NUMBER
,p_ded_fis_ac   IN OUT NUMBER
,P_ded_tot_ac   IN OUT NUMBER
,p_ded_con_ac   IN OUT NUMBER
,p_ded_fig_ac   IN OUT NUMBER
,p_ded_alt_ac   IN OUT NUMBER
--
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
CREATE OR REPLACE PACKAGE BODY Peccmore11 IS
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
--Determinazione dell'Imponibile, Aliquota e Imposta IRPEF e T.F.R.
PROCEDURE voci_fisc_ipt
(
 p_ci        NUMBER
,p_ci_lav_pr  VARCHAR2
,p_al        DATE    -- Data di Termine o Fine Mese
,p_anno       NUMBER
,p_mese       NUMBER
,p_mensilita  VARCHAR2
,p_fin_ela    DATE
,p_tipo       VARCHAR2
,p_conguaglio NUMBER
,p_base_ratei VARCHAR2
,p_base_det   VARCHAR2
,p_mesi_irpef NUMBER
,p_base_cong  VARCHAR2
,p_scad_cong  VARCHAR2
,p_rest_cong  VARCHAR2
,p_rate_addizionali NUMBER
,p_detrazioni_ap    VARCHAR2
--
,p_spese          NUMBER
,p_tipo_spese     VARCHAR2
,p_ulteriori      NUMBER
,p_tipo_ulteriori VARCHAR2
,p_perc_irpef_ord NUMBER
,p_perc_irpef_sep NUMBER
,p_perc_irpef_liq NUMBER
,p_rid_tfr        NUMBER
,p_rid_rid_tfr    NUMBER
,p_effe_cong      VARCHAR2
,p_alq_ap         NUMBER
,p_ant_liq_ap     NUMBER
,p_ant_acc_ap     NUMBER
,p_ant_acc_2000   NUMBER
,p_ipt_liq_ap     NUMBER
,p_fdo_tfr_ap     NUMBER
,p_fdo_tfr_2000   NUMBER
,p_riv_tfr_ap     NUMBER
,p_gg_anz_c       NUMBER
,p_gg_anz_t_2000  NUMBER
,p_gg_anz_i_2000  NUMBER
,p_gg_anz_r_2000  NUMBER
,p_ult_mese       NUMBER
,p_ult_mensilita  VARCHAR2
,p_gg_lav_ac      NUMBER
,p_gg_det_ac      NUMBER
--
--  Voci parametriche
, P_det_con       VARCHAR2
, P_det_fig       VARCHAR2
, P_det_alt       VARCHAR2
, P_det_spe       VARCHAR2
, P_det_ult       VARCHAR2
, P_riv_tfr       VARCHAR2
, P_ret_tfr       VARCHAR2
, P_qta_tfr       VARCHAR2
, P_rit_tfr       VARCHAR2
, P_rit_riv       VARCHAR2
, P_cal_anz       VARCHAR2  -- Specifica di calcolo Anzianita`
--
-- Valori Progressivi di ritorno
,p_ipn_tot_ac IN OUT NUMBER
,p_ipt_tot_ac IN OUT NUMBER
,p_ipn_terzi         NUMBER
,p_ass_terzi         NUMBER
,p_ipn_tot_ass_ac IN OUT NUMBER
,p_ipt_tot_ass_ac IN OUT NUMBER
,p_det_fis_ac IN OUT NUMBER
,p_ipt_pag_mc IN OUT NUMBER
,p_ipt_pag_ac IN OUT NUMBER
,p_det_con_ac IN OUT NUMBER
,p_det_fig_ac IN OUT NUMBER
,p_det_alt_ac IN OUT NUMBER
,p_det_spe_ac IN OUT NUMBER
,p_det_ult_ac IN OUT NUMBER
,p_det_div_ac IN OUT NUMBER
,p_add_irpef_mp IN OUT NUMBER
,p_add_prov_mp  IN OUT NUMBER
,p_add_comu_mp  IN OUT NUMBER
,p_ipn_mp       IN OUT NUMBER
,p_det_god_mp   IN OUT NUMBER
,p_ded_fis_ac   IN OUT NUMBER
,P_ded_tot_ac   IN OUT NUMBER
,p_ded_con_ac   IN OUT NUMBER
,p_ded_fig_ac   IN OUT NUMBER
,p_ded_alt_ac   IN OUT NUMBER
--
-- Parametri per Trace
,p_trc    IN     NUMBER     -- Tipo di Trace
,p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
) IS
--
--Progressivi Fiscali Anno Corrente al valore del Mese Precedente
D_ipn_mp           MOVIMENTI_FISCALI.ipn_ord%TYPE;
D_alq_ord_mp       MOVIMENTI_FISCALI.alq_ord%TYPE;
D_alq_sep_mp       MOVIMENTI_FISCALI.alq_ord%TYPE;
D_alq_ord_max      MOVIMENTI_FISCALI.alq_ord%TYPE;
D_ipt_mp           MOVIMENTI_FISCALI.rit_ord%TYPE;
D_alq_ac_mp        MOVIMENTI_FISCALI.alq_ac%TYPE;
D_ipt_ac_mp        MOVIMENTI_FISCALI.ipt_ac%TYPE;
D_add_irpef_mp      MOVIMENTI_FISCALI.ipt_ac%TYPE;
D_add_prov_mp       MOVIMENTI_FISCALI.ipt_ac%TYPE;
D_add_comu_mp       MOVIMENTI_FISCALI.ipt_ac%TYPE;
D_det_fis_mp       MOVIMENTI_FISCALI.det_fis%TYPE;
D_det_god_mp       MOVIMENTI_FISCALI.det_god%TYPE;
D_con_fis_mp       MOVIMENTI_FISCALI.con_fis%TYPE;
D_det_con_mp       MOVIMENTI_FISCALI.det_con%TYPE;
D_det_fig_mp       MOVIMENTI_FISCALI.det_fig%TYPE;
D_det_alt_mp       MOVIMENTI_FISCALI.det_alt%TYPE;
D_det_spe_mp       MOVIMENTI_FISCALI.det_spe%TYPE;
D_det_ult_mp       MOVIMENTI_FISCALI.det_ult%TYPE;
D_det_div_mp       MOVIMENTI_FISCALI.det_fis%TYPE;
D_ipt_ass_mp       MOVIMENTI_FISCALI.ipn_ass%TYPE;
D_ipn_ass_mp       MOVIMENTI_FISCALI.ipn_ass%TYPE;
-- D_ipn_tot_ass_ac    MOVIMENTI_FISCALI.ipn_ass%TYPE;
D_ipn_ap_mp        MOVIMENTI_FISCALI.ipn_ap%TYPE;
D_alq_ap_mp        MOVIMENTI_FISCALI.alq_ap%TYPE;
D_ipt_ap_mp        MOVIMENTI_FISCALI.ipt_ap%TYPE;
D_lor_liq_mp       MOVIMENTI_FISCALI.lor_liq%TYPE;
D_lor_acc_mp       MOVIMENTI_FISCALI.lor_acc%TYPE;
D_lor_acc_2000_mp   MOVIMENTI_FISCALI.lor_acc_2000%TYPE;
D_rid_liq_mp       MOVIMENTI_FISCALI.rid_liq%TYPE;
D_rtp_liq_mp       MOVIMENTI_FISCALI.rtp_liq%TYPE;
D_det_liq_mp        MOVIMENTI_FISCALI.det_liq%TYPE;
D_dtp_liq_mp        MOVIMENTI_FISCALI.dtp_liq%TYPE;
D_ipn_liq_mp       MOVIMENTI_FISCALI.ipn_liq%TYPE;
D_ipn_liq_tot      MOVIMENTI_FISCALI.ipn_liq%TYPE;
D_alq_liq_mp       MOVIMENTI_FISCALI.alq_liq%TYPE;
D_ipt_liq_mp       MOVIMENTI_FISCALI.ipt_liq%TYPE;
D_gg_anz_t_mp       MOVIMENTI_FISCALI.gg_anz_t%TYPE;
D_gg_anz_i_mp       MOVIMENTI_FISCALI.gg_anz_i%TYPE;
D_gg_anz_r_mp       MOVIMENTI_FISCALI.gg_anz_r%TYPE;
D_fdo_tfr_ap_liq_mp MOVIMENTI_FISCALI.fdo_tfr_ap_liq%TYPE;
D_fdo_tfr_ap_ant    MOVIMENTI_FISCALI.fdo_tfr_ap_liq%TYPE;
D_fdo_tfr_2000_liq_mp MOVIMENTI_FISCALI.fdo_tfr_2000_liq%TYPE;
D_riv_tfr_mp       MOVIMENTI_FISCALI.riv_tfr%TYPE;
D_riv_tfr_liq_mp    MOVIMENTI_FISCALI.riv_tfr_liq%TYPE;
D_riv_tfr_ap_mp        MOVIMENTI_FISCALI.riv_tfr%TYPE;
D_riv_tfr_ap_liq_mp    MOVIMENTI_FISCALI.riv_tfr_ap_liq%TYPE;
D_qta_tfr_ac_mp     MOVIMENTI_FISCALI.qta_tfr_ac%TYPE;
D_qta_tfr_ac_liq_mp MOVIMENTI_FISCALI.qta_tfr_ac_liq%TYPE;
D_rit_tfr_mp        MOVIMENTI_FISCALI.rit_tfr%TYPE;
D_rit_riv_mp        MOVIMENTI_FISCALI.rit_riv%TYPE;
D_somme_od_mp       MOVIMENTI_FISCALI.somme_od%TYPE;
D_ded_fis_mp        MOVIMENTI_FISCALI.ded_fis%TYPE;
D_ded_tot_mp        MOVIMENTI_FISCALI.ded_tot%TYPE;
D_ded_base_mp       MOVIMENTI_FISCALI.ded_base%TYPE;
D_ded_agg_mp        MOVIMENTI_FISCALI.ded_agg%TYPE;
D_ded_con_mp        MOVIMENTI_FISCALI.ded_con%TYPE;
D_ded_fig_mp        MOVIMENTI_FISCALI.ded_fig%TYPE;
D_ded_alt_mp        MOVIMENTI_FISCALI.ded_alt%TYPE;
D_voce_ded_con      VARCHAR2(10);
D_voce_ded_fig      VARCHAR2(10);
D_voce_ded_alt      VARCHAR2(10);
D_voce_det_con      VARCHAR2(10);
D_voce_det_fig      VARCHAR2(10);
D_voce_det_alt      VARCHAR2(10);
--
--Dati di calcolo
D_ratei_anz        NUMBER;
D_ratei_anz_app    NUMBER;
D_ipn_liq_res       NUMBER;
D_fdo_tfr_ap_res    NUMBER;
D_fdo_tfr_2000_res  NUMBER;
D_riv_tfr_ap_res    NUMBER;
D_riv_tfr_res       NUMBER;
D_qta_tfr_ac_res    NUMBER;
D_rit_tfr_tot       NUMBER;
D_rit_riv_tot       NUMBER;
D_per_liq          NUMBER;
D_riduzione        NUMBER;
D_detrazione        NUMBER;
D_tfr_totale        NUMBER;
D_rif_sca_tfr        DATE;    -- data a cui vengono determinati gli scaglioni per il calcolo del fiscale di liquidazione
D_tfr_fondi         NUMBER;
d_gg_det            NUMBER;
D_arr               VARCHAR2(1);
D_imponibile        NUMBER;
D_is_mese_conguaglio BOOLEAN;
D_mesi_deduzione     NUMBER;
D_ipn_ded            NUMBER;
D_ipn_tot_ded_ac     NUMBER;
D_ipn_tot_ass_ded_ac NUMBER;
D_somme_od_ded_ac    NUMBER;
D_ipn_ord_ded        NUMBER;
D_ipn_ass_ded        NUMBER;
D_somme_od_ded       NUMBER;
D_ipn_ded_magg       NUMBER;
--
--Valori Fiscali del Mese Corrente
D_imp_det_fis    MOVIMENTI_FISCALI.det_fis%TYPE;
D_imp_det_con    MOVIMENTI_FISCALI.det_con%TYPE;
D_imp_det_fig    MOVIMENTI_FISCALI.det_fig%TYPE;
D_imp_det_alt    MOVIMENTI_FISCALI.det_alt%TYPE;
D_det_con_ac     MOVIMENTI_FISCALI.det_con%TYPE;
D_det_fc_ac      MOVIMENTI_FISCALI.det_con%TYPE;
D_det_ft_ac      MOVIMENTI_FISCALI.det_con%TYPE;
D_det_fig_ac     MOVIMENTI_FISCALI.det_fig%TYPE;
D_det_alt_ac     MOVIMENTI_FISCALI.det_alt%TYPE;
D_imp_det_spe    MOVIMENTI_FISCALI.det_spe%TYPE;
D_det_spe_ac     MOVIMENTI_FISCALI.det_spe%TYPE;
D_imp_det_ult    MOVIMENTI_FISCALI.det_ult%TYPE;
D_imp_det_god    MOVIMENTI_FISCALI.det_god%TYPE;
D_gg_anz_t       MOVIMENTI_FISCALI.gg_anz_t%TYPE;
D_gg_anz_i       MOVIMENTI_FISCALI.gg_anz_i%TYPE;
D_gg_anz_r       MOVIMENTI_FISCALI.gg_anz_r%TYPE;
D_gg_anz_tp      NUMBER(5);
D_gg_anz_tp_2000 NUMBER(5);
D_lor_ord       NUMBER;
D_rit_ord       NUMBER;
D_ipn_ord       MOVIMENTI_FISCALI.ipn_ord%TYPE;
D_alq_ord       MOVIMENTI_FISCALI.alq_ord%TYPE;
D_ipt_ord       MOVIMENTI_FISCALI.ipt_ord%TYPE;
D_lor_sep       NUMBER;
D_rit_sep       NUMBER;
D_ipn_sep       MOVIMENTI_FISCALI.ipn_sep%TYPE;
D_alq_sep       MOVIMENTI_FISCALI.alq_sep%TYPE;
D_ipt_sep       MOVIMENTI_FISCALI.ipt_sep%TYPE;
D_lor_ap        NUMBER;
D_rit_ap        NUMBER;
D_ipn_ap        MOVIMENTI_FISCALI.ipn_ap%TYPE;
D_ipn_ap_neg     NUMBER;
D_alq_ap        MOVIMENTI_FISCALI.alq_ap%TYPE;
D_ipt_ap        MOVIMENTI_FISCALI.ipt_ap%TYPE;
D_lor_lor_liq    NUMBER;
D_lor_liq       NUMBER;
D_lor_acc       NUMBER;
D_richiesta_ant date;
D_anno_ant      varchar2(4);
D_mese_ant      varchar2(2);
D_giorno_ant    varchar2(2);
D_mese_prec     varchar2(2);
D_tfr_pubblico  varchar2(2);
D_mensilita_ant MOVIMENTI_FISCALI.mensilita%TYPE;
D_rid_fondi     informazioni_retributive.TARIFFA%type;
D_lor_acc_2000   NUMBER;
D_rit_liq       NUMBER;
D_rid_liq       NUMBER;
D_rtp_liq       NUMBER;
D_det_liq        MOVIMENTI_FISCALI.det_liq%TYPE;
D_dtp_liq        MOVIMENTI_FISCALI.dtp_liq%TYPE;
D_ipn_liq_2000   NUMBER;
D_ipn_liq_ac     MOVIMENTI_FISCALI.ipn_liq%TYPE;
D_ipt_liq_ac     MOVIMENTI_FISCALI.ipt_liq%TYPE;
D_ipn_liq       MOVIMENTI_FISCALI.ipn_liq%TYPE;
D_alq_liq       MOVIMENTI_FISCALI.alq_liq%TYPE;
D_ipt_liq       MOVIMENTI_FISCALI.ipt_liq%TYPE;
D_lor_tra       MOVIMENTI_FISCALI.lor_tra%TYPE;
D_rit_tra       MOVIMENTI_FISCALI.rit_tra%TYPE;
D_lor_tra_fis    MOVIMENTI_FISCALI.lor_tra%TYPE;
D_ipn_tra       MOVIMENTI_FISCALI.ipn_tra%TYPE;
D_lor_ass       NUMBER;
D_rit_ass       MOVIMENTI_FISCALI.rit_ass%TYPE;
D_ipn_ass       MOVIMENTI_FISCALI.ipn_ass%TYPE;
D_ipt_ass       MOVIMENTI_FISCALI.ipt_ass%TYPE;
D_lor_aap       NUMBER;
D_rit_aap       MOVIMENTI_FISCALI.rit_aap%TYPE;
D_ipn_aap       MOVIMENTI_FISCALI.ipn_aap%TYPE;
D_ipt_aap       MOVIMENTI_FISCALI.ipt_aap%TYPE;
D_somme_0       NUMBER;
D_somme_1       NUMBER;
D_somme_2       NUMBER;
D_somme_3       NUMBER;
D_somme_4       NUMBER;
D_somme_5       NUMBER;
D_somme_6       NUMBER;
D_somme_7       NUMBER;
D_somme_8       NUMBER;
D_somme_9       NUMBER;
D_somme_10       NUMBER;
D_somme_11       NUMBER;
D_somme_12       NUMBER;
D_somme_13       NUMBER;
D_somme_14       NUMBER;
D_somme_15       NUMBER;
D_somme_16       NUMBER;
D_somme_17       NUMBER;
D_somme_18       NUMBER;
D_somme_19       NUMBER;
D_ipn_prev       MOVIMENTI_FISCALI.ipn_prev%TYPE;
D_ipn_ssn        MOVIMENTI_FISCALI.ipn_ssn%TYPE;
D_rit_ssn        MOVIMENTI_FISCALI.rit_ssn%TYPE;
D_ipn_ssn_liq    MOVIMENTI_FISCALI.ipn_ssn_liq%TYPE;
D_rit_ssn_liq    MOVIMENTI_FISCALI.rit_ssn_liq%TYPE;
D_lor_tfr_pag    NUMBER; --Lordo Accant.T.F.R. Liquidato dal fondo
D_lor_tfr_per    NUMBER;  --Lordo Accant.T.F.R. Liquidato in %
D_tfr_dis        NUMBER;  --T.F.R. disponibile per la liquidazione
D_fdo_tfr_ap_liq MOVIMENTI_FISCALI.fdo_tfr_ap_liq%TYPE;
D_fdo_tfr_2000_liq MOVIMENTI_FISCALI.fdo_tfr_2000_liq%TYPE;
D_lor_riv_pag    NUMBER;  -- Lordo Riv.T.F.R. Liquidato dal fondo
D_lor_riv_per    NUMBER;  -- Lordo Riv.T.F.R. Liquidato in %
D_riv_tfr        MOVIMENTI_FISCALI.riv_tfr%TYPE;
D_rit_tfr_mese   MOVIMENTI_FISCALI.rit_tfr%TYPE;
D_riv_tfr_liq    MOVIMENTI_FISCALI.riv_tfr_liq%TYPE;
D_riv_tfr_ap     INFORMAZIONI_EXTRACONTABILI.riv_tfr_ap%TYPE;
D_riv_tfr_ap_liq MOVIMENTI_FISCALI.riv_tfr_ap_liq%TYPE;
D_ret_tfr        MOVIMENTI_FISCALI.ret_tfr%TYPE;
D_qta_tfr_ac     MOVIMENTI_FISCALI.qta_tfr_ac%TYPE;
D_qta_tfr_ac_mese   MOVIMENTI_FISCALI.qta_tfr_ac%TYPE;
D_qta_tfr_mese_ant  MOVIMENTI_FISCALI.qta_tfr_ac%TYPE;
D_qta_tfr_ac_liq MOVIMENTI_FISCALI.qta_tfr_ac_liq%TYPE;
D_ipn_tfr        MOVIMENTI_FISCALI.ipn_tfr%TYPE;
D_rit_tfr        MOVIMENTI_FISCALI.rit_tfr%TYPE;
D_rit_tfr_mese_ant  MOVIMENTI_FISCALI.rit_tfr%TYPE;
D_rit_riv        MOVIMENTI_FISCALI.rit_riv%TYPE;
D_val_conv_ded   NUMBER;
D_val_conv_det   NUMBER;
D_riduzioni_tfr  NUMBER;
D_detrazioni_tfr NUMBER;
D_somme_od          MOVIMENTI_FISCALI.somme_od%TYPE;
D_somme_od_ac       MOVIMENTI_FISCALI.somme_od%TYPE;
D_ded_fis           MOVIMENTI_FISCALI.ded_fis%TYPE;
D_ded_tot           MOVIMENTI_FISCALI.ded_tot%TYPE;
D_ded_per           MOVIMENTI_FISCALI.ded_per%TYPE;
D_ded_base          MOVIMENTI_FISCALI.ded_base%TYPE;
D_ded_agg           MOVIMENTI_FISCALI.ded_agg%TYPE;
D_ded_base_ac       MOVIMENTI_FISCALI.ded_base_ac%TYPE;
D_ded_agg_ac        MOVIMENTI_FISCALI.ded_agg_ac%TYPE;
D_ded_per_ac        MOVIMENTI_FISCALI.ded_per_ac%TYPE;
D_ded_con           MOVIMENTI_FISCALI.ded_con%TYPE;
D_ded_fig           MOVIMENTI_FISCALI.ded_fig%TYPE;
D_ded_alt           MOVIMENTI_FISCALI.ded_alt%TYPE;
D_ded_per_fam       MOVIMENTI_FISCALI.ded_per_fam%TYPE;
D_ded_con_ac        MOVIMENTI_FISCALI.ded_con_ac%TYPE;
D_ded_fig_ac        MOVIMENTI_FISCALI.ded_fig_ac%TYPE;
D_ded_alt_ac        MOVIMENTI_FISCALI.ded_alt_ac%TYPE;
D_ded_per_fam_ac    MOVIMENTI_FISCALI.ded_per_fam_ac%TYPE;
D_p_imp_det         MOVIMENTI_FISCALI.ded_fis%TYPE;
D_imp_det           MOVIMENTI_FISCALI.ded_fis%TYPE;
--D_nr_figli          NUMBER;
--
D_anticipazione varchar2(2);                        -- Anticipazione SI/NO
BEGIN
  BEGIN  --Acquisizione progressivi Fiscali mese precedente
     D_tfr_pubblico := 'NO';
     P_stp := 'VOCI_FISC_IPT-01';
     SELECT NVL( SUM( ipn_ord + NVL(ipn_sep,0) ), 0 )
         , NVL( MAX( DECODE( LPAD(TO_CHAR(mese),2)||MENSILITA
                         , LPAD(TO_CHAR(P_ult_mese),2)||
                           P_ult_mensilita, alq_ord
                                        , NULL
                         )
                  )
              , 0)
         , NVL( MAX( DECODE( LPAD(TO_CHAR(mese),2)||MENSILITA
                         , LPAD(TO_CHAR(P_ult_mese),2)||
                           P_ult_mensilita, alq_sep
                                        , NULL
                         )
                  )
              , 0)
         , NVL( MAX( alq_ord ), 0)
         , NVL( SUM( ipt_ord + NVL(ipt_sep,0) ), 0 )
         , NVL( MAX( DECODE( LPAD(TO_CHAR(mese),2)||MENSILITA
                         , LPAD(TO_CHAR(P_ult_mese),2)||
                           P_ult_mensilita, alq_ac
                                        , NULL
                         )
                   )
              , 0)
         , NVL( MAX( DECODE( LPAD(TO_CHAR(mese),2)||MENSILITA
                         , LPAD(TO_CHAR(P_ult_mese),2)||
                           P_ult_mensilita, ipt_ac
                                        , NULL
                         )
                  )
              , 0)
         , NVL( SUM( add_irpef ), 0 )
         , NVL( SUM( add_irpef_provinciale ), 0 )
         , NVL( SUM( add_irpef_comunale ), 0 )
         , NVL( SUM( det_fis ), 0 )
         , NVL( SUM( det_god ), 0 )
         , NVL( SUM( det_con ), 0 )
         , NVL( SUM( det_fig ), 0 )
         , NVL( SUM( det_alt ), 0 )
         , NVL( SUM( det_spe ), 0 )
         , NVL( SUM( det_ult ), 0 )
         , NVL( SUM( det_fis ), 0 ) -
           NVL( SUM( det_con ), 0 ) -
           NVL( SUM( det_fig ), 0 ) -
           NVL( SUM( det_alt ), 0 ) -
           NVL( SUM( det_spe ), 0 ) -
           NVL( SUM( det_ult ), 0 )
         , NVL( SUM( ipn_ass ), 0 )
         , NVL( SUM( ipt_ass ), 0 )
         , NVL( SUM( con_fis ), 0 )
         , NVL( SUM( ipn_ap  ), 0 )
         , NVL( MAX( DECODE( LPAD(TO_CHAR(mese),2)||MENSILITA
                         , LPAD(TO_CHAR(P_ult_mese),2)||
                           P_ult_mensilita, alq_ap
                                        , NULL
                         )
                  )
              , 0)
         , NVL( SUM( ipt_ap  ), 0 )
         , NVL( SUM( lor_liq ), 0 )
         , NVL( SUM( lor_acc ), 0 )
         , NVL( SUM( lor_acc_2000 ), 0 )
         , NVL( SUM( rid_liq ), 0 )
         , NVL( SUM( rtp_liq ), 0 )
         , NVL( SUM( det_liq ), 0 )
         , NVL( SUM( dtp_liq ), 0 )
         , NVL( SUM( ipn_liq ), 0 )
         , NVL( MAX( DECODE( LPAD(TO_CHAR(mese),2)||MENSILITA
                         , LPAD(TO_CHAR(P_ult_mese),2)
                           ||P_ult_mensilita, alq_liq
                                          , NULL
                         )
                  )
              , 0)
         , NVL( SUM( ipt_liq ), 0 )
         , NVL( SUM( gg_anz_t ), 0 )
         , NVL( SUM( gg_anz_i ), 0 )
         , NVL( SUM( gg_anz_r ), 0 )
         , NVL( SUM( fdo_tfr_ap_liq ), 0 )
         , NVL( SUM( fdo_tfr_2000_liq ), 0 )
         , NVL( SUM( riv_tfr ), 0 )
         , NVL( SUM( riv_tfr_liq ), 0 )
         , NVL( SUM( riv_tfr_ap_liq ), 0 )
         , NVL( SUM( qta_tfr_ac ), 0 )
         , NVL( SUM( qta_tfr_ac_liq ), 0 )
         , NVL( SUM( rit_tfr ), 0 )
         , NVL( SUM( rit_riv ), 0 )
         , NVL( SUM( somme_od ), 0 )
         , NVL( SUM( ded_fis ), 0 )
         , NVL( SUM( ded_tot ), 0 )
         , NVL( SUM( ded_base ), 0 )
         , NVL( SUM( ded_agg ), 0 )
         , NVL( SUM( ded_con ), 0 )
         , NVL( SUM( ded_fig ), 0 )
         , NVL( SUM( ded_alt ), 0 )
       INTO D_ipn_mp
         , D_alq_ord_mp
         , D_alq_sep_mp
         , D_alq_ord_max
         , D_ipt_mp
         , D_alq_ac_mp
         , D_ipt_ac_mp
         , D_add_irpef_mp
         , D_add_prov_mp
         , D_add_comu_mp
         , D_det_fis_mp
         , D_det_god_mp
         , D_det_con_mp
         , D_det_fig_mp
         , D_det_alt_mp
         , D_det_spe_mp
         , D_det_ult_mp
         , D_det_div_mp
         , D_ipn_ass_mp
         , D_ipt_ass_mp
         , D_con_fis_mp
         , D_ipn_ap_mp
         , D_alq_ap_mp
         , D_ipt_ap_mp
         , D_lor_liq_mp
         , D_lor_acc_mp
         , D_lor_acc_2000_mp
         , D_rid_liq_mp
         , D_rtp_liq_mp
         , D_det_liq_mp
         , D_dtp_liq_mp
         , D_ipn_liq_mp
         , D_alq_liq_mp
         , D_ipt_liq_mp
         , D_gg_anz_t_mp
         , D_gg_anz_i_mp
         , D_gg_anz_r_mp
         , D_fdo_tfr_ap_liq_mp
         , D_fdo_tfr_2000_liq_mp
         , D_riv_tfr_mp
         , D_riv_tfr_liq_mp
         , D_riv_tfr_ap_liq_mp
         , D_qta_tfr_ac_mp
         , D_qta_tfr_ac_liq_mp
         , D_rit_tfr_mp
         , D_rit_riv_mp
         , D_somme_od_mp
         , D_ded_fis_mp
         , D_ded_tot_mp
         , D_ded_base_mp
         , D_ded_agg_mp
         , D_ded_con_mp
         , D_ded_fig_mp
         , D_ded_alt_mp
       FROM MOVIMENTI_FISCALI
      WHERE ci   = P_ci
        AND anno = P_anno
        AND LPAD(TO_CHAR(mese),2)||MENSILITA
               < LPAD(TO_CHAR(P_mese),2)||P_mensilita
     ;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
-- dbms_output.put_line('Imponibile al mese prec.   D_ipn_liq_mp :'||D_ipn_liq_mp);
-- dbms_output.put_line('                           D_rit_riv_mp :'||D_rit_riv_mp);
-- dbms_output.put_line('                           D_det_liq_mp :'||D_det_liq_mp);
-- dbms_output.put_line('                           D_dtp_liq_mp :'||D_dtp_liq_mp);
  P_add_irpef_mp := D_add_irpef_mp;
  P_add_prov_mp  := D_add_prov_mp;
  P_add_comu_mp  := D_add_comu_mp;
  P_ipn_mp       := D_ipn_mp;
  P_det_god_mp   := D_det_god_mp;
  begin
     select nvl(D_ipn_liq_mp,0) + nvl(sum (ipn_liq_ap),0)
	 into D_ipn_liq_tot
	 from progressivi_fiscali
      where ci   = P_ci
        and anno = P_anno
        and mese = P_mese
        and mensilita = P_mensilita
     ;
  exception
     when no_data_found then
          D_ipn_liq_tot := 0;
  end;
-- dbms_output.put_line('Imponibile totale   D_ipn_liq_tot :'||D_ipn_liq_tot);
  IF P_tipo = 'N' THEN
     BEGIN  --Totalizza Giorni di Anzianita`
        P_stp := 'VOCI_FISC_IPT-02';
        Peccmore12.VOCI_FISC_ANZ  --Totalizza Giorni di Anzianita`
          ( P_ci, P_fin_ela, P_base_ratei
               , D_gg_anz_t
               , D_gg_anz_i
               , D_gg_anz_r
          );
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  ELSE
     D_gg_anz_t := 0;
     D_gg_anz_i := 0;
     D_gg_anz_r := 0;
  END IF;
  BEGIN  --Determinazione degli Imponibili FISCALI
     P_stp := 'VOCI_FISC_IPT-03';
SELECT
--Assoggettamento Fiscale Imponib.e Ritenute
--nvl( sum( nvl(caco.ipn_c,caco.imp)
 NVL( SUM( decode(voec.specifica,'SOM_ERE',nvl(caco.ipn_c,caco.imp)
                   ,caco.imp)
        * DECODE(covo.fiscale,'C',1,'F',1,'X',1,0)
        * DECODE(NVL(caco.arr,'C'),'C',1,0)
        )
    , 0 ) lor_ord
, NVL( SUM( NVL(caco.ipn_c,caco.imp)
        * DECODE(covo.fiscale,'R',1,0)
        * DECODE(NVL(caco.arr,'C'),'C',1,0)
        ) * -1
    , 0 ) rit_ord
--, nvl( sum( nvl(caco.ipn_s,caco.imp)
, NVL( SUM( caco.imp
        * DECODE(covo.fiscale,'S',1,0)
        * DECODE(NVL(caco.arr,'C'),'C',1,0)
        )
    , 0 )
+  NVL( SUM( decode(voec.specifica,'SOM_ERE',caco.ipn_s
                   ,0)
        * DECODE(covo.fiscale,'C',1,0)
        * DECODE(NVL(caco.arr,'C'),'C',1,0)
        )
    , 0 ) lor_sep
, NVL( SUM( NVL(caco.ipn_s,0)
        * DECODE(covo.fiscale,'R',1,0)
        ) * -1
    , 0 ) rit_sep
, NVL( SUM( caco.imp
        * DECODE(covo.fiscale,'P',1,'Y',1,0)
        --+ nvl(caco.ipn_p,caco.imp)
        + caco.imp
        * DECODE(covo.fiscale,'C',1,'F',1,'X',1,'S',1,0)
        * DECODE(NVL(caco.arr,'C'),'P',1,0)
        )
    , 0 ) lor_ap
, NVL( SUM( NVL(caco.ipn_p,0)
        * DECODE(covo.fiscale,'R',1,0)
        ) * -1
    , 0 ) rit_ap
, NVL( SUM( caco.imp
        * DECODE(covo.fiscale,'L',1,0)
        )
    , 0 ) lor_lor_liq
, NVL( SUM( caco.imp
        * DECODE(covo.fiscale,'A',1,'Z',1,0)
        )
    , 0 ) lor_acc
, max(DECODE( covo.fiscale
             ,'A',caco.riferimento
	     ,'V',caco.riferimento
             ,'Z',caco.riferimento,to_date(null)
            )
     ) richiesta_ant
, NVL( SUM( caco.imp
        * DECODE(covo.fiscale,'V',1,0)
        )
    , 0 ) lor_acc_2000
, NVL( SUM( NVL(caco.ipn_l,0)
        * DECODE(covo.fiscale,'R',1,0)
        ) * -1
    , 0 ) rit_liq
--, nvl( sum( nvl(caco.ipn_t,caco.imp)
, NVL( SUM( caco.imp
        * DECODE(covo.fiscale,'T',1,'F',1,'D',1,0)
        )
    , 0 ) lor_tra
, NVL( SUM( NVL(caco.ipn_t,0)
        * DECODE(covo.fiscale,'R',1,0)
        ) * -1
    , 0 ) rit_tra
, NVL( SUM( caco.imp
        * DECODE(covo.fiscale,'F',1,0)
        )
    , 0 ) lor_tra_fis
, NVL( SUM( caco.imp
        * DECODE(covo.fiscale,'X',1,0)
        * DECODE(NVL(caco.arr,'C'),'C',1,0)
        )
    , 0 ) lor_ass
, NVL( SUM( NVL(caco.ipn_a,0)
        * DECODE(covo.fiscale,'R',1,0)
        * DECODE(NVL(caco.arr,'C'),'C',1,0)
        ) * -1
    , 0 ) rit_ass
, NVL( SUM( caco.imp
        * DECODE(covo.fiscale,'X',1,'Y',1,0)
        * DECODE(NVL(caco.arr,'C'),'P',1,DECODE(covo.fiscale,'Y',1,0))
        )
    , 0 ) lor_aap
, NVL( SUM( NVL(caco.ipn_ap,0)
        * DECODE(covo.fiscale,'R',1,0)
        ) * -1
    , 0 ) rit_aap
, NVL( SUM( caco.imp * DECODE(covo.somme,'0',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'1',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'2',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'3',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'4',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'5',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'6',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'7',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'8',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'9',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'10',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'11',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'12',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'13',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'14',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'15',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'16',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'17',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'18',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'19',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'P',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'I',1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(covo.somme,'R',1,0) ) * -1, 0 )
, NVL( SUM( caco.ipn_l * DECODE(covo.somme,'I',1,0) ), 0 )
, NVL( SUM( caco.ipn_l * DECODE(covo.somme,'R',1,0) ) * -1, 0 )
, NVL( SUM( caco.imp * DECODE(covo.fiscale,'A',1,0)
                 * DECODE( voec.specifica, 'DAL_FONDO', 1, 0 )
                )
           , 0 ) lor_tfr_pag
, NVL( SUM( caco.imp * DECODE(covo.fiscale,'A',1,0)
                 * DECODE( NVL(voec.specifica,'DAL_TFR'), 'DAL_TFR', 1, 0 )
                )
           , 0 ) lor_tfr_per
, NVL( SUM( caco.imp * DECODE(covo.fiscale,'A',0,'V',0,1)
                 * DECODE( voec.specifica, 'DAL_FONDO', 1, 0 )
                )
           , 0 ) lor_riv_pag
, NVL( SUM( caco.imp * DECODE(covo.fiscale,'A',0,'V',0,1)
                 * DECODE( voec.specifica, 'DAL_TFR', 1, 0 )
                )
           , 0 ) lor_riv_per
, NVL( SUM( caco.imp * DECODE(caco.voce,P_riv_tfr,1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(caco.voce,P_ret_tfr,1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(caco.voce,P_qta_tfr,1,0) ), 0 )
, NVL( SUM( caco.tar * DECODE(caco.voce,P_rit_tfr,1,0) ), 0 )
, NVL( SUM( caco.imp * DECODE(caco.voce,P_rit_tfr,1,0) ) , 0 )
, NVL( SUM( caco.imp * DECODE(caco.voce,P_rit_riv,1,0) ) , 0 )
, NVL( SUM( (caco.imp * -1) * DECODE(covo.somme,'OD',1,0) ), 0 )
  INTO D_lor_ord
     , D_rit_ord
     , D_lor_sep
     , D_rit_sep
     , D_lor_ap
     , D_rit_ap
     , D_lor_lor_liq
     , D_lor_acc
     , D_richiesta_ant
     , D_lor_acc_2000
     , D_rit_liq
     , D_lor_tra
     , D_rit_tra
     , D_lor_tra_fis
     , D_lor_ass
     , D_rit_ass
     , D_lor_aap
     , D_rit_aap
     , D_somme_0
     , D_somme_1
     , D_somme_2
     , D_somme_3
     , D_somme_4
     , D_somme_5
     , D_somme_6
     , D_somme_7
     , D_somme_8
     , D_somme_9
     , D_somme_10
     , D_somme_11
     , D_somme_12
     , D_somme_13
     , D_somme_14
     , D_somme_15
     , D_somme_16
     , D_somme_17
     , D_somme_18
     , D_somme_19
     , D_ipn_prev
     , D_ipn_ssn
     , D_rit_ssn
     , D_ipn_ssn_liq
     , D_rit_ssn_liq
     , D_lor_tfr_pag
     , D_lor_tfr_per
     , D_lor_riv_pag
     , D_lor_riv_per
     , D_riv_tfr
     , D_ret_tfr
     , D_qta_tfr_ac
     , D_ipn_tfr
     , D_rit_tfr
     , D_rit_riv
     , D_somme_od
  FROM VOCI_ECONOMICHE voec
     , CONTABILITA_VOCE covo
     , CALCOLI_CONTABILI caco
 WHERE voec.codice = covo.voce
   AND covo.voce = caco.voce||''
   AND covo.sub  = caco.sub
   AND caco.riferimento
       BETWEEN NVL(covo.dal,TO_DATE(2222222,'j'))
          AND NVL(covo.al ,TO_DATE(3333333,'j'))
   AND caco.ci = P_ci
     ;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
-- dbms_output.put_line('                           D_riv_tfr :'||D_riv_tfr);
-- dbms_output.put_line('                           D_rit_riv :'||D_rit_riv);
-- dbms_output.put_line('                       D_richiesta_ant :'||D_richiesta_ant);
-- dbms_output.put_line(' ---------- Primo Lor_acc  D_lor_acc :'||D_lor_acc);
  D_anticipazione := 'NO';
  D_mese_prec     := 'NO';
  if     D_richiesta_ant is not null
     and P_conguaglio   = 0  -- Testa P_conguaglio per verificare se dipendente cessato.
                             -- Nel caso viene trattato forzosamente come liquidazione.
  then D_anticipazione := 'SI';
       D_rit_riv       := 0;
	 D_rit_riv_mp    := 0;
  end if;
/* modifica del 23/03/2005 il calcolo fiscale lo eseguiamo sempre sulla base della data
                              di riferimento; gestiamo solo il caso di data nulla */
  IF D_richiesta_ant is null THEN
     D_rif_sca_tfr := P_al;
  else
     D_rif_sca_tfr := D_richiesta_ant;
  END IF;
  if   D_anticipazione = 'SI' then
       D_anno_ant      := to_char(D_richiesta_ant,'yyyy');
       D_mese_ant      := to_char(D_richiesta_ant,'mm');
       D_giorno_ant    := to_char(D_richiesta_ant,'dd');
       if D_giorno_ant <= 15      then
          if  D_mese_ant = P_mese and D_anno_ant = P_anno then
	        D_mese_prec  := 'SI';
          end if;
          select decode(d_mese_ant, 1 ,D_anno_ant - 1, D_anno_ant)
		        ,decode(d_mese_ant, 1 ,12 , D_mese_ant - 1)
                ,last_day(add_months(d_richiesta_ant,-1))
		    into D_anno_ant
			    ,D_mese_ant
                ,D_rif_sca_tfr
		    from dual
		  ;
       end if;
	   begin
    	   select max(mensilita)
    	     into D_mensilita_ant
    		 from mensilita
    		where mese = D_mese_ant
    		  and tipo = 'N'
    	   ;
	   exception when no_data_found then null;
	   end;
  end if;
-- dbms_output.put_line('   ---------   Secondo lor_ac  + D_lor_acc :'||D_lor_acc);
-- dbms_output.put_line('   ---------   Secondo lor_ac  - D_qta_tfr_ac :'||D_qta_tfr_ac);
-- dbms_output.put_line('   ---------   Secondo lor_ac  + D_rit_tfr :'||D_rit_tfr);
-- dbms_output.put_line('   ---------   Secondo lor_ac  + D_mese_prec :'||D_mese_prec);
  D_qta_tfr_mese_ant := 0;
  D_rit_tfr_mese_ant := 0;
  if D_mese_prec = 'SI'
     then
-- dbms_output.put_line('P_anno :'||P_anno);
-- dbms_output.put_line('P_mese :'||P_mese);
/* Questa parte e probabilmente un trip inutile, probabilmente dannoso. Fortunatamente non c'e mai passato nessuno
   Mauro e Annalena 18/12/2003
      if D_mese_ant <> to_number(to_char(add_months(to_date('01'||lpad(P_mese,2,'0')||'2000','ddmmyyyy'),-1),'mm'))
	    then
        begin
      	  select nvl(qta_tfr_ac,0)
      	        ,nvl(rit_tfr,0)
      		into D_qta_tfr_mese_ant
      		    ,D_rit_tfr_mese_ant
      		from movimenti_fiscali
      	   where ci = P_ci
      	     and anno = D_anno_ant
      		 and mese = D_mese_ant
      		 and mensilita = D_mensilita_ant
      	  ;
      	exception when no_data_found then
      	               D_qta_tfr_mese_ant := 0;
      				   D_rit_tfr_mese_ant := 0;
    	end;
	  end if;
*/
      D_lor_acc     := D_lor_acc - D_qta_tfr_ac + D_rit_tfr - D_qta_tfr_mese_ant + D_rit_tfr_mese_ant;
      D_riv_tfr     := 0;
      D_ret_tfr     := 0;
      D_qta_tfr_ac  := 0;
      D_ipn_tfr     := 0;
      D_rit_riv     := 0;
  end if;
-- dbms_output.put_line('   ---------   Terzo lor_ac   D_lor_acc :'||D_lor_acc);
-- dbms_output.put_line('D_qta_tfr_mese_ant :'||D_qta_tfr_mese_ant);
-- dbms_output.put_line('D_rit_tfr_mese_ant :'||D_rit_tfr_mese_ant);
-- dbms_output.put_line('D_anno_ant :'||D_anno_ant);
-- dbms_output.put_line('D_mese_ant :'||D_mese_ant);
-- dbms_output.put_line('D_giorno_ant :'||D_giorno_ant);
-- dbms_output.put_line('D_mese_prec :'||D_mese_prec);
-- dbms_output.put_line('D_mensilita_ant :'||D_mensilita_ant);
-- dbms_output.put_line('D_richiesta_ant :'||D_richiesta_ant);
-- dbms_output.put_line('P_conguaglio :'||P_conguaglio);
-- dbms_output.put_line('D_anticipazione :'||D_anticipazione);
  BEGIN  --Calcolo Imponibili
     P_stp := 'VOCI_FISC_IPT-04';
     --Calcolo Imponibili al netto contributi
     IF SIGN(D_lor_ap-D_rit_ap) = -1 THEN
        IF D_ipn_ap_mp = 0 THEN
          D_ipn_ap_neg := D_lor_ap - D_rit_ap;
          D_ipn_ap  := 0;
          D_rit_ap  := 0;
        ELSE
          D_ipn_ap_neg := D_lor_ap - D_rit_ap + D_ipn_ap_mp;
          D_ipn_ap  := GREATEST( D_lor_ap - D_rit_ap
                             , D_ipn_ap_mp * -1
                             );
        END IF;
     ELSE
        D_ipn_ap_neg := 0;
        D_ipn_ap  := D_lor_ap  - D_rit_ap;
     END IF;
     D_ipn_ord := D_lor_ord - D_rit_ord;
     D_ipn_sep := D_lor_sep - D_rit_sep;
     D_ipn_tra := D_lor_tra_fis - D_rit_tra;
     D_lor_liq := D_lor_lor_liq - D_rit_liq;
     --Calcolo Progressivi di T.F.R.
     D_fdo_tfr_ap_res := NVL(P_fdo_tfr_ap,0)    - NVL(D_fdo_tfr_ap_liq_mp,0);
     D_fdo_tfr_2000_res := NVL(P_fdo_tfr_2000,0) - NVL(D_fdo_tfr_2000_liq_mp,0);
     D_riv_tfr_ap_res := NVL(P_riv_tfr_ap,0) - NVL(D_riv_tfr_ap_liq_mp,0);
     D_riv_tfr_res    := NVL(D_riv_tfr_mp,0) - NVL(D_riv_tfr_liq_mp,0)+ NVL(D_riv_tfr,0);
     D_qta_tfr_ac_res := NVL(D_qta_tfr_ac_mp,0) - NVL(D_qta_tfr_ac_liq_mp,0)
                                         + NVL(D_qta_tfr_ac,0);
     D_rit_tfr_tot    := NVL(D_rit_tfr_mp,0)    + NVL(D_rit_tfr,0);
     D_rit_riv_tot    := NVL(D_rit_riv_mp,0)    + NVL(D_rit_riv,0);
     --Calcolo valori di comodo per il calcolo
     D_tfr_dis := D_fdo_tfr_ap_res
                + D_qta_tfr_ac_res
		+ D_fdo_tfr_2000_res --
--              + D_riv_tfr_ap_res                                                          difetto 1173
                + D_riv_tfr_ap_res  - e_round(D_riv_tfr_ap_res * .11,'I')
                + D_riv_tfr_res
                - D_rit_tfr_tot
                - D_rit_riv_tot
                - D_lor_tfr_pag
                - D_lor_riv_pag ;
     IF D_lor_tfr_per = 0 AND
        D_lor_riv_per = 0 THEN
        D_per_liq := 0;
     ELSE
        IF D_tfr_dis = 0 THEN
           D_per_liq := 1;
        ELSE
           D_per_liq := ROUND( (D_lor_tfr_per+D_lor_riv_per) / D_tfr_dis
                             , 6 );
        END IF;
     END IF;
  D_per_liq := 1;
  Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  --Totalizzazione Imponibili mese precedente + mese corrente
     IF D_ipn_ord != 0 THEN
        D_ipn_ass := D_lor_ass - D_rit_ass;
     ELSE
        D_ipn_ass := 0;
     END IF;
     P_ipn_tot_ac     := p_ipn_mp + D_ipn_ord + D_ipn_sep;
     D_somme_od_ac    := D_somme_od_mp + D_somme_od;
     P_ipn_tot_ass_ac := D_ipn_ass_mp + D_ipn_ass;
  END;
  BEGIN  -- Calcolo DEDUZIONI di IMPOSTA
     D_is_mese_conguaglio := GP4_RARE.is_mese_conguaglio(P_ci, P_fin_ela, P_tipo, P_conguaglio);
     IF GP4_RARE.get_val_conv_ded_fam(P_ci, P_fin_ela) is null
     THEN -- Gestione DETRAZIONI Fiscali Familiari
        D_voce_det_con := P_det_con;
        D_voce_det_fig := P_det_fig;
        D_voce_det_alt := P_det_alt;
     ELSE -- Gestione DEDUZIONI Fiscali Familiari
        D_voce_ded_con := P_det_con;
        D_voce_ded_fig := P_det_fig;
        D_voce_ded_alt := P_det_alt;
        D_voce_det_con := null;
        D_voce_det_fig := null;
        D_voce_det_alt := null;
     END IF;
     -- Ottiene Valori di Deduzioni Diverse Annuali
     D_mesi_deduzione := GP4_RARE.get_mesi_deduzione(P_ci, P_fin_ela);
     D_ipn_ded        := GP4_INEX.get_ipn_ded(P_ci, P_anno);
     D_ipn_ded_magg   := GP4_INEX.get_ipn_ded_magg(P_ci, P_anno);
     IF D_ipn_ded is null
     THEN
     D_ipn_tot_ded_ac     := P_ipn_tot_ac + nvl(D_ipn_ded_magg,0);                 -- 17/05/2005
     D_ipn_tot_ass_ded_ac := P_ipn_tot_ass_ac;
     D_somme_od_ded_ac    := D_somme_od_ac;
     D_ipn_ord_ded        := D_ipn_ord + nvl(D_ipn_ded_magg,0) / D_mesi_deduzione; -- 17/05/2005
     D_ipn_ass_ded        := D_ipn_ass;
     D_somme_od_ded       := D_somme_od;
       IF D_is_mese_conguaglio
       THEN
          D_ipn_tot_ded_ac     := D_ipn_tot_ded_ac + P_ipn_terzi;      -- modifica del 30/03/2005
          D_ipn_tot_ass_ded_ac := D_ipn_tot_ass_ded_ac + P_ass_terzi;  -- modifica del 30/03/2005
       END IF;
     ELSE
     D_ipn_tot_ded_ac     := D_ipn_ded;
     D_ipn_tot_ass_ded_ac := 0;
     D_somme_od_ded_ac    := 0;
     D_ipn_ord_ded        := D_ipn_ded / D_mesi_deduzione;
     D_ipn_ass_ded        := 0;
     D_somme_od_ded       := 0;
     END IF;
     D_ded_per_ac  := GP4_RARE.get_ded_per_div
                      ( P_ci, P_fin_ela
                      , D_ipn_tot_ded_ac, D_ipn_tot_ass_ded_ac, D_somme_od_ded_ac  -- modifica del 10/03/2005
                      , 'A');
     P_ded_tot_ac  := GP4_RARE.get_ded_fis_div
                      ( P_ci, P_fin_ela
                      , D_ipn_tot_ded_ac, D_ipn_tot_ass_ded_ac, D_somme_od_ded_ac  -- modifica del 10/03/2005
                      , 'A', D_is_mese_conguaglio);
     D_ded_base_ac := GP4_RARE.get_ded_fis_base
                      (P_ci, P_fin_ela
                      , D_ipn_tot_ded_ac, D_ipn_tot_ass_ded_ac, D_somme_od_ded_ac  -- modifica del 10/03/2005
                      , 'A', D_is_mese_conguaglio);
     D_ded_agg_ac  := GP4_RARE.get_ded_fis_agg
                      ( P_ci, P_fin_ela
                      , D_ipn_tot_ded_ac, D_ipn_tot_ass_ded_ac, D_somme_od_ded_ac  -- modifica del 10/03/2005
                      , 'A', D_is_mese_conguaglio);
     -- Ottiene Percentuale di Deduzioni Diverse Mensili
     D_ded_per     := GP4_RARE.get_ded_per_div
                      ( P_ci, P_fin_ela
                      , D_ipn_ord_ded, D_ipn_ass_ded, D_somme_od_ded -- modifica del 10/03/2005
                      , 'M');
     IF D_is_mese_conguaglio
           -- ( la funzione memorizza il Flag di Conguaglio sul Package GP4_RARE )
     THEN  -- Se si tratta di mese di Conguaglio Fiscale
        -- Determina Valori di Deduzioni Diverse Mensili
        D_ded_base := D_ded_base_ac - D_ded_base_mp;
        D_ded_agg  := D_ded_agg_ac  - D_ded_agg_mp;
        D_ded_fis  := D_ded_base + D_ded_agg;
       D_ded_per  := D_ded_per_ac;
     ELSE  -- Se mensilita senza Conguaglio Fiscale
        IF (D_ipn_ord_ded > 0 and p_tipo = 'N')           -- modifica del 10/03/2005
        THEN
           -- Ottiene Valori di Deduzioni Diverse Mensili
           D_ded_per  := GP4_RARE.get_ded_per_div
                         ( P_ci, P_fin_ela
                         , D_ipn_ord_ded, D_ipn_ass_ded, D_somme_od_ded -- modifica del 10/03/2005
                         , 'M');
           D_ded_fis  := GP4_RARE.get_ded_fis_div
                         ( P_ci, P_fin_ela
                         , D_ipn_ord_ded, D_ipn_ass_ded, D_somme_od_ded -- modifica del 10/03/2005
                         , 'M');
           D_ded_base := GP4_RARE.get_ded_fis_base
                         ( P_ci, P_fin_ela
                         , D_ipn_ord_ded, D_ipn_ass_ded, D_somme_od_ded -- modifica del 10/03/2005
                         , 'M');
           D_ded_agg  := GP4_RARE.get_ded_fis_agg
                         ( P_ci, P_fin_ela
                         , D_ipn_ord_ded, D_ipn_ass_ded, D_somme_od_ded -- modifica del 10/03/2005
                         , 'M');
        END IF;
     END IF;
     P_stp := 'VOCI_FISC_IPT-04.1';
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  IF GP4_RARE.get_val_conv_ded_fam(P_ci, P_fin_ela) is not null then
     BEGIN  -- Emissione voci di Deduzione Familiare
        GP4_RARE.set_ipn_ded_fis_fam(P_ci
                                    , D_ipn_ord_ded, D_somme_od_ded -- modifica del 10/03/2005
                                    , 'M');
        GP4_RARE.set_ipn_ded_fis_fam(P_ci
                                    , D_ipn_tot_ded_ac, D_somme_od_ded_ac  -- modifica del 10/03/2005
                                    , 'A');
        IF D_is_mese_conguaglio
        THEN
           D_imponibile := D_ipn_tot_ded_ac;                  -- modifica del 10/03/2005
        ELSE
           D_imponibile := D_ipn_ord_ded;                     -- modifica del 10/03/2005
        END IF;
        PECCMORE_autofam.VOCI_AUTO_FAM
        ( P_ci, P_al
        , P_anno, P_mese, P_mensilita, P_fin_ela
        , P_tipo, P_conguaglio
        , P_base_ratei, P_base_det
        , null, null, null, null
        , null
        , D_voce_ded_con, D_voce_ded_fig, D_voce_ded_alt, null, null,'E'
        , D_imponibile, null
        , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
        );
        -- Ottiene Percentuale Deduzione Mensile:
        -- ( calcolate e Memorizzate da "VOCI_AUTO_FAM" su GP4_RARE )
        GP4_RARE.LKP_ded_fis_fam( P_ci, P_fin_ela
                                , D_ded_con, D_ded_fig, D_ded_alt
                                , D_ded_per_fam, 'M');
        -- Ottiene Deduzioni Annuali:
        -- ( calcolate e Memorizzate da "VOCI_AUTO_FAM" su GP4_RARE )
        GP4_RARE.LKP_ded_fis_fam( P_ci, P_fin_ela
                                , D_ded_con_ac, D_ded_fig_ac, D_ded_alt_ac
                                , D_ded_per_fam_ac, 'A');
        -- Emissione Voci Detrazione Fiscale a Saldo per conguaglio fiscale:
        --
        -- Preleva valore progressivo precedente
        -- Preleva valore mese corrente
        -- Inserisce voce detrazione a conguaglio
        --
        IF D_is_mese_conguaglio THEN
          GP4_CACO.set_input('C');
          GP4_CACO.set_estrazione('AF');
          D_ded_per_fam := D_ded_per_fam_ac;
          IF to_char(P_al, 'mm') != P_mese THEN
             D_arr := 'C';
          END IF;
          IF D_ded_con_ac IS NOT NULL THEN  --Detrazioni CONIUGE
             D_imp_det   := GP4_CACO.get_imp(P_ci, P_det_con);
             GP4_CACO.insert_voce(P_ci, P_det_con, '*', P_al
                                 , D_ded_con_ac - D_ded_con_mp - D_imp_det
                                 , '', '', D_arr);
          END IF;
          IF D_ded_fig_ac IS NOT NULL THEN  --Detrazioni FIGLI
             D_imp_det   := GP4_CACO.get_imp(P_ci, P_det_fig);
             GP4_CACO.insert_voce(P_ci, P_det_fig, '*', P_al
                                 , D_ded_fig_ac - D_ded_fig_mp - D_imp_det
                                 , '', '', D_arr);
          END IF;
          IF D_ded_alt_ac IS NOT NULL THEN  --Detrazioni ALTRI
             D_imp_det   := GP4_CACO.get_imp(P_ci, P_det_alt);
             GP4_CACO.insert_voce(P_ci, P_det_alt, '*', P_al
                                 , D_ded_alt_ac - D_ded_alt_mp - D_imp_det
                                 , '', '', D_arr);
          END IF;
        END IF;
        -- Sovrascrive valori teorici estratti da LKP
        -- con il valore effettivamente emesso nel mese
        D_ded_con := GP4_CACO.get_imp(P_ci, D_voce_ded_con);
        D_ded_fig := GP4_CACO.get_imp(P_ci, D_voce_ded_fig);
        D_ded_alt := GP4_CACO.get_imp(P_ci, D_voce_ded_alt);
        -- Aggiunge Deduzioni Familiari a Deduzioni Diverse
        D_ded_fis := D_ded_fis + D_ded_con + D_ded_fig + D_ded_alt;
        P_ded_tot_ac := P_ded_tot_ac + D_ded_con_ac + D_ded_fig_ac + D_ded_alt_ac;
        P_stp := 'VOCI_FISC_IPT-04.2';
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF;
  /* Revisione 1.1
     Fino alla 1.0 la lettura veniva eseguita alla data P_fin_ela (errato) e solo nel caso
     fosse falsa la condizione (d_ipn_ord > 0 and p_tipo = 'N')
  */
-- 29/03/2005 spostato avanti
--  P_ded_tot_ac := nvl(D_ded_fis,0) + D_ded_tot_mp;
  P_ded_fis_ac := greatest(0,least(nvl(D_ded_fis,0),d_ipn_ord)) + d_ded_fis_mp;
  IF D_ipn_ord > 0 THEN
     BEGIN  --Calcolo Aliquota e Imposta Ordinaria
        P_stp := 'VOCI_FISC_IPT-05';
        SELECT DECODE( P_perc_irpef_ord
                     , NULL, scfi.aliquota
                           , P_perc_irpef_ord
                     )
             , DECODE( P_perc_irpef_ord
                     , NULL, ( ( ( GREATEST(D_ipn_ord - nvl(d_ded_fis,0),0)
                                 * P_mesi_irpef - scfi.scaglione
                                 ) * scfi.aliquota / 100 + scfi.imposta
                               ) / P_mesi_irpef
                             )
                           , ( GREATEST(D_ipn_ord - nvl(d_ded_fis,0),0)
                             * P_perc_irpef_ord / 100
                             )
                    )
          INTO D_alq_ord
             , D_ipt_ord
          FROM SCAGLIONI_FISCALI scfi
         WHERE scfi.scaglione =
              (SELECT MAX(scaglione)
                 FROM SCAGLIONI_FISCALI
                WHERE scaglione <= GREATEST(D_ipn_ord - nvl(d_ded_fis,0),0)  *P_mesi_irpef
                  AND P_fin_ela BETWEEN dal and NVL(al ,TO_DATE(3333333,'j'))
              )
           AND P_fin_ela BETWEEN scfi.dal and NVL(scfi.al ,TO_DATE(3333333,'j'))
        ;
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
           D_alq_ord := 0;
           D_ipt_ord := 0;
     END;
  ELSE
         D_alq_ord := 0;
         D_ipt_ord := 0;
  END IF;
/* Modifica del 23/12/2004 - spostata la determinazione dell'imponibile D_ipn_ass */
  IF D_ipn_ord != 0 THEN
     D_ipt_ass := E_Round( D_ipn_ass * D_ipt_ord / D_ipn_ord,'I');
  ELSE
     D_ipt_ass := 0;
  END IF;
  IF D_ipn_sep > 0 THEN
     BEGIN  --Calcolo Aliquota e Imposta Separata
        P_stp := 'VOCI_FISC_IPT-06';
        SELECT DECODE( P_perc_irpef_sep
                   , 1, decode( GREATEST(D_alq_ord_mp,D_alq_sep_mp,D_alq_ord)
                               ,0,scfi.aliquota,GREATEST(D_alq_ord_mp,D_alq_sep_mp,D_alq_ord))
                   , 2, GREATEST(D_alq_ord_max,D_alq_ord)
                      , NVL(P_perc_irpef_sep,scfi.aliquota)
                   )
            , DECODE( P_perc_irpef_sep
                   , NULL, ( ( ( GREATEST(D_ipn_sep,0)
                             * P_mesi_irpef - scfi.scaglione
                             ) * scfi.aliquota / 100 + scfi.imposta
                            ) / P_mesi_irpef
                          )
                        , GREATEST(D_ipn_sep,0)
                        * DECODE( P_perc_irpef_sep
                               , 1, decode( GREATEST(D_alq_ord_mp,D_alq_sep_mp,D_alq_ord)
                                           ,0,scfi.aliquota,GREATEST(D_alq_ord_mp,D_alq_sep_mp,D_alq_ord))
                               , 2, GREATEST(D_alq_ord_max,D_alq_ord)
                                  , P_perc_irpef_sep
                               ) / 100
                   )
         INTO D_alq_sep
            , D_ipt_sep
         FROM SCAGLIONI_FISCALI scfi
        WHERE scfi.scaglione =
             (SELECT MAX(scaglione)
               FROM SCAGLIONI_FISCALI
               WHERE scaglione <= GREATEST(D_ipn_sep,0)*P_mesi_irpef
                AND P_fin_ela BETWEEN dal
                                AND NVL(al ,TO_DATE(3333333,'j'))
             )
          AND P_fin_ela BETWEEN scfi.dal
                          AND NVL(scfi.al ,TO_DATE(3333333,'j'))
        ;
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
            D_alq_sep := 0;
            D_ipt_sep := 0;
     END;
  ELSE
     D_alq_sep := 0;
     D_ipt_sep := 0;
  END IF;
  IF  D_ipn_ap != 0
  OR  NVL( P_effe_cong, ' ' )        = 'M'
  OR  NVL( P_effe_cong, P_scad_cong ) = 'M'
  AND P_mese  = 12
  AND P_tipo IN ( 'S', 'N' )
  THEN
     --Attivazione in caso di imponibile nel mese o di richiesta di
     --conguaglio a scadenza Mensile
     BEGIN  --Calcolo Aliquota e Imposta Anni Precedenti
           --con ricalcolo Imposta alla ultima Aliquota applicata
        P_stp := 'VOCI_FISC_IPT-07';
        SELECT NVL(P_alq_ap,scfi.aliquota)
            , ( (D_ipn_ap + D_ipn_ap_mp)
              * NVL(P_alq_ap,scfi.aliquota) / 100
              ) - D_ipt_ap_mp
         INTO D_alq_ap
            , D_ipt_ap
         FROM SCAGLIONI_FISCALI scfi
        WHERE scfi.scaglione = 0
          AND ADD_MONTHS(P_fin_ela,DECODE(P_anno,1998,-12,1999,-24,2003,-12,2004,-24,0))
              BETWEEN scfi.dal
                 AND NVL(scfi.al ,TO_DATE(3333333,'j'))
        ;
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
            D_alq_ap := NVL(P_alq_ap,0);
            D_ipt_ap := 0;
     END;
  ELSE
     D_alq_ap := D_alq_ap_mp;
     D_ipt_ap := 0;
  END IF;
  IF D_ipn_ap != 0 THEN
     D_ipn_aap := D_lor_aap - D_rit_aap;
     D_ipt_aap := E_Round( D_ipn_aap * D_ipt_ap / D_ipn_ap,'I');
  ELSE
     D_ipn_aap := 0;
     D_ipt_aap := 0;
  END IF;
  IF D_ipn_ap_neg < 0 THEN
     D_ipn_ord := D_ipn_ord + D_ipn_ap_neg;
     D_somme_8 := D_ipn_ap_neg * -1;
  END IF;
-- spostata avanti la lettura delle rid. TFR; sostituta P_al con D_rif_sca_tfr
  BEGIN
    select riduzioni_tfr,detrazioni_tfr
      into d_riduzioni_tfr,d_detrazioni_tfr
      from validita_fiscale
     where D_rif_sca_tfr BETWEEN dal
                      AND NVL(al ,TO_DATE(3333333,'j'))
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      d_riduzioni_tfr := 0;
      d_detrazioni_tfr := 0;
  END;
  IF  D_lor_liq != 0
  OR  D_lor_acc != 0
  OR  D_lor_acc_2000 != 0
  THEN
     --Attivazione in caso di lordo nel mese
     BEGIN  --Calcolo Imponibile Aliquota e Imposta Liquidazione
        P_stp := 'VOCI_FISC_IPT-08';
-- dbms_output.put_line('d_riduzioni_tfr '||d_riduzioni_tfr);
        d_riduzione := d_riduzioni_tfr;
/*
        --  Calcolo Riduzione su Liquidazione
        IF P_al < TO_DATE('31121997','ddmmyyyy') THEN
          D_riduzione := 258.23;
        ELSIF Valuta = 'L' THEN
          D_riduzione := 600000;
        ELSE D_riduzione := 309.87;
     END IF;
*/
        D_gg_anz_tp_2000 := P_gg_anz_t_2000 - P_gg_anz_i_2000;
        D_gg_anz_tp := D_gg_anz_t_mp - D_gg_anz_i_mp
                   + D_gg_anz_t    - D_gg_anz_i;
/*
 * Calcolo abbattimento dell'imponibile
 * solo per le liquidazioni e non per le anticipazioni
 */
/* Impostazione piu recente: anticipazione senza abbattimento.....
      IF  D_lor_acc != 0  THEN
        D_rid_liq := NVL( P_rid_tfr
                        , E_Round( D_riduzione / 12 * GREATEST(0,CEIL( ((  P_gg_anz_t_2000
                                                 ) / 30) - 0.5))
                               ,'I')
                        );
     ELSE
        IF D_rit_riv_tot  = 0 THEN
           D_rid_liq := NVL( P_rid_tfr
                           , E_Round( D_riduzione / 12 * GREATEST(0,CEIL( ((  P_gg_anz_t_2000
                                                    ) / 30) - 0.5))
                                  ,'I')
                           );
        ELSE
          D_rid_liq := D_riv_tfr_res - D_rit_riv_tot; --D_rid_liq := D_riv_tfr - D_rit_riv_tot;
        END IF;
     END IF;
     IF D_lor_acc != 0 AND D_lor_acc_2000 = 0 THEN
	D_rid_liq := 0;
     END IF;
*/
/* vecchia impostazione, buona solo per il privato. WMM 14/12/2001 */
-- dbms_output.put_line('D_lor_acc '||D_lor_acc);
-- dbms_output.put_line('D_lor_acc_2000 '||D_lor_acc_2000);
-- dbms_output.put_line('D_rit_riv_tot '||D_rit_riv_tot);
-- dbms_output.put_line('P_rid_tfr '||P_rid_tfr);
-- dbms_output.put_line('Percorso 1       '||D_rid_liq);
-- dbms_output.put_line('D_riduzione '||D_riduzione);
      if D_tfr_pubblico = 'NO' -- indipendentemente dal che l'ente sia pubblico o meno,
                               -- applica comunque e sempre questo calcolo,
                               -- senza passare negli
                               -- altri rami: E' probabile che le condizioni sul valore
                               -- di D_tfr_pubblico
                               -- siano state inibite in una fase successiva senza
                               -- completare il lavoro di pulizia
     then
-- dbms_output.put_line('Percorso 2       '||D_rid_liq);
           D_rid_liq := NVL( P_rid_tfr
                           , E_Round( D_riduzione / 12 * GREATEST(0,CEIL( ((  P_gg_anz_i_2000
                                                    ) / 30) - 0.5))
                                  ,'I')
                           );
-- dbms_output.put_line('D_riduzione '||D_riduzione);
-- dbms_output.put_line('P_gg_anz_t_2000 '||P_gg_anz_t_2000);
      else
           IF  D_lor_acc != 0  THEN
-- dbms_output.put_line('Percorso 3       '||D_rid_liq);
               D_rid_liq := NVL( P_rid_tfr
                               , E_Round( D_riduzione / 12 * GREATEST(0,CEIL( ((  P_gg_anz_i_2000
                                                                      ) / 30) - 0.5))
                                         ,'I')
                               );
           ELSE
             IF D_rit_riv_tot  = 0 THEN
-- dbms_output.put_line('Percorso 4       '||D_rid_liq);
                D_rid_liq := NVL( P_rid_tfr
                                , E_Round( D_riduzione / 12 * GREATEST(0,CEIL( ((  P_gg_anz_i_2000
                                                         ) / 30) - 0.5))
                                         ,'I')
                                );
             ELSE
-- dbms_output.put_line('Percorso 5       '||D_rid_liq);
                D_rid_liq := D_riv_tfr_res - D_rit_riv_tot; --D_rid_liq := D_riv_tfr - D_rit_riv_tot;
             END IF;
           END IF;
           IF D_lor_acc != 0 AND D_lor_acc_2000 = 0 THEN
-- dbms_output.put_line('Percorso 6       '||D_rid_liq);
             D_rid_liq := 0;
           END IF;
      END IF;
-- dbms_output.put_line('Abbattimento: D_rid_liq '||D_rid_liq);
-- dbms_output.put_line('Abbattimento: D_tfr_pubblico '||D_tfr_pubblico);
-- dbms_output.put_line('Abbattimento: D_lor_acc '||D_lor_acc);
-- dbms_output.put_line('Abbattimento: P_rid_tfr '||P_rid_tfr);
-- dbms_output.put_line('Abbattimento: D_riduzione '||D_riduzione);
-- dbms_output.put_line('Abbattimento: (1) D_rid_liq '||D_rid_liq);
-- dbms_output.put_line('Abbattimento: P_gg_anz_t_2000 '||P_gg_anz_t_2000);
-- dbms_output.put_line('Abbattimento: D_rit_riv_tot '||D_rit_riv_tot);
-- dbms_output.put_line('Abbattimento: D_lor_acc_2000 '||D_lor_acc_2000);
-- dbms_output.put_line('----');
-- dbms_output.put_line('Abbattimento: D_riv_tfr_res '||D_riv_tfr_res);
-- dbms_output.put_line('Abbattimento: D_rit_riv_tot '||D_rit_riv_tot);
	 /* Prelevo dalle informazioni retributive il valore della riduzione dell'abbattimento
	    dovuto ai fondi integrativi
	 */
	 D_rid_fondi := 0;
	 begin
	   select (  (d_riduzione * 13.5 / 100) * inre.tariffa ) / 12
                *  months_between( to_date('31122000','ddmmyyyy'),inre.dal-1 )
	     into D_rid_fondi
		 from informazioni_retributive inre
		where ci    = P_ci
		  and voce in (select codice from voci_economiche where specifica = 'RID_FONDI')
		  and D_richiesta_ant between nvl(inre.dal, to_date(2222222,'j'))
		                          and nvl(inre.al , to_date(3333333,'j'))
              and inre.dal < to_date('31122000','ddmmyyyy')
	   ;
	 exception when no_data_found then
		 	     D_rid_fondi := 0;
     end;
-- dbms_output.put_line('Abbattimento: (1.1) D_rid_liq '||D_rid_liq);
     D_rid_liq := D_rid_liq - nvl(D_rid_fondi,0);
-- dbms_output.put_line('Abbattimento: (2) D_rid_liq '||D_rid_liq);
-- termine vecchia impostazione
        IF P_rid_rid_tfr != 0 THEN
          D_rtp_liq := P_rid_rid_tfr;
        ELSIF D_gg_anz_tp_2000 != 0 THEN
          D_rtp_liq := E_Round(  D_riduzione / 12
                              * ( GREATEST(0,CEIL( ( ( P_gg_anz_t_2000
                                         ) / 30) - 0.5
                                       ))
                                - GREATEST(0,CEIL( (( P_gg_anz_i_2000
                                                   ) / 30) - 0.5
                                       ))
                                )
                            * (  P_gg_anz_r_2000 /  D_gg_anz_tp_2000
                              )
                           ,'I' );
        ELSE
          D_rtp_liq := 0;
        END IF;
        BEGIN  -- Calcolo Detrazioni su Liquidazione
        BEGIN
        SELECT d_detrazioni_tfr*2
          INTO D_detrazione
           FROM POSIZIONI
          WHERE codice = (SELECT posizione FROM PERIODI_RETRIBUTIVI
                           WHERE ci = P_ci
                             AND periodo = P_fin_ela
                             AND competenza = 'A'
                         )
            AND NVL(tipo_determinato,'NO') = 'SI'
        ;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
          SELECT d_detrazioni_tfr
           INTO D_detrazione
           FROM dual
         ;
        END;
        D_det_liq := E_Round( D_detrazione / 12
                             * GREATEST(0,CEIL( ((  D_gg_anz_i
                                                  + D_gg_anz_i_mp
                                                  - P_gg_anz_i_2000
                                                 ) / 30) - 0.5))
                               ,'I')
                        ;
--        IF D_gg_anz_tp != 0 THEN
        IF D_gg_anz_tp != 0 AND D_gg_anz_tp - D_gg_anz_tp_2000 <> 0 THEN
           D_dtp_liq := E_Round(  D_detrazione / 12
                               * ( GREATEST(0,CEIL( ( ( D_gg_anz_t
                                                      + D_gg_anz_t_mp
                                                      - P_gg_anz_t_2000
                                          ) / 30) - 0.5
                                        ))
                                 - GREATEST(0,CEIL( (( D_gg_anz_i
                                                     + D_gg_anz_i_mp
                                                     - P_gg_anz_i_2000
                                                    ) / 30) - 0.5
                                        ))
                                 )
                                    * (  (D_gg_anz_r + D_gg_anz_r_mp- P_gg_anz_r_2000)
                                      /  (D_gg_anz_tp - D_gg_anz_tp_2000)
                                      )
                                   ,'I' );
        ELSE
           D_dtp_liq := 0;
        END IF;
        END;
        BEGIN  --Calcolo Imponibile TOTALE di Liquidazione
              --per il calcolo del reddito di riferimento e degli
              --abbattimenti,
              --se prevista considera solo la voce LOR_ACC
              --altrimenti considera solo la voce LOR_LIQ
             D_ipn_liq_2000:= P_ant_acc_2000 + D_lor_acc_2000 +
                              D_lor_acc_2000_mp;
             D_ipn_liq_ac  := P_ant_acc_ap + D_lor_acc + D_lor_acc_mp;
             D_ipn_liq     := P_ant_acc_ap + D_lor_acc + D_lor_acc_mp +
                              P_ant_acc_2000 + D_lor_acc_2000 +
                              D_lor_acc_2000_mp;
             D_ipn_liq_res := P_ant_liq_ap + D_lor_liq + D_lor_liq_mp;
-- dbms_output.put_line('+++++++++++++++++++++++++++++++++');
-- dbms_output.put_line('P_ant_acc_ap '||P_ant_acc_ap);
-- dbms_output.put_line('D_lor_acc '||D_lor_acc);
-- dbms_output.put_line('D_lor_acc_mp '||D_lor_acc_mp);
-- dbms_output.put_line('P_ant_acc_2000 '||P_ant_acc_2000);
-- dbms_output.put_line('D_lor_acc_2000 '||D_lor_acc_2000);
-- dbms_output.put_line('D_lor_acc_2000_mp '||D_lor_acc_2000_mp);
-- dbms_output.put_line('+++++++++++++++++++++++++++++++++');
-- dbms_output.put_line('D_ipn_liq_ac '||D_ipn_liq_ac);
-- dbms_output.put_line('P_gg_anz_c '||P_gg_anz_c);
-- dbms_output.put_line('D_gg_anz_t_mp '||D_gg_anz_t_mp);
-- dbms_output.put_line('D_gg_anz_t '||D_gg_anz_t);
-- dbms_output.put_line('+++++++++++++++++++++++++++++++++');
          IF P_cal_anz = 'FRR' THEN
             D_ratei_anz := TRUNC( ROUND( ( P_gg_anz_c
--                                      + P_gg_anz_t_2000
                                      + D_gg_anz_t_mp
                                      + D_gg_anz_t
                                      ) / 30
                                    ) / 12
                              , 3
                              );
             IF D_ratei_anz = 0 THEN
               D_ratei_anz := 1;
             END IF;
          ELSE
             D_ratei_anz := GREATEST( 1
                                 , TRUNC( ROUND( ( P_gg_anz_c
--                                               + P_gg_anz_t_2000
                                               + D_gg_anz_t_mp
                                               + D_gg_anz_t
                                               ) / 30
                                             ) / 12
                                       , 3
                                       )
                                 );
          END IF;
        END;
-- dbms_output.put_line('P_gg_anz_c '||P_gg_anz_c);
-- dbms_output.put_line('D_gg_anz_t_mp '||D_gg_anz_t_mp);
-- dbms_output.put_line('D_gg_anz_t '||D_gg_anz_t);
-- dbms_output.put_line('D_richiesta_ant '||D_richiesta_ant);
-- dbms_output.put_line('D_anno_ant '||D_anno_ant);
-- dbms_output.put_line('D_mese_ant '||D_mese_ant);
-- dbms_output.put_line('D_mensilita_ant '||D_mensilita_ant);
-- dbms_output.put_line('D_lor_acc '||D_lor_acc);
-- dbms_output.put_line('D_rit_tfr --'||D_rit_tfr);
-- dbms_output.put_line('D_ratei_anz --'||D_ratei_anz);
/* Distinzione tra anticipazione, liquidazione e tfr pubblico */
      D_rit_tfr_mese := nvl(D_rit_tfr,0);
      D_qta_tfr_ac_mese := nvl(D_qta_tfr_ac,0);
-- dbms_output.put_line('**************************************************************');
-- dbms_output.put_line('D_qta_tfr_ac '||D_qta_tfr_ac);
      IF  D_anticipazione = 'SI'  THEN
       D_ratei_anz_app := D_ratei_anz;
/* modifica del 23/03/2005 aggiunte nvl perche la funzione di gruppo non esce mai per no data found */
       BEGIN
        select nvl(greatest(1,round(sum(gg_anz_t)/12/30,3)),D_ratei_anz_app)
		      ,nvl(sum(qta_tfr_ac),0)
			  ,nvl(sum(rit_tfr),0)
			  ,nvl(sum(fdo_tfr_ap),0)
			  ,0
			  ,0
/* fine modifica del 23/03/2005 */
          into D_ratei_anz
		      ,D_qta_tfr_ac
			  ,D_rit_tfr
			  ,D_fdo_tfr_ap_ant
			  ,D_qta_tfr_ac_mp
			  ,D_rit_tfr_mp
          from progressivi_fiscali
         where ci = P_ci
           and anno      = D_anno_ant
           and mese      = D_mese_ant
           and mensilita = D_mensilita_ant
        ;
       EXCEPTION when no_data_found or too_many_rows then D_ratei_anz := D_ratei_anz_app;
                 --ripristina il valore della D_ratei_anz nel caso non sia presente il progressivo fiscale
                 -- alla data di riferimento della voce (caso Potenza...)
       END;
       D_tfr_totale := D_fdo_tfr_ap_ant + P_fdo_tfr_2000 +
                       P_ant_acc_ap + P_ant_acc_2000 +
                       D_qta_tfr_ac + D_qta_tfr_ac_mp -
                       D_rit_tfr - D_rit_tfr_mp;
     else
       D_tfr_totale := P_fdo_tfr_ap + P_fdo_tfr_2000 +
                       P_ant_acc_ap + P_ant_acc_2000 +
                       D_qta_tfr_ac + D_qta_tfr_ac_mp -
                       D_rit_tfr - D_rit_tfr_mp;
     END IF;
-- dbms_output.put_line('Anzianita D_ratei_anz '||D_ratei_anz);
-- dbms_output.put_line('   ***   Dopo Mese Precedente   ***');
-- dbms_output.put_line('Primo D_tfr_totale --'||D_tfr_totale);
-- dbms_output.put_line('D_rit_riv_tot --'||D_rit_riv_tot);
-- dbms_output.put_line('D_rit_tfr --'||D_rit_tfr);
/*
       IF D_rit_riv_tot  = 0 THEN
          D_tfr_totale :=   D_lor_acc_2000 +
                            P_fdo_tfr_ap + P_fdo_tfr_2000 - (D_riv_tfr - D_rit_riv_tot);
        ELSE
         D_tfr_totale :=   P_fdo_tfr_ap + P_fdo_tfr_2000 - (D_riv_tfr - D_rit_riv_tot);
        END IF;
*/
-- dbms_output.put_line('---  TFR Totale per reddito riferimento  ---');
-- dbms_output.put_line('P_fdo_tfr_ap --'||P_fdo_tfr_ap);
-- dbms_output.put_line('P_fdo_tfr_2000 --'||P_fdo_tfr_2000);
-- dbms_output.put_line('P_ant_acc_ap --'||P_ant_acc_ap);
-- dbms_output.put_line('P_ant_acc_2000 --'||P_ant_acc_2000);
-- dbms_output.put_line('D_qta_tfr_ac --'||D_qta_tfr_ac);
-- dbms_output.put_line('D_qta_tfr_ac_mp --'||D_qta_tfr_ac_mp);
-- dbms_output.put_line('D_rit_tfr --'||D_rit_tfr);
-- dbms_output.put_line('D_rit_tfr_mp --'||D_rit_tfr_mp);
-- dbms_output.put_line('---  TFR Totale per reddito riferimento  ---');
	 D_tfr_fondi := 0;
	 if D_anticipazione = 'NO' then
    	 begin
    	   select sum(imp)
    	     into D_tfr_fondi
    	     from movimenti_contabili moco
            where moco.ci = P_ci
              and voce in (select codice from voci_economiche
    		                where specifica = 'FONDI_TFR'
    					  )
           ;
    	 exception when no_data_found then
    	   D_tfr_fondi := 0;
    	 end;
    	 begin
    	   select D_tfr_fondi + sum(imp)
    	     into D_tfr_fondi
    	     from calcoli_contabili caco
            where caco.ci = P_ci
              and voce in (select codice from voci_economiche
    		                where specifica = 'FONDI_TFR'
    					  )
           ;
    	 exception when no_data_found then
    	   null;
    	 end;
	 else
	     begin
		   D_tfr_fondi := fondi_tfr_progressivi(P_ci,d_anno_ant,d_mese_ant);
		 exception when no_data_found then
		   D_tfr_fondi := 0;
		 end;
	 end if;
-- dbms_output.put_line('D_tfr_fondi --'||D_tfr_fondi);
-- dbms_output.put_line('P_perc_irpef_liq --'||P_perc_irpef_liq);
/* modifica del 23/03/2005 sostituito con inizializzazione precdente */
--     IF D_anticipazione <> 'SI' then
--        D_rif_sca_tfr := P_al;
--     END IF;
     D_tfr_totale := D_tfr_totale + nvl(D_tfr_fondi,0);
	 Peccmore12.VOCI_FISC_LIQ  --Calcolo Aliquota e Imposta Liquidazione
          ( P_ci, D_rif_sca_tfr, P_anno, P_mese, P_mensilita, P_fin_ela
                , D_tfr_totale, D_ipn_liq, D_ratei_anz
                , D_rid_liq, D_rtp_liq, D_ipn_liq_res
                , D_ipt_liq_mp, P_ipt_liq_ap
                , D_alq_liq_mp
                , P_perc_irpef_liq
                , D_alq_liq , D_ipt_liq
                , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
          );
-- dbms_output.put_line('***  Calcolo Imposta  ***');
-- dbms_output.put_line('D_rif_sca_tfr '||D_rif_sca_tfr );
-- dbms_output.put_line('D_alq_liq '||D_alq_liq );
-- dbms_output.put_line('D_ipt_liq '||D_ipt_liq );
-- dbms_output.put_line('P_ipt_liq_ap '||P_ipt_liq_ap );
-- dbms_output.put_line('D_ipn_liq_res '||D_ipn_liq_res );
-- dbms_output.put_line('D_ipn_liq_2000 '||D_ipn_liq_2000);
-- dbms_output.put_line('D_ipn_liq_ac '||D_ipn_liq_ac);
-- dbms_output.put_line('D_ipn_liq '||D_ipn_liq);
-- dbms_output.put_line('D_rid_liq '||D_rid_liq);
-- dbms_output.put_line('D_rid_liq_mp '||D_rid_liq_mp);
-- dbms_output.put_line('D_rtp_liq '||D_rtp_liq);
-- dbms_output.put_line('D_rtp_liq_mp '||D_rtp_liq_mp);
-- dbms_output.put_line('---------------------------------------');
       BEGIN  -- Riduzione al valore di incremento mensile
          IF D_ipn_liq_2000 > (D_rid_liq + D_rtp_liq) THEN
             D_rtp_liq := D_rtp_liq - D_rtp_liq_mp;
          ELSE
/* modifica del 23/03/2005 aggiunto greatest con zero per gestire il caso di lordo mag. delle sole rid. intere */
             D_rtp_liq := Greatest(0,LEAST( D_ipn_liq_2000
                                          , D_rid_liq + D_rtp_liq
                                          ) - D_rid_liq
                                  );
          END IF;
-- dbms_output.put_line(' ---  Esposizione Imponibile --- ');
-- dbms_output.put_line('D_ipn_liq '||D_ipn_liq);
-- dbms_output.put_line('D_ipn_liq_mp '||D_ipn_liq_mp);
-- dbms_output.put_line('D_rid_liq '||D_rid_liq);
-- dbms_output.put_line('D_rid_liq_mp '||D_rid_liq_mp);
-- dbms_output.put_line('D_rtp_liq_mp '||D_rtp_liq_mp);
-- dbms_output.put_line('D_rtp_liq '||D_rtp_liq);
-- dbms_output.put_line('D_ipn_liq_res '||D_ipn_liq_res);
-- dbms_output.put_line('D_ipn_liq_tot '||D_ipn_liq_tot);
		  select GREATEST( D_ipn_liq - nvl(D_rid_liq,0) - nvl(D_rtp_liq,0)
                             , 0
                             ) + D_ipn_liq_res - D_ipn_liq_tot --+ D_ipn_liq_mp        --   - D_ipn_liq_mp
			into D_ipn_liq
			from dual
		  ;
        END;
        if   D_anticipazione = 'SI'
        then D_det_liq := 0;
             D_dtp_liq :=0;
        end if;
        BEGIN  -- Detrazioni al valore di incremento mensile
           D_ipt_liq_ac := E_Round(D_ipn_liq_ac * D_alq_liq / 100,'I');
           IF D_ipt_liq_ac > (D_det_liq + D_dtp_liq) THEN
              D_det_liq := D_det_liq - D_det_liq_mp;
              D_dtp_liq := D_dtp_liq - D_dtp_liq_mp;
-- dbms_output.put_line('                         Detrazione caso 1 '||D_det_liq);
           ELSE
              D_det_liq := GREATEST( 0
                                   , LEAST( D_ipt_liq_ac
                                          , D_det_liq + D_dtp_liq
                                          ) - D_det_liq_mp);
              D_dtp_liq := LEAST( D_ipt_liq_ac
                                , D_det_liq + D_dtp_liq
                                ) - D_det_liq;
-- dbms_output.put_line('                         Detrazione caso 2 '||D_det_liq);
           END IF;
        END;
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
    END;
  ELSE
     D_rid_liq := 0;
     D_rtp_liq := 0;
     D_ipn_liq := 0;
     D_alq_liq := D_alq_liq_mp;
     D_ipt_liq := 0;
  END IF;
-- dbms_output.put_line('Quota del mese D_qta_tfr_ac '||D_qta_tfr_ac);
  BEGIN  --Calcolo Liquidato T.F.R.
     P_stp := 'VOCI_FISC_IPT-09';
  if d_richiesta_ant is null
     then D_per_liq := 0;
  end if;
  if d_richiesta_ant is null
     then D_qta_tfr_ac_liq := 0;
  elsif D_anticipazione = 'SI'
     then D_qta_tfr_ac_liq := 0;
  else  D_qta_tfr_ac_liq := E_round(D_qta_tfr_ac_res,'I') - E_round(D_rit_tfr_tot,'I');
  end if;
     D_fdo_tfr_ap_liq := E_Round(D_lor_acc,'I') - e_round(D_qta_tfr_ac_liq,'I');
     D_fdo_tfr_2000_liq := D_lor_acc_2000;
	 if nvl(D_lor_riv_per,0) <> 0 then
        D_riv_tfr_ap_liq := E_Round(D_lor_riv_pag + D_riv_tfr_ap_res * D_per_liq,'I');
        D_riv_tfr_liq    := E_Round(D_lor_riv_per,'I') - E_Round(D_riv_tfr_ap_liq,'I');
	 else
        D_riv_tfr_ap_liq := 0;
        D_riv_tfr_liq    := 0;
	 end if;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  --Totalizzazione Imposta mese precedente + mese corrente
/* Eliminazione del 23/12/2004
 *  Totalizzazione Imponibili
 *  trasferita  prima del calcolo Deduzioni
--     P_ipn_tot_ac := p_ipn_mp + D_ipn_ord + D_ipn_sep;
--     P_somme_od_ac := D_somme_od_mp + D_somme_od;
--     P_ipn_tot_ass_ac := D_ipn_ass_mp + D_ipn_ass;
 */
     P_ipt_tot_ac := D_ipt_mp + D_ipt_ord + D_ipt_sep;
     P_ipt_tot_ass_ac := D_ipt_ass_mp + D_ipt_ass;
  END;
  Peccmore12.VOCI_FISC_DET  --Assestamento Detrazioni Fiscali di Imposta
     ( P_ci, P_ci_lav_pr, P_al
          , P_anno, P_mese, P_mensilita, P_fin_ela
          , P_tipo, P_conguaglio
          , P_base_ratei, P_base_det
          , P_mesi_irpef, P_base_cong
          , P_scad_cong, P_rest_cong, P_effe_cong
          , P_rate_addizionali, P_detrazioni_ap
          , P_spese, P_tipo_spese, P_ulteriori, P_tipo_ulteriori
          , P_gg_lav_ac, P_gg_det_ac
          , D_ipn_tot_ded_ac, P_ipt_tot_ac, P_ipn_terzi, P_ass_terzi
          , D_imp_det_fis
          , D_imp_det_con, D_imp_det_fig, D_imp_det_alt
          , D_imp_det_spe, D_det_spe_ac, D_imp_det_ult
          , D_voce_det_con, D_voce_det_fig, D_voce_det_alt, P_det_spe, P_det_ult
          , D_ipn_ord_ded
          , P_ipn_tot_ass_ac, D_ipn_ass, D_somme_od, D_somme_od_ac
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  BEGIN  --Calcolo Detrazione Fiscale Annuale Totale
     D_val_conv_det := gp4_defi.get_val_conv_det_fam(P_fin_ela);
     D_imp_det_god := LEAST( D_imp_det_fis
                         , greatest(D_ipt_ord + D_ipt_sep - D_ipt_ass,0));
/* modifica 15/01/2007 */
     IF D_val_conv_det is not null
     THEN -- ridetermina le detrazioni godute sulla base dell'intera imposta
     dbms_output.put_line('D_imp_det_fis '||D_imp_det_fis||' D_ipt_ord '||D_ipt_ord||' D_ipt_sep '||D_ipt_sep);
       IF P_conguaglio = 0 and nvl(P_effe_cong,' ') != 'M' THEN
          D_imp_det_god := LEAST( D_imp_det_fis
                                , greatest(D_ipt_ord + D_ipt_sep ,0));
          ELSE
          D_imp_det_god := LEAST( D_imp_det_fis
                                , greatest(nvl(P_ipt_tot_ac,0)-nvl(D_det_god_mp,0)
                                          ,0)
                                );
       END IF;
     END IF;
/* fine modifica 15/01/2007 */
     P_det_fis_ac  := D_det_fis_mp  + D_imp_det_fis;
/* modifica del 05/01/2007 */
     IF D_val_conv_det is not null
     THEN -- trattamento detrazioni Finanziaria 2007:
          -- Ottiene le Detrazioni Annuali
          -- calcolate e Memorizzate da "VOCI_AUTO_FAM" su GP4_RARE
        GP4_RARE.LKP_det_fis_fam( P_ci, P_fin_ela
                                , D_det_con_ac, D_det_fc_ac, D_det_ft_ac, D_det_fig_ac, D_det_alt_ac
                                );
       P_det_con_ac  := nvl(D_det_con_ac,0);
-- dbms_output.put_line('***D_det_ft_ac '||D_det_ft_ac||'D_Det_fc_ac '||D_Det_fc_ac);
       P_det_fig_ac  := nvl(D_det_fig_ac,0) -
                        nvl(D_det_ft_ac,0)  +
                        greatest(nvl(D_det_ft_ac,0),nvl(D_Det_fc_ac,0));
       P_det_alt_ac  := nvl(D_det_alt_ac,0);
       P_det_spe_ac  := nvl(D_det_spe_ac,0);
     ELSE -- trattamento vecchie detrazioni e deduzioni fiscali
/* fine modifica del 05/01/2007 */
       P_det_con_ac  := D_det_con_mp  + D_imp_det_con;
       P_det_fig_ac  := D_det_fig_mp  + D_imp_det_fig;
       P_det_alt_ac  := D_det_alt_mp  + D_imp_det_alt;
       P_det_spe_ac  := D_det_spe_mp  + D_imp_det_spe;
     END IF;
     P_det_ult_ac  := D_det_ult_mp  + D_imp_det_ult;
     P_det_div_ac  := D_det_div_mp  + D_imp_det_fis
                                - D_imp_det_con
                                - D_imp_det_fig
                                - D_imp_det_alt
                                - D_imp_det_spe
                                - D_imp_det_ult;
     P_ipt_pag_mc  := D_ipt_ord + D_ipt_sep - D_imp_det_god;
--     dbms_output.put_line('D_det_god_mp '||D_det_god_mp||' D_imp_det_god '||D_imp_det_god);
     P_ipt_pag_ac  := P_ipt_tot_ac - ( D_det_god_mp + D_imp_det_god )
                               - D_con_fis_mp;
     P_ded_con_ac  := D_ded_con_ac;
     P_ded_fig_ac  := D_ded_fig_ac;
     P_ded_alt_ac  := D_ded_alt_ac;
  END;
  D_qta_tfr_ac_mese := nvl(D_qta_tfr_ac_mese,D_qta_tfr_ac);
  D_rit_tfr_mese := nvl(D_rit_tfr_mese,D_rit_tfr);
    BEGIN  --Emissione Movimento Fiscale Mensile
     P_stp := 'VOCI_FISC_IPT-10';
     INSERT INTO MOVIMENTI_FISCALI
     ( ci, anno, mese, MENSILITA
     , rit_ord, ipn_ord, alq_ord, ipt_ord
     , rit_sep, ipn_sep, alq_sep, ipt_sep
     , alq_ac , ipt_ac , det_fis
     , det_con, det_fig, det_alt
/* modifica del 05/01/2007 */
     , det_con_ac, det_fig_ac, det_alt_ac
     , det_spe, det_spe_ac, det_ult
/* fine modifica del 05/01/2007 */
     , det_god
     , con_fis
     , rit_ap , ipn_ap , alq_ap , ipt_ap
     , lor_liq, lor_acc, lor_acc_2000, rit_liq
     , rid_liq, rtp_liq, det_liq, dtp_liq
     , ipn_liq, alq_liq, ipt_liq
     , gg_anz_t, gg_anz_i, gg_anz_r
     , lor_tra, rit_tra, ipn_tra
     , rit_ass, ipn_ass, ipt_ass
     , rit_aap, ipn_aap, ipt_aap
     , fdo_tfr_ap_liq
     , fdo_tfr_2000_liq
     , riv_tfr, riv_tfr_liq, riv_tfr_ap_liq
     , ret_tfr
     , qta_tfr_ac, qta_tfr_ac_liq
     , ipn_tfr, rit_tfr, rit_riv
     , somme_0, somme_1, somme_2, somme_3, somme_4
     , somme_5, somme_6, somme_7, somme_8, somme_9
     , somme_10, somme_11, somme_12, somme_13, somme_14
     , somme_15, somme_16, somme_17, somme_18, somme_19
     , ipn_prev
     , ipn_ssn, rit_ssn, ipn_ssn_liq, rit_ssn_liq
     , data_richiesta_ant
     , tfr_liq_rif_ap
     , somme_od
     , ded_fis, ded_per, ded_tot
     , ded_base, ded_agg
     , ded_base_ac, ded_agg_ac, ded_per_ac
     , ded_con, ded_fig, ded_alt, ded_per_fam
     , ded_con_ac, ded_fig_ac, ded_alt_ac, ded_per_fam_ac
     ) VALUES
     ( P_ci, P_anno, P_mese, P_mensilita
     , D_rit_ord, D_ipn_ord, D_alq_ord
     , D_ipt_ord
     , D_rit_sep, D_ipn_sep, D_alq_sep, D_ipt_sep
     , D_alq_ac_mp, D_ipt_ac_mp, D_imp_det_fis
     , D_imp_det_con, D_imp_det_fig, D_imp_det_alt
/* modifica del 05/01/2007 */
     , P_det_con_ac, P_det_fig_ac, P_det_alt_ac
     , D_imp_det_spe, P_det_spe_ac, D_imp_det_ult
/* fine modifica del 05/01/2007 */
     , decode( P_conguaglio,
               0, decode( P_effe_cong
                        , 'M', least( D_imp_det_fis, greatest(nvl(P_ipt_tot_ac,0)-nvl(D_det_god_mp,0) ,0 ) )
                             , D_imp_det_god
                        )
                , least( D_imp_det_fis, greatest(nvl(P_ipt_tot_ac,0)-nvl(D_det_god_mp,0) , 0) )
             )
     , 0
     , D_rit_ap  , D_ipn_ap  , D_alq_ap
     , D_ipt_ap
     , D_lor_liq , D_lor_acc , D_lor_acc_2000, D_rit_liq
     , nvl(D_rid_liq,0)-nvl(D_rid_liq_mp,0)     -- registro l'abbattimento solo per la parte di competenza del mese
     , D_rtp_liq
     , D_det_liq, D_dtp_liq
     , nvl(D_ipn_liq,0) --- decode(nvl(D_ipn_liq,0),0,0,nvl(d_ipn_liq_tot,0)) -- registro l'imponibile del mese
     , D_alq_liq
     , D_ipt_liq
     , D_gg_anz_t, D_gg_anz_i, D_gg_anz_r
     , D_lor_tra , D_rit_tra , D_ipn_tra
     , D_rit_ass , D_ipn_ass , D_ipt_ass
     , D_rit_aap , D_ipn_aap , D_ipt_aap
     , D_fdo_tfr_ap_liq
     , D_fdo_tfr_2000_liq
     , D_riv_tfr, D_riv_tfr_liq, D_riv_tfr_ap_liq
     , D_ret_tfr
     , D_qta_tfr_ac_mese, D_qta_tfr_ac_liq
     , D_ipn_tfr, D_rit_tfr_mese, D_rit_riv
     , D_somme_0, D_somme_1, D_somme_2, D_somme_3, D_somme_4
     , D_somme_5, D_somme_6, D_somme_7, D_somme_8, D_somme_9
     , D_somme_10, D_somme_11, D_somme_12, D_somme_13, D_somme_14
     , D_somme_15, D_somme_16, D_somme_17, D_somme_18, D_somme_19
     , D_ipn_prev
     , D_ipn_ssn, D_rit_ssn, D_ipn_ssn_liq, D_rit_ssn_liq
     , d_richiesta_ant
     , decode( to_char(d_richiesta_ant,'yyyy')
	       ,P_anno,0
	              ,nvl(D_fdo_tfr_ap_liq,0) + nvl(D_fdo_tfr_2000_liq,0)
		 )
     , d_somme_od
     , decode( P_conguaglio,
               0, least(nvl(D_ded_fis,0),greatest(0,d_ipn_ord))
                , least( D_ded_base + D_ded_agg + D_ded_con + D_ded_fig + D_ded_alt
                       , greatest(nvl(P_ipn_tot_ac,0),0)))  -- 29/12/2005
     , nvl(D_ded_per,100)
     , D_ded_base + D_ded_agg + D_ded_con + D_ded_fig + D_ded_alt
     , D_ded_base, D_ded_agg
     , D_ded_base_ac, D_ded_agg_ac, nvl(D_ded_per_ac,100)
     , D_ded_con, D_ded_fig, D_ded_alt, nvl(D_ded_per_fam,100)
     , D_ded_con_ac, D_ded_fig_ac, D_ded_alt_ac, nvl(D_ded_per_fam_ac,100)
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
