CREATE OR REPLACE PACKAGE peccmocp1 IS
/******************************************************************************
 NOME:        PECCMOCP1
 DESCRIZIONE: Calcolo del Bilancio di Previsione         
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1.1  28/04/2004 MF     Attivazione procedure peccmocp_ritenuta.scorporo
                        Voci termine : in caso di voci di ritenuta raggruppa
                        anche per qta.
                        Trasferimento in output anche del TIPO delibera.
 1.2  07/07/2004 NN     In VOCI_TERMINE non raggruppa per competenza in caso
                        di voci con specifica RGA13M.
 1.3  23/07/2004 AM     Estrazione data di riferimento da PERE e non da RAGI
 1.4  27/10/2004 AM     Passa in movimenti_contabili_previsione anche le variabili
                        (che per il bil.prev. provengono da inre_bp)
 1.5  28/06/2005 CB     Gestione codice_siope
 1.6  25/09/2006 MS     Trattamento nuovi campi automatismi di INEX in insert ( Att.17266 )
 1.7  24/10/2006 MS     Correzione automatismi di INEX in insert ( Att.17266.1 )
******************************************************************************/

revisione varchar2(30) := '7 del 24/10/2006';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

  PROCEDURE calcolo_ci
( P_ci         NUMBER
, P_ni         NUMBER
, P_al         DATE    -- Data di Termine o Fine Anno
, P_base_ratei  VARCHAR2
, P_base_det    VARCHAR2
, P_mesi_irpef  NUMBER
, P_base_cong   VARCHAR2
, P_scad_cong   VARCHAR2
, P_rest_cong   VARCHAR2
, P_rate_addizionali NUMBER
, P_detrazioni_ap    VARCHAR2
, P_anno       NUMBER
, P_mese       NUMBER
, P_mensilita   VARCHAR2
, P_fin_ela     DATE
, P_tipo       VARCHAR2
, P_mens_codice VARCHAR2
, P_periodo     VARCHAR2
--  Voci parametriche
, P_ass_fam     VARCHAR2
, P_det_con     VARCHAR2
, P_det_fig     VARCHAR2
, P_det_alt     VARCHAR2
, P_det_spe     VARCHAR2
, P_det_ult     VARCHAR2
, P_riv_tfr     VARCHAR2
, P_ret_tfr     VARCHAR2
, P_qta_tfr     VARCHAR2
, P_rit_tfr     VARCHAR2
, P_rit_riv     VARCHAR2
, P_lor_tfr     VARCHAR2
, P_lor_tfr_00  VARCHAR2
, P_lor_riv     VARCHAR2
, P_cal_anz     VARCHAR2
, P_comp       VARCHAR2
, P_trat       VARCHAR2
, P_netto       VARCHAR2
, P_add_irpef   VARCHAR2
, P_add_irpefs  VARCHAR2
, P_add_irpefp  VARCHAR2
, P_add_reg_so  VARCHAR2
, P_add_reg_pa  VARCHAR2
, P_add_reg_ra  VARCHAR2
, P_add_prov    VARCHAR2
, P_add_provs   VARCHAR2
, P_add_provp   VARCHAR2
, P_add_pro_so  VARCHAR2
, P_add_pro_pa  VARCHAR2
, P_add_pro_ra  VARCHAR2
, P_add_comu    VARCHAR2
, P_add_comus   VARCHAR2
, P_add_comup   VARCHAR2
, P_add_com_so  VARCHAR2
, P_add_com_pa  VARCHAR2
, P_add_com_ra  VARCHAR2
-- Parametri per Trace
, p_trc    IN     NUMBER     -- Tipo di Trace
, p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
, p_pas    IN     NUMBER     -- Numero di Passo procedurale
, p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
, p_stp    IN OUT VARCHAR2       -- Step elaborato
, p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
);
PROCEDURE voci_termine
(
 p_ci        NUMBER
,p_anno       NUMBER
,p_mese       NUMBER
,p_mensilita  VARCHAR2
,p_fin_ela    DATE
,p_tipo       VARCHAR2
-- Parametri per Trace
,p_trc    IN     NUMBER     -- Tipo di Trace
,p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
);
PROCEDURE voci_inizio
(
 p_ci        NUMBER
,p_anno       NUMBER
,p_mese       NUMBER
,p_mensilita  VARCHAR2
,p_fin_ela    DATE
,p_ricalcolo  IN OUT VARCHAR2
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
CREATE OR REPLACE PACKAGE BODY Peccmocp1 IS

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

PROCEDURE calcolo_ci
( P_ci         NUMBER
, P_ni         NUMBER
, P_al         DATE    -- Data di Termine o Fine Anno
, P_base_ratei  VARCHAR2
, P_base_det    VARCHAR2
, P_mesi_irpef  NUMBER
, P_base_cong   VARCHAR2
, P_scad_cong   VARCHAR2
, P_rest_cong   VARCHAR2
, P_rate_addizionali NUMBER
, P_detrazioni_ap    VARCHAR2
, P_anno       NUMBER
, P_mese       NUMBER
, P_mensilita   VARCHAR2
, P_fin_ela     DATE
, P_tipo       VARCHAR2
, P_mens_codice VARCHAR2
, P_periodo     VARCHAR2
--  Voci parametriche
, P_ass_fam     VARCHAR2
, P_det_con     VARCHAR2
, P_det_fig     VARCHAR2
, P_det_alt     VARCHAR2
, P_det_spe     VARCHAR2
, P_det_ult     VARCHAR2
, P_riv_tfr     VARCHAR2
, P_ret_tfr     VARCHAR2
, P_qta_tfr     VARCHAR2
, P_rit_tfr     VARCHAR2
, P_rit_riv     VARCHAR2
, P_lor_tfr     VARCHAR2
, P_lor_tfr_00  VARCHAR2
, P_lor_riv     VARCHAR2
, P_cal_anz     VARCHAR2
, P_comp       VARCHAR2
, P_trat       VARCHAR2
, P_netto       VARCHAR2
, P_add_irpef   VARCHAR2
, P_add_irpefs  VARCHAR2
, P_add_irpefp  VARCHAR2
, P_add_reg_so  VARCHAR2
, P_add_reg_pa  VARCHAR2
, P_add_reg_ra  VARCHAR2
, P_add_prov    VARCHAR2
, P_add_provs   VARCHAR2
, P_add_provp   VARCHAR2
, P_add_pro_so  VARCHAR2
, P_add_pro_pa  VARCHAR2
, P_add_pro_ra  VARCHAR2
, P_add_comu    VARCHAR2
, P_add_comus   VARCHAR2
, P_add_comup   VARCHAR2
, P_add_com_so  VARCHAR2
, P_add_com_pa  VARCHAR2
, P_add_com_ra  VARCHAR2
-- Parametri per Trace
, p_trc    IN     NUMBER     -- Tipo di Trace
, p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
, p_pas    IN     NUMBER     -- Numero di Passo procedurale
, p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
, p_stp    IN OUT VARCHAR2       -- Step elaborato
, p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
) IS
form_trigger_failure EXCEPTION;
D_tim_pro         VARCHAR2(5);    -- Time impiegato in secondi per Procedure
D_spese           RAPPORTI_RETRIBUTIVI.spese%TYPE;
D_tipo_ulteriori  RAPPORTI_RETRIBUTIVI.tipo_ulteriori%TYPE;
D_ulteriori       RAPPORTI_RETRIBUTIVI.ulteriori%TYPE;
D_posizione_inail RAPPORTI_RETRIBUTIVI.posizione_inail%TYPE;
D_data_inail      RAPPORTI_RETRIBUTIVI.data_inail%TYPE;
D_istituto        RAPPORTI_RETRIBUTIVI.istituto%TYPE;
D_sportello       RAPPORTI_RETRIBUTIVI.sportello%TYPE;
D_conguaglio      NUMBER;
D_ult_mese_mofi   MOVIMENTI_FISCALI.mese%TYPE;
D_ult_mens_mofi   MOVIMENTI_FISCALI.MENSILITA%TYPE;
D_ult_anno_moco   MOVIMENTI_FISCALI.anno%TYPE;
D_ult_mese_moco   MOVIMENTI_FISCALI.mese%TYPE;
D_ult_mens_moco   MOVIMENTI_FISCALI.MENSILITA%TYPE;
D_cong_ind        NUMBER;
D_d_cong          DATE;
D_d_cong_al       DATE;
D_ricalcolo       VARCHAR2(1);
/* modifica del 23/07/2004 */
D_al              DATE;
/* fine modifica del 23/07/2004 */
BEGIN
  BEGIN  -- Acquisizione dati retributivi individuali
     P_stp := 'CALCOLO_CI-01';
     SELECT rare.spese
         , rare.ulteriori
         , rare.tipo_ulteriori
         , rare.posizione_inail
         , rare.data_inail
         , rare.istituto
         , rare.sportello
       INTO D_spese
         , D_ulteriori
         , D_tipo_ulteriori
         , D_posizione_inail
         , D_data_inail
         , D_istituto
         , D_sportello
       FROM RAPPORTI_RETRIBUTIVI rare
      WHERE rare.ci    = P_ci
     ;
     Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
         D_spese := 1; -- per  detrazioni su posti vacanti senza rare
  END;
  BEGIN  -- Preleva l'indicazione di conguaglio individuale
     P_stp := 'CALCOLO_CI-02';
     SELECT NVL( MAX( conguaglio), 0 )
         , MAX
           ( DECODE
             ( DECODE( conguaglio
                     , 7, 3
                       , conguaglio
                     )
             , 3, 0
               , DECODE( TO_NUMBER(TO_CHAR(al,'yyyy'))
                      , anno, DECODE( TO_NUMBER(TO_CHAR(al,'yyyymm'))
                                   , TO_NUMBER( TO_CHAR(P_anno)||
                                      LPAD(TO_CHAR(P_mese),2,'0'))
                                          , 0
                                          , 1
                                   )
                            , 2
                      )
             )
           )
         , MIN(
  DECODE( TO_CHAR(pere.gg_con)||TO_CHAR(pere.gg_lav)
        ,'01',TO_DATE('01/'||TO_CHAR(P_fin_ela,'mm/yyyy'),'dd/mm/yyyy')
             ,TO_DATE('01/'||TO_CHAR(al,'mm/yyyy'),'dd/mm/yyyy')
        )
              )
/* modifica del 23/07/2004 */
          , nvl(max(decode( pere.competenza
                          , 'P', to_date(null)
                               , decode( pere.tipo
                                       , 'F', to_date(null)
                                            , pere.al
                                       )
                          )
                   )
               , P_al) -- Se per errore da pere ritornasse null, assumiano data di ragi o fine mese
       INTO D_conguaglio
          , D_cong_ind
          , D_d_cong
          , D_al
/* fine modifica del 23/07/2004 */
       FROM PERIODI_RETRIBUTIVI_BP pere
      WHERE ci      = P_ci
        AND periodo = P_fin_ela
        AND competenza IN ('P','C','A')
     ;
     --
     -- Verifica se caso di conguaglio Competenze Accessorie
     --
/* Il calcolo Periodi_Retributivi attiva "conguaglio" in funzione
  del tipo di conguaglio competenze (Fisse/Accessorie) richiesto.
  Il flag "cong_ind" di Periodi_Giuridici viene dedotto dai Periodi
  Retributivi per considerare il caso di ricalcolo movimenti senza
  rideterminazione dei periodi retributivi.
  D_conguaglio: Indicatore di Conguaglio Fiscale
               0 = No Conguaglio
               1 = Cong.Fiscale per assenza
               2 = Cong.Fiscale per termine nel mese
               3 = Cong.Fiscale per ripresa x arretrati
      ( n + 4 ) Modificato per Conguaglio Competenze Accessorie
      ( 0 + 4 ) 4 = No Conguaglio           + Cong.Comp.Acc.
      ( 1 + 4 ) 5 = Cong.Fiscale per assenza + Cong.Comp.Acc.
      ( 2 + 4 ) 6 = Cong.Fiscale per termine + Cong.Comp.Acc.
      ( 3 + 4 ) 7 = Cong.Fiscale per ripresa + Cong.Comp.Acc.
  D_cong_ind  : Indicatore di Conguaglio Giuridico
               0 = No Conguaglio
               1 = Anno Prec. a fiscale AP               (  X  )
               2 = Anno Prec. a fiscale AC               ( AC  )
      ( n + 2 ) Da Modificare per Conguaglio Competenze Accessorie
      ( 1 + 2 ) 3 = Anno Prec. a fiscale AP + Cong.Comp.Acc.(CA/AP)
      ( 2 + 2 ) 4 = Anno Prec. a fiscale AC + Cong.Comp.Acc.(CA/AC)
*/
     IF D_conguaglio > 3 THEN
        D_conguaglio := D_conguaglio - 4;
        D_cong_ind := D_cong_ind + 2;
     END IF;
     Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     --
     -- Azzera informazione di Dimesso in Mensilita` Aggiuntiva
     --
     IF  P_tipo       = 'A'  /* MAI POSSIBILE IN *PREVISIONE* */
     AND D_conguaglio = 2
     THEN
        D_conguaglio := 0;
     END IF;
  END;
  BEGIN  -- Preleva ultima mensilita` elaborata
     P_stp := 'CALCOLO_CI-03';
     SELECT mese
         , MENSILITA
       INTO D_ult_mese_mofi
         , D_ult_mens_mofi
       FROM MOVIMENTI_FISCALI
      WHERE ci   = P_ci
        AND anno = P_anno
        AND LPAD(TO_CHAR(mese),2)||MENSILITA =
          (SELECT MAX(LPAD(TO_CHAR(mese),2)||MENSILITA)
             FROM MOVIMENTI_FISCALI
            WHERE ci   = P_ci
              AND anno = P_anno
              AND MENSILITA NOT LIKE '*%'
              AND LPAD(TO_CHAR(mese),2)||MENSILITA
                 <
                 LPAD(TO_CHAR(P_mese),2)||P_mensilita
          )
     ;
     D_ult_anno_moco := P_anno;
     D_ult_mese_moco := D_ult_mese_mofi;
     D_ult_mens_moco := D_ult_mens_mofi;
     Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  EXCEPTION
     WHEN NO_DATA_FOUND THEN
        D_ult_mese_mofi := 0;
        D_ult_mens_mofi := NULL;
        BEGIN  -- Ultima mensilita di anno precedente
          SELECT anno
               , mese
               , MENSILITA
            INTO D_ult_anno_moco
               , D_ult_mese_moco
               , D_ult_mens_moco
            FROM MOVIMENTI_FISCALI
           WHERE ci   = P_ci
             AND anno = P_anno - 1
             AND LPAD(TO_CHAR(mese),2)||MENSILITA =
               (SELECT MAX(LPAD(TO_CHAR(mese),2)||MENSILITA)
                  FROM MOVIMENTI_FISCALI
                 WHERE ci     = P_ci
                   AND anno   = P_anno - 1
                   AND mese+0 = 12
                   AND MENSILITA NOT LIKE '*%'
               )
          ;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
               D_ult_anno_moco := P_anno - 1;
               D_ult_mese_moco := 12;
               D_ult_mens_moco := 'DIC';
        END;
  END;
  D_tim_pro := TO_CHAR(SYSDATE,'sssss');
  VOCI_INIZIO  -- Operazioni di Inizio Retribuzione
     ( P_ci, P_anno, P_mese, P_mensilita, P_fin_ela, D_ricalcolo
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_INIZIO-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp2.VOCI_AUTOMATICHE  -- Determinazione voci Automatiche iniziali
     ( P_ci, D_al
          , P_anno, P_mese, P_mensilita, P_fin_ela
          , P_tipo, D_conguaglio
          , P_base_ratei, P_base_det
          , D_spese, D_ulteriori, D_tipo_ulteriori
          , P_ass_fam
          , P_det_con, P_det_fig, P_det_alt, P_det_spe, P_det_ult
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_AUTOMATICHE-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp4.VOCI_RETRIBUTIVE  -- Emissione Voci Retributive
     ( P_ci, D_ult_anno_moco, D_al, D_cong_ind, D_d_cong, D_d_cong_al
          , P_anno, P_mese, P_mensilita, P_fin_ela
          , P_tipo, D_conguaglio, P_mens_codice, P_periodo, D_ricalcolo
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_RETRIBUTIVE-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp5.VOCI_ESTRAZIONE  -- Emissione Voci a Estrazione Condizionata
     ( P_ci, D_ult_anno_moco, D_al, D_cong_ind, D_d_cong
          , P_anno, P_mese, P_mensilita, P_fin_ela
          , P_tipo, D_conguaglio, P_mens_codice, P_periodo
          , D_posizione_inail, D_data_inail
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_ESTRAZIONE-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp6.VOCI_CALCOLO  -- Determinazione voci a CALCOLO su Basi
     ( P_ci, D_al
          , P_anno, P_mese, P_mensilita, P_fin_ela, D_d_cong
          , P_tipo, 'CB', P_base_ratei
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_CALCOLO_B-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp9.VOCI_RITENUTA  -- Determinazione voci a RITENUTA su Basi
     ( P_ci, D_ult_anno_moco, D_al
          , P_anno, P_mese, P_mensilita, P_fin_ela
          , P_tipo, D_conguaglio, P_mens_codice, P_periodo, 'RB'
          , D_posizione_inail, D_data_inail
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_RITENUTA_B-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp6.VOCI_QUANTITA  -- Determinazione voci a QUANTITA' da valorizzare
     ( P_ci, D_al
          , P_anno, P_mese, P_mensilita, P_fin_ela
          , P_tipo, P_base_ratei
          , D_ult_anno_moco, D_cong_ind, D_d_cong
          , D_conguaglio, P_mens_codice, P_periodo
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_QUANTITA-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp6.VOCI_CALCOLO  -- Determinazione voci a CALCOLO su Calcolo
     ( P_ci, D_al
          , P_anno, P_mese, P_mensilita, P_fin_ela, D_d_cong
          , P_tipo, 'CC', P_base_ratei
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_CALCOLO_C-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp9.VOCI_RITENUTA  -- Determinazione voci a RITENUTA su Calcolo
     ( P_ci, D_ult_anno_moco, D_al
          , P_anno, P_mese, P_mensilita, P_fin_ela
          , P_tipo, D_conguaglio, P_mens_codice, P_periodo, 'RC'
          , D_posizione_inail, D_data_inail
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_RITENUTA_C-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp8.VOCI_IMPONIBILE -- Determinazione degli Imponibili
     ( P_ci, D_ult_anno_moco, D_al
          , P_anno, P_mese, P_mensilita, P_fin_ela
          , P_tipo, D_conguaglio, P_mens_codice, P_periodo
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_IMPONIBILE-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp6.VOCI_CALCOLO  -- Determinazione voci a CALCOLO su Imponibili
     ( P_ci, D_al
          , P_anno, P_mese, P_mensilita, P_fin_ela, D_d_cong
          , P_tipo, 'CI', P_base_ratei
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_CALCOLO_I-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp9.VOCI_RITENUTA  -- Determinazione voci a RITENUTA su Imponibili
     ( P_ci, D_ult_anno_moco, D_al
          , P_anno, P_mese, P_mensilita, P_fin_ela
          , P_tipo, D_conguaglio, P_mens_codice, P_periodo, 'RI'
          , D_posizione_inail, D_data_inail
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_RITENUTA_I-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp8.VOCI_TFR
     ( P_ci, D_al
           , P_anno, P_mese, P_mensilita, P_fin_ela
           , P_riv_tfr, P_ret_tfr, P_qta_tfr, P_rit_tfr, P_rit_riv
           , P_lor_tfr, P_lor_tfr_00, P_lor_riv
           , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_TFR-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp6.VOCI_CALCOLO  -- Determinazione voci a CALCOLO su Ritenute
     ( P_ci, D_al
          , P_anno, P_mese, P_mensilita, P_fin_ela, D_d_cong
          , P_tipo, 'CR', P_base_ratei
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
      );
  P_stp := 'VOCI_CALCOLO_R-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp9.VOCI_RITENUTA  -- Determinazione voci a RITENUTA su Ritenute
     ( P_ci, D_ult_anno_moco, D_al
          , P_anno, P_mese, P_mensilita, P_fin_ela
          , P_tipo, D_conguaglio, P_mens_codice, P_periodo, 'RR'
          , D_posizione_inail, D_data_inail
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_RITENUTA_R-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp10.VOCI_FISCALI  -- Determinazione voci Fiscali
     ( P_ci, P_ni, D_al
           , P_anno, P_mese, P_mensilita, P_fin_ela
           , P_tipo, D_conguaglio
           , P_base_ratei, P_base_det
           , P_mesi_irpef, P_base_cong, P_scad_cong, P_rest_cong
           , P_rate_addizionali, P_detrazioni_ap
           , D_spese, D_ulteriori, D_tipo_ulteriori
           , D_ult_mese_mofi, D_ult_mens_mofi
           , D_ult_anno_moco, D_ult_mese_moco, D_ult_mens_moco
           , P_det_con, P_det_fig, P_det_alt, P_det_spe, P_det_ult
           , P_riv_tfr, P_ret_tfr, P_qta_tfr, P_rit_tfr, P_rit_riv
           , P_cal_anz
           , P_add_irpef, P_add_irpefs, P_add_irpefp
           , P_add_reg_so, P_add_reg_pa, P_add_reg_ra
           , P_add_prov, P_add_provs, P_add_provp
           , P_add_pro_so, P_add_pro_pa, P_add_pro_ra
           , P_add_comu, P_add_comus, P_add_comup
           , P_add_com_so, P_add_com_pa, P_add_com_ra
           , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
    );
  P_stp := 'VOCI_FISCALI-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp6.VOCI_CALCOLO  -- Determinazione voci a CALCOLO Sucessive
     ( P_ci, D_al
          , P_anno, P_mese, P_mensilita, P_fin_ela, D_d_cong
          , P_tipo, 'CS', P_base_ratei
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_CALCOLO_S-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  Peccmocp9.VOCI_RITENUTA  -- Determinazione voci a RITENUTA Successive
     ( P_ci, D_ult_anno_moco, D_al
          , P_anno, P_mese, P_mensilita, P_fin_ela
          , P_tipo, D_conguaglio, P_mens_codice, P_periodo, 'RS'
          , D_posizione_inail, D_data_inail
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_RITENUTA_S-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
  DECLARE D_netto_neg VARCHAR2(2) := 'NO';
  BEGIN
     Peccmocp7.VOCI_NETTO  -- Determinazione Netto Cedolino
        ( P_ci, D_al
             , P_anno, P_mese, P_mensilita, P_fin_ela
             , P_tipo
             , D_istituto, D_sportello
             , D_netto_neg
             , P_comp    , P_trat     , P_netto
             , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
        );
     IF D_netto_neg = 'SI' THEN
        P_stp := '!!! < 0 #'||TO_CHAR(P_ci);
        Peccmocp.log_trace(7,P_prn,P_pas,P_prs,P_stp,0,P_tim);
        Peccmocp.w_errore := 'P05830';  -- Segnalazione Negativi
     ELSIF
        D_netto_neg = 'NN' THEN  -- Netto o Compet. a ZERO
        P_stp := '!!! = 0 #'||TO_CHAR(P_ci);
        Peccmocp.log_trace(7,P_prn,P_pas,P_prs,P_stp,0,P_tim);
        Peccmocp.w_errore := 'P05830';  -- Segnalazione Negativi
     END IF;
  END;
  P_stp := 'VOCI_NETTO-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
/* modifica del 28/04/2004 */
  PECCMOCP_RITENUTA.SCORPORO  -- Operazioni di scorporo delle ritenute
     ( P_ci, D_al
     , P_anno, P_mese, P_mensilita, P_fin_ela
     , P_tipo
     , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_TERMINE-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
/* fine modifica del 28/04/2004 */
  VOCI_TERMINE  -- Operazione di Chiusura Retribuzione
     ( P_ci
          , P_anno, P_mese, P_mensilita, P_fin_ela
          , P_tipo
          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
     );
  P_stp := 'VOCI_TERMINE-END';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,D_tim_pro);
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
       RAISE ;
  WHEN OTHERS THEN
       Peccmocp.err_trace( P_trc, P_prn, P_pas, P_prs, P_stp, 0, P_tim );
       RAISE FORM_TRIGGER_FAILURE;
END;
PROCEDURE voci_termine
(
 p_ci        NUMBER
,p_anno       NUMBER
,p_mese       NUMBER
,p_mensilita  VARCHAR2
,p_fin_ela    DATE
,p_tipo       VARCHAR2
-- Parametri per Trace
,p_trc    IN     NUMBER     -- Tipo di Trace
,p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
) IS
form_trigger_failure EXCEPTION;
BEGIN
  BEGIN  -- Passaggio dei dati da CALCOLI_CONTABILI *PREVISIONE*
        --                   a MOVIMENTI_CONTABILI_PREVISIONE
        -- Non tratta voci con INPUT = '*' che sono voci valide
        -- solo per il calcolo
     P_stp := 'TERMINE-01';
     INSERT INTO MOVIMENTI_CONTABILI_PREVISIONE
     ( ci, anno, mese, MENSILITA
     , bilancio
     , budget
     , riferimento
     , arr
     , tar, qta, imp
     , anno_del, sede_del, numero_del, delibera  -- modifica del 28/04/2004 
     , risorsa_intervento, capitolo, articolo, conto
     , impegno, anno_impegno, sub_impegno, anno_sub_impegno
     , ipn_p, ipn_eap,codice_siope
     )
     SELECT P_ci, P_anno, P_mese, P_mensilita
         , nvl(covo.bilancio,'0')
         , covo.budget
/* modifica 16/03/2004 */
         -- , caco.riferimento
         , MAX(caco.riferimento)
/* fine modifica 16/03/2004 */
         , max(caco.arr) -- modifica 16/03/2004
         , DECODE( MAX(voec.classe)
                , 'C', MAX(caco.tar)
                , 'Q', MAX(caco.tar)
                     , SUM(caco.tar)
                )
/* modifica del 28/04/2004 */
         , DECODE( MAX(voec.classe)
                , 'R', MAX(caco.qta)
                     , SUM(caco.qta)
                )
         -- , SUM(caco.qta)
/* fine modifica del 28/04/2004 */
         , SUM(caco.imp)
         , caco.anno_del, caco.sede_del, caco.numero_del, caco.delibera  -- modifica del 28/04/2004 
         , caco.risorsa_intervento, caco.capitolo, caco.articolo, caco.conto
         , caco.impegno, caco.anno_impegno, caco.sub_impegno, caco.anno_sub_impegno
         , SUM(caco.ipn_p), SUM(caco.ipn_eap),caco.codice_siope
       FROM VOCI_ECONOMICHE voec
         , CONTABILITA_VOCE covo
         , CALCOLI_CONTABILI caco
      WHERE voec.codice     = caco.voce||''
        AND voec.memorizza != 'N'
        AND caco.ci        = P_ci
        AND covo.voce       = caco.voce||''
        AND covo.sub        = caco.sub
        AND caco.riferimento between nvl(covo.dal,to_date(2222222,'j'))
                             and nvl(covo.al ,to_date(3333333,'j'))
        AND covo.budget     is not null
/* modifica del 27/10/2004 Volutamente diversa rispetto al calcolo mensile */
--        AND UPPER(caco.input) IN ( 'R', 'C', 'A' )
/* fine mod. del 27/10/2004 */
        AND (    voec.tipo != 'F'
            AND (    NVL(caco.imp,0)     != 0
                OR  NVL(caco.ipn_p,0)   != 0
                OR  NVL(caco.ipn_eap,0) != 0
                OR  NVL(voec.specie,'I') = 'T'
                AND UPPER(caco.input)    = 'R'
                AND     caco.arr       IS NULL
                AND NVL(caco.tar,0)     != 0
                OR      voec.automatismo LIKE 'IRPEF%'
               )
            OR  voec.tipo = 'F'
            AND (    NVL(voec.specie,'I')   = 'T'
                AND (   NVL(caco.tar,0)   != 0
                     OR NVL(caco.imp,0)   != 0
                     OR NVL(caco.ipn_p,0) != 0
                    )
                OR  NVL(voec.specie,'I')   = 'I'
                AND (   NVL(caco.imp,0)   != 0
                     OR NVL(caco.ipn_p,0) != 0
                    )
                OR  NVL(voec.specie,'N') NOT IN ('T','I')
                AND NVL(caco.qta,0)       != 0
               )
           )
      GROUP BY covo.bilancio
            , covo.budget
/* modifica 16/03/2004 */
            -- , caco.riferimento
            -- , caco.arr
            , decode( substr(voec.specifica,1,3), 'RGA', to_char(caco.tar), to_char(caco.riferimento))
            , decode( substr(voec.specifica,1,3), 'RGA', to_char(caco.riferimento,'yyyy') , to_char(null))
            , decode( substr(voec.specifica,1,3), 'RGA', decode(caco.arr,'P','P',to_char(null)), caco.arr)
/* fine modifica 16/03/2004 */
/* modifica 07/07/2004 */
            -- , nvl(caco.competenza,caco.riferimento)
            , decode( voec.specifica, 'RGA13M', null, nvl(caco.competenza,caco.riferimento))
/* fine modifica 07/07/2004 */
            , caco.ore
            , caco.anno_del, caco.sede_del, caco.numero_del, caco.delibera  -- modifica del 28/04/2004 
            , caco.risorsa_intervento, caco.capitolo, caco.articolo, caco.conto
            , caco.impegno, caco.anno_impegno, caco.sub_impegno, caco.anno_sub_impegno,caco.codice_siope
/* modifica del 28/04/2004 */
            , decode( voec.classe
                    , 'R', caco.qta
                         , null
                    )
/* fine modifica del 28/04/2004 */
     HAVING (    MAX(voec.tipo) != 'F'
            AND (   NVL(SUM(caco.imp),0)     != 0
                OR  NVL(SUM(caco.ipn_p),0)   != 0
                OR  NVL(SUM(caco.ipn_eap),0) != 0
                OR  NVL(MAX(voec.specie),'I') = 'T'
                AND     MAX(UPPER(caco.input))= 'R'
                AND     MAX(caco.arr)        IS NULL
                AND NVL(SUM(caco.tar),0)     != 0
                OR  MAX(voec.automatismo) LIKE 'IRPEF%'
               )
            OR  MAX(voec.tipo) = 'F'
            AND (    NVL(MAX(voec.specie),'I')   = 'T'
                AND (   NVL(SUM(caco.tar),0)   != 0
                     OR NVL(SUM(caco.imp),0)   != 0
                     OR NVL(SUM(caco.ipn_p),0) != 0
                    )
                OR  NVL(MAX(voec.specie),'I')   = 'I'
                AND (   NVL(SUM(caco.imp),0)   != 0
                     OR NVL(SUM(caco.ipn_p),0) != 0
                    )
                OR  NVL(MAX(voec.specie),'N') NOT IN ('T','I')
                AND NVL(SUM(caco.qta),0)       != 0
               )
           )
     ;
     peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  -- Eliminazione valori FISCALI generati per calcolo *PREVISIONE*
     P_stp := 'TERMINE-02';
     delete from movimenti_fiscali
      where ci       = P_ci
        and anno      = P_anno
        and mese      = P_mese
        and mensilita = P_mensilita
     ;
     peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
/* Non utilizzata per Bil.prev. in quanto non vengono trattate le Variabili 
  BEGIN  -- Aggiornamento delle VARIABILI_RETRIBUTIVE
        -- Non tratta voci con INPUT = '*' che sono voci valide
        -- solo per il calcolo
     P_stp := 'TERMINE-02.1';
     FOR CURV IN
        (SELECT caco.voce, caco.sub
             , caco.riferimento, caco.arr
             , caco.input, caco.data
             , caco.tar, caco.qta, caco.imp
             , caco.ipn_p, caco.ipn_eap
             , DECODE(voec.tipo,'T',-1,1) segno
          FROM VOCI_ECONOMICHE   voec
             , CALCOLI_CONTABILI caco
         WHERE voec.codice = caco.voce||''
           AND caco.ci = P_ci
           AND UPPER(caco.input) NOT IN ( 'R', 'C', 'A', '*')
        ) LOOP
        P_stp := 'TERMINE-02.1';
        Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        BEGIN  -- Aggiornamento dati calcolati in CALCOLI_CONTABILI
              --                           su MOVIMENTI_CONTABILI_PREVISIONE
          UPDATE MOVIMENTI_CONTABILI_PREVISIONE
             SET tar     = curv.tar
               , qta     = curv.qta
               , imp     = curv.imp
               , ipn_p   = curv.ipn_p
               , ipn_eap = curv.ipn_eap
           WHERE ci          = P_ci
             AND anno        = P_anno
             AND mese        = P_mese
             AND MENSILITA    = P_mensilita
             AND voce        = curv.voce
             AND sub         = curv.sub
             AND riferimento  = curv.riferimento
             AND NVL(arr,' ') = NVL(curv.arr,' ')
             AND input||''    = curv.input
             AND NVL(data,TO_DATE('2222222','j'))
                            = NVL(curv.data,TO_DATE('2222222','j'))
             AND NVL(tar_var,NVL(curv.tar,0))
                            = NVL(curv.tar,0)
             AND NVL(qta_var*curv.segno,NVL(curv.qta,0))
                            = NVL(curv.qta,0)
             AND NVL(imp_var*curv.segno,NVL(curv.imp,0))
                            = NVL(curv.imp,0)
          ;
        END;
     END LOOP;
  END;
*/
  IF NVL(P_trc,0) != 1  -- In caso di TRACE non svuota Tavola Lavoro
  THEN
     BEGIN  -- Svuotamento della tavola di lavoro
        P_stp := 'TERMINE-03';
		NULL;
        DELETE FROM CALCOLI_CONTABILI
        WHERE ci = P_ci
        ;
        Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     Peccmocp.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
-- Operazioni di Inizio Retribuzione
--
-- Operazioni di allineamento degli archivi al momento precedente
--  l'elaborazione
--
PROCEDURE voci_inizio
(
 p_ci        NUMBER
,p_anno       NUMBER
,p_mese       NUMBER
,p_mensilita  VARCHAR2
,p_fin_ela    DATE
,p_ricalcolo  IN OUT VARCHAR2
-- Parametri per Trace
,p_trc    IN     NUMBER     -- Tipo di Trace
,p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
) IS
form_trigger_failure EXCEPTION;
BEGIN
  BEGIN  -- Svuotamento della tavola di lavoro per sicurezza
        -- (dovrebbe essere stata svuotata dopo il calcolo)
     P_stp := 'INIZIO-00';
     DELETE FROM CALCOLI_CONTABILI
      WHERE ci = P_ci
     ;
     Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  -- Eliminazione dei valori FISCALI mensili
     P_stp := 'INIZIO-01';
     DELETE FROM MOVIMENTI_FISCALI
      WHERE ci       = P_ci
        AND anno      = P_anno
        AND mese      = P_mese
        AND MENSILITA = P_mensilita
     ;
     IF SQL%ROWCOUNT > 0 THEN
        p_ricalcolo := 'Y';
     ELSE
        p_ricalcolo := 'N';
     END IF;
     Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  -- Inserisce record vuoto se EXTRACONTABILE non presente
     P_stp := 'INIZIO-02';
INSERT INTO INFORMAZIONI_EXTRACONTABILI
 ( ci, anno
 , ant_liq_ap, ant_acc_ap, ant_acc_2000, ipt_liq_ap, ipn_liq_ap
 , aut_ass_fam, aut_ded_fam
 )
SELECT
 P_ci, P_anno
, 0, 0, 0, 0, 0
, 'NO', 'SI'
 FROM dual
 WHERE NOT EXISTS
     (SELECT 'x'
        FROM INFORMAZIONI_EXTRACONTABILI
       WHERE ci        = P_ci
        AND anno       = P_anno
     )
;
     peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  -- Eliminazione dei precedenti MOVIMENTI
        -- generati dal calcolo ( INPUT in 'R', 'C', 'A' )
     P_stp := 'INIZIO-03';
     DELETE MOVIMENTI_CONTABILI_PREVISIONE
      WHERE ci        = P_ci
        AND anno       = P_anno
        AND mese       = P_mese
        AND MENSILITA  = P_mensilita
--        AND UPPER(input)||'' IN ( 'R', 'C', 'A')   il bil.prev. non utilizza variabili
     ;
/* Non utilizzata per Bil.prev. in quanto non vengono trattate le Variabili 
     UPDATE MOVIMENTI_CONTABILI_PREVISIONE
        SET imp = NULL,
            qta = NULL,
            tar = NULL
      WHERE ci        = P_ci
        AND anno       = P_anno
        AND mese       = P_mese
        AND MENSILITA  = P_mensilita
        AND UPPER(input)||'' NOT IN ( 'R', 'C', 'A')
     ;
*/
     Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
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
