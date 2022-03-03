CREATE OR REPLACE PACKAGE Peccmore10 IS
/******************************************************************************
 NOME:        Peccmore10
 DESCRIZIONE: Calcolo VOCI Fiscali.
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1    23/12/2004 MF     Finanziaria 2005.
                        Eliminazione richiamo Procedure Calcolo_Deduzione.
 1.1  24/01/2005 AM-NN  Applicazione add. regionale Veneto con coeff. di riduzione
 1.2  03/03/2005 NN     Applicazione add. regionale Lombardia : in presenza di
                        cond.add. in inex, se non e indicata la corrispondente alq
                        nel dizionario, si applica comunque l'addizionale regionale.
 1.3  15/03/2005 NN     Gestito arr per voce SOM_ERE, prima all'erede era tutto 'corrente'
 1.4  30/03/2005 NN     In caso di conguaglio fiscale, con deduzioni del mese maggiori
                        del reddito (per esempio per conguaglio di mesi in cui non erano
                        state calcolate), riporta nel mese le deduzioni totali e non
                        solo le deduzioni fino al raggiungimento dell'imponibile.
                        Di conseguenza la voce IPREF_ORD del mese puo essere negativa.
 1.5  09/06/2005 NN     Calcolo addizionali regionali e comunali su imponibile
                        al netto delle deduzioni per carichi familiari.
 1.6  09/08/2005 NN     La lettura dell'ipn regionale x l'alq. aggiuntiva considerava
                        ancora l'ipn NON abbattuto delle deduzioni.
 1.7  03/10/2005 NN     In caso di conguaglio x assenza con relativo flag attivo, si
                        liquida il saldo delle addizionali (residuo) e non solo la rata del mese.
 1.8  20/12/2005 NN     Applicazione add. regionale Veneto anno 2006.
 1.9  27/02/2006 NN     Non applicava il conguaglio alle addizionali in caso di richiesta
                        di conguaglio in AINEX.
 2    05/01/2007 AM     Adeguamento alla Legge Finanziaria 2007
 2.1  12/01/2007 AM     Addizionale Veneto: in caso di correttivo trattava l'aliquota in negativo
 2.2  17/01/2007 ML-AM  Modificato inserimento voce DET.MEN per mancata quadtratur ain conguaglio quadratura (A19233)
 2.3  25/01/2007 AM     AddizionaliIRPEF comunali: dall'anno 2007 la data di riferimento per controllo della
                        residenza e 1/1 e non 31/12 (o data di cessazione)
 2.4  06/02/2007 ML     Modificato inserimento voce DET.NGOD per inserire anche se a 0.
                        In caso di attribuzione totale delle detrazio sospese non 
                        azzerava la voce DET.NGOD (A19566)
 2.5  06/02/2007 ML     Determinazione mese di conguaglio con la funzione del gp4_rare (A19571).
 2.6  09/02/2007 ML     Calcolo addizionale comunale chiamando le apposite funzioni del peccmore_addizionali (A19572)
 2.7  03/05/2007 ML     Eliminazione rateizzazione addizionale comunale sospesa (A19870)
 2.8  25/07/2007 AM     Gestiti eredi con più registrazioni su RADI (con anni diversi) e 
                        adeguata la lettura di RADI con il campo rilevanza
******************************************************************************/
revisione varchar2(30) := '2.8 del 25/07/2007';
FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);
PROCEDURE voci_fiscali
(
 p_ci        NUMBER
,p_ni        NUMBER
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
,p_imp_add_veneto   IN OUT NUMBER     -- Add.Reg. Veneto per casi particolari   -- 20/12/2005
,p_caso_particolare IN OUT NUMBER     -- Add.Reg. Veneto, anche se importo = 0  -- 20/12/2006
--
, p_spese        NUMBER
, p_tipo_spese   VARCHAR2
, P_ulteriori     NUMBER
, p_tipo_ulteriori VARCHAR2
, P_ult_mese_mofi NUMBER
, P_ult_mens_mofi VARCHAR2
, P_ult_anno_moco NUMBER
, P_ult_mese_moco NUMBER
, P_ult_mens_moco VARCHAR2
--  Voci parametriche
, P_det_con      VARCHAR2
, P_det_fig      VARCHAR2
, P_det_alt      VARCHAR2
, P_det_spe      VARCHAR2
, P_det_ult      VARCHAR2
, P_riv_tfr      VARCHAR2
, P_ret_tfr      VARCHAR2
, P_qta_tfr      VARCHAR2
, P_rit_tfr      VARCHAR2
, P_rit_riv      VARCHAR2
, P_cal_anz      VARCHAR2  -- Specifica di calcolo Anzianita`
, P_add_irpef    VARCHAR2
, P_add_irpefs   VARCHAR2
, P_add_irpefp   VARCHAR2
, P_add_reg_so   VARCHAR2
, P_add_reg_pa   VARCHAR2
, P_add_reg_ra   VARCHAR2
, P_add_prov     VARCHAR2
, P_add_provs    VARCHAR2
, P_add_provp    VARCHAR2
, P_add_pro_so   VARCHAR2
, P_add_pro_pa   VARCHAR2
, P_add_pro_ra   VARCHAR2
, P_add_comu     VARCHAR2
, P_add_comus    VARCHAR2
, P_add_comup    VARCHAR2
, P_add_com_so   VARCHAR2
, P_add_com_pa   VARCHAR2
, P_add_com_ra   VARCHAR2
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
CREATE OR REPLACE PACKAGE BODY Peccmore10 IS
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
--Valorizzazione Voci Fiscali
PROCEDURE voci_fiscali
(
 p_ci        NUMBER
,p_ni        NUMBER
,p_al        DATE    --Data di Termine o Fine Mese
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
,p_imp_add_veneto IN OUT  NUMBER     -- Addizionale Regione Veneto per casi particolari   -- 20/12/2005
,p_caso_particolare IN OUT NUMBER     -- Add.Reg. Veneto, anche se importo = 0            -- 20/12/2006
--
, p_spese        NUMBER
, p_tipo_spese   VARCHAR2
, P_ulteriori     NUMBER
, p_tipo_ulteriori VARCHAR2
, P_ult_mese_mofi NUMBER
, P_ult_mens_mofi VARCHAR2
, P_ult_anno_moco NUMBER
, P_ult_mese_moco NUMBER
, P_ult_mens_moco VARCHAR2
--Voci parametriche
, P_det_con      VARCHAR2
, P_det_fig      VARCHAR2
, P_det_alt      VARCHAR2
, P_det_spe      VARCHAR2
, P_det_ult      VARCHAR2
, P_riv_tfr      VARCHAR2
, P_ret_tfr      VARCHAR2
, P_qta_tfr      VARCHAR2
, P_rit_tfr      VARCHAR2
, P_rit_riv      VARCHAR2
, P_cal_anz      VARCHAR2  --Specifica di calcolo Anzianita`
, P_add_irpef    VARCHAR2
, P_add_irpefs   VARCHAR2
, P_add_irpefp   VARCHAR2
, P_add_reg_so   VARCHAR2
, P_add_reg_pa   VARCHAR2
, P_add_reg_ra   VARCHAR2
, P_add_prov     VARCHAR2
, P_add_provs    VARCHAR2
, P_add_provp    VARCHAR2
, P_add_pro_so   VARCHAR2
, P_add_pro_pa   VARCHAR2
, P_add_pro_ra   VARCHAR2
, P_add_comu     VARCHAR2
, P_add_comus    VARCHAR2
, P_add_comup    VARCHAR2
, P_add_com_so   VARCHAR2
, P_add_com_pa   VARCHAR2
, P_add_com_ra   VARCHAR2
--Parametri per Trace
,p_trc    IN     NUMBER     --Tipo di Trace
,p_prn    IN     NUMBER     --Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     --Numero di Passo procedurale
,p_prs    IN OUT NUMBER     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
) IS
D_perc_irpef_ord  INFORMAZIONI_EXTRACONTABILI.perc_irpef_ord%TYPE;
D_perc_irpef_sep  INFORMAZIONI_EXTRACONTABILI.perc_irpef_sep%TYPE;
D_perc_irpef_liq  INFORMAZIONI_EXTRACONTABILI.perc_irpef_liq%TYPE;
D_rid_tfr         INFORMAZIONI_EXTRACONTABILI.rid_tfr%TYPE;
D_rid_rid_tfr     INFORMAZIONI_EXTRACONTABILI.rid_rid_tfr%TYPE;
D_base_cong_ind   INFORMAZIONI_EXTRACONTABILI.base_cong%TYPE;
D_effe_cong       INFORMAZIONI_EXTRACONTABILI.effe_cong%TYPE;
D_cat_fiscale     CLASSI_RAPPORTO.cat_fiscale%TYPE;
D_alq_ap          INFORMAZIONI_EXTRACONTABILI.alq_ap%TYPE;
D_ant_liq_ap      INFORMAZIONI_EXTRACONTABILI.ant_liq_ap%TYPE;
D_ant_acc_ap      INFORMAZIONI_EXTRACONTABILI.ant_acc_ap%TYPE;
D_ant_acc_2000    INFORMAZIONI_EXTRACONTABILI.ant_acc_2000%TYPE;
D_ipt_liq_ap      INFORMAZIONI_EXTRACONTABILI.ipt_liq_ap%TYPE;
D_fdo_tfr_ap      INFORMAZIONI_EXTRACONTABILI.fdo_tfr_ap%TYPE;
D_fdo_tfr_2000    INFORMAZIONI_EXTRACONTABILI.fdo_tfr_2000%TYPE;
D_riv_tfr_ap      INFORMAZIONI_EXTRACONTABILI.riv_tfr_ap%TYPE;
D_gg_anz_c        INFORMAZIONI_EXTRACONTABILI.gg_anz_c%TYPE;
D_gg_anz_t_2000   INFORMAZIONI_EXTRACONTABILI.gg_anz_t_2000%TYPE;
D_gg_anz_i_2000   INFORMAZIONI_EXTRACONTABILI.gg_anz_i_2000%TYPE;
D_gg_anz_r_2000   INFORMAZIONI_EXTRACONTABILI.gg_anz_r_2000%TYPE;
D_ipn_terzi       INFORMAZIONI_EXTRACONTABILI.ipn_1%TYPE;
D_ass_terzi       INFORMAZIONI_EXTRACONTABILI.ipn_ass_1%TYPE;
D_ipt_terzi       INFORMAZIONI_EXTRACONTABILI.ipt_1%TYPE;
D_add_reg_terzi   INFORMAZIONI_EXTRACONTABILI.add_reg_1%TYPE;
D_add_pro_terzi   INFORMAZIONI_EXTRACONTABILI.add_pro_1%TYPE;
D_add_com_terzi   INFORMAZIONI_EXTRACONTABILI.add_com_1%TYPE;
D_imp_reg_so      INFORMAZIONI_EXTRACONTABILI.add_com_1%TYPE;
D_imp_reg_ra_mp   INFORMAZIONI_EXTRACONTABILI.add_com_1%TYPE;
D_imp_reg_ra      INFORMAZIONI_EXTRACONTABILI.add_com_1%TYPE;
D_imp_pro_so      INFORMAZIONI_EXTRACONTABILI.add_com_1%TYPE;
D_imp_pro_ra_mp   INFORMAZIONI_EXTRACONTABILI.add_com_1%TYPE;
D_imp_pro_ra      INFORMAZIONI_EXTRACONTABILI.add_com_1%TYPE;
D_imp_com_so      INFORMAZIONI_EXTRACONTABILI.add_com_1%TYPE;
D_imp_com_ra_mp   INFORMAZIONI_EXTRACONTABILI.add_com_1%TYPE;
D_imp_com_ra      INFORMAZIONI_EXTRACONTABILI.add_com_1%TYPE;
D_cond_add        INFORMAZIONI_EXTRACONTABILI.cond_add%TYPE;
--Dati di deposito per calcolo
D_alq_ac         MOVIMENTI_FISCALI.alq_ac%TYPE;  --Aliquota Max Annua
D_ipt_ac         MOVIMENTI_FISCALI.ipt_ac%TYPE;  --Imposta Ricalcolata
D_con_fis        MOVIMENTI_FISCALI.con_fis%TYPE;
D_dimesso        VARCHAR2(1);
D_ci_lav_pr       VARCHAR2(1);
D_gg_lav_ac       NUMBER;
D_gg_det_ac       NUMBER;
D_deceduto        VARCHAR2(1);
D_erede           NUMBER;
D_soggette_ac     NUMBER;
D_soggette_s      NUMBER;
D_soggette_ap     NUMBER;
D_liquidazione    NUMBER;
D_ritenuta_liquidazione     NUMBER;
D_conguaglio      NUMBER;
D_add_comunale    NUMBER;
D_add_provinciale NUMBER;
D_add_regionale   NUMBER;
D_SOM_ERE   NUMBER;
D_SOM_ERE_ARR  NUMBER;     -- modifica del 15/03/2005
D_SOM_ERE_LI   NUMBER;
D_SOM_ERE_RL   NUMBER;
D_SOM_ERE_NS   NUMBER;
D_SOM_ERE_CO   NUMBER;
D_ADD_ERE_C   NUMBER;
D_ADD_ERE_P   NUMBER;
D_ADD_ERE_R   NUMBER;
D_PRIMO_EREDE NUMBER;
--Valori di ritorno da Subroutine
D_ipn_tot_ac      MOVIMENTI_FISCALI.ipn_ord%TYPE;  --Imponibile Annuo
D_ipt_tot_ac      MOVIMENTI_FISCALI.ipt_ord%TYPE;  --Imposta Annua
D_ipt_tot_ass_ac  MOVIMENTI_FISCALI.ipt_ass%TYPE;  --Ipt Annua Assimilati
D_ipn_tot_ass_ac  MOVIMENTI_FISCALI.ipn_ass%TYPE;  --Ipn Annua Assimilati
D_det_fis_ac      MOVIMENTI_FISCALI.det_fis%TYPE;  --Detrazioni Annue
D_det_con_ac      MOVIMENTI_FISCALI.det_con%TYPE;  --Detrazioni Annue
D_det_fig_ac      MOVIMENTI_FISCALI.det_fig%TYPE;  --Detrazioni Annue
D_det_alt_ac      MOVIMENTI_FISCALI.det_alt%TYPE;  --Detrazioni Annue
D_det_spe_ac      MOVIMENTI_FISCALI.det_spe%TYPE;  --Detrazioni Annue
D_det_ult_ac      MOVIMENTI_FISCALI.det_ult%TYPE;  --Detrazioni Annue
D_det_div_ac      MOVIMENTI_FISCALI.det_fis%TYPE;  --Detrazioni Annue
D_ipt_pag_mc      MOVIMENTI_FISCALI.ipt_ord%TYPE;  --Imposta Pagata mese
D_ipt_pag_ac      MOVIMENTI_FISCALI.ipt_ord%TYPE;  --Imposta Pagata Annua
D_add_irpef_mp     MOVIMENTI_FISCALI.add_irpef%TYPE;  --Add. IRPEF pagata
D_ipn_add_irpef_mp MOVIMENTI_FISCALI.add_irpef%TYPE;  --Ipn. add. Reg.
D_add_irpef_mc    MOVIMENTI_FISCALI.add_irpef%TYPE;  --Add. IRPEF mese
D_add_prov_mp     MOVIMENTI_FISCALI.add_irpef%TYPE;  -- Add. IRPEF pagata
D_ipn_add_prov_mp MOVIMENTI_FISCALI.add_irpef%TYPE;  -- Ipn. add. Reg.
D_add_prov_mc     MOVIMENTI_FISCALI.add_irpef%TYPE;  -- Add. IRPEF mese
D_add_comu_mp      MOVIMENTI_FISCALI.add_irpef_comunale%TYPE;
D_ipn_add_comu_mp  MOVIMENTI_FISCALI.add_irpef%TYPE;  --Ipn. add. Com.
D_add_comu_mc      MOVIMENTI_FISCALI.add_irpef_comunale%TYPE;
D_alq_add_comu     ADDIZIONALE_IRPEF_COMUNALE.aliquota%TYPE;
D_alq_add_prov     VALIDITA_FISCALE.aliquota_irpef_provinciale%TYPE;
D_alq_add_reg_aumento ADDIZIONALE_IRPEF_REGIONALE.aliquota%TYPE;
D_imposta_reg      ADDIZIONALE_IRPEF_REGIONALE.imposta%TYPE;
D_scaglione_reg    ADDIZIONALE_IRPEF_REGIONALE.scaglione%TYPE;
D_regione          ADDIZIONALE_IRPEF_REGIONALE.regione%TYPE;
D_alq_add_reg      VALIDITA_FISCALE.aliquota_irpef_regionale%TYPE;
D_alq_add_reg_veneto VALIDITA_FISCALE.aliquota_irpef_regionale%TYPE;
D_ipn_mp           MOVIMENTI_FISCALI.ipn_ord%TYPE;
D_det_god_mp       MOVIMENTI_FISCALI.det_god%TYPE;
D_riduzioni_tfr    NUMBER;
D_detrazioni_tfr   NUMBER;
D_ded_fis_ac       NUMBER;
D_ded_tot_ac       NUMBER;
D_ded_con_ac       NUMBER;
D_ded_fig_ac       NUMBER;
D_ded_alt_ac       NUMBER;
--
BEGIN
  BEGIN  --Acquisizione dati contabili individuali
     P_stp := 'VOCI_FISCALI-01';
            SELECT inex.perc_irpef_ord
                 , inex.perc_irpef_sep
                 , inex.perc_irpef_liq
                 , inex.rid_tfr
                 , inex.rid_rid_tfr
                 , inex.base_cong
                 , inex.effe_cong
                 , inex.alq_ap
                 , inex.ant_liq_ap
                 , NVL(inex.ant_acc_ap,0)
                 , NVL(inex.ant_acc_2000,0)
                 , inex.ipt_liq_ap
                 , NVL(inex.fdo_tfr_ap, 0)
                 , NVL(inex.fdo_tfr_2000, 0)
                 , NVL(inex.riv_tfr_ap, 0)
                 , NVL(inex.gg_anz_c, 0)
                 , NVL(inex.gg_anz_t_2000, 0)
                 , NVL(inex.gg_anz_i_2000, 0)
                 , NVL(inex.gg_anz_r_2000, 0)
                 , NVL(inex.ipn_1, 0) + NVL(inex.ipn_2, 0) + NVL(inex.ipn_3, 0)
                 , NVL(inex.ipn_ass_1, 0) + NVL(inex.ipn_ass_2, 0)
                                          + NVL(inex.ipn_ass_3, 0)
                 , NVL(inex.ipt_1, 0) + NVL(inex.ipt_2, 0) + NVL(inex.ipt_3, 0)
                 , NVL(inex.add_reg_1, 0) + NVL(inex.add_reg_2, 0)
                                          + NVL(inex.add_reg_3, 0)
                 , NVL(inex.add_pro_1, 0) + NVL(inex.add_pro_2, 0)
                                          + NVL(inex.add_pro_3, 0)
                 , NVL(inex.add_com_1, 0) + NVL(inex.add_com_2, 0)
                                          + NVL(inex.add_com_3, 0)
                 , inex.cond_add
              INTO D_perc_irpef_ord
                 , D_perc_irpef_sep
                 , D_perc_irpef_liq
                 , D_rid_tfr
                 , D_rid_rid_tfr
                 , D_base_cong_ind
                 , D_effe_cong
                 , D_alq_ap
                 , D_ant_liq_ap
                 , D_ant_acc_ap
                 , D_ant_acc_2000
                 , D_ipt_liq_ap
                 , D_fdo_tfr_ap
                 , D_fdo_tfr_2000
                 , D_riv_tfr_ap
                 , D_gg_anz_c
                 , D_gg_anz_t_2000
                 , D_gg_anz_i_2000
                 , D_gg_anz_r_2000
                 , D_ipn_terzi
                 , D_ass_terzi
                 , D_ipt_terzi
                 , D_add_reg_terzi
                 , D_add_pro_terzi
                 , D_add_com_terzi
                 , D_cond_add
       FROM INFORMAZIONI_EXTRACONTABILI inex
      WHERE inex.ci    = P_ci
        AND inex.anno  = P_anno
     ;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  --Preleva Codice Individuale di precedente Rapporto di Lavoro
     P_stp := 'VOCI_FISCALI-01.1';
     SELECT MAX('x')
       INTO D_ci_lav_pr
       FROM RAPPORTI_DIVERSI radi
      WHERE ci   = P_ci
/* modifica del 25/07/2007 */
        AND rilevanza = 'L'
        AND anno = P_anno
/* sostituita la vecchia lettura con il nuovo test sulla rilevanza
        AND EXISTS (SELECT 'x'
                    FROM RAPPORTI_INDIVIDUALI
                   WHERE ni = (SELECT ni FROM RAPPORTI_INDIVIDUALI
                              WHERE ci = P_ci)
                     AND ci = radi.ci_erede
                     AND rapporto IN
                       (SELECT codice FROM CLASSI_RAPPORTO
                         WHERE presenza = 'NO')
                 )
 fine modifica del 25/07/2007 */
      ;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  EXCEPTION
     WHEN OTHERS THEN
         D_ci_lav_pr := NULL;
  END;
  BEGIN  --Preleva Numero di Giorni Lavorati nell'anno
     P_stp := 'VOCI_FISCALI-01.2';
     SELECT SUM(NVL(LEAST(365
                     , SUM( pere.gg_det)
                     )
                ,0))
         , NVL
           ( SUM
             ( DECODE
               ( P_base_det
               , 'G', SUM( pere.gg_fis )
               , 'M', CEIL
                     ( SUM( pere.gg_fis
                         * DECODE(pere.competenza,'A',1,'C',1,0)
                         ) / 30
                     ) * 30
                   + FLOOR
                     ( SUM( pere.gg_fis
                         * DECODE(pere.competenza,'P',1,0)
                         ) / 30
                     ) * 30
               , 'R', ROUND
                     ( SUM( pere.gg_fis
                         * DECODE(pere.competenza,'A',1,'C',1,0)
                         ) / 30
                     ) * 30
                   + ROUND
                     ( SUM( pere.gg_fis
                         * DECODE(pere.competenza,'P',1,0)
                         ) / 30
                     ) * 30
               )
             )
           , 0
           )
       INTO D_gg_det_ac
         , D_gg_lav_ac
       FROM PERIODI_RETRIBUTIVI pere
      WHERE pere.ci IN
          (SELECT P_ci FROM dual
            UNION
           SELECT ci_erede FROM RAPPORTI_DIVERSI radi
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
        AND pere.periodo     BETWEEN TO_DATE( '0101'||TO_CHAR(P_anno)
                                       , 'ddmmyyyy'
                                       )
                             AND P_fin_ela
        AND (   TO_CHAR(pere.al,'yyyy') = P_anno
            OR P_detrazioni_ap = 'SI'
           )
        AND pere.anno+0      = P_anno
        AND pere.competenza IN ('P','C','A')
        AND pere.SERVIZIO    = 'Q'
      GROUP BY pere.ci, pere.mese
     ;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
--
-- Controllo presenza Eredi o abbinamento a Deceduto
--
  BEGIN
    select 'x'
      into D_deceduto
      from dual
     where exists (select 'x'
                     from rapporti_diversi
                    where ci_erede = P_ci
                      and rilevanza = 'E'
                   )
-- poichè si tratta di una exists, non occorre il controllo sull'anno
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_deceduto := null;
  END;
  BEGIN
    select ci_erede
      into D_erede
      from rapporti_diversi
     where ci = P_ci
       and rilevanza = 'E'
/* modifica del 25/07/2007 */
       and anno = (Select max(anno) from rapporti_diversi
                    where ci = P_ci
                      and rilevanza = 'E'
                  )
/* fine modifica del 25/07/2007 */
    ;
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      D_erede := null;
    WHEN TOO_MANY_ROWS THEN
      D_erede := null;
  END;
-- Inizio Trattamento del deceduto
  IF D_deceduto is not null THEN
    BEGIN
-- Acquisizione Somme del Deceduto per azzeramento
      P_stp := 'VOCI_FISCALI-01.3.1';
      select NVL( SUM( caco.imp
        * DECODE(covo.fiscale,'C',1,'F',1,'X',1,0)
        * DECODE(NVL(caco.arr,'C'),'C',1,0)
        )
        , 0 )
  - NVL( SUM( NVL(caco.ipn_c,caco.imp)
       * DECODE(covo.fiscale,'R',1,0)
       * DECODE(NVL(caco.arr,'C'),'C',1,0)
       ) * -1
       , 0 )
  , NVL( SUM( caco.imp
       * DECODE(covo.fiscale,'S',1,0)
       * DECODE(NVL(caco.arr,'C'),'C',1,0)
       )
       , 0 )
  - NVL( SUM( NVL(caco.ipn_s,0)
       * DECODE(covo.fiscale,'R',1,0)
       ) * -1
       , 0 )
  , NVL( SUM( caco.imp
       * DECODE(covo.fiscale,'P',1,'Y',1,0)
       --+ nvl(caco.ipn_p,caco.imp)
       + caco.imp
       * DECODE(covo.fiscale,'C',1,'F',1,'X',1,'S',1,0)
       * DECODE(NVL(caco.arr,'C'),'P',1,0)
       )
       , 0 )
  - NVL( SUM( NVL(caco.ipn_p,0)
       * DECODE(covo.fiscale,'R',1,0)
       ) * -1
       , 0 )
        into D_SOGGETTE_AC
            ,D_SOGGETTE_S
            ,D_SOGGETTE_AP
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
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_SOGGETTE_AC :=0;
        D_SOGGETTE_S  :=0;
        D_SOGGETTE_AP :=0;
    END;
     BEGIN  -- Estrazione voci Somme Deceduto
      IF nvl(D_SOGGETTE_AC,0) != 0 THEN
        P_stp := 'VOCI_FISCALI-01.3.2';
        insert into calcoli_contabili
             ( ci, voce, sub
             , riferimento
             , arr
             , input
             , estrazione
             , imp
             , ipn_c
             , ipn_s
             )
        select P_ci, voec.codice, '*'
             , P_al
             , ''
             , 'C'
             , voec.classe||voec.estrazione
             , (D_SOGGETTE_AC + D_SOGGETTE_S) * -1
             , D_SOGGETTE_AC * -1
             , D_SOGGETTE_S * -1
          from contabilita_voce    covo
             , voci_economiche     voec
         where voec.specifica     = 'SOM_ERE'
           and covo.voce          = voec.codice||''
           and covo.sub           = '*'
           and P_fin_ela    between nvl(covo.dal,to_date(2222222,'j'))
                                and nvl(covo.al ,to_date(3333333,'j'))
           and not exists
              (select 'x'
                 from calcoli_contabili
                where voce = voec.codice
                  and sub  = '*'
                  and arr is null
                  and ci   = P_ci
              )
        ;
        peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
      END IF;
    END;
-- Estrazione voci Somme Anno Precedente Deceduto
    BEGIN
      IF nvl(D_SOGGETTE_AP,0) != 0 THEN
        P_stp := 'VOCI_FISCALI-01.3.3';
        insert into calcoli_contabili
             ( ci, voce, sub
             , riferimento
             , arr
             , input
             , estrazione
             , imp
             )
        select P_ci, voec.codice, '*'
             , P_al
             , 'P'
             , 'C'
             , voec.classe||voec.estrazione
             , D_SOGGETTE_AP * -1 imp
          from contabilita_voce    covo
             , voci_economiche     voec
         where voec.specifica     = 'SOM_ERE'
           and covo.voce          = voec.codice||''
           and covo.sub           = '*'
           and P_fin_ela    between nvl(covo.dal,to_date(2222222,'j'))
                                and nvl(covo.al ,to_date(3333333,'j'))
           and not exists
               (select 'x'
                  from calcoli_contabili
                 where voce = voec.codice
                   and sub  = '*'
                   and arr  = 'P'
                   and ci   = P_ci
               )
        ;
        peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
      END IF;
    END;
  END IF;
  IF D_EREDE is not null THEN
-- Acquisizione Somme del Deceduto per azzeramento
    BEGIN
      select sum(decode(voec.specifica,'SOM_ERE',nvl(caco.imp,0) *
                                                 decode(caco.arr,'P',0,1)  --  modifica del 15/03/2005
                                  ,null
                   )) /*somme eredi */
           , sum(decode(voec.specifica,'SOM_ERE',nvl(caco.imp,0) *
                                                 decode(caco.arr,'P',1,0)
                                  ,null
                   )) /*somme eredi arr*/
           , sum(decode(voec.specifica,'SOM_ERE_LI',nvl(caco.imp, 0 )
                                  ,null
                   )) /*somme eredi liquidazione */
           , sum(decode(voec.specifica,'SOM_ERE_RL',nvl(caco.imp,0)
                                  ,null
                   )) /*somme eredi ritenute liquid. */
           , sum(decode(voec.specifica,'SOM_ERE_NS',nvl(caco.imp,0)
                                  ,null
                   )) /*somme eredi non soggette */
           , sum(decode(voec.specifica,'SOM_ERE_CO',nvl(caco.imp,0)
                                  ,null
                   )) /*conguaglio fiscale */
           , sum(decode(voec.specifica,'ADD_ERE_R',nvl(caco.imp,0)
                                  ,null
                   )) /*aadizionale regionale. */
           , sum(decode(voec.specifica,'ADD_ERE_C',nvl(caco.imp,0)
                                  ,null
                   )) /*addizionale comunale */
           , sum(decode(voec.specifica,'ADD_ERE_P',nvl(caco.imp,0)
                                  ,null
                   )) /*addizionale provinciale */
        into D_SOM_ERE
            ,D_SOM_ERE_ARR                        -- modifica del 15/03/2005
            ,D_SOM_ERE_LI
            ,D_SOM_ERE_RL
            ,D_SOM_ERE_NS
            ,D_SOM_ERE_CO
            ,D_ADD_ERE_R
            ,D_ADD_ERE_C
            ,D_ADD_ERE_P
        FROM VOCI_ECONOMICHE voec
           , MOVIMENTI_CONTABILI caco
       WHERE voec.codice = caco.voce
         AND caco.ci = D_erede
         AND caco.anno = P_anno
         AND caco.mese = P_mese
         AND caco.mensilita = P_mensilita
         AND voec.specifica in ('SOM_ERE','SOM_ERE_LI'
                               ,'SOM_ERE_RL','SOM_ERE_NS'
                               ,'SOM_ERE_CO','ADD_ERE_C'
                               ,'ADD_ERE_P','ADD_ERE_R'
                               )
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_SOM_ERE := 0;
        D_SOM_ERE_ARR := 0;               --  modifica del 15/03/2005
        D_SOM_ERE_LI := 0;
        D_SOM_ERE_RL := 0;
        D_SOM_ERE_NS := 0;
        D_SOM_ERE_CO := 0;
        D_ADD_ERE_C := 0;
        D_ADD_ERE_P := 0;
        D_ADD_ERE_R := 0;
    END;
-- Calcolo Quota da emettere per l'Erede
    BEGIN
-- Identifica il Primo Erede: il primo con Quota piu alta
      select min(ci)
        into D_PRIMO_EREDE
        from RAPPORTI_DIVERSI
       where quota_erede = (select max(quota_erede)
                              from RAPPORTI_DIVERSI
                             where ci_erede = D_EREDE)
         and ci_erede = D_EREDE
      ;
IF P_CI = D_PRIMO_EREDE THEN
        select round(D_SOM_ERE / 100 * sum(decode(ci,P_ci,quota_erede,0)),2)
             + D_SOM_ERE - sum(round(D_SOM_ERE / 100 * nvl(quota_erede,0),2))
             , round(D_SOM_ERE_ARR / 100 * sum(decode(ci,P_ci,quota_erede,0)),2)
             + D_SOM_ERE_ARR - sum(round(D_SOM_ERE_ARR / 100 * nvl(quota_erede,0),2))
             , round(D_SOM_ERE_LI / 100 * sum(decode(ci,P_ci,quota_erede,0)),2)
             + D_SOM_ERE_LI - sum(round(D_SOM_ERE_LI / 100 * nvl(quota_erede,0),2))
             , round(D_SOM_ERE_RL / 100 * sum(decode(ci,P_ci,quota_erede,0)),2)
             + D_SOM_ERE_RL - sum(round(D_SOM_ERE_RL / 100 * nvl(quota_erede,0),2))
             , round(D_SOM_ERE_NS / 100 * sum(decode(ci,P_ci,quota_erede,0)),2)
             + D_SOM_ERE_NS - sum(round(D_SOM_ERE_NS / 100 * nvl(quota_erede,0),2))
             , round(D_SOM_ERE_CO / 100 * sum(decode(ci,P_ci,quota_erede,0)),2)
             + D_SOM_ERE_CO - sum(round(D_SOM_ERE_CO / 100 * nvl(quota_erede,0),2))
             , round(D_ADD_ERE_C / 100 * sum(decode(ci,P_ci,quota_erede,0)),2)
             + D_ADD_ERE_C - sum(round(D_ADD_ERE_C / 100 * nvl(quota_erede,0),2))
             , round(D_ADD_ERE_P / 100 * sum(decode(ci,P_ci,quota_erede,0)),2)
             + D_ADD_ERE_P - sum(round(D_ADD_ERE_P / 100 * nvl(quota_erede,0),2))
             , round(D_ADD_ERE_R / 100 * sum(decode(ci,P_ci,quota_erede,0)),2)
             + D_ADD_ERE_R - sum(round(D_ADD_ERE_R / 100 * nvl(quota_erede,0),2))
          into D_SOM_ERE
              ,D_SOM_ERE_ARR                             -- modifica del 15/03/2005
              ,D_SOM_ERE_LI
              ,D_SOM_ERE_RL
              ,D_SOM_ERE_NS
              ,D_SOM_ERE_CO
              ,D_ADD_ERE_C
              ,D_ADD_ERE_P
              ,D_ADD_ERE_R
          from RAPPORTI_DIVERSI radi
         where ci_erede = D_EREDE
/* modifica del 25/07/2007 */
           and anno = (select max(anno) from rapporti_diversi
                        where ci_erede = D_EREDE
                          and ci = radi.ci)
/* fine modifica del 25/07/2007 */
  ;
ELSE
        select D_SOM_ERE / 100* nvl(quota_erede,0)
             , D_SOM_ERE_ARR / 100* nvl(quota_erede,0)      -- modifica del 15/03/2005
             , D_SOM_ERE_LI / 100* nvl(quota_erede,0)
             , D_SOM_ERE_RL / 100* nvl(quota_erede,0)
             , D_SOM_ERE_NS / 100* nvl(quota_erede,0)
             , D_SOM_ERE_CO / 100* nvl(quota_erede,0)
             , D_ADD_ERE_C / 100* nvl(quota_erede,0)
             , D_ADD_ERE_P / 100* nvl(quota_erede,0)
             , D_ADD_ERE_R / 100* nvl(quota_erede,0)
          into D_SOM_ERE
              ,D_SOM_ERE_ARR                                -- modifica del 15/03/2005
              ,D_SOM_ERE_LI
              ,D_SOM_ERE_RL
              ,D_SOM_ERE_NS
              ,D_SOM_ERE_CO
              ,D_ADD_ERE_C
              ,D_ADD_ERE_P
              ,D_ADD_ERE_R
          from RAPPORTI_DIVERSI radi
         where ci_erede = D_EREDE
           and ci = P_ci
/* modifica del 25/07/2007 */
           and anno = (select max(anno) from rapporti_diversi
                        where ci_erede = D_EREDE
                          and ci =P_ci)
/* fine modifica del 25/07/2007 */

       ;
      END IF;
    END;
    insert into calcoli_contabili
           ( ci, voce, sub
           , riferimento
           , arr
           , input
           , estrazione
           , imp
           )
      select P_ci, voec.codice, '*'
           , P_al
           , ''
           , 'C'
           , voec.classe||voec.estrazione
           , decode( voec.specifica
           ,'SOM_ERE'    , D_SOM_ERE    * -1
           ,'SOM_ERE_LI' , D_SOM_ERE_LI * -1
           ,'SOM_ERE_RL' , D_SOM_ERE_RL * -1
           ,'SOM_ERE_NS' , D_SOM_ERE_NS * -1
           ,'SOM_ERE_CO' , D_SOM_ERE_CO * -1
           ,'ADD_ERE_C'  , D_ADD_ERE_C  * -1
           ,'ADD_ERE_P'  , D_ADD_ERE_P  * -1
           ,'ADD_ERE_R'  , D_ADD_ERE_R  * -1
           ) imp
        from contabilita_voce    covo
           , voci_economiche     voec
       where voec.specifica    in ('SOM_ERE','SOM_ERE_LI'
                                  ,'SOM_ERE_RL','SOM_ERE_NS'
                                  ,'SOM_ERE_CO','ADD_ERE_C'
                                  ,'ADD_ERE_P','ADD_ERE_R'
                                  )
         and covo.voce          = voec.codice||''
         and covo.sub           = '*'
         and P_fin_ela    between nvl(covo.dal,to_date(2222222,'j'))
                              and nvl(covo.al ,to_date(3333333,'j'))
         and not exists
            (select 'x'
               from calcoli_contabili
              where voce = voec.codice
                and sub  = '*'
                and arr is null
                and ci   = P_ci
            )
union
      select P_ci, voec.codice, '*'
           , P_al
           , 'P'
           , 'C'
           , voec.classe||voec.estrazione
           , D_SOM_ERE_ARR * -1
        from contabilita_voce    covo
           , voci_economiche     voec
       where voec.specifica    = 'SOM_ERE'
         and covo.voce          = voec.codice||''
         and covo.sub           = '*'
         and P_fin_ela    between nvl(covo.dal,to_date(2222222,'j'))
                              and nvl(covo.al ,to_date(3333333,'j'))
         and not exists
            (select 'x'
               from calcoli_contabili
              where voce = voec.codice
                and sub  = '*'
                and arr  = 'P'
                and ci   = P_ci
            )
      ;
      peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
    END IF;
  Peccmore11.VOCI_FISC_IPT  --Determinazione Imponibili, Aliquote, Imposta e T.F.R
    ( P_ci, D_ci_lav_pr, P_al
          , P_anno, P_mese, P_mensilita, P_fin_ela
          , P_tipo, P_conguaglio
          , P_base_ratei, P_base_det
          , P_mesi_irpef, NVL(D_base_cong_ind, P_base_cong)
          , P_scad_cong, P_rest_cong
          , P_rate_addizionali, P_detrazioni_ap
/* modifica del 07/01/2007 passa anche il P_tipo_spese */
          , P_spese, P_tipo_spese, P_ulteriori, P_tipo_ulteriori
          , D_perc_irpef_ord, D_perc_irpef_sep
          , D_perc_irpef_liq, D_rid_tfr, D_rid_rid_tfr
          , D_effe_cong
          , D_alq_ap, D_ant_liq_ap
          , D_ant_acc_ap, D_ant_acc_2000, D_ipt_liq_ap
          , D_fdo_tfr_ap, D_fdo_tfr_2000, D_riv_tfr_ap, D_gg_anz_c
          , D_gg_anz_t_2000, D_gg_anz_i_2000, D_gg_anz_r_2000
          , P_ult_mese_mofi, P_ult_mens_mofi, D_gg_lav_ac, D_gg_det_ac
          , P_det_con, P_det_fig, P_det_alt, P_det_spe, P_det_ult
          , P_riv_tfr, P_ret_tfr, P_qta_tfr, P_rit_tfr, P_rit_riv
          , P_cal_anz
          , D_ipn_tot_ac, D_ipt_tot_ac, D_ipn_terzi, D_ass_terzi
          , D_ipn_tot_ass_ac , D_ipt_tot_ass_ac
          , D_det_fis_ac, D_ipt_pag_mc, D_ipt_pag_ac
          , D_det_con_ac, D_det_fig_ac, D_det_alt_ac
          , D_det_spe_ac, D_det_ult_ac, D_det_div_ac
          , D_add_irpef_mp
          , D_add_prov_mp
          , D_add_comu_mp
          , D_ipn_mp, D_det_god_mp
          , D_ded_fis_ac, D_ded_tot_ac
          , D_ded_con_ac, D_ded_fig_ac, D_ded_alt_ac
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  BEGIN  --Emissione Voci Fisse FISCALI : Ordinarie
        --Separate
        --Anni Precedenti
        --Liquidazione
        --e Voce Fissa di Liquidazione Fondo T.F.R.
     P_stp := 'VOCI_FISCALI-02';
-- modifica del 30/03/2005 - spostato dal passo VOCI_FISCALI-03
     D_ipn_tot_ac := D_ipn_tot_ac + D_ipn_terzi;
-- Fine modifica del 30/03/2005
     INSERT INTO CALCOLI_CONTABILI
     ( ci, voce, sub
     , riferimento
     , input
     , estrazione
     , tar
     , qta
     , imp
     , ipn_eap
     )
     SELECT
       P_ci, voec.codice, '*'
     , P_al
     , 'C'
     , 'AF'
     , DECODE( voec.automatismo
            , 'IRPEF_ORD', mofi.ipn_ord - decode( P_conguaglio
                                                , 0, nvl(mofi.ded_fis,0)
                                                   , least( nvl(mofi.ded_tot ,0), nvl(D_ipn_tot_ac,0)))     -- 30/03/2005
            , 'IRPEF_SEP', mofi.ipn_sep
            , 'IRPEF_AP' , mofi.ipn_ap
            , 'IRPEF_LIQ', mofi.ipn_liq
            , 'IRPEF_ASS', mofi.ipn_ass
            , 'IRPEF_AAP', mofi.ipn_aap
                         , NULL
           )
     , DECODE( voec.automatismo
            , 'IRPEF_ORD', mofi.alq_ord
            , 'IRPEF_SEP', mofi.alq_sep
            , 'IRPEF_AP' , mofi.alq_ap
            , 'IRPEF_LIQ', mofi.alq_liq
            , 'DED_BASE' , mofi.ded_per * -1
            , 'DED_AGG'  , mofi.ded_per * -1
            , 'DED_BASE_A', mofi.ded_per_ac * -1
            , 'DED_AGG_A' , mofi.ded_per_ac * -1
            , 'PRG_CON'   , mofi.ded_per_fam_ac * -1
            , 'PRG_FIG'   , mofi.ded_per_fam_ac * -1
            , 'PRG_ALT'   , mofi.ded_per_fam_ac * -1
                         , NULL
           ) * -1
     , DECODE( voec.automatismo
            , 'IRPEF_ORD', mofi.ipt_ord
            , 'IRPEF_SEP', mofi.ipt_sep
            , 'IRPEF_AP' , mofi.ipt_ap
            , 'IRPEF_LIQ', mofi.ipt_liq
            , 'IRPEF_ASS', mofi.ipt_ass
            , 'IRPEF_AAP', mofi.ipt_aap
            , 'DED_BASE' , mofi.ded_base * -1
            , 'DED_AGG'  , mofi.ded_agg  * -1
            , 'DED_MEN'  , decode( P_conguaglio
                                 , 0, mofi.ded_fis  * -1
                                    , least( nvl(mofi.ded_tot ,0), nvl(D_ipn_tot_ac,0)) * -1)      -- 30/03/2005
            , 'DED_BASE_A', mofi.ded_base_ac * -1
            , 'DED_AGG_A' , mofi.ded_agg_ac  * -1
            , 'PRG_CON'   , mofi.ded_con_ac  * -1
            , 'PRG_FIG'   , mofi.ded_fig_ac  * -1
            , 'PRG_ALT'   , mofi.ded_alt_ac  * -1
		, 'DET_LIQ'  , (NVL(mofi.det_liq,0) + NVL(mofi.dtp_liq,0)) * -1
            , 'DET_MEN'  , decode( P_conguaglio
                                 , 0, decode( D_effe_cong
                                            , 'M', least( nvl(mofi.det_fis,0), (nvl(D_ipt_tot_ac,0)-nvl(D_det_god_mp,0)) ) * -1
                                                 , mofi.det_god * -1 )
                                    , least( nvl(mofi.det_fis,0), (nvl(D_ipt_tot_ac,0)-nvl(D_det_god_mp,0)) ) * -1
                                 )
                         , mofi.fdo_tfr_ap_liq * -1
           ) * -1
     , DECODE( voec.automatismo
            , 'DET_MEN'  , NULL
                       , 0
            )
       FROM VOCI_ECONOMICHE voec
         , MOVIMENTI_FISCALI mofi
      WHERE (   voec.automatismo = 'IRPEF_ORD' AND mofi.ipn_ord != 0
            OR voec.automatismo = 'IRPEF_SEP' AND mofi.ipn_sep != 0
            OR voec.automatismo = 'IRPEF_AP'  AND
              (   mofi.ipn_ap  != 0
               OR mofi.ipt_ap  != 0
              )
            OR voec.automatismo = 'IRPEF_LIQ' AND
              (   mofi.ipn_liq != 0
               OR mofi.ipt_liq != 0
              )
            OR voec.automatismo = 'IRPEF_ASS' AND mofi.ipn_ass != 0
            OR voec.automatismo = 'IRPEF_AAP' AND mofi.ipn_aap != 0
            OR voec.automatismo = 'DET_MEN'   AND mofi.det_fis != 0
            OR voec.automatismo = 'DED_BASE'  AND mofi.ded_base != 0
            OR voec.automatismo = 'DED_AGG'   AND mofi.ded_agg != 0
            OR voec.automatismo = 'DED_MEN'   AND mofi.ded_fis != 0
            OR voec.automatismo = 'DED_BASE_A' AND mofi.ded_base_ac != 0
            OR voec.automatismo = 'DED_AGG_A'  AND mofi.ded_agg_ac  != 0
            OR voec.automatismo = 'PRG_CON'    AND mofi.ded_con_ac != 0
            OR voec.automatismo = 'PRG_FIG'    AND mofi.ded_fig_ac != 0
            OR voec.automatismo = 'PRG_ALT'    AND mofi.ded_alt_ac != 0
            OR voec.automatismo = 'DET_LIQ'   AND
              (mofi.det_liq != 0 OR mofi.dtp_liq != 0)
            OR voec.automatismo = 'FDO_LIQ'   AND
               mofi.fdo_tfr_ap_liq != 0
           )
        AND mofi.ci       = P_ci
        AND mofi.anno      = P_anno
        AND mofi.mese      = P_mese
        AND mofi.MENSILITA = P_mensilita
     ;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  --Calcolo Aliquota e Imposta FISCALE Annuale
     P_stp := 'VOCI_FISCALI-03';
-- Eliminazione del 30/03/2005 - spostato al passo VOCI_FISCALI-02
--     D_ipn_tot_ac := D_ipn_tot_ac + D_ipn_terzi;
-- Fine liminazione del 30/03/2005
-- Eliminato lancio di Peccmore11.Calcolo_Deduzione
     P_stp := 'VOCI_FISCALI-04';
     INSERT INTO CALCOLI_CONTABILI
     ( ci, voce, sub
     , riferimento
     , input
     , estrazione
     , tar
     , qta
     , imp
     , ipn_eap
     )
     SELECT
       P_ci, voec.codice, '*'
     , P_al
     , 'C'
     , 'AF'
     , null
     , null
     , D_ipn_tot_ac
     , null
       FROM VOCI_ECONOMICHE voec
      WHERE voec.automatismo = 'IRPEF_IPN'
        AND D_ipn_tot_ac  != 0
     ;
SELECT
 DECODE( D_perc_irpef_ord
       , NULL, scfi.aliquota
            , D_perc_irpef_ord
       )
, DECODE( D_perc_irpef_ord
       , NULL, ( ( ( GREATEST( 0, D_ipn_tot_ac - nvl(d_ded_tot_ac,0))
                 / DECODE( NVL( D_base_cong_ind, P_base_cong )
                        , 'M', DECODE( CEIL( D_gg_lav_ac / 30 )
                                    ,  0, P_mesi_irpef
                                    , 12, P_mesi_irpef
                                       , CEIL( D_gg_lav_ac / 30 )
                                    )
                        , 'P', GREATEST
                              ( 1, P_mesi_irpef - ( 12 - P_mese + 1 )
                              )
                             , P_mesi_irpef
                        ) * P_mesi_irpef - scfi.scaglione
                 ) * scfi.aliquota / 100 + scfi.imposta
               ) / P_mesi_irpef
                 * DECODE( NVL( D_base_cong_ind, P_base_cong )
                        , 'M', DECODE( CEIL( D_gg_lav_ac / 30 )
                                    ,  0, P_mesi_irpef
                                    , 12, P_mesi_irpef
                                       , CEIL( D_gg_lav_ac / 30 )
                                    )
                        , 'P', GREATEST
                              ( 1, P_mesi_irpef - ( 12 - P_mese + 1 )
                              )
                             , P_mesi_irpef
                        )
              )
            , ( GREATEST( 0, D_ipn_tot_ac - nvl(d_ded_tot_ac,0)) * D_perc_irpef_ord / 100
              )
       )
 INTO D_alq_ac
    , D_ipt_ac
 FROM SCAGLIONI_FISCALI scfi
WHERE scfi.scaglione =
    (SELECT MAX(scaglione)
       FROM SCAGLIONI_FISCALI
      WHERE scaglione <=
           GREATEST( 0, D_ipn_tot_ac - nvl(d_ded_tot_ac,0))
         / DECODE( NVL( D_base_cong_ind, P_base_cong )
                , 'M', DECODE( CEIL( D_gg_lav_ac / 30 )
                            ,  0, P_mesi_irpef
                            , 12, P_mesi_irpef
                               , CEIL( D_gg_lav_ac / 30 )
                            )
                , 'P', GREATEST
                      ( 1, P_mesi_irpef - ( 12 - P_mese + 1 ) )
                     , P_mesi_irpef
                )
         * P_mesi_irpef
        AND P_fin_ela BETWEEN NVL(dal,TO_DATE(2222222,'j'))
                       AND NVL(al ,TO_DATE(3333333,'j'))
    )
 AND P_fin_ela BETWEEN scfi.dal
                 AND NVL(scfi.al ,TO_DATE(3333333,'j'))
;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  --Emissione Voci Fisse Fiscali Annuali
     P_stp := 'VOCI_FISCALI-04';
-- dbms_output.put_Line('D_ipn_tot_ac '||D_ipn_tot_ac);
     INSERT INTO CALCOLI_CONTABILI
     ( ci, voce, sub
     , riferimento
     , input
     , estrazione
     , tar
     , qta
     , imp
     , ipn_eap
     )
     SELECT
       P_ci, voec.codice, '*'
     , P_al
     , 'C'
     , 'AF'
     ,  DECODE( voec.automatismo
             , 'IRPEF_LOR', greatest(D_ipn_tot_ac - nvl(D_ded_tot_ac,0),0)
                        , NULL
             )
     , DECODE( voec.automatismo
            , 'IRPEF_LOR', D_alq_ac * -1
            , 'PRG_SPE'  , D_gg_det_ac
            , 'PRG_ULT'  , D_gg_det_ac
                       , NULL
            )
     , DECODE( voec.automatismo
            , 'IRPEF_LOR', D_ipt_ac * -1
            , 'DET_TOT'  , D_det_fis_ac
            , 'PRG_CON'  , D_det_con_ac
            , 'PRG_FIG'  , D_det_fig_ac
            , 'PRG_ALT'  , D_det_alt_ac
            , 'PRG_SPE'  , D_det_spe_ac
            , 'PRG_ULT'  , D_det_ult_ac
            , 'PRG_DIV'  , D_det_div_ac
            , 'IRPEF_PAG', ( D_ipt_pag_ac + D_ipt_terzi ) * -1
            )
     , DECODE( voec.automatismo
            , 'IRPEF_LOR', 0
                       , NULL
            )
       FROM VOCI_ECONOMICHE voec
      WHERE (   voec.automatismo = 'IRPEF_LOR' AND D_ipn_tot_ac != 0
            OR voec.automatismo = 'DET_TOT'    AND D_det_fis_ac != 0
            OR voec.automatismo = 'PRG_CON'   AND D_det_con_ac != 0
            OR voec.automatismo = 'PRG_FIG'   AND D_det_fig_ac != 0
            OR voec.automatismo = 'PRG_ALT'   AND D_det_alt_ac != 0
            OR voec.automatismo = 'PRG_SPE'   AND D_det_spe_ac != 0
            OR voec.automatismo = 'PRG_ULT'   AND D_det_ult_ac != 0
            OR voec.automatismo = 'PRG_DIV'   AND D_det_div_ac != 0
            OR voec.automatismo = 'IRPEF_PAG' AND D_ipt_pag_ac
                                           + D_ipt_terzi != 0
           )
     ;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  --
  --Calcolo del Conguaglio Fiscale
  --
  /* modifica del 06/02/07 */
--  IF  P_conguaglio                 !=  0
--  AND NVL( D_effe_cong, ' ' )       != 'N'
--  OR  NVL( D_effe_cong, P_scad_cong ) = 'M'
--  OR  NVL( D_effe_cong, P_scad_cong ) = 'A'
--  AND P_mese  = 12
--  AND P_tipo IN ( 'S', 'N' )
  IF GP4_RARE.is_mese_conguaglio(P_ci, P_fin_ela, P_tipo, P_conguaglio)
    /* fine modifica del 06/02/07 */
  THEN
     D_con_fis := GREATEST( 0
                       , D_ipt_ac - D_det_fis_ac
                       ) * -1
                         + D_ipt_pag_ac
                         + D_ipt_terzi;
     --
     --P_conguaglio = 0  : In Forza
     --P_conguaglio = 1  : Conguaglio per Assenza dal servizio
     --P_conguaglio = 2  : Cessazione del rapporto
     --P_conguaglio = 3  : Ripresa per Arretrati
     --
/* modifica del del 27/02/2006 */
--     IF  P_conguaglio = 0
     IF  P_conguaglio = 0 and NVL( D_effe_cong, P_scad_cong ) != 'M'
/* fine modifica del del 27/02/2006 */
     THEN
        D_dimesso := 'N';
     ELSE  --Cessati o Ripresa per arretrati
        IF  P_mese       = 12
        AND P_tipo      IN ( 'S', 'N' )
        THEN
           SELECT DECODE( MAX(rilevanza)
                      , 'P', 'D'
                           , 'S'
                      )
             INTO D_dimesso
             FROM PERIODI_GIURIDICI
            WHERE rilevanza = 'P'
              AND ci       = P_ci
              AND al       =
                 TO_CHAR( TO_DATE( '3112'||TO_CHAR(P_anno)
                               , 'ddmmyyyy'
                               )
                       )
           ;
        ELSE
           D_dimesso := 'S';
        END IF;
     END IF;
     IF  D_con_fis    > 0  THEN
        BEGIN  --Riduzione Voce di Conguaglio Positivo fino a capienza
              --delle Ritenute Fiscali del mese.
          P_stp := 'VOCI_FISCALI-05';
          IF  P_mese       = 12          AND  --|
              P_tipo      IN ( 'S', 'N' ) AND --|> Sostituto imposta
              P_rest_cong  = 'A'         AND  --|
              ( D_dimesso  IN ('N','D')    OR --|> Normativa 1998
               P_ANNO    >= 1998              --|
              )                               --|
          OR
              P_rest_cong  = 'M'         AND  --|> Restituisce Sempre
              ( D_dimesso  IN ('N','D')   OR  --|> Normativa 1998
               P_ANNO    >= 1998              --|
              )                               --|
          THEN  --Salta riduzione per Restituzione Totale
              NULL;
          ELSE  --Restituzione della sola Imposta del Mese
              D_con_fis := LEAST( D_con_fis
                             , D_ipt_pag_mc
                             );
          END IF;
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;
     END IF;
     BEGIN  --Emissione Voci Fisse di CONGUAGLIO FISCALE
        P_stp := 'VOCI_FISCALI-06';
        INSERT INTO CALCOLI_CONTABILI
        ( ci, voce, sub
        , riferimento
        , input
        , estrazione
        , imp
        )
        SELECT
         P_ci, voec.codice, '*'
        , P_al
        , 'C'
        , 'AF'
        ,  DECODE( voec.automatismo
               , 'DET_GOD'   , D_ipt_ac
               , 'IRPEF_CON' , D_con_fis
               , 'DED_GOD'   , greatest(D_ded_fis_ac,0)
               )
         FROM VOCI_ECONOMICHE voec
        WHERE (   voec.automatismo = 'DET_GOD' AND
                 D_det_fis_ac     > D_ipt_ac
               OR voec.automatismo = 'IRPEF_CON' AND D_con_fis != 0
               OR voec.automatismo = 'DED_GOD'   AND D_ded_fis_ac != D_ded_tot_ac
              )
        ;
 /* modifica del 05/01/2007 */
        INSERT INTO CALCOLI_CONTABILI
        ( ci, voce, sub
        , riferimento
        , input
        , estrazione
        , imp
        , ipn_p
        )
        SELECT
         P_ci, voec.codice, '*'
        , P_al
        , 'C'
        , 'AF'
        , greatest(0,D_det_fis_ac - D_ipt_ac)
        , 1
         FROM VOCI_ECONOMICHE voec
        WHERE voec.automatismo = 'DET_NGOD'
--          AND D_det_fis_ac     > D_ipt_ac
        ;
 /* fine modifica del 05/01/2007 */
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
     SELECT cat_fiscale
       INTO D_cat_fiscale
       FROM CLASSI_RAPPORTO
      WHERE codice = (SELECT rapporto FROM RAPPORTI_INDIVIDUALI
                     WHERE ci = P_ci
                   )
     ;
     IF P_anno >= 1998 AND D_cat_fiscale IN ('1','2','15','25') THEN
        BEGIN  --Emissione Voce di Addizionale IRPEF Regionale
              --mensile e progressiva
          P_stp := 'VOCI_FISCALI-06.1';
          D_alq_add_reg := 0;
          BEGIN
          SELECT aliquota_irpef_regionale
            INTO D_alq_add_reg
            FROM VALIDITA_FISCALE
           WHERE P_fin_ela BETWEEN dal
                               AND NVL(al,TO_DATE('3333333','j'))
          ;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN NULL;
          END;
          BEGIN
               D_ipn_tot_ac := nvl(D_ipn_tot_ac,0) - (nvl(D_ded_con_ac,0) + nvl(D_ded_fig_ac,0) + nvl(D_ded_alt_ac,0));
          SELECT decode(D_cond_add,1,NVL(x.aliquota_cond1,NVL(x.aliquota,0)),
                                   2,NVL(x.aliquota_cond2,NVL(x.aliquota,0)),
                                     NVL(x.aliquota,0))
                ,NVL(x.imposta,0),NVL(x.scaglione,0)
                ,NVL(regione,0)                                          -- 20/12/2005
            INTO D_alq_add_reg_aumento,D_imposta_reg,D_scaglione_reg
                ,D_regione
            FROM ADDIZIONALE_IRPEF_REGIONALE x
           WHERE nvl(x.scaglione,0) = (select max(nvl(scaglione,0))
                                  from ADDIZIONALE_IRPEF_REGIONALE
                                 where cod_regione = x.cod_regione
                                   and dal         = x.dal
                                   and nvl(scaglione,0) < D_ipn_tot_ac)
             and P_fin_ela BETWEEN x.dal
                               AND NVL(x.al,TO_DATE('3333333','j'))
             AND x.cod_regione =
                (SELECT regione
                   FROM comuni
                  WHERE (cod_provincia,cod_comune) =
                        (SELECT provincia_res,comune_res
                           FROM ANAGRAFICI
                          WHERE ni = (SELECT ni FROM RAPPORTI_INDIVIDUALI
                                       WHERE ci = P_ci)
                            AND p_fin_ela BETWEEN dal
                                              AND NVL(al,TO_DATE('3333333','j'))
                         ) )
          ;
          EXCEPTION
               WHEN NO_DATA_FOUND THEN
                 D_alq_add_reg_aumento := 0;
                 D_imposta_reg         := 0;
                 D_scaglione_reg       := 0;
                 D_regione             := 0;
          END;
          P_stp := 'VOCI_FISCALI-06.2';
/* 24/01/2005 Vecchia versione
          IF P_add_irpef IS NOT NULL THEN
            IF (D_ipt_ac - D_det_fis_ac) > 10.33 THEN   -- in lire erano 20000
                select  E_Round( D_ipn_tot_ac * D_alq_add_reg / 100 ,'I') +
                                 decode(D_cond_add,null,E_Round((D_ipn_tot_ac - D_scaglione_reg) *
                                                          D_alq_add_reg_aumento / 100,'I') + D_imposta_reg
                                                       ,E_Round(D_ipn_tot_ac * D_alq_add_reg_aumento / 100,'I')
                                       )
                                 - D_add_irpef_mp - D_add_reg_terzi
                  into D_add_irpef_mc
                  from DUAL;
            ELSE
               D_add_irpef_mc := (D_add_irpef_mp + D_add_reg_terzi) * -1;
            END IF;
          ELSIF P_add_irpefs IS NOT NULL THEN
            IF (D_ipt_ac - D_det_fis_ac) > 0 THEN
                select  E_Round( D_ipn_tot_ac * D_alq_add_reg / 100 ,'I') +
                                 decode(D_cond_add,null,E_Round((D_ipn_tot_ac - D_scaglione_reg) *
                                                          D_alq_add_reg_aumento / 100,'I') + D_imposta_reg
                                                       ,E_Round(D_ipn_tot_ac * D_alq_add_reg_aumento / 100,'I')
                                       )
                                 - D_add_irpef_mp - D_add_reg_terzi
                  into D_add_irpef_mc
                  from DUAL;
            ELSE
               D_add_irpef_mc := (D_add_irpef_mp + D_add_reg_terzi) * -1;
            END IF;
          ELSE
            D_add_irpef_mc := 0;
          END IF;
   fine vecchia versione - 24/01/2005 */
          IF P_add_irpef IS NOT NULL AND (D_ipt_ac - D_det_fis_ac) > 10.33 -- in lire erano 20000
          OR P_add_irpefs IS NOT NULL AND (D_ipt_ac - D_det_fis_ac) > 0 THEN
           IF D_regione = 7 THEN         -- Regione Veneto
              peccmore_veneto.cal_veneto ( P_ci, P_anno, P_fin_ela, D_ipn_tot_ac
                                         , D_alq_add_reg, D_alq_add_reg_aumento
                                         , D_add_irpef_mp, D_add_reg_terzi, P_imp_add_veneto, P_caso_particolare
                                         , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                                         );
              D_add_irpef_mc := P_imp_add_veneto;
           END IF;
           IF D_regione != 7 or P_caso_particolare = 0 THEN   -- Non e' un caso particolare del Veneto
             IF D_imposta_reg > 0 AND D_imposta_reg < 1 THEN     -- si tratta di un correttivo
                select  E_Round( D_ipn_tot_ac * D_alq_add_reg / 100 ,'I')
                    +  decode( D_cond_add
                             , null, E_Round( D_ipn_tot_ac * D_alq_add_reg_aumento / 100,'I')
                                   - E_Round( ( min(nvl(scaglione,0)) - D_ipn_tot_ac ) * D_imposta_reg ,'I')
                                   , E_Round(D_ipn_tot_ac * D_alq_add_reg_aumento / 100,'I')
                             )
                    - D_add_irpef_mp - D_add_reg_terzi
                  into D_add_irpef_mc
                  from ADDIZIONALE_IRPEF_REGIONALE
                 where cod_regione =
                      (SELECT regione
                         FROM comuni
                        WHERE (cod_provincia,cod_comune) =
                              (SELECT provincia_res,comune_res
                                 FROM ANAGRAFICI
                                WHERE ni = (SELECT ni FROM RAPPORTI_INDIVIDUALI
                                             WHERE ci = P_ci)
                                  AND p_fin_ela BETWEEN dal
                                                    AND NVL(al,TO_DATE('3333333','j'))
                              ) )
                   and P_fin_ela BETWEEN dal
                                 AND NVL(al,TO_DATE('3333333','j'))
                   and nvl(scaglione,0) > D_ipn_tot_ac
                ;
             ELSIF D_regione = 7 and D_imposta_reg = 1 THEN              -- Addizionale Regione Veneto Da 29001 a 29147
/* modifica del 04/01/2007 */
                   select round( (1 - (D_ipn_tot_ac / decode( p_anno
                                                            , 2006, 28739
                                                                  , 27748
                                                            )
/* fine modifica del 04/01/2007 */
                                      ) ) * 100,4)  *-1                  -- MOd. del 12/01/2007 (inversione del segno)
                     into D_alq_add_reg_veneto
                     from dual
                   ;
                   select  E_Round( D_ipn_tot_ac * D_alq_add_reg_veneto / 100 ,'I')
                         - D_add_irpef_mp - D_add_reg_terzi
                     into D_add_irpef_mc
                     from dual
                   ;
                   D_alq_add_reg         := D_alq_add_reg_veneto;
                   D_alq_add_reg_aumento := 0;
             ELSE
             select  E_Round( D_ipn_tot_ac * D_alq_add_reg / 100 ,'I')
                  +  decode( D_cond_add
                           , null, E_Round((D_ipn_tot_ac - D_scaglione_reg)*D_alq_add_reg_aumento / 100,'I')
                                   + D_imposta_reg
                                 , E_Round(D_ipn_tot_ac * D_alq_add_reg_aumento / 100,'I')
                           )
                  - D_add_irpef_mp - D_add_reg_terzi
               into D_add_irpef_mc
               from DUAL;
             END IF;                             -- si tratta di un correttivo
           END IF;                               -- Non e' un caso particolare del Veneto
          ELSIF P_add_irpef IS NOT NULL or P_add_irpefs IS NOT NULL THEN
             D_add_irpef_mc := (D_add_irpef_mp + D_add_reg_terzi) * -1;
          ELSE
             D_add_irpef_mc := 0;
          END IF;
         --Preleva valore progressivo precedente
             SELECT NVL(SUM(prco.p_tar),0)
               INTO D_ipn_add_irpef_mp
               FROM progressivi_contabili prco
              WHERE prco.ci       = P_ci
               AND prco.anno      = P_anno
               AND prco.mese      = P_mese
               AND prco.MENSILITA = P_mensilita
               AND prco.voce      = NVL(P_add_irpef,P_add_irpefs)
             ;
          INSERT INTO CALCOLI_CONTABILI
          ( ci, voce, sub
          , riferimento
          , input
          , estrazione
          , tar, qta, imp
          )
          SELECT   P_ci, NVL(P_add_irpef,P_add_irpefs), '*'
                , P_al
                , 'C'
                , 'AF'
                , D_ipn_tot_ac - D_ipn_add_irpef_mp
                , (D_alq_add_reg + D_alq_add_reg_aumento) * -1
                , D_add_irpef_mc * -1
            FROM dual
           WHERE NVL(P_add_irpef,P_add_irpefs) IS NOT NULL
          ;
          IF  P_mese       = 12          AND
              P_tipo      IN ( 'S', 'N' ) AND
              D_dimesso    = 'N'         AND
              D_cat_fiscale NOT IN ('15','25') AND
              P_ANNO      >= 1999       THEN
             INSERT INTO CALCOLI_CONTABILI
             ( ci, voce, sub
             , riferimento
             , input
             , estrazione
             , tar, qta, imp
             )
             SELECT   P_ci, P_add_reg_so, '*'
                   , P_al
                   , 'C'
                   , 'AF'
                   , D_ipn_tot_ac - D_ipn_add_irpef_mp
                   , (D_alq_add_reg + D_alq_add_reg_aumento)
                   , D_add_irpef_mc
               FROM dual
              WHERE P_add_reg_so IS NOT NULL
               AND D_add_irpef_mc >= 0
             ;
          END IF;
          INSERT INTO CALCOLI_CONTABILI
          ( ci, voce, sub
          , riferimento
          , input
          , estrazione
          , tar, qta, imp
          )
          SELECT   P_ci, P_add_irpefp, '*'
                , P_al
                , 'C'
                , 'AF'
                , D_ipn_tot_ac
                , (D_alq_add_reg + D_alq_add_reg_aumento) * -1
                , (D_add_irpef_mc+D_add_irpef_mp+D_add_reg_terzi)
            FROM dual
           WHERE P_add_irpefp IS NOT NULL
          ;
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;
    END IF;
     IF P_anno >= 1999 AND D_cat_fiscale IN ('1','2','15','25') THEN
dbms_output.put_line('chiamo comunale '||D_dimesso);     
        Peccmore_addizionali.add_com  -- Determinazione voci Fiscali
                  ( P_ci, P_al
                  , P_anno, P_mese, P_mensilita, P_fin_ela
                  , P_tipo, P_rate_addizionali
                  , P_imp_add_veneto, P_caso_particolare
                  , D_dimesso, D_cat_fiscale
                  , P_add_comu, P_add_comus, P_add_comup
                  , P_add_com_so
                  , D_ipn_tot_ac, D_ipt_ac, D_det_fis_ac
                  , D_add_comu_mp, D_add_com_terzi
                  , D_add_comu_mc
                  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                  );
--inizio commento wml
/*       BEGIN  --Emissione Voce di Addizionale IRPEF Comunale
              --mensile e progressiva
          P_stp := 'VOCI_FISCALI-06.3';
          D_alq_add_comu := 0;
          BEGIN
          SELECT aliquota_irpef_comunale
            INTO D_alq_add_comu
            FROM VALIDITA_FISCALE
           WHERE P_fin_ela BETWEEN dal
                             AND NVL(al,TO_DATE('3333333','j'))
          ;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN NULL;
          END;
          BEGIN
          SELECT NVL(D_alq_add_comu,0) + NVL(aliquota,0)
            INTO D_alq_add_comu
            FROM ADDIZIONALE_IRPEF_COMUNALE
           WHERE P_fin_ela BETWEEN dal
                             AND NVL(al,TO_DATE('3333333','j'))
             AND (cod_provincia,cod_comune) =
                (SELECT provincia_res,comune_res
                   FROM ANAGRAFICI anag
                  WHERE ni = (SELECT ni FROM RAPPORTI_INDIVIDUALI
                             WHERE ci = P_ci)
\* modifica del 25/01/2007 *\
                    AND (   P_anno <  2007 and p_fin_ela
                                               BETWEEN dal AND NVL(al,TO_DATE('3333333','j'))
           -- mod. introdotta dalla Legge Finanziaria 2007:
                         or P_anno >= 2007 and dal = (select min(dal) from anagrafici
                                                       where ni = anag.ni
                                                         and  NVL(al,TO_DATE('3333333','j')) >= to_date('0101'||P_anno,'ddmmyyyy')
                                                     )
                        )
                )
\* fine modifica del 25/01/2007 *\
          ;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN NULL;
          END;
          IF D_alq_add_comu IS NOT NULL THEN
             IF P_add_comu IS NOT NULL THEN
               IF (D_ipt_ac - D_det_fis_ac) > 10.33 THEN  -- in lire erano 20000
                 D_add_comu_mc :=
                 E_Round( D_ipn_tot_ac * D_alq_add_comu / 100 ,'I')
                      - D_add_comu_mp - D_add_com_terzi;
               ELSE
                 D_add_comu_mc := (D_add_comu_mp+D_add_com_terzi) *-1;
               END IF;
             ELSIF P_add_comus IS NOT NULL THEN
                 IF (D_ipt_ac - D_det_fis_ac) > 0 THEN
                   D_add_comu_mc :=
                   E_Round( D_ipn_tot_ac * D_alq_add_comu / 100 ,'I')
                       - D_add_comu_mp - D_add_com_terzi;
                 ELSE
                   D_add_comu_mc :=(D_add_comu_mp+D_add_com_terzi)*-1;
                 END IF;
             ELSE
               D_add_comu_mc := 0;
             END IF;
          ELSE
             D_add_comu_mc := (D_add_comu_mp+D_add_com_terzi) *-1;
          END IF;
          --Preleva valore progressivo precedente
             SELECT NVL(SUM(prco.p_tar),0)
               INTO D_ipn_add_comu_mp
               FROM progressivi_contabili prco
              WHERE prco.ci       = P_ci
               AND prco.anno      = P_anno
               AND prco.mese      = P_mese
               AND prco.MENSILITA = P_mensilita
               AND prco.voce      = NVL(P_add_comu,P_add_comus)
             ;
dbms_output.put_line('insert 1: '||NVL(P_add_comu,P_add_comus)||' D_add_comu_mc '||D_add_comu_mc * -1);
          INSERT INTO CALCOLI_CONTABILI
          ( ci, voce, sub
          , riferimento
          , input
          , estrazione
          , tar, qta, imp
          )
          SELECT   P_ci, NVL(P_add_comu,P_add_comus), '*'
                , P_al
                , 'C'
                , 'AF'
                , D_ipn_tot_ac - D_ipn_add_comu_mp
                , D_alq_add_comu * -1
                , D_add_comu_mc * -1
            FROM dual
           WHERE NVL(P_add_comu,P_add_comus) IS NOT NULL
          ;
          IF  P_mese       = 12          AND
              P_tipo      IN ( 'S', 'N' ) AND
              D_dimesso    = 'N'         AND
              D_cat_fiscale NOT IN ('15','25') AND
              P_ANNO      >= 1999       THEN
dbms_output.put_line('insert 2: '||P_add_com_so||' D_add_comu_mc '||D_add_comu_mc );
             INSERT INTO CALCOLI_CONTABILI
             ( ci, voce, sub
             , riferimento
             , input
             , estrazione
             , tar, qta, imp
             )
             SELECT   P_ci, P_add_com_so, '*'
                   , P_al
                   , 'C'
                   , 'AF'
                   , D_ipn_tot_ac - D_ipn_add_comu_mp
                   , D_alq_add_comu
                   , D_add_comu_mc
               FROM dual
              WHERE P_add_com_so IS NOT NULL
               AND D_add_comu_mc >= 0
             ;
          END IF;
dbms_output.put_line('insert 3: '||P_add_comup );
          INSERT INTO CALCOLI_CONTABILI
          ( ci, voce, sub
          , riferimento
          , input
          , estrazione
          , tar, qta, imp
          )
          SELECT   P_ci, P_add_comup, '*'
                , P_al
                , 'C'
                , 'AF'
                , D_ipn_tot_ac
                , D_alq_add_comu * -1
                , (D_add_comu_mc+D_add_comu_mp+D_add_com_terzi)
            FROM dual
           WHERE P_add_comup IS NOT NULL
          ;
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;*/
-- fine    
null;
     END IF;
  END IF;
            IF P_anno >= 2001 AND D_cat_fiscale IN ('1','2','15','25') THEN
               BEGIN  -- Emissione Voce di Addizionale IRPEF Provinciale
                      -- mensile e progressiva
                  P_stp := 'VOCI_FISCALI-06.4';
                  D_alq_add_prov := 0;
                  BEGIN
                  SELECT aliquota_irpef_provinciale
                    INTO D_alq_add_prov
                    FROM VALIDITA_FISCALE
                   WHERE P_fin_ela BETWEEN dal
                                       AND NVL(al,TO_DATE('3333333','j'))
                  ;
                  EXCEPTION
                     WHEN NO_DATA_FOUND THEN NULL;
                  END;
                  P_stp := 'VOCI_FISCALI-06.5';
                  IF P_add_prov IS NOT NULL THEN
                    IF (D_ipt_ac - D_det_fis_ac) > 10.33 THEN   -- in lire erano 20000
                       D_add_prov_mc :=
                       E_Round( D_ipn_tot_ac * D_alq_add_prov / 100 ,'I')
                            - D_add_prov_mp - D_add_pro_terzi;
                    ELSE
                       D_add_prov_mc := (D_add_prov_mp+D_add_pro_terzi) *-1;
                    END IF;
                  ELSIF P_add_provs IS NOT NULL THEN
                    IF (D_ipt_ac - D_det_fis_ac) > 0 THEN
                       D_add_prov_mc :=
                       E_Round( D_ipn_tot_ac * D_alq_add_prov / 100 ,'I')
                            - D_add_prov_mp - D_add_pro_terzi;
                    ELSE
                       D_add_prov_mc := (D_add_prov_mp+D_add_pro_terzi) *-1;
                    END IF;
                  ELSE
                    D_add_prov_mc := 0;
                  END IF;
                  -- Preleva valore progressivo precedente
                     SELECT NVL(SUM(prco.p_tar),0)
                       INTO D_ipn_add_prov_mp
                       FROM progressivi_contabili prco
                      WHERE prco.ci        = P_ci
                        AND prco.anno      = P_anno
                        AND prco.mese      = P_mese
                        AND prco.MENSILITA = P_mensilita
                        AND prco.voce      = NVL(P_add_prov,P_add_provs)
                     ;
                  INSERT INTO CALCOLI_CONTABILI
                  ( ci, voce, sub
                  , riferimento
                  , input
                  , estrazione
                  , tar, qta, imp
                  )
                  SELECT   P_ci, NVL(P_add_prov,P_add_provs), '*'
                         , P_al
                         , 'C'
                         , 'AF'
                         , D_ipn_tot_ac - D_ipn_add_prov_mp
                         , D_alq_add_prov * -1
                         , D_add_prov_mc * -1
                    FROM dual
                   WHERE NVL(P_add_prov,P_add_provs) IS NOT NULL
                  ;
                  IF  P_mese       = 12           AND
                      P_tipo      IN ( 'S', 'N' ) AND
                      D_dimesso    = 'N'          AND
                      D_cat_fiscale NOT IN ('15','25') AND
                      P_ANNO      >= 2001        THEN
                     INSERT INTO CALCOLI_CONTABILI
                     ( ci, voce, sub
                     , riferimento
                     , input
                     , estrazione
                     , tar, qta, imp
                     )
                     SELECT   P_ci, P_add_pro_so, '*'
                            , P_al
                            , 'C'
                            , 'AF'
                            , D_ipn_tot_ac - D_ipn_add_prov_mp
                            , D_alq_add_prov
                            , D_add_prov_mc
                       FROM dual
                      WHERE P_add_pro_so IS NOT NULL
                        AND D_add_prov_mc >= 0
                     ;
                  END IF;
                  INSERT INTO CALCOLI_CONTABILI
                  ( ci, voce, sub
                  , riferimento
                  , input
                  , estrazione
                  , tar, qta, imp
                  )
                  SELECT   P_ci, P_add_provp, '*'
                         , P_al
                         , 'C'
                         , 'AF'
                         , D_ipn_tot_ac
                         , D_alq_add_prov * -1
                         , (D_add_prov_mc+D_add_prov_mp+D_add_pro_terzi)
                    FROM dual
                   WHERE P_add_provp IS NOT NULL
                  ;
                  Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
               END;
           END IF;
  BEGIN  --Emissione addizionale IRPEF AP rateale
     IF P_tipo = 'N' AND P_mese <= P_rate_addizionali THEN
     P_stp := 'VOCI_FISCALI-06.6';
     SELECT NVL(SUM(imp),0)
       INTO D_imp_reg_so
       FROM MOVIMENTI_CONTABILI
      WHERE ci       = P_ci
        AND anno      = P_anno
        AND mese      = 1
        AND MENSILITA IN ('*AP','*R*')
        AND TO_CHAR(riferimento,'yyyy') >= P_anno-1
        AND voce      IN ( P_add_reg_so, P_add_reg_pa)
        AND sub       = '*'
     ;
     SELECT NVL(SUM(imp),0)
       INTO D_imp_pro_so
       FROM MOVIMENTI_CONTABILI
      WHERE ci        = P_ci
        AND anno      = P_anno
        AND mese      = 1
        AND MENSILITA IN ('*AP','*R*')
        AND TO_CHAR(riferimento,'yyyy') >= P_anno-1
        AND voce      IN ( P_add_pro_so, P_add_pro_pa)
        AND sub       = '*'
     ;
     BEGIN  --Preleva valore progressivo precedente
        SELECT NVL(SUM(prco.p_imp),0)
         INTO D_imp_reg_ra_mp
         FROM progressivi_contabili prco
        WHERE prco.ci       = P_ci
          AND prco.anno      = P_anno
          AND prco.mese      = P_mese
          AND prco.MENSILITA = P_mensilita
          AND prco.voce      = P_add_reg_ra
        ;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
              D_imp_reg_ra_mp := 0;
     END;
     BEGIN  --Preleva valore del mese corrente
        SELECT NVL(SUM(caco.imp),0)
         INTO D_imp_reg_ra
         FROM CALCOLI_CONTABILI caco
        WHERE caco.ci       = P_ci
          AND caco.voce      = P_add_reg_ra
        ;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
             D_imp_reg_ra := 0;
     END;
            BEGIN  -- Preleva valore progressivo precedente
               SELECT NVL(SUM(prco.p_imp),0)
                 INTO D_imp_pro_ra_mp
                 FROM progressivi_contabili prco
                WHERE prco.ci        = P_ci
                  AND prco.anno      = P_anno
                  AND prco.mese      = P_mese
                  AND prco.MENSILITA = P_mensilita
                  AND prco.voce      = P_add_pro_ra
               ;
            EXCEPTION
                WHEN NO_DATA_FOUND THEN
                      D_imp_pro_ra_mp := 0;
            END;
            BEGIN  -- Preleva valore del mese corrente
               SELECT NVL(SUM(caco.imp),0)
                 INTO D_imp_pro_ra
                 FROM CALCOLI_CONTABILI caco
                WHERE caco.ci        = P_ci
                  AND caco.voce      = P_add_pro_ra
               ;
            EXCEPTION
               WHEN NO_DATA_FOUND THEN
                     D_imp_pro_ra := 0;
            END;
            
--
--  RATE COMUNALI
--
dbms_output.put_line(' D_dimesso '||D_dimesso||' P_mese '||P_mese||' P_rate_addizionali '||P_rate_addizionali);
          IF P_anno <= 2007 THEN
             Peccmore_addizionali.rate_com  -- Determinazione voci Fiscali
                      ( P_ci, P_al
                      , P_anno, P_mese, P_mensilita
                      , P_rate_addizionali
                      , P_add_com_ra, P_add_com_pa, P_add_com_so, D_dimesso
                      , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                  );
          END IF;
/*
     BEGIN  --Preleva valore progressivo precedente
        SELECT NVL(SUM(prco.p_imp),0)
         INTO D_imp_com_ra_mp
         FROM progressivi_contabili prco
        WHERE prco.ci       = P_ci
          AND prco.anno      = P_anno
          AND prco.mese      = P_mese
          AND prco.MENSILITA = P_mensilita
          AND prco.voce      = P_add_com_ra
        ;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
              D_imp_com_ra_mp := 0;
     END;
     BEGIN  --Preleva valore del mese corrente
        SELECT NVL(SUM(caco.imp),0)
         INTO D_imp_com_ra
         FROM CALCOLI_CONTABILI caco
        WHERE caco.ci       = P_ci
          AND caco.voce      = P_add_com_ra
        ;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
             D_imp_com_ra := 0;
     END;
*/     
     IF D_dimesso = 'S' OR P_mese = P_rate_addizionali THEN
        INSERT INTO CALCOLI_CONTABILI
        ( ci, voce, sub
        , riferimento
        , input
        , estrazione
        , imp
        )
        SELECT   P_ci, P_add_reg_ra, '*'
              , P_al
              , 'C'
              , 'AF'
              , (D_imp_reg_so + D_imp_reg_ra_mp + D_imp_reg_ra) * -1
         FROM dual
        WHERE P_add_reg_ra IS NOT NULL
        ;
        INSERT INTO CALCOLI_CONTABILI
        ( ci, voce, sub
        , riferimento
        , input
        , estrazione
        , imp
        )
        SELECT   P_ci, P_add_pro_ra, '*'
               , P_al
               , 'C'
               , 'AF'
               , (D_imp_pro_so + D_imp_pro_ra_mp + D_imp_pro_ra) * -1
          FROM dual
         WHERE P_add_pro_ra IS NOT NULL
        ;
/*
        INSERT INTO CALCOLI_CONTABILI
        ( ci, voce, sub
        , riferimento
        , input
        , estrazione
        , imp
        )
        SELECT   P_ci, P_add_com_ra, '*'
              , P_al
              , 'C'
              , 'AF'
              , (D_imp_com_so + D_imp_com_ra_mp + D_imp_com_ra) * -1
         FROM dual
        WHERE P_add_com_ra IS NOT NULL
        ;
*/        
     ELSE
        IF D_imp_reg_so + D_imp_reg_ra_mp + D_imp_reg_ra != 0 THEN
          INSERT INTO CALCOLI_CONTABILI
          ( ci, voce, sub
          , riferimento
          , input
          , estrazione
          , imp
          )
          SELECT   P_ci, P_add_reg_ra, '*'
                , P_al
                , 'C'
                , 'AF'
                , e_ROUND(D_imp_reg_so * -1 / P_rate_addizionali, 'I')
            FROM dual
           WHERE P_add_reg_ra IS NOT NULL
             AND NOT EXISTS
                   (SELECT 'x'
                      FROM CALCOLI_CONTABILI
                     WHERE voce = P_add_reg_ra
                      AND sub  = '*'
                      AND ci   = P_ci
                   )
          ;
        END IF;
        IF D_imp_pro_so + D_imp_pro_ra_mp + D_imp_pro_ra != 0 THEN
           INSERT INTO CALCOLI_CONTABILI
                 ( ci, voce, sub
                 , riferimento
                 , input
                 , estrazione
                 , imp
                 )
           SELECT   P_ci, P_add_pro_ra, '*'
                  , P_al
                  , 'C'
                  , 'AF'
                  , e_ROUND(D_imp_pro_so * -1 / P_rate_addizionali,'I')
               FROM dual
              WHERE P_add_pro_ra IS NOT NULL
                AND NOT EXISTS
                   (SELECT 'x'
                      FROM CALCOLI_CONTABILI
                     WHERE voce = P_add_pro_ra
                       AND sub  = '*'
                       AND ci   = P_ci
                   )
           ;
        END IF;
/*        
        IF D_imp_com_so + D_imp_com_ra_mp + D_imp_com_ra != 0 THEN
          INSERT INTO CALCOLI_CONTABILI
          ( ci, voce, sub
          , riferimento
          , input
          , estrazione
          , imp
          )
          SELECT   P_ci, P_add_com_ra, '*'
                , P_al
                , 'C'
                , 'AF'
                , e_ROUND(D_imp_com_so * -1 / P_rate_addizionali,'I')
            FROM dual
           WHERE P_add_com_ra IS NOT NULL
             AND NOT EXISTS
                   (SELECT 'x'
                      FROM CALCOLI_CONTABILI
                     WHERE voce = P_add_com_ra
                      AND sub  = '*'
                      AND ci   = P_ci
                   )
          ;
        END IF;
*/
     END IF;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END IF;
  END;
-- xxx
  IF D_DECEDUTO is not null THEN
    BEGIN
      P_stp := 'VOCI_FISCALI-06.7.1';
      select nvl(mofi.lor_acc,0)
           + nvl(mofi.lor_liq,0)
           + nvl(mofi.lor_acc_2000,0)
           , nvl(mofi.ipt_liq,0)
           , nvl(mofi.con_fis,0)
        into D_LIQUIDAZIONE
           , D_RITENUTA_LIQUIDAZIONE
           , D_CONGUAGLIO
        from movimenti_fiscali mofi
       where mofi.ci        = P_ci
         and mofi.anno      = P_anno
         and mofi.mese      = P_mese
         and mofi.MENSILITA = P_mensilita
      ;
    EXCEPTION
      WHEN NO_DATA_FOUND THEN
        D_LIQUIDAZIONE := 0;
        D_RITENUTA_LIQUIDAZIONE := 0;
        D_CONGUAGLIO := 0;
    END;
    BEGIN
        D_ADD_REGIONALE   :=  D_add_irpef_mc;
        D_ADD_PROVINCIALE :=  D_add_prov_mc;
        D_ADD_COMUNALE    :=  D_add_comu_mc;
-- dbms_output.put_line('Add.Reg. '||to_char(D_ADD_REGIONALE));
    END;
    P_stp := 'VOCI_FISCALI-06.7.2';
    insert into calcoli_contabili
              ( ci, voce, sub
              , riferimento
              , arr
              , input
              , estrazione
              , imp
              )
         select P_ci, voec.codice, '*'
              , P_al
              , ''
              , 'C'
              , voec.classe||voec.estrazione
              , decode( voec.specifica
                      , 'SOM_ERE_LI', D_LIQUIDAZIONE * -1
                      , 'SOM_ERE_RL', D_RITENUTA_LIQUIDAZIONE
                      , 'SOM_ERE_CO', D_con_fis * -1
                      , 'ADD_ERE_C' , D_ADD_COMUNALE
                      , 'ADD_ERE_P' , D_ADD_PROVINCIALE
                      , 'ADD_ERE_R' , D_ADD_REGIONALE
                      ) imp
          from contabilita_voce    covo
             , voci_economiche     voec
         where voec.specifica in ('SOM_ERE_LI', 'SOM_ERE_RL',
                                  'SOM_ERE_CO', 'ADD_ERE_C',
                                  'ADD_ERE_P', 'ADD_ERE_R')
           and covo.voce      = voec.codice||''
           and covo.sub       = '*'
           and P_fin_ela     between nvl(covo.dal,to_date(2222222,'j'))
                                 and nvl(covo.al ,to_date(3333333,'j'))
           and not exists
              (select 'x'
                 from calcoli_contabili
                where voce = voec.codice
                  and sub  = '*'
                  and arr is null
                  and ci   = P_ci
              )
    ;
    peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END IF;
  BEGIN  --Aggiornamento Aliq., Imposta Annuale e Conguaglio del mese
     P_stp := 'VOCI_FISCALI-07';
     UPDATE MOVIMENTI_FISCALI mofi
        SET alq_ac  = D_alq_ac
         , ipt_ac  = D_ipt_ac
         , con_fis = NVL(D_con_fis,0)
         , add_irpef = D_add_irpef_mc
         , add_irpef_provinciale = D_add_prov_mc
         , add_irpef_comunale = D_add_comu_mc
     WHERE ci       = P_ci
       AND anno      = P_anno
       AND mese      = P_mese
       AND MENSILITA = P_mensilita
     ;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  --Emissione della voce di ARROTONDAMENTO PRECEDENTE
     P_stp := 'VOCI_FISCALI-08';
     INSERT INTO CALCOLI_CONTABILI
     ( ci, voce, sub
     , riferimento
     , input
     , estrazione
     , imp
     )
     SELECT P_ci, voec.codice, '*'
         , P_al
         , 'C'
         , 'N'
         , SUM(moco.imp) * -1
       FROM VOCI_ECONOMICHE voec
         , MOVIMENTI_CONTABILI moco
      WHERE voec.automatismo = 'ARR_PRE'
        AND moco.ci         = P_ci
        AND moco.anno       = P_ult_anno_moco
        AND moco.mese       = P_ult_mese_moco
        AND moco.MENSILITA   = P_ult_mens_moco
        AND moco.imp       != 0
        AND moco.voce =
          (SELECT MAX(codice)
             FROM VOCI_ECONOMICHE
            WHERE automatismo LIKE 'ARR_ATT%'
          )
      GROUP BY voec.codice
     ;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  --Emissione della voce di TOTALE COMPETENZE
        --TOTALE TRATTENUTE
        --NETTO CEDOLINO
     P_stp := 'VOCI_FISCALI-09';
     INSERT INTO CALCOLI_CONTABILI
     ( ci, voce, sub
     , riferimento
     , input
     , estrazione
     , imp
     )
     SELECT P_ci, voec.codice, '*'
         , P_al
         , 'C'
         , 'AF'
         , SUM(caco.imp)
       FROM VOCI_ECONOMICHE voec
         , VOCI_ECONOMICHE voecc
         , CALCOLI_CONTABILI caco
      WHERE (   voec.automatismo = 'COMP' AND voecc.tipo   = 'C'
            OR voec.automatismo = 'TRAT' AND voecc.tipo   = 'T'
            OR voec.automatismo = 'NETTO'
           )
        AND voecc.tipo  IN ('C','T')
        AND voecc.codice = caco.voce||''
        AND caco.ci      = P_ci
      GROUP BY voec.codice
     ;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  Peccmore.VOCI_TOTALE  --Totalizzazione delle Voci Automatiche Fiscali
     ( P_ci, P_al, P_fin_ela, P_tipo, 'AF'
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     Peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
END;
/
