CREATE OR REPLACE PACKAGE Peccmore_autofam IS
/******************************************************************************
 NOME:        Peccmore_autofam
 DESCRIZIONE: Calcolo VOCI Automatiche di Carico Familiare.
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1    23/12/2004 MF     Calcolo Deduzioni Familiari per Finanziaria 2005.
                        Riferimenti ai Package GP4_RARE e GP4_INEX.
                        Riferimenti ai Package GP4_DEFI e GP4_ENTE.
 2    23/03/2005 NN     Gestitione errori in gp4_defi.get_importo
 2.1  25/03/2005 NN     Per le deduzioni familiari, tratta i record di cafa solo
                        in presenza di gg_af per il corrispondente mese in pere.
 2.2  14/11/2005 NN     Calcolo deduzioni familiari, non trattava i dati di ACAFA
                        imputati al ci relativo ad un precedente rapporto sempre con l'ente.
 2.3  18/11/2005 NN     Calcolo deduzioni familiari, non trattava i dati di ACAFA
                        in caso di conguaglio, per i mesi non inclusi in PERE.
 2.4  05/12/2005 NN     Calcolo deduzioni familiari, effettua il conguaglio anche
                        per mensilita di tipo 'A' (13A).
 4    05/01/2007 AM     Adeguamento alla Legge Finanziaria 2007
 4.1  18/01/2007 ML     Attivazione deltrazione figlio in assenza del coniuge (A19233).
 4.2  30/01/2007 ML     Modifica attribuzioni detrazioni familiari in caso di variazione
                        della sitazione (A18405.3)
 4.3  19/02/2007 ML     Attribuzione detrazioni per tutto l'anno, anche se non lavorato (A18831.1)
 4.4 22/03/2007  ML     Gestione campo aumento per detrazioni (A20236).
 4.5 26/03/2007  ML     Gestione campo aumento per detrazioni figli (A20237).
 4.6 25/07/2007  AM     aggiunto il controllo dell'anno su RADI
 5.0 19/09/2007  AM     Implementata la gestione del conguaglio carichi familiari per permettere di
                        inibire il conguaglio delle detrazioni lasciando solo quello degli ass.fam
 5.1 22/10/2007  NN     Utilizzato il nuovo campo pere.gg_df per il calcolo delle detrazioni familiari.
******************************************************************************/
revisione varchar2(30) := '5.1 del 22/10/2007';
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
,p_tipo_spese  VARCHAR2
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
,p_reddito_dip  NUMBER  -- se Rilevanza = D : Reddito Dip. per Detrazioni
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
CREATE OR REPLACE PACKAGE BODY Peccmore_autofam IS
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
,p_tipo_spese  VARCHAR2
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
,p_reddito_dip  NUMBER  -- se Rilevanza = D : Reddito Dip. per Detrazioni
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
D_divisore     NUMBER := 12;
D_conguaglio   NUMBER := 0;
D_imponibile        NUMBER;
D_effe_cong         VARCHAR(1);
D_scaglione_coniuge NUMBER;
D_scaglione_fc      NUMBER;
D_scaglione_cn_defi NUMBER;
D_scaglione_figli   NUMBER;
D_val_conv_det_fam  NUMBER;
D_val_conv_det_fig  NUMBER;
D_nr_figli          NUMBER;
D_val_conv_ded_fam  NUMBER;
D_val_ded_con       NUMBER;
D_val_det_fc        NUMBER;
D_val_aum_fc        NUMBER;
D_val_det_ft        NUMBER;  --Valore figlio da togliere
D_val_aum_ft        NUMBER;  --Valore aumento figlio da togliere
D_val_ded_fig       NUMBER;
D_val_det_fg        NUMBER;
D_val_aum_fg        NUMBER;
D_val_det_fd        NUMBER;
D_val_aum_fd        NUMBER;
D_val_det_fm        NUMBER;
D_val_det_md        NUMBER;
D_val_det_fh        NUMBER;
D_val_det_hd        NUMBER;
D_val_ded_alt       NUMBER;
D_aumento           NUMBER;
D_aum_coniuge       NUMBER;
D_val_det_fc_ac     NUMBER := 0;
D_val_det_ft_ac     NUMBER := 0;
D_val_ded_con_ac    NUMBER := 0;
D_val_ded_fig_ac    NUMBER := 0;
D_val_ded_alt_ac    NUMBER := 0;
D_ded_per           NUMBER := 100;
D_ded_per_ac        NUMBER := 100;
D_det_per_con       NUMBER := 100;
D_det_per_fig       NUMBER := 100;
D_det_per_Alt       NUMBER := 100;
D_det_per_con_ac    NUMBER := 100;
D_det_per_fc_ac     NUMBER := 100;
D_det_per_fig_ac    NUMBER := 100;
D_det_per_Alt_ac    NUMBER := 100;
D_percentuale       NUMBER := 100;
D_diff_det_coniuge  NUMBER;
D_diff_det_fc       NUMBER;
D_diff_con_ac       NUMBER := 0;
D_diff_fc_ac        NUMBER := 0;
D_coniuge           NUMBER;
D_cond_fis          VARCHAR2(4);
D_cond_fis_cc       VARCHAR2(4);
CURSOR C_CAFA (A_annuale NUMBER) IS
        SELECT P_ci ci, anno, mese
             , decode(P_rilevanza,'A',nvl(mese_att_ass,mese_att),mese_att) mese_att  -- modifica del 19/09/2007
             , cond_fam, nucleo_fam, figli_fam
             , cond_fis, scaglione_coniuge, coniuge
             , scaglione_figli, figli, figli_dd, figli_mn, figli_mn_dd
             , figli_hh, figli_hh_dd, altri
             , giorni
             , decode( nvl(figli,0) + nvl(figli_dd,0)
                     , 0, null
                        ,  nvl(figli,0) + nvl(figli_dd,0))      nr_figli
             , decode( nvl(figli_mn,0) + nvl(figli_mn_dd,0)
                     , 0, null
                        , nvl(figli_mn,0) + nvl(figli_mn_dd,0)) nr_figli_mn
             , decode( nvl(figli_hh,0) + nvl(figli_hh_dd,0)
                     , 0, null
                        , nvl(figli_hh,0) + nvl(figli_hh_dd,0)) nr_figli_hh
          FROM CARICHI_FAMILIARI cafa
         WHERE ci = P_ci
           and decode(P_rilevanza,'A',cond_fam,cond_fis) is not null
           and (anno,mese+0)  IN
              (SELECT DISTINCT anno, mese
                 FROM CARICHI_FAMILIARI
                WHERE ci = P_ci
                  AND (    anno      = P_anno
                       and mese+0    = P_mese
                       and P_tipo    = 'N'
                        -- Tratta Carico mese corrente
                        -- solo se Mensilita` Normale
                      OR  anno       = P_anno
--                       and mese+0    <= P_mese
                       and nvl(d_effe_cong,' ') != 'N'
                       and A_annuale > 0
                        -- Tratta le righe dell'intero anno se conguaglio fiscale
                      OR  anno       = P_anno
--                       and mese+0    <= P_mese
                       and A_annuale  = 9
                        -- Tratta le righe dell'intero anno per determinare il progressivo
                      OR   anno = P_anno
                       and giorni is null
                       and P_tipo    = 'N'
                       and mese in (select pere.mese
                                      from periodi_retributivi pere
                                     where pere.ci          = P_ci
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
                      OR   anno      = P_anno
                       and decode(P_rilevanza,'A',nvl(mese_att_ass,mese_att),mese_att) = P_mese   -- modifica del 19/09/2007
                       and decode(P_rilevanza,'A',nvl(mese_att_ass,mese_att),mese_att) > mese+0   -- modifica del 19/09/2007
                       and P_tipo    = 'N'
                        -- Tratta Carico mese a conguaglio
                        -- solo se Mensilita` non Aggiuntiva
                        -- Se Mensilita Speciale solo se del mese 12
                      OR   anno      = P_anno-1
                       and decode(P_rilevanza,'A',nvl(mese_att_ass,mese_att),mese_att) = P_mese   -- modifica del 19/09/2007
                       and decode(P_rilevanza,'A',nvl(mese_att_ass,mese_att),mese_att) < mese+0   -- modifica del 19/09/2007
                       and P_tipo    = 'N'
                        -- Tratta Carico mese a conguaglio
                        -- solo se Mensilita` non Aggiuntiva
                        -- Se Mensilita Speciale solo se del mese 12
                        -- Tratta le informazioni dell'anno precedente
                        --  (ultimi mesi) sull'anno corrente
                      )
              )
           AND ( (A_annuale != 9 and decode(P_rilevanza,'A',nvl(mese_att_ass,mese_att),mese_att) = P_mese)    -- modifica del 19/09/2007
               or
               giorni > 0
               or
               exists (select 'x'
                         from periodi_retributivi pere2
                        where pere2.ci          = P_ci
                          and pere2.periodo =
                             (select nvl( max(pere3.periodo)
                                        , last_day(to_date(to_char(nvl(cafa.mese,12))||'/'||to_char(cafa.anno),'mm/yyyy')))
	                          from periodi_retributivi pere3
	                         where pere3.ci       = P_ci
                                 and pere3.periodo >= to_date(cafa.anno||lpad(cafa.mese,2,0),'yyyymm')
                                 and pere3.periodo <= P_fin_ela
                                 and to_number(to_char(pere3.al,'yyyymm')) = to_number(cafa.anno||lpad(cafa.mese,2,0))
                                 and pere3.competenza in ('A','C','P')
                                 and nvl(pere3.tipo,' ') not in ('R','F')
                             )
                          and to_number(to_char(pere2.al,'yyyymm')) = to_number(cafa.anno||lpad(cafa.mese,2,0))
                          and (   pere2.competenza in ('C','A')
                               or pere2.competenza = 'P' and A_annuale != 9
                              )
                          and pere2.servizio    = 'Q'
                          and nvl(pere2.tipo,' ') not in ('R','F')
                       having sum(pere2.gg_af) != 0
                           or sum(pere2.gg_df) != 0
                      )
               )
   union
        SELECT cafa.ci ci, anno, mese
             , decode(P_rilevanza,'A',nvl(mese_att_ass,mese_att),mese_att) mese_att  -- modifica del 19/09/2007
             , cond_fam, nucleo_fam, figli_fam
             , cond_fis, scaglione_coniuge, coniuge
             , scaglione_figli, figli, figli_dd, figli_mn, figli_mn_dd
             , figli_hh, figli_hh_dd, altri
             , giorni
             , decode( nvl(figli,0) + nvl(figli_dd,0)
                     , 0, null
                        ,  nvl(figli,0) + nvl(figli_dd,0))      nr_figli
             , decode( nvl(figli_mn,0) + nvl(figli_mn_dd,0)
                     , 0, null
                        , nvl(figli_mn,0) + nvl(figli_mn_dd,0)) nr_figli_mn
             , decode( nvl(figli_hh,0) + nvl(figli_hh_dd,0)
                     , 0, null
                        , nvl(figli_hh,0) + nvl(figli_hh_dd,0)) nr_figli_hh
          FROM CARICHI_FAMILIARI cafa
         WHERE ci in
               (select ci_erede
                  from RAPPORTI_DIVERSI radi
                 where ci = P_ci
                   and rilevanza in ('R','L')
                   and anno = P_anno
               )
          and A_annuale             > 0
          and nvl(d_effe_cong,' ') != 'N'
          and anno                  = P_anno
          and mese+0               <= P_mese
     ORDER BY 1, 2, 3
;
BEGIN
  BEGIN -- Trattamento del Carico Familiare
        P_stp := 'VOCI_AUTO_FAM-00a';
     D_effe_cong := GP4_INEX.get_effe_cong(P_ci, P_anno);
     IF D_effe_cong is null then
        D_effe_cong := GP4_ENTE.get_scad_cong;
     END IF;
     IF D_effe_cong is null then
        D_effe_cong := ' ';
     END IF;
     IF  P_anno >= 2003
     AND GP4_RARE.is_mese_conguaglio(P_ci, P_fin_ela, P_tipo, P_conguaglio)
     THEN
        d_conguaglio := 1;
     ELSE
        d_conguaglio := 0;
     END IF;
     D_val_conv_ded_fam := GP4_RARE.get_val_conv_ded_fam(P_ci, P_fin_ela);
     D_val_conv_det_fam := GP4_RARE.get_val_conv_det_fam(P_ci, P_fin_ela);
     D_diff_det_coniuge := GP4_DEFI.get_diff_det_con
                               ( P_anno, P_mese, 'CC', 'CN', 1
                               , P_ci                                         -- 23/03/2005
                               , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);    -- 23/03/2005
     D_diff_det_fc := D_diff_det_coniuge;
/*   -------------------------------------------------------------------------------------
     Calcolo x deduzioni (2003-2006 per altre deduzioni
                          2005-2006 per carichi familiari )
     ------------------------------------------------------------------------------------- */
     IF P_rilevanza = 'F' and D_val_conv_det_fam is not null
        THEN -- acquisisce l'imponibile progressivo da uatilizzare nel calcolo del progressivo detrazioni
             -- la variabile P_imponibile passata al package viene utilizzata invece per il calcolo delle
             -- detrazioni mensili (e contiene l'imponibile progressivo o del mese a seconda che sia o
             -- meno mese di conguaglio)
        GP4_RARE.lkp_ipn_det_fis_fam(P_ci, P_fin_ela, P_anno, P_mese, P_mensilita, D_imponibile);
-- dbms_output.put_line('D_imponibile '||D_imponibile);
     ELSIF P_rilevanza = 'E' and D_val_conv_ded_fam is not null THEN
        D_imponibile := P_imponibile;
     END IF;
     IF P_rilevanza = 'F' and D_val_conv_det_fam is not null
     OR P_rilevanza = 'E' and D_val_conv_ded_fam is not null
     THEN  -- Esegue primo ciclo su Carichi Familiari con esame su tutto l'anno solo se:
           -- rilevanza 'E' e esiste Valore Convenzionale
        P_stp := 'VOCI_AUTO_FAM-00b';
        BEGIN
        select max(nvl(figli,0)+nvl(figli_dd,0))
          into D_nr_figli
          from carichi_familiari
         where ci     = P_ci
           and anno   = P_anno;
/*           and mese+0 = P_mese;
        EXCEPTION WHEN NO_DATA_FOUND THEN
        select nvl(figli,0)+nvl(figli_dd,0)
          into D_nr_figli
          from carichi_familiari
         where ci          = P_ci
           and (anno,mese) =
              (select max(anno), substr(max(anno||lpad(mese,2,0)),5)
                 from movimenti_fiscali
                where ci = P_ci
                  and anno||lpad(mese,2,0) < P_anno||lpad(P_mese,2,0));
*/
        END;
        D_coniuge  := to_number(null);
        D_cond_fis := null;
        D_cond_fis_cc := null;
        D_aum_coniuge := 0;
-- dbms_output.put_line('P_rilevanza '||P_rilevanza||' P_anno '||P_anno||' P_mese '||P_mese||
--                     ' d_effe_cong '||d_effe_cong||' P_tipo '||P_tipo||' P_fin_ela '||P_fin_ela);
        FOR CURV IN C_CAFA(9) -- Argomento fisso a 9 per esame di tutto l'anno
        LOOP
       Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
-- dbms_output.put_line('Sono nel loop di CAFA per la lettura di tutto l''anno: P_anno '||P_anno||' P_mese '||P_mese||
--                     ' D_imponibile '||D_imponibile||' P_imponibile '||P_imponibile||' P_conuaglio '||P_conguaglio);
        BEGIN  -- Valorizza i Carichi Familiari di tutto l'anno per stabilire
               -- la percentuale mensile da applicare
               -- la percentuale annuale di eventuale conguaglio
           IF  curv.anno = P_anno
           THEN  -- Memorizza su Package GP4_RARE i valori di deduzione Mensile e Annuale
                 -- ottenendo la Percentuale da utizzare in VOCI_AUTO_FAM_DF
                 -- Verranno riestratti e registrati su Movimenti Fiscali
                 -- dalla procedure chiamante VOCI_FISC_IPT.
              -- Lo scaglione per Deduzioni, se non indicato, sempre = 1
              IF P_rilevanza = 'F' THEN -- determina lo scaglione annuale
                 IF curv.coniuge is not null THEN
                   D_scaglione_coniuge := GP4_DEFI.get_nr_scaglione
                                 ( P_anno, P_mese, curv.cond_fis, 'CN', curv.coniuge, 1
                                 , curv.scaglione_coniuge, D_imponibile, P_ci
                                 , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
                 END IF;
                 D_scaglione_fc := GP4_DEFI.get_nr_scaglione
                               ( P_anno, P_mese, 'CC', 'CN', 1, 1
                               , curv.scaglione_coniuge, D_imponibile, P_ci
                               , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
-- dbms_output.put_line('@@@ D_scaglione_coniuge '||D_scaglione_coniuge||' P_anno '||P_anno||' P_mese '||P_mese||
--                     ' curv.cond_fis '||curv.cond_fis||' curv.coniuge '||curv.coniuge||' P_conguaglio '||P_conguaglio||
--                     ' P_conguaglio '||P_conguaglio||' D_imponibile '||D_imponibile);
              ELSIF curv.scaglione_coniuge is null
              THEN
                 D_scaglione_coniuge := 1;  --??????
              ELSE
                 D_scaglione_coniuge := curv.scaglione_coniuge;
              END IF;
-- dbms_output.put_line('** primo passaggio: scaglione coniuge cursore '||curv.scaglione_coniuge||' D_scag_con '||D_scaglione_coniuge);
              IF curv.scaglione_figli is null
              THEN
                 D_scaglione_figli   := 1;
              ELSE
                 D_scaglione_figli   := curv.scaglione_figli;
              END IF;
-- dbms_output.put_line('** cond.fis. '||curv.cond_fis||' scaglione coniuge cursore '||curv.scaglione_coniuge||' D_scag_con '||D_scaglione_coniuge||' coniuge '||curv.coniuge||' D_imponibile '||D_imponibile||' P_conguaglio '||P_conguaglio||' D_cond_fis_cc '||D_cond_fis_cc);
              P_stp := 'VOCI_AUTO_FAM-00c';
              D_aumento := GP4_DEFI.get_imp_aum
                           ( P_anno, P_mese, curv.cond_fis, 'CN', D_scaglione_coniuge, curv.coniuge
                           , D_imponibile, P_conguaglio, 1
                           , P_ci,'A'                                         -- 23/03/2005
                           , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);   -- 23/03/2005
              IF curv.cond_fis = 'CC' THEN
                 D_aum_coniuge := D_aumento;
              END IF;
-- dbms_output.put_line('** D_aumento. '||D_aumento||' D_aum_coniuge '||D_aum_coniuge);
              D_val_ded_con := GP4_DEFI.get_imp_aum
                               ( P_anno, P_mese, curv.cond_fis, 'CN', D_scaglione_coniuge, curv.coniuge
                               , D_imponibile, P_conguaglio, 1
                               , P_ci, 'I'                                         -- 23/03/2005
                               , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);   -- 23/03/2005
              D_val_det_fg  := GP4_DEFI.get_imp_aum
                               ( P_anno, P_mese, curv.cond_fis, 'FG', D_scaglione_figli, curv.figli
                               , D_imponibile, P_conguaglio, 1
                               , P_ci, 'I'                                         -- 23/03/2005
                               , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);    -- 23/03/2005
              D_val_aum_fg  := GP4_DEFI.get_imp_aum
                               ( P_anno, P_mese, curv.cond_fis, 'FG', D_scaglione_figli, curv.figli
                               , D_imponibile, P_conguaglio, 1
                               , P_ci, 'A'                                         -- 23/03/2005
                               , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);    -- 23/03/2005
-- dbms_output.put_line('** D_val_det_fg. '||D_val_det_fg||' D_val_aum_fg '||D_val_aum_fg);
              D_val_det_fd  := GP4_DEFI.get_imp_aum
                               ( P_anno, P_mese, curv.cond_fis, 'FD', D_scaglione_figli, curv.figli_dd
                               , D_imponibile, P_conguaglio, 1
                               , P_ci, 'I'                                         -- 23/03/2005
                               , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);    -- 23/03/2005
              D_val_aum_fd  := GP4_DEFI.get_imp_aum
                               ( P_anno, P_mese, curv.cond_fis, 'FD', D_scaglione_figli, curv.figli_dd
                               , D_imponibile, P_conguaglio, 1
                               , P_ci, 'A'                                         -- 23/03/2005
                               , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);    -- 23/03/2005
-- dbms_output.put_line('** D_val_det_fd. '||D_val_det_fd||' D_val_aum_fd '||D_val_aum_fd);
              D_val_det_fm  := GP4_DEFI.get_imp_aum
                               ( P_anno, P_mese, curv.cond_fis, 'FM', D_scaglione_figli, curv.figli_mn
                               , D_imponibile, P_conguaglio, 1
                               , P_ci, 'I'                                         -- 23/03/2005
                               , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);    -- 23/03/2005
              D_val_det_md  := GP4_DEFI.get_imp_aum
                               ( P_anno, P_mese, curv.cond_fis, 'MD', D_scaglione_figli, curv.figli_mn_dd
                               , D_imponibile, P_conguaglio, 1
                               , P_ci, 'I'                                         -- 23/03/2005
                               , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);    -- 23/03/2005
              D_val_det_fh  := GP4_DEFI.get_imp_aum
                               ( P_anno, P_mese, curv.cond_fis, 'FH', D_scaglione_figli, curv.figli_hh
                               , D_imponibile, P_conguaglio, 1
                               , P_ci, 'I'                                         -- 23/03/2005
                               , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);    -- 23/03/2005
              D_val_det_hd  := GP4_DEFI.get_imp_aum
                               ( P_anno, P_mese, curv.cond_fis, 'HD', D_scaglione_figli, curv.figli_hh_dd
                               , D_imponibile, P_conguaglio, 1
                               , P_ci, 'I'                                         -- 23/03/2005
                               , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);    -- 23/03/2005
              IF D_nr_figli > 3 THEN
                 D_val_ded_fig := nvl(D_val_det_fg,0) + nvl(D_val_det_fd,0) +
                                  nvl(D_val_det_fm,0) + nvl(D_val_det_md,0) +
                                  nvl(D_val_det_fh,0) + nvl(D_val_det_hd,0) +
                                  nvl(D_val_aum_fg,0) + nvl(D_val_aum_fd,0);
-- dbms_output.put_line('** D_val_ded_fig. '||D_val_ded_fig||' D_nr_figli '||D_nr_figli);
              ELSE D_val_ded_fig := nvl(D_val_det_fg,0) + nvl(D_val_det_fd,0) +
                                    nvl(D_val_det_fm,0) + nvl(D_val_det_md,0) +
                                    nvl(D_val_det_fh,0) + nvl(D_val_det_hd,0);
-- dbms_output.put_line('** D_val_ded_fig. '||D_val_ded_fig||' D_nr_figli '||D_nr_figli);
              END IF;
              D_val_ded_alt := GP4_DEFI.get_imp_aum
                               ( P_anno, P_mese, curv.cond_fis, 'AL', D_scaglione_figli, curv.altri
                               , D_imponibile, P_conguaglio, 1
                               , P_ci, 'I'                                         -- 23/03/2005
                               , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);   -- 23/03/2005
              Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
-- Calcolo detrazione del figlio al posto del coniuge
              P_stp := 'VOCI_AUTO_FAM-00d';
              IF nvl(curv.figli,0) != 0 and curv.cond_fis = 'AC' THEN
                 D_val_det_fc  := GP4_DEFI.get_imp_aum
                                  ( P_anno, P_mese, 'CC', 'CN', D_scaglione_fc, 1
                                  , D_imponibile, P_conguaglio, 1
                                  , P_ci, 'I'
                                  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
                 D_val_aum_fc  := GP4_DEFI.get_imp_aum
                                  ( P_anno, P_mese, 'CC', 'CN', D_scaglione_fc, 1
                                  , D_imponibile, P_conguaglio, 1
                                  , P_ci, 'A'
                                  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
                 IF curv.nr_figli = nvl(curv.nr_figli_mn,curv.nr_figli) and
                    curv.nr_figli = nvl(curv.nr_figli_hh,curv.nr_figli)
                 THEN
                    D_val_det_ft := (D_val_ded_fig / nvl(curv.nr_figli,1));
                 ELSE
                    D_val_det_ft := GP4_DEFI.get_imp_aum
                                    ( P_anno, P_mese, curv.cond_fis, 'FG', D_scaglione_figli, 1
                                    , D_imponibile, P_conguaglio, 1
                                    , P_ci, 'I'                                         -- 23/03/2005
                                    , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
                    D_val_aum_ft := GP4_DEFI.get_imp_aum
                                    ( P_anno, P_mese, curv.cond_fis, 'FG', D_scaglione_figli, 1
                                    , D_imponibile, P_conguaglio, 1
                                    , P_ci, 'A'                                         -- 23/03/2005
                                    , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
                    IF D_nr_figli > 3 THEN
                       D_val_det_ft := D_val_det_ft + D_val_aum_ft;
                    END IF;
                 END IF;
              ELSE
                 D_val_det_fc  := 0;
                 D_val_det_ft  := 0;
              END IF;
              Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
-- dbms_output.put_line('calcolo del mese: D_val_ded_con '||D_val_ded_con||' D_val_ded_fig '||D_val_ded_fig||' D_val_ded_alt '||D_val_ded_alt);
-- dbms_output.put_line('calcolo del mese: D_val_ded_FIG '||D_val_ded_FIG||' D_val_det_ft '||D_val_det_ft||' coniuge '||nvl(curv.coniuge,9));
              P_stp := 'VOCI_AUTO_FAM-00e';
              IF curv.mese = P_mese and P_rilevanza = 'E'
              THEN -- Memorizza su Package GP4_RARE i valori di deduzione Mensile
                 D_ded_per := GP4_RARE.set_val_ded_fis_fam
                              ( P_ci, P_fin_ela
                              , D_val_ded_con
                              , D_val_ded_fig
                              , D_val_ded_alt
                              , 'M'
                              );
              ELSIF -- curv.mese = P_mese and
                    P_rilevanza = 'F'
              THEN -- Calcola la % di detrazione Mensile per le Detrazione L.Fin. 2007 Mensile
-- dbms_output.put_line('calcolo le detrazioni del mese '||P_mese||' all''interno del loop dell''anno ');
                IF curv.coniuge is not null THEN
                  IF D_scaglione_coniuge between 50 and 98 THEN
                     D_scaglione_cn_defi := D_scaglione_coniuge -50;
                  ELSE
                     D_scaglione_cn_defi := GP4_DEFI.get_nr_scaglione
                               ( P_anno, P_mese, curv.cond_fis, 'CN', curv.coniuge, 0
                               , curv.scaglione_coniuge, P_imponibile, P_ci
                               , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
                  END IF;
                  IF trunc(D_scaglione_cn_defi/10) in (1,3)          -- tratta lo scaglione effettivo sul reddito
                  THEN
                     D_det_per_con := 100;
-- dbms_output.put_line('D_scaglione_cn_defi '||D_scaglione_cn_defi||' D_det_per_con fissa a '||D_det_per_con);
                  ELSE D_det_per_con := gp4_defi.get_det_per_div
                                           ( P_anno, P_mese, curv.cond_fis, 'CN'
                                           , D_scaglione_cn_defi, curv.coniuge,  P_imponibile, 0
                                           , P_ci
                                           , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
-- dbms_output.put_line('D_scaglione_cn_defi '||D_scaglione_cn_defi||' D_det_per_con CALCOLATA '||D_det_per_con);
                  END IF;
                END IF;
                IF curv.figli is not null or curv.figli_dd is not null THEN
                  D_val_conv_det_fig := gp4_defi.get_val_conv_det_fig(P_fin_ela,D_nr_figli);
                  D_det_per_fig := gp4_rare.get_det_per_fam
                                  ( P_ci, P_fin_ela
                                  , D_val_conv_det_fig
                                  , P_imponibile, 'M');
-- dbms_output.put_line('+++++ P_imponibile '||P_imponibile||' D_det_per_fig '||D_det_per_fig||' D_val_conv_det_fig' ||D_val_conv_det_fig||' calcolo M');
                END IF;
                IF curv.altri is not null THEN
                  D_det_per_alt := gp4_rare.get_det_per_fam
                                  ( P_ci, P_fin_ela
                                  , D_val_conv_det_fam
                                  , P_imponibile, 'M');
                END IF;
              END IF;
-- Calcolo della % di detrazione (Finanziaria 2007) sul singolo mese ELIMINATO
--              IF P_rilevanza = 'E'
--              THEN
                 IF curv.coniuge is not null then
                    D_val_ded_con_ac := D_val_ded_con_ac + D_val_ded_con / 12;
                    D_diff_con_ac    := D_diff_con_ac    + D_diff_det_coniuge / 12;
                 END IF;
                 D_val_ded_fig_ac := D_val_ded_fig_ac + D_val_ded_fig / 12;
                 D_val_ded_alt_ac := D_val_ded_alt_ac + D_val_ded_alt / 12;
                 D_val_det_fc_ac  := D_val_det_fc_ac  + D_val_det_fc  / 12;
-- DBMS_output.put_line('xx D_val_det_ft_ac '||' D_val_det_ft '||D_val_det_ft);
                 D_val_det_ft_ac  := D_val_det_ft_ac  + D_val_det_ft  / 12;
-- DBMS_output.put_line('yy D_val_det_ft_ac '||' D_val_det_ft '||D_val_det_ft);
                 D_diff_fc_ac     := D_diff_fc_ac     + D_diff_det_fc / 12;
-- dbms_output.put_line('progressivo: D_val_ded_con_ac '||D_val_ded_con_ac||' D_val_ded_fig_ac '||D_val_ded_fig_ac||' D_val_ded_alt_ac '||D_val_ded_alt_ac);
/* Calcolo della % di detrazione (Finanziaria 2007) sul singolo mese ELIMINATO
              ELSE -- Calcola la % di detrazione Annuale (senza proiettare il reddito)
                IF curv.coniuge is not null THEN
                  IF D_scaglione_coniuge between 50 and 98 THEN
                     D_scaglione_cn_defi := D_scaglione_coniuge -50;
                  ELSE
                     D_scaglione_cn_defi := D_scaglione_coniuge;
                  END IF;
                  IF trunc(D_scaglione_cn_defi/10) in (1,3)          -- tratta lo scaglione effettivo sul reddito
                  THEN
                     D_det_per_con_ac := 100;
                     D_val_ded_con_ac := D_val_ded_con_ac + e_round( ( D_val_ded_con / 12 ) * D_det_per_con_ac / 100 ,'I');
                  ELSIF D_scaglione_coniuge = 0 THEN
                        D_det_per_con_ac := gp4_defi.get_det_per_div
                                           ( P_anno, P_mese, curv.cond_fis, 'CN'
                                           , D_scaglione_cn_defi, curv.coniuge,  D_imponibile, 1
                                           , P_ci
                                           , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
                        D_val_ded_con_ac := D_val_ded_con_ac + e_round( ( ( D_val_ded_con - (D_diff_det_coniuge* D_det_per_con_ac / 100)
                                                                          ) / 12) , 'I');
  -- dbms_output.put_line('******************* D_diff_det_couniuge '||D_diff_det_coniuge);
                  ELSE  D_det_per_con_ac := gp4_defi.get_det_per_div
                                           ( P_anno, P_mese, curv.cond_fis, 'CN'
                                           , D_scaglione_cn_defi, curv.coniuge,  D_imponibile, 1
                                           , P_ci
                                           , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
                        D_val_ded_con_ac := D_val_ded_con_ac + e_round( ( D_val_ded_con / 12 ) * D_det_per_con_ac / 100 ,'I');
                  END IF;
                END IF;
-- dbms_output.put_line('******************* D_val_ded_con '||D_val_ded_con);
-- dbms_output.put_line('******************* D_val_ded_con_ac '||D_val_ded_con_ac||' perc. '||D_det_per_con_ac);
                 D_nr_figli := nvl(curv.figli,0)+nvl(curv.figli_dd,0);
-- dbms_output.put_line('xxxx D_nr_figli '||D_nr_figli);
                 D_val_conv_det_fig := gp4_defi.get_val_conv_det_fig(P_fin_ela,D_nr_figli);
                 D_det_per_fig_ac := gp4_rare.get_det_per_fam
                                ( P_ci, P_fin_ela
                                , D_val_conv_det_fig
                                , D_imponibile, 'A');
                 D_det_per_alt_ac := gp4_rare.get_det_per_fam
                                ( P_ci, P_fin_ela
                                , D_val_conv_det_fam
                                , D_imponibile, 'A');
                 D_val_ded_fig_ac := D_val_ded_fig_ac + e_round( ( D_val_ded_fig / 12 ) * D_det_per_fig_ac / 100 ,'I');
                 D_val_ded_alt_ac := D_val_ded_alt_ac + e_round( ( D_val_ded_alt / 12 ) * D_det_per_alt_ac / 100 ,'I');
              END IF;
fine ELIMINAZIONE */
           END IF;
        END;
-- dbms_output.put_line('******************* D_coniuge '||D_coniuge||' curv.coniuge '||curv.coniuge);
        D_coniuge := nvl(curv.coniuge,D_coniuge);
        IF curv.coniuge is not null THEN
           D_cond_fis_cc := curv.cond_fis;
        END IF;
-- dbms_output.put_line('******************* D_coniuge '||D_coniuge||' curv.coniuge '||curv.coniuge);
-- dbms_output.put_line('******************* D_cond_fis '||D_cond_fis||' curv.cond_fis '||curv.cond_fis);
        D_cond_fis := nvl(curv.cond_fis,D_cond_fis);
-- dbms_output.put_line('******************* D_cond_fis '||D_cond_fis||' curv.cond_fis '||curv.cond_fis);
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END LOOP;  -- cursore CURV
-- dbms_output.put_line('******************* fine del loop su CAFA');
        P_stp := 'VOCI_AUTO_FAM-00f';
        IF P_rilevanza = 'E'
        THEN -- Memorizza su Package GP4_RARE i valori di deduzione Annuale
          D_ded_per_ac := GP4_RARE.set_val_ded_fis_fam
                          ( P_ci, P_fin_ela
                          , D_val_ded_con_ac
                          , D_val_ded_fig_ac
                          , D_val_ded_alt_ac
                          , 'A'
                          );
        ELSIF P_rilevanza = 'F'
        THEN -- Memorizza su Package GP4_RARE i valori di Detrazione L.Fin. 2007 Annuale
-- Morena: inserire il calcolo delle formule e della % per ottenere i valori annuali corretti
-- dbms_output.put_line('******************* sono dentro la F con D_coniuge '||D_coniuge);
          IF D_coniuge is not null THEN
-- dbms_output.put_line('***** D_scaglione_coniuge '||D_scaglione_coniuge);
            IF D_scaglione_coniuge between 50 and 98 THEN
               D_scaglione_cn_defi := D_scaglione_coniuge -50;
            ELSE
               D_scaglione_cn_defi := D_scaglione_coniuge;
            END IF;
-- dbms_output.put_line('***** D_scaglione_cn_defi '||D_scaglione_cn_defi||' D_val_ded_con_ac '||D_val_ded_con_ac);
            IF trunc(D_scaglione_cn_defi/10) in (1,3)          -- tratta lo scaglione effettivo sul reddito
            THEN
               D_det_per_con_ac := 100;
               D_val_ded_con_ac := e_round( D_val_ded_con_ac * D_det_per_con_ac / 100 ,'I');
            ELSIF D_scaglione_coniuge = 0 THEN
                  D_det_per_con_ac := gp4_defi.get_det_per_div
                                     ( P_anno, P_mese, D_cond_fis_cc, 'CN'
                                     , D_scaglione_cn_defi, D_coniuge,  D_imponibile, 1
                                     , P_ci
                                     , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
                  D_val_ded_con_ac :=  e_round( D_val_ded_con_ac - (D_diff_con_ac * D_det_per_con_ac / 100), 'I');
-- dbms_output.put_line('6/12**************** D_diff_det_couniuge '||D_diff_det_coniuge||' D_diff_con_ac '||D_diff_con_ac||' D_det_per_con_ac '||D_det_per_con_ac);
            ELSE  D_det_per_con_ac := gp4_defi.get_det_per_div
                                     ( P_anno, P_mese, D_cond_fis_cc, 'CN'
                                     , D_scaglione_cn_defi, D_coniuge,  D_imponibile, 1
                                     , P_ci
                                     , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
                  D_val_ded_con_ac := e_round( D_val_ded_con_ac * D_det_per_con_ac / 100 ,'I');
            END IF;
          END IF;
-- dbms_output.put_line('D_val_ded_con '||D_val_ded_con);
-- dbms_output.put_line('D_val_ded_con_ac '||D_val_ded_con_ac||' perc. '||D_det_per_con_ac);
--###
IF D_cond_fis = 'AC' THEN
            IF trunc(D_scaglione_fc/10) in (1,3)          -- tratta lo scaglione effettivo sul reddito
            THEN
               D_det_per_fc_ac := 100;
               IF nvl(D_aum_coniuge,0) = 0 THEN
                  D_val_det_fc_ac := e_round( D_val_det_fc_ac * D_det_per_fc_ac / 100 ,'I') + nvl(D_val_aum_fc,0);
               ELSE 
                  D_val_det_fc_ac := e_round( D_val_det_fc_ac * D_det_per_fc_ac / 100 ,'I');
               END IF;
            ELSIF D_scaglione_fc = 0 THEN
                  D_det_per_fc_ac := gp4_defi.get_det_per_div
                                     ( P_anno, P_mese, 'CC', 'CN'
                                     , D_scaglione_fc, 1,  D_imponibile, 1
                                     , P_ci
                                     , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
                  D_val_det_fc_ac :=  e_round( D_val_det_fc_ac - (D_diff_fc_ac * D_det_per_fc_ac / 100), 'I');
            ELSE  D_det_per_fc_ac := gp4_defi.get_det_per_div
                                     ( P_anno, P_mese, 'CC', 'CN'
                                     , D_scaglione_fc, 1,  D_imponibile, 1
                                     , P_ci
                                     , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
                  D_val_det_fc_ac := e_round( D_val_det_fc_ac * D_det_per_fc_ac / 100 ,'I');
            END IF;
-- dbms_output.put_line('D_val_det_fc_ac '||D_val_det_fc_ac||' perc. '||D_det_per_fc_ac);
END IF;
          D_val_conv_det_fig := gp4_defi.get_val_conv_det_fig(P_fin_ela,D_nr_figli);
          D_det_per_fig_ac := gp4_rare.get_det_per_fam
                         ( P_ci, P_fin_ela
                         , D_val_conv_det_fig
                         , D_imponibile, 'A');
-- dbms_output.put_line('@@D_val_ded_fig '||D_val_ded_fig);
-- dbms_output.put_line('@@D_val_ded_fig_ac '||D_val_ded_fig_ac||' perc. '||D_det_per_fig_ac);
          D_det_per_alt_ac := gp4_rare.get_det_per_fam
                         ( P_ci, P_fin_ela
                         , D_val_conv_det_fam
                         , D_imponibile, 'A');
          D_val_ded_fig_ac := e_round( D_val_ded_fig_ac * D_det_per_fig_ac / 100 ,'I');
          D_val_det_ft_ac  := e_round( D_val_det_ft_ac  * D_det_per_fig_ac / 100 ,'I');
          D_val_ded_alt_ac := e_round( D_val_ded_alt_ac * D_det_per_alt_ac / 100 ,'I');
-- dbms_output.put_line('::::D_val_det_ft_ac '||D_val_det_ft_ac||' D_val_det_fc_ac '||D_val_det_fc_ac);
          gp4_rare.set_val_det_fis_fam( P_ci, P_fin_ela
                                      , '', '', ''
                                      , D_det_per_con_ac, D_det_per_fig_ac, D_det_per_alt_ac
                                      -- passa i campi "ded" perche utilizzati nel calcolo precedente, ma in caso di
                                      -- rilevanza 'F' contengono i valori delle DETRAZIONI
                                      , D_val_ded_con_ac + nvl(D_aum_coniuge,0)
                                      , D_val_det_fc_ac, D_val_det_ft_ac, D_val_ded_fig_ac, D_val_ded_alt_ac, 'A');
        END IF;
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        IF D_conguaglio = 1
        THEN -- Utilizza la Percentuale Annuale nella successiva emissione delle Deduzioni
           D_ded_per := D_ded_per_ac;
           D_det_per_con := D_det_per_con_ac;
           D_det_per_fig := D_det_per_fig_ac;
           D_det_per_alt := D_det_per_alt_ac;
        END IF;
     END IF;
     -- Esegue ciclo su Carichi Familiari solo se:
     --   o rilevanza 'A' (ass.fam.)
     --   o rilevanza 'E' (deduzioni) ed esiste Valore Convenzionale
     --   o rilevanza 'D' (detrazioni ante 2005) e non esiste Valore Convenzionale
     --   o rilevanza 'F' (deduzioni Finanziaria 2007) ed esiste Valore Convenzionale
-- dbms_output.put_line('cosa devo calcolare? ');
-- dbms_output.put_line('   rilevanza '||P_rilevanza);
-- dbms_output.put_line('   D_val_conv_ded_fam '||D_val_conv_ded_fam);
-- dbms_output.put_line('   D_val_conv_det_fam '||D_val_conv_det_fam );
     IF P_rilevanza = 'A'
     OR P_rilevanza = 'D' and D_val_conv_ded_fam is null and D_val_conv_det_fam is null
     OR P_rilevanza = 'E' and D_val_conv_ded_fam is not null
     OR P_rilevanza = 'F' and D_val_conv_det_fam is not null
     THEN
        P_stp := 'VOCI_AUTO_FAM-01';
-- dbms_output.put_line('Conguaglio '||D_Conguaglio);
-- dbms_output.put_line('P_rilevanza '||P_rilevanza||' P_anno '||P_anno||' P_mese '||P_mese||
--                     ' d_effe_cong '||d_effe_cong||' P_tipo '||P_tipo||' P_fin_ela '||P_fin_ela);
        FOR CURF IN C_CAFA(D_Conguaglio)
        LOOP
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
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
               Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
               Peccmore3.VOCI_AUTO_FAM_AF  -- Assegno per Nucleo Familiare
                  (P_ci, P_al
                      , curf.anno, P_mese, P_mensilita, P_fin_ela
                      , P_ass_fam, curf.cond_fam, curf.nucleo_fam
                      , curf.figli_fam, curf.mese
                      , curf.giorni, D_cong_af
                      , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                  );
             END;
          END IF;  -- Termine trattamento p_rilevanza 'A'
          IF  curf.anno = P_anno
          AND (   P_rilevanza = 'D' -- Detrazioni Imposta
              OR  P_rilevanza = 'E' -- Deduzioni  Imponibile
              OR  P_rilevanza = 'F' -- Detrazioni Imposta da Finanziaria 2007
              )
          --
          -- Determinazione Voci di DETRAZIONE o DEDUZIONE FISCALE
          --              solo per Anno Corrente
          --
          THEN
            IF P_rilevanza in( 'D', 'E') -- Lo scaglione per Deduzioni e le Detrazioni L.Fin. 2007
                                         --  ??? se non indicato, viene assunto sempre = 1
            THEN
              IF curf.scaglione_coniuge is null
              THEN
                 D_scaglione_coniuge := 1;
              ELSE
                 D_scaglione_coniuge := curf.scaglione_coniuge;
              END IF;
              IF curf.scaglione_figli is null
              THEN
                 D_scaglione_figli   := 1;
              ELSE
                 D_scaglione_figli   := curf.scaglione_figli;
              END IF;
            ELSE
               D_scaglione_coniuge := curf.scaglione_coniuge;
               D_scaglione_figli   := curf.scaglione_figli;
            END IF;
-- dbms_output.put_line('yyyyyyy P_det_con '||P_det_con||' '||curf.coniuge||' '||curf.mese||' '||p_mese);
            IF  P_det_con     IS NOT NULL
            AND (   NVL(curf.coniuge,0) != 0
                 OR curf.mese != P_mese         -- Richesta Conguaglio
                )
            THEN
               BEGIN
                 P_stp := 'VOCI_AUTO_FAM-03';
                 Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                 IF    P_rilevanza = 'E' THEN
                       D_Percentuale := D_ded_per;
                 ELSIF P_rilevanza = 'F' THEN
-- dbms_output.put_line('passo di qui D_scaglione_coniuge '|| D_scaglione_coniuge );
                       D_Percentuale := D_det_per_con;
-- dbms_output.put_line('coniuge  Perc. '||D_det_per_con);
                 END IF;
-- dbms_output.put_line('coniuge Rilevanza '||P_rilevanza||' Perc. '||D_percentuale||' D_scaglione_coniuge '||
--                       D_scaglione_coniuge||' d_conguaglio '||d_conguaglio);
                 Peccmore3.VOCI_AUTO_FAM_DF  -- Detrazione Coniuge
                    (P_ci, P_al
                        , curf.anno, P_mese, P_tipo, P_fin_ela
                        , P_rilevanza
                        , P_det_con, curf.cond_fis, 'CN'
                        , D_scaglione_coniuge, curf.coniuge
                        , curf.mese, curf.giorni, D_cong_cn,p_imponibile,d_divisore,d_conguaglio
                        , 0
                        , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                        , D_percentuale
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
                 Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                 IF    P_rilevanza = 'E' THEN
                       D_Percentuale := D_ded_per;
                 ELSIF P_rilevanza = 'F' THEN
                       D_Percentuale := D_det_per_fig;
                 END IF;
                 Peccmore3.VOCI_AUTO_FAM_DF  -- Detrazione Figli
                    (P_ci, P_al
                        , curf.anno, P_mese, P_tipo, P_fin_ela
                        , P_rilevanza
                        , P_det_fig, curf.cond_fis, 'FG'
                        , D_scaglione_figli ,curf.figli
                        , curf.mese, curf.giorni, D_cong_fg,p_imponibile,d_divisore,d_conguaglio
                        , D_nr_figli
                        , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                        , D_percentuale
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
                 Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                 IF    P_rilevanza = 'E' THEN
                       D_Percentuale := D_ded_per;
                 ELSIF P_rilevanza = 'F' THEN
                       D_Percentuale := D_det_per_fig;
                 END IF;
                 Peccmore3.VOCI_AUTO_FAM_DF  -- Detrazione Figli Doppia Detrazione
                    (P_ci, P_al
                        , curf.anno, P_mese, P_tipo, P_fin_ela
                        , P_rilevanza
                        , P_det_fig, curf.cond_fis, 'FD'
                        , D_scaglione_figli, curf.figli_dd
                        , curf.mese, curf.giorni, D_cong_fg,p_imponibile,d_divisore,d_conguaglio
                        , D_nr_figli
                        , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                        , D_percentuale
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
                 Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                 IF    P_rilevanza = 'E' THEN
                       D_Percentuale := D_ded_per;
                 ELSIF P_rilevanza = 'F' THEN
                       D_Percentuale := D_det_per_fig;
                 END IF;
                 Peccmore3.VOCI_AUTO_FAM_DF  -- Detrazione Figli Minori
                    (P_ci, P_al
                        , curf.anno, P_mese, P_tipo, P_fin_ela
                        , P_rilevanza
                        , P_det_fig, curf.cond_fis, 'FM'
                        , D_scaglione_figli, curf.figli_mn
                        , curf.mese, curf.giorni, D_cong_fg,p_imponibile,d_divisore,d_conguaglio
                        , D_nr_figli
                        , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                        , D_percentuale
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
                  Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                 IF    P_rilevanza = 'E' THEN
                       D_Percentuale := D_ded_per;
                 ELSIF P_rilevanza = 'F' THEN
                       D_Percentuale := D_det_per_fig;
                 END IF;
                  Peccmore3.VOCI_AUTO_FAM_DF  -- Detrazione Figli Minori Doppi
                     (P_ci, P_al
                          , curf.anno, P_mese, P_tipo, P_fin_ela
                          , P_rilevanza
                          , P_det_fig, curf.cond_fis, 'MD'
                          , D_scaglione_figli, curf.figli_mn_dd
                          , curf.mese, curf.giorni,D_cong_fg,p_imponibile,d_divisore,d_conguaglio
                          , D_nr_figli
                          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                          , D_percentuale
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
                  Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                 IF    P_rilevanza = 'E' THEN
                       D_Percentuale := D_ded_per;
                 ELSIF P_rilevanza = 'F' THEN
                       D_Percentuale := D_det_per_fig;
                 END IF;
                  Peccmore3.VOCI_AUTO_FAM_DF  -- Detrazione Figli Handicappati
                     (P_ci, P_al
                          , curf.anno, P_mese, P_tipo, P_fin_ela
                          , P_rilevanza
                          , P_det_fig, curf.cond_fis, 'FH'
                          , D_scaglione_figli, curf.figli_hh
                          , curf.mese, curf.giorni,D_cong_fg,p_imponibile,d_divisore,d_conguaglio
                          , D_nr_figli
                          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                          , D_percentuale
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
                  Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                 IF    P_rilevanza = 'E' THEN
                       D_Percentuale := D_ded_per;
                 ELSIF P_rilevanza = 'F' THEN
                       D_Percentuale := D_det_per_fig;
                 END IF;
                  Peccmore3.VOCI_AUTO_FAM_DF  -- Detrazione Figli Minori Doppi
                     (P_ci, P_al
                          , curf.anno, P_mese, P_tipo, P_fin_ela
                          , P_rilevanza
                          , P_det_fig, curf.cond_fis, 'HD'
                          , D_scaglione_figli, curf.figli_hh_dd
                          , curf.mese, curf.giorni,D_cong_fg,p_imponibile,d_divisore,d_conguaglio
                          , D_nr_figli
                          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                          , D_percentuale
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
                 Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                 IF    P_rilevanza = 'E' THEN
                       D_Percentuale := D_ded_per;
                 ELSIF P_rilevanza = 'F' THEN
                       D_Percentuale := D_det_per_alt;
                 END IF;
                 Peccmore3.VOCI_AUTO_FAM_DF  -- Detrazione Altri
                    (P_ci, P_al
                        , curf.anno, P_mese, P_tipo, P_fin_ela
                        , P_rilevanza
                        , P_det_alt, curf.cond_fis, 'AL'
                        , D_scaglione_figli, curf.altri
                        , curf.mese, curf.giorni, D_cong_al,p_imponibile,d_divisore,d_conguaglio
                        , 0
                        , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                        , D_percentuale
                    );
               END;
            END IF;
            /* Vecchio calcolo altre detrazioni - ante 2003 */
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
                   Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                   Peccmore3.VOCI_AUTO_FAM_DF  -- Detrazione Spese
                      (P_ci, P_al
                          , P_anno, P_mese, P_tipo, P_fin_ela
                          , P_rilevanza
                          , P_det_spe, '*', 'SP', P_spese, ''
                          , curf.mese, NULL, D_cong_sp,p_imponibile,d_divisore,d_conguaglio
                          , 0
                          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                      );
                 END;
              END IF;
              IF P_det_ult IS NOT NULL AND NVL(P_ulteriori,0) != 0 AND P_reddito_dip != 0
              THEN
                 BEGIN
                   P_stp := 'VOCI_AUTO_FAM-08';
                   Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
                   Peccmore3.VOCI_AUTO_FAM_DF  -- Detrazione Ulteriori
                      (P_ci, P_al
                          , P_anno, P_mese, P_tipo, P_fin_ela
                          , P_rilevanza
                          , P_det_ult, '*', P_tipo_ulteriori, P_ulteriori, ''
                          , curf.mese, NULL, D_cong_ud,p_reddito_dip,d_divisore,d_conguaglio
                          , 0
                          , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                      );
                 END;
              END IF;
            END IF; -- Fine Vecchio calcolo altre detrazioni - ante 2003
          END IF; -- Fine trattamento p_rilevanza = 'D', 'E', F'
        END;
        END LOOP;  -- cursore CURF
     END IF;  -- Fine esecuzione condizionata su Rilevanza 'D' o 'E'.
/*   nuove detrazioni da Finanziaria 2007 */
     IF  P_rilevanza    = 'F' and d_val_conv_det_fam is not null
     AND P_tipo         = 'N'           -- Se Mensilita` Normale
     AND P_det_spe      IS NOT NULL
     AND NVL(P_spese,0) != 0            -- Detrazioni di Spese del mese
     THEN
        BEGIN
          P_stp := 'VOCI_AUTO_FAM-09';
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
          select decode(p_conguaglio,0,12,1)
            into d_divisore
            from dual
          ;
          Peccmore3.VOCI_AUTO_FAM_DF  -- Detrazione Finanziaria 2007
             (P_ci, P_al
                 , P_anno, P_mese, P_tipo, P_fin_ela
                 , P_rilevanza
                 , P_det_spe, '*', P_tipo_Spese, P_spese, ''
                 , P_mese, NULL, D_cong_sp,p_imponibile,d_divisore,P_conguaglio
                 , 0
                 , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
             );
        END;
     END IF;
     /* Vecchio calcolo per SPESE DI PRODUZIONE - ante 2003 */
     IF  P_rilevanza    = 'D'
     AND P_tipo         = 'N'           -- Se Mensilita` Normale
     AND P_det_spe      IS NOT NULL
     AND NVL(P_spese,0) != 0            -- Detrazioni di Spese del mese
     THEN
        BEGIN
          P_stp := 'VOCI_AUTO_FAM-09';
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
          select decode(p_conguaglio,0,12,1)
            into d_divisore
            from dual
          ;
          Peccmore3.VOCI_AUTO_FAM_DF  -- Detrazione Spese
             (P_ci, P_al
                 , P_anno, P_mese, P_tipo, P_fin_ela
                 , P_rilevanza
                 , P_det_spe, '*', 'SP',P_spese, ''
                 , P_mese, NULL, D_cong_sp,p_imponibile,d_divisore,P_conguaglio
                 , 0
                 , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
             );
        END;
     END IF; -- fine vecchio calcolo per SPESE DI PRODUZIONE - ante 2003 */
     IF  P_rilevanza          = 'D'
     AND P_reddito_dip       != 0
     AND P_det_ult           IS NOT NULL
     AND P_tipo               = 'N'      -- Se Mensilita` Normale
                                         -- Ulteriori Detrazioni del mese
     THEN
       IF NVL(P_ulteriori,0) != 0
       OR d_effe_cong IN ('M','A')
          AND P_mese                     = 12
          AND P_tipo                     IN ( 'S', 'N' )
       OR P_conguaglio       != 0
          AND NVL(d_effe_cong,' ') != 'N'
       OR NVL(d_effe_cong,' ') = 'M'
       THEN
         BEGIN
           P_stp := 'VOCI_AUTO_FAM-10';
           IF d_conguaglio = 1 THEN d_divisore := 1;
           END IF;
           Peccmore3.VOCI_AUTO_FAM_DF  -- Detrazione Ulteriori
              (P_ci, P_al
                   , P_anno, P_mese, P_tipo, P_fin_ela
                   , P_rilevanza
                   , P_det_ult, '*', P_tipo_ulteriori
                   , P_ulteriori,''
                   , P_mese, NULL, D_cong_ud,p_reddito_dip,d_divisore,d_conguaglio
                   , 0
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
     Peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
END;
/
