CREATE OR REPLACE PACKAGE peccmore_addizionali IS
/******************************************************************************
 NOME:        peccmore_addizionali
 DESCRIZIONE: Calcolo VOCI Fiscali.
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    13/02/2007 __     Prima emissione.
 1.0  08/03/2007 ML     Gestione Addizionale comunale con esenzione e scaglioni (A19993.0)
 1.1  14/03/2007 ML     Gestione formato del campo aliquota come da tabella (%type) (A19926.1)
 1.2  04/04/2007 ML     Gestione richiesta esenzione comunale (A20420)
 1.3  27/04/2007 ML     Inserimento addizionale comunale sospesa anche per conguagli successivi (A19870)
******************************************************************************/
revisione varchar2(30) := '1.3 del 27/04/2007';
FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);
FUNCTION get_add_comu
        ( P_ipn_tot_ac Number
        , P_alq_add_comu ADDIZIONALE_IRPEF_COMUNALE.aliquota%TYPE
        )  RETURN NUMBER;
pragma restrict_references(VERSIONE,WNDS,WNPS);
FUNCTION get_alq_comu
        ( P_ci      Number
        , P_anno    Number
        , P_fin_ela Date
        )  RETURN NUMBER;
--
-- NON UTILIZZATA
--        
pragma restrict_references(VERSIONE,WNDS,WNPS);
PROCEDURE get_alq_comup
        ( P_ci         IN     Number
        , P_anno       IN     Number
        , P_fin_ela    IN     Date
        , P_reddito    IN     number
        , P_alq        IN OUT ADDIZIONALE_IRPEF_COMUNALE.aliquota%TYPE
        , P_esenzione  IN OUT number
        , P_scaglione  IN OUT number
        , P_imposta    IN OUT number
        );
pragma restrict_references(VERSIONE,WNDS,WNPS);
PROCEDURE rate_com
(
 p_ci         NUMBER
,p_al        DATE    --Data di Termine o Fine Mese
,p_anno       NUMBER
,p_mese       NUMBER
,p_mensilita  VARCHAR2
,p_rate_addizionali NUMBER
,P_add_com_ra   VARCHAR2
,P_add_com_pa       VARCHAR2
,P_add_com_so       VARCHAR2
,P_dimesso      VARCHAR2
-- Parametri per TRACE
,p_trc    IN     NUMBER     -- Tipo di Trace
,p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
);
PROCEDURE add_com
(
 p_ci        NUMBER
,p_al        DATE    --Data di Termine o Fine Mese
,p_anno       NUMBER
,p_mese       NUMBER
,p_mensilita  VARCHAR2
,p_fin_ela    DATE
,p_tipo       VARCHAR2
,p_rate_addizionali NUMBER
,p_imp_add_veneto IN OUT  NUMBER     -- Addizionale Regione Veneto per casi particolari   -- 20/12/2005
,p_caso_particolare IN OUT NUMBER     -- Add.Reg. Veneto, anche se importo = 0            -- 20/12/2006
, P_dimesso      VARCHAR2
, P_cat_fiscale  VARCHAR2
--  Voci parametriche
, P_add_comu     VARCHAR2
, P_add_comus    VARCHAR2
, P_add_comup    VARCHAR2
, P_add_com_so   VARCHAR2
-- Valori Fiscali
, p_ipn_tot_ac NUMBER
, p_ipt_ac     NUMBER
, p_det_fis_ac NUMBER
, p_add_comu_mp  NUMBER
, P_add_com_terzi NUMBER
, D_add_comu_mc  OUT NUMBER
-- Parametri per Trace
,p_trc    IN     NUMBER     -- Tipo di Trace
,p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
);
PROCEDURE add_reg
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
-- Valori Fiscali
, p_ipn_tot_ac   NUMBER
, p_ipt_ac       NUMBER
, p_det_fis_ac   NUMBER
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
CREATE OR REPLACE PACKAGE BODY peccmore_addizionali IS
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
--Valorizzazione Addizionali Regionali e Comunali
FUNCTION get_add_comu
        ( P_ipn_tot_ac Number
        , P_alq_add_comu ADDIZIONALE_IRPEF_COMUNALE.aliquota%TYPE
        )  RETURN NUMBER IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
  DECLARE
    D_importo number;
  BEGIN
    D_importo := E_Round( P_ipn_tot_ac * P_alq_add_comu / 100 ,'I');
    RETURN D_importo;
   END;
END get_add_comu;
FUNCTION get_alq_comu
        ( P_ci      Number
        , P_anno    Number
        , P_fin_ela Date
        )  RETURN NUMBER IS
--
-- NON UTILIZZATA
--        
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
  DECLARE
    D_aliquota   ADDIZIONALE_IRPEF_COMUNALE.aliquota%TYPE;
    BEGIN
          BEGIN
          SELECT aliquota_irpef_comunale
            INTO D_aliquota
            FROM VALIDITA_FISCALE
           WHERE P_fin_ela BETWEEN dal
                             AND NVL(al,TO_DATE('3333333','j'))
          ;
          EXCEPTION
               WHEN NO_DATA_FOUND THEN NULL;
          END;
          BEGIN
          SELECT NVL(D_aliquota,0) + NVL(aliquota,0)
            INTO D_aliquota
            FROM ADDIZIONALE_IRPEF_COMUNALE
           WHERE P_fin_ela BETWEEN dal
                               AND NVL(al,TO_DATE('3333333','j'))
             AND (cod_provincia,cod_comune) =
                (SELECT provincia_res,comune_res
                   FROM ANAGRAFICI anag
                  WHERE ni = (SELECT ni FROM RAPPORTI_INDIVIDUALI
                             WHERE ci = P_ci)
/* modifica del 25/01/2007 */
                    AND (   P_anno <  2007 and p_fin_ela
                                               BETWEEN dal AND NVL(al,TO_DATE('3333333','j'))
           -- mod. introdotta dalla Legge Finanziaria 2007:
                         or P_anno >= 2007 and dal = (select min(dal) from anagrafici
                                                       where ni = anag.ni
                                                         and  NVL(al,TO_DATE('3333333','j')) >= to_date('0101'||P_anno,'ddmmyyyy')
                                                     )
                        )
                )
/* fine modifica del 25/01/2007 */
          ;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN NULL;
          END;
    RETURN D_aliquota;
END;
END get_alq_comu;
PROCEDURE get_alq_comup
        ( P_ci         IN     Number
        , P_anno       IN     Number
        , P_fin_ela    IN     Date
        , P_reddito    IN     number
        , P_alq        IN OUT ADDIZIONALE_IRPEF_COMUNALE.aliquota%TYPE
        , P_esenzione  IN OUT number
        , P_scaglione  IN OUT number
        , P_imposta    IN OUT number
        ) IS
/******************************************************************************
 NOME:        VERSIONE
 DESCRIZIONE: Restituisce la versione e la data di distribuzione del package.
 PARAMETRI:   --
 RITORNA:     stringa varchar2 contenente versione e data.
 NOTE:        Il secondo numero della versione corrisponde alla revisione
              del package.
******************************************************************************/
BEGIN
  DECLARE
    D_aliquota   ADDIZIONALE_IRPEF_COMUNALE.aliquota%TYPE;
    BEGIN
          BEGIN
          SELECT aliquota_irpef_comunale
            INTO D_aliquota
            FROM VALIDITA_FISCALE
           WHERE P_fin_ela BETWEEN dal
                             AND NVL(al,TO_DATE('3333333','j'))
          ;
          EXCEPTION
               WHEN NO_DATA_FOUND THEN NULL;
          END;
          BEGIN
          SELECT NVL(D_aliquota,0) + NVL(aliquota,0)
               , nvl(esenzione,0),nvl(scaglione,0),nvl(imposta,0)
            INTO P_alq, P_esenzione, P_scaglione, P_imposta
            FROM ADDIZIONALE_IRPEF_COMUNALE ADIC
           WHERE P_fin_ela BETWEEN dal
                               AND NVL(al,TO_DATE('3333333','j'))
             AND (cod_provincia,cod_comune) =
                (SELECT provincia_res,comune_res
                   FROM ANAGRAFICI anag
                  WHERE ni = (SELECT ni FROM RAPPORTI_INDIVIDUALI
                             WHERE ci = P_ci)
/* modifica del 25/01/2007 */
                    AND (   P_anno <  2007 and p_fin_ela
                                               BETWEEN dal AND NVL(al,TO_DATE('3333333','j'))
           -- mod. introdotta dalla Legge Finanziaria 2007:
                         or P_anno >= 2007 and dal = (select min(dal) from anagrafici
                                                       where ni = anag.ni
                                                         and NVL(al,TO_DATE('3333333','j')) >= to_date('0101'||P_anno,'ddmmyyyy')
                                                     )
                        )
                )
             AND scaglione = (select max(scaglione)
                                from addizionale_irpef_comunale
                               where dal           = adic.dal
                                 and cod_provincia = adic.cod_provincia
                                 and cod_comune    = adic.cod_comune
                                 and scaglione    <= P_reddito)
/* fine modifica del 25/01/2007 */
          ;
          EXCEPTION
             WHEN NO_DATA_FOUND THEN NULL;
          END;
END;
END get_alq_comup;
PROCEDURE rate_com
(
 p_ci               NUMBER
,p_al               DATE    --Data di Termine o Fine Mese
,p_anno             NUMBER
,p_mese             NUMBER
,p_mensilita        VARCHAR2
,p_rate_addizionali NUMBER
,P_add_com_ra       VARCHAR2
,P_add_com_pa       VARCHAR2
,P_add_com_so       VARCHAR2
,P_dimesso          VARCHAR2
-- Parametri per TRACE
,p_trc    IN     NUMBER     -- Tipo di Trace
,p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
) IS
D_imp_com_so      INFORMAZIONI_EXTRACONTABILI.add_com_1%TYPE;
D_imp_com_ra_mp   INFORMAZIONI_EXTRACONTABILI.add_com_1%TYPE;
D_imp_com_ra      INFORMAZIONI_EXTRACONTABILI.add_com_1%TYPE;
BEGIN
     SELECT NVL(SUM(imp),0)
       INTO D_imp_com_so
       FROM MOVIMENTI_CONTABILI
      WHERE ci       = P_ci
        AND anno      = P_anno
        AND mese      = 1
        AND MENSILITA IN ('*AP','*R*')
        AND TO_CHAR(riferimento,'yyyy') >= P_anno-1
        AND voce      IN ( P_add_com_so, P_add_com_pa)
        AND sub       = '*'
     ;
     BEGIN  --Preleva valore progressivo precedente
        SELECT NVL(SUM(prco.p_imp),0)
         INTO D_imp_com_ra_mp
         FROM progressivi_contabili prco
        WHERE prco.ci        = P_ci
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
        WHERE caco.ci        = P_ci
          AND caco.voce      = P_add_com_ra
        ;
     EXCEPTION
        WHEN NO_DATA_FOUND THEN
             D_imp_com_ra := 0;
     END;
     IF P_dimesso = 'S' OR P_mese = P_rate_addizionali THEN
--dbms_output.put_line('* insert 4: '||P_add_com_ra||
--                     ' D_imp_com_so '||D_imp_com_so||' D_imp_com_ra_mp '||D_imp_com_ra_mp||' D_imp_com_ra '||D_imp_com_ra);
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
     ELSE
        IF D_imp_com_so + D_imp_com_ra_mp + D_imp_com_ra != 0 THEN
--dbms_output.put_line('* insert 5: '||P_add_com_ra||
--                     ' imp '||e_ROUND(D_imp_com_so * -1 / P_rate_addizionali,'I'));
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
     END IF;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     Peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END rate_com;
PROCEDURE add_com
(
 p_ci        NUMBER
,p_al        DATE    --Data di Termine o Fine Mese
,p_anno       NUMBER
,p_mese       NUMBER
,p_mensilita  VARCHAR2
,p_fin_ela    DATE
,p_tipo       VARCHAR2
,p_rate_addizionali NUMBER
,p_imp_add_veneto   IN OUT  NUMBER     -- Addizionale Regione Veneto per casi particolari   -- 20/12/2005
,p_caso_particolare IN OUT NUMBER     -- Add.Reg. Veneto, anche se importo = 0            -- 20/12/2006
, P_dimesso      VARCHAR2
, P_cat_fiscale  VARCHAR2
--Voci parametriche
, P_add_comu     VARCHAR2
, P_add_comus    VARCHAR2
, P_add_comup    VARCHAR2
, P_add_com_so   VARCHAR2
-- Valori Fiscali
, p_ipn_tot_ac    NUMBER
, p_ipt_ac        NUMBER
, p_det_fis_ac    NUMBER
, p_add_comu_mp   NUMBER
, P_add_com_terzi NUMBER
, D_add_comu_mc  OUT NUMBER
--Parametri per Trace
,p_trc    IN     NUMBER     --Tipo di Trace
,p_prn    IN     NUMBER     --Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     --Numero di Passo procedurale
,p_prs    IN OUT NUMBER     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
) IS
--Valori di ritorno da Subroutine
D_ipn_add_comu_mp  MOVIMENTI_FISCALI.add_irpef%TYPE;  --Ipn. add. Com.
P_reddito          MOVIMENTI_FISCALI.add_irpef%TYPE;
P_esenzione        MOVIMENTI_FISCALI.add_irpef%TYPE;
P_imposta          MOVIMENTI_FISCALI.add_irpef%TYPE;
P_scaglione        MOVIMENTI_FISCALI.add_irpef%TYPE;
P_alq              ADDIZIONALE_IRPEF_COMUNALE.aliquota%TYPE;
--D_add_comu_mc      MOVIMENTI_FISCALI.add_irpef_comunale%TYPE;
D_alq_add_comu     ADDIZIONALE_IRPEF_COMUNALE.aliquota%TYPE;
D_add_comu_ac_mp   MOVIMENTI_FISCALI.add_irpef_comunale%TYPE;
D_add_comu_ac_mc   MOVIMENTI_FISCALI.add_irpef_comunale%TYPE;
D_add_comu_ri      MOVIMENTI_FISCALI.add_irpef_comunale%TYPE;
D_add_comu_so_mp   MOVIMENTI_FISCALI.add_irpef_comunale%TYPE;
D_ci_esente        VARCHAR2(2);
--
BEGIN
  D_ci_esente := gp4_inex.get_esente_comu(P_ci,P_anno);
--dbms_output.put_line('sono nella proc. delle comunali');
  BEGIN  --Emissione Voce di Addizionale IRPEF Comunale
         --mensile e progressiva
     P_stp := 'VOCI_FISCALI-06.3';
     get_alq_comup(P_ci, P_anno, P_fin_ela, P_ipn_tot_ac, P_alq, P_esenzione, P_scaglione, P_imposta);
     D_alq_add_comu := P_alq;
--          D_alq_add_comu := nvl(get_alq_comu(P_ci,P_anno,P_fin_ela),0);
--
--  Calcolo del saldo
--
 dbms_output.put_line('P_dimesso '||P_dimesso||' D_ci_esente '||D_ci_esente||' P_esenzione '||P_esenzione);
   IF  D_ci_esente = 'NO' THEN
       P_esenzione := 0;
   END IF;
   IF D_alq_add_comu != 0 and P_ipn_tot_ac > nvl(P_esenzione,0)  THEN
        IF P_add_comu IS NOT NULL THEN
          IF (P_ipt_ac - P_det_fis_ac) > 10.33 THEN  -- in lire erano 20000
            D_add_comu_mc := get_add_comu(P_ipn_tot_ac-P_scaglione,D_alq_add_comu)
                             + P_imposta
                             - P_add_comu_mp - P_add_com_terzi;
          ELSE
            D_add_comu_mc := (P_add_comu_mp+P_add_com_terzi) *-1;
          END IF;
        ELSIF P_add_comus IS NOT NULL THEN
           IF (P_ipt_ac - P_det_fis_ac) > 0 THEN
               D_add_comu_mc := get_add_comu(P_ipn_tot_ac-P_scaglione,D_alq_add_comu)
                                + P_imposta
                                - P_add_comu_mp - P_add_com_terzi;
           ELSE
             D_add_comu_mc :=(P_add_comu_mp+P_add_com_terzi)*-1;
           END IF;
        ELSE
           D_add_comu_mc := 0;
        END IF;
   ELSE
      D_add_comu_mc := (P_add_comu_mp+P_add_com_terzi) *-1;
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
             SELECT NVL(SUM(prco.p_imp),0) * -1
               INTO D_add_comu_ac_mp
               FROM progressivi_contabili prco
              WHERE prco.ci       = P_ci
               AND prco.anno      = P_anno
               AND prco.mese      = P_mese
               AND prco.MENSILITA = P_mensilita
               AND prco.voce      =
                  (select codice from voci_economiche
                    where specifica = 'ADD_COM_AC')
               AND prco.sub       = substr(P_anno,3,2)
             ;
             SELECT NVL(SUM(imp),0) * -1
               INTO D_add_comu_ac_mc
               FROM calcoli_contabili
              WHERE ci        = P_ci
                AND voce      =
                   (select codice from voci_economiche
                     where specifica = 'ADD_COM_AC')
                AND sub       = substr(P_anno,3,2)
              ;
             SELECT NVL(SUM(prco.p_imp),0) *-1
               INTO D_add_comu_ri
               FROM progressivi_contabili prco
              WHERE prco.ci       = P_ci
               AND prco.anno      = P_anno
               AND prco.mese      = P_mese
               AND prco.MENSILITA = P_mensilita
               AND prco.voce      =
                  (select codice from voci_economiche
                    where specifica = 'ADD_COM_RI')
               AND prco.sub       = '*'
             ;
             SELECT NVL(SUM(prco.imp),0) 
               INTO D_add_comu_so_mp
               FROM movimenti_contabili prco
              WHERE prco.ci       = P_ci
               AND prco.anno      = P_anno
               AND prco.mese      = 12
--               AND prco.MENSILITA = P_mensilita
               AND prco.voce      =
                  (select codice from voci_economiche
                    where specifica = 'ADD_COM_SO')
               AND prco.sub       = '*'
             ;
          INSERT INTO CALCOLI_CONTABILI
          ( ci, voce, sub
          , riferimento
          , input
          , estrazione
          , imp
          )
          SELECT  P_ci, codice, '*'
                , P_al
                , 'C'
                , 'AF'
--                , P_ipn_tot_ac - D_ipn_add_comu_mp
--                , D_alq_add_comu * -1
                , (D_add_comu_ac_mc + D_add_comu_ac_mp + D_add_comu_ri)
            FROM voci_economiche
           WHERE specifica      = 'ADD_COM_RI'
             and D_add_comu_ri = 0
          ;
--dbms_output.put_line('* insert 1: '||NVL(P_add_comu,P_add_comus)||' tar '||to_char(P_ipn_tot_ac - D_ipn_add_comu_mp)||
--                     ' imp '||to_char(D_add_comu_mc));
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
                , P_ipn_tot_ac - D_ipn_add_comu_mp
                , D_alq_add_comu * -1
                , D_add_comu_mc * -1
            FROM dual
           WHERE NVL(P_add_comu,P_add_comus) IS NOT NULL
          ;
--
-- Inserisce la sospesa se il dipendente NON e cessato, e mese 12
--
          IF  P_mese       = 12           AND
              P_tipo      IN ( 'S', 'N' ) AND
--              P_dimesso    = 'N'          AND
              P_cat_fiscale NOT IN ('15','25') AND
              P_ANNO      >= 1999       THEN
--dbms_output.put_line('* insert 2: P_dimesso '||P_dimesso||' P_add_com_so '||P_add_com_so||' tar '||p_ipn_tot_ac - D_ipn_add_comu_mp||
--                     ' imp '||D_add_comu_mc);
dbms_output.put_line('* insert 2: P_dimesso '||P_dimesso||' P_add_com_so_mp '||D_add_comu_so_mp||
                     ' imp '||to_char(D_add_comu_mc - (D_add_comu_ac_mc + D_add_comu_ac_mp + D_add_comu_ri)));
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
                   , P_ipn_tot_ac - D_ipn_add_comu_mp
                   , D_alq_add_comu
                   , greatest( D_add_comu_mc - (D_add_comu_ac_mc + D_add_comu_ac_mp + D_add_comu_ri)
                             , D_add_comu_so_mp * -1
                             )
               FROM dual
              WHERE P_add_com_so IS NOT NULL
                and P_dimesso = 'N'
                and (    greatest( D_add_comu_mc - (D_add_comu_ac_mc + D_add_comu_ac_mp + D_add_comu_ri)
                                 , D_add_comu_mc * -1
                                 ) > 0
                     or (     greatest( D_add_comu_mc - (D_add_comu_ac_mc + D_add_comu_ac_mp + D_add_comu_ri)
                                      , D_add_comu_so_mp * -1
                                      ) < 0
                         and exists
                            (select 'x' from movimenti_contabili
                              where anno = P_anno
                                and mese = 12
                                and ci   = P_ci
                                and voce = P_add_com_so)
                        )
                    )
             ;
          END IF;
--dbms_output.put_line('* insert 3: '||P_add_comup||' tar '||D_ipn_tot_ac ||
--                     ' imp '||(D_add_comu_mc+D_add_comu_mp+D_add_com_terzi));
--
-- Inserisce voce informativa del progressivo dell'addizionale (figurativa)
--
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
                , P_ipn_tot_ac
                , D_alq_add_comu * -1
                , (D_add_comu_mc+P_add_comu_mp+P_add_com_terzi)
            FROM dual
           WHERE P_add_comup IS NOT NULL
          ;
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     Peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END add_com;
PROCEDURE add_reg
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
-- Valori Fiscali
, p_ipn_tot_ac   NUMBER
, p_ipt_ac       NUMBER
, p_det_fis_ac   NUMBER
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
D_ipt_tot_ac      MOVIMENTI_FISCALI.ipt_ord%TYPE;  --Imposta Annua
D_ipt_tot_ass_ac  MOVIMENTI_FISCALI.ipt_ass%TYPE;  --Ipt Annua Assimilati
D_ipn_tot_ass_ac  MOVIMENTI_FISCALI.ipn_ass%TYPE;  --Ipn Annua Assimilati
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
--               D_ipn_tot_ac := nvl(D_ipn_tot_ac,0) - (nvl(D_ded_con_ac,0) + nvl(D_ded_fig_ac,0) + nvl(D_ded_alt_ac,0));
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
                                   and nvl(scaglione,0) < P_ipn_tot_ac)
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
          IF P_add_irpef IS NOT NULL AND (P_ipt_ac - P_det_fis_ac) > 10.33 -- in lire erano 20000
          OR P_add_irpefs IS NOT NULL AND (P_ipt_ac - P_det_fis_ac) > 0 THEN
           IF D_regione = 7 THEN         -- Regione Veneto
              peccmore_veneto.cal_veneto ( P_ci, P_anno, P_fin_ela, P_ipn_tot_ac
                                         , D_alq_add_reg, D_alq_add_reg_aumento
                                         , D_add_irpef_mp, D_add_reg_terzi, P_imp_add_veneto, P_caso_particolare
                                         , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
                                         );
              D_add_irpef_mc := P_imp_add_veneto;
           END IF;
           IF D_regione != 7 or P_caso_particolare = 0 THEN   -- Non e' un caso particolare del Veneto
             IF D_imposta_reg > 0 AND D_imposta_reg < 1 THEN     -- si tratta di un correttivo
                select  E_Round( P_ipn_tot_ac * D_alq_add_reg / 100 ,'I')
                    +  decode( D_cond_add
                             , null, E_Round( P_ipn_tot_ac * D_alq_add_reg_aumento / 100,'I')
                                   - E_Round( ( min(nvl(scaglione,0)) -P_ipn_tot_ac ) * D_imposta_reg ,'I')
                                   , E_Round(P_ipn_tot_ac * D_alq_add_reg_aumento / 100,'I')
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
                   and nvl(scaglione,0) > P_ipn_tot_ac
                ;
             ELSIF D_regione = 7 and D_imposta_reg = 1 THEN              -- Addizionale Regione Veneto Da 29001 a 29147
/* modifica del 04/01/2007 */
                   select round( (1 - (P_ipn_tot_ac / decode( p_anno
                                                            , 2006, 28739
                                                                  , 27748
                                                            )
/* fine modifica del 04/01/2007 */
                                      ) ) * 100,4)  *-1                  -- MOd. del 12/01/2007 (inversione del segno)
                     into D_alq_add_reg_veneto
                     from dual
                   ;
                   select  E_Round( P_ipn_tot_ac * D_alq_add_reg_veneto / 100 ,'I')
                         - D_add_irpef_mp - D_add_reg_terzi
                     into D_add_irpef_mc
                     from dual
                   ;
                   D_alq_add_reg         := D_alq_add_reg_veneto;
                   D_alq_add_reg_aumento := 0;
             ELSE
             select  E_Round( P_ipn_tot_ac * D_alq_add_reg / 100 ,'I')
                  +  decode( D_cond_add
                           , null, E_Round((P_ipn_tot_ac - D_scaglione_reg)*D_alq_add_reg_aumento / 100,'I')
                                   + D_imposta_reg
                                 , E_Round(P_ipn_tot_ac * D_alq_add_reg_aumento / 100,'I')
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
                , P_ipn_tot_ac - D_ipn_add_irpef_mp
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
                   , P_ipn_tot_ac - D_ipn_add_irpef_mp
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
                , P_ipn_tot_ac
                , (D_alq_add_reg + D_alq_add_reg_aumento) * -1
                , (D_add_irpef_mc+D_add_irpef_mp+D_add_reg_terzi)
            FROM dual
           WHERE P_add_irpefp IS NOT NULL
          ;
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        END;
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
     SELECT NVL(SUM(imp),0)
       INTO D_imp_com_so
       FROM MOVIMENTI_CONTABILI
      WHERE ci       = P_ci
        AND anno      = P_anno
        AND mese      = 1
        AND MENSILITA IN ('*AP','*R*')
        AND TO_CHAR(riferimento,'yyyy') >= P_anno-1
        AND voce      IN ( P_add_com_so, P_add_com_pa)
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
     END IF;
     Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END IF;
  END;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     Peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END add_reg;
END;
/
