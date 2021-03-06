CREATE OR REPLACE PACKAGE Peccmore9 IS
/******************************************************************************
 NOME:        Peccmore9
 DESCRIZIONE: Calcolo VOCI Ritenuta
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1    28/04/2004 MF     Calcolo Ritenuta solo su Voci relative alla stessa
                        delibera indicata sulla Ritenuta (se presente):
                        - Calcolo Imponibile su Valori del Mese
                        - Riduzione Importo da valori Progressivi
                        - Riduzione Importo su valori Mese Corrente
                        Mantiene la data di competenza per le voci negative
                        provenienti da scorporo.
                        Annulla la delibera anche nel caso in cui la base di
                        calcolo della ritenuta sia una voce di classe Imponibile.
 2    09/07/2004 NN     Nelle voci ritenuta per scorporo mantiene la data di
                        competenza imposta in fase di generazione delle voci.
 3    20/07/2004 MF     Rettifica alla gestione delle ritenute su "Cumulo" di
                        imponibile.
 4    01/12/2004 NN     Corretta riduzione da progressivi nel caso di scorporo
                        su voci a cumulo.
                        Calcolo ritenute di scorporo (estrazione = RY) frazionate
                        per data riferimento in caso di flag su imponibile.
                        Non esegue la totalizzazione voci in caso di estrazione
                        RX o RY.
 4.1  28/01/2005 NN-AM  Corretta lettura progressivi nel caso di voci a Cumulo
                        con delibera (tratta comunque tutti i prg. come per le voci
                        a Progressivo e congruentemente alla riduzione)
 4.2  04/03/2005 AM     Corretta inversione di campi in insert RITENUTE-04
 4.3  08/03/2005 AM-NN  Corretto il calcolo della proporzione tra ipn_ac e ipn_ap
                        nella riduzione delle ritenute su Cumulo (prima eseguiva la
                        somma delle proporzioni sui singoli record, adesso esegue la
                        proporzione sulla somma dei record)
 4.4  31/03/2005 AM     Attivazione specifica SNN sulle voci a Cumulo
 4.5  26/05/2005 NN     Non riduce le voci di ritenuta se comunicate da variabili
 5    28/06/2005 CB     Codice SIOPE
 5.1  03/08/2005 NN     Velocizzata la insert in caco
 5.2  05/10/2005 NN     Attivato calcolo specifico per ONAOSI
 5.3  28/12/2005 NN-AM  Ritenuta AP forzata uguale a Ritenuta dell'anno se i relativi imponibili
                        sono uguali e la differenza tra le ritenute ? 0.01 (arrotondamenti).
 5.4  15/02/2006 NN     Passati anche voce e data al calcolo onaosi.
 5.5  11/07/2006 AM     Azzerati tutti i campi "di cui" della rit. ONAOSI (oltre all'ipn_ap)
 5.6  12/09/2006 ML     Modifica VOCI_RITENUTA per esclusione voci gia scorporate per delibera (A17518)
 5.7  02/05/2007 NN     Calcolo cumulo imponibile sia per riferimento che per competenza (Att. 9942).
 5.8  18/06/2007 AM     Assestamenti a seguito delle installazioni beta c/o prov. Brescia, Bergamo, Lecco
 5.9  18/09/2007 AM     Per la riduzione della ritenuta su progressivo, differenziato il trattamento 
                        delle ritenute senza cassa/comp. attivo (prima era assimilato a calcolo per competenza)
 5.10 21/09/2007 NN     Non riduceva le voci calcolate su altra voce (non su imponibile).
                        Non riduceva le voci a cumulo se non attivata Cassa/Competenza.
 5.11 24/09/2007 NN     Nel caso di ritenuta con scorporo x riferimento (RY) applicava la riduzione x cumulo. 
 5.12 27/09/2007 NN     Gestito il nuovo campo pere.delibera
 5.13 06/11/2007 NN     In caso di pi? voci con stessa delibera e riferimento diverso, valorizzava la tariffa
                        della ritenuta senza tener conto dei diversi riferimenti.
          
******************************************************************************/
revisione varchar2(30) := '5.13 del 06/11/2007';
FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);
  PROCEDURE voci_ritenuta
(
 p_ci             NUMBER
,p_anno_ret       NUMBER
,p_al             DATE    -- Data di Termine o Fine Mese
,p_anno           NUMBER
,p_mese           NUMBER
,p_mensilita       VARCHAR2
,p_fin_ela        DATE
,p_tipo           VARCHAR2
,p_conguaglio    NUMBER
,p_mens_codice     VARCHAR2
,p_periodo        VARCHAR2
,p_estrazione      VARCHAR2
,p_posizione_inail VARCHAR2
,p_data_inail      DATE
,p_cassa_competenza VARCHAR2
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
CREATE OR REPLACE PACKAGE BODY Peccmore9 IS
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
-- Valorizzazione Voci a Ritenuta
--
PROCEDURE voci_ritenuta
(
 p_ci              NUMBER
,p_anno_ret        NUMBER
,p_al              DATE    -- Data di Termine o Fine Mese
,p_anno            NUMBER
,p_mese            NUMBER
,p_mensilita       VARCHAR2
,p_fin_ela         DATE
,p_tipo            VARCHAR2
,p_conguaglio      NUMBER
,p_mens_codice     VARCHAR2
,p_periodo         VARCHAR2
,p_estrazione      VARCHAR2
,p_posizione_inail VARCHAR2
,p_data_inail      DATE
,p_cassa_competenza VARCHAR2
-- Parametri per Trace
,p_trc    IN     NUMBER     -- Tipo di Trace
,p_prn    IN     NUMBER     -- Numero di Prenotazione elaborazione
,p_pas    IN     NUMBER     -- Numero di Passo procedurale
,p_prs    IN OUT NUMBER     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
) IS
D_numero_voci    NUMBER;    -- Numero Voci a Ritenuta presenti
--
D_segno          NUMBER;
D_confronto      NUMBER;
D_rif_confronto  NUMBER;
D_assesta_mp     NUMBER;
D_assesta        NUMBER;
D_effettivo      NUMBER;
D_effettivo_mp   NUMBER;
D_specifica      VOCI_ECONOMICHE.specifica%TYPE;
D_memo_voce      VOCI_ECONOMICHE.memorizza%TYPE;
D_memo_voce_ipn  VOCI_ECONOMICHE.memorizza%TYPE;
D_memo_voce_rid  VOCI_ECONOMICHE.memorizza%TYPE;
/* modifica 01/12/2004 */
D_ritenute_frazionate VARCHAR2(2);
/* fine modifica 01/12/2004 */
D_rivo_dal       RITENUTE_VOCE.dal%TYPE;
D_rivo_al        RITENUTE_VOCE.al%TYPE;
D_dal            RITENUTE_VOCE.dal%TYPE;
D_al             RITENUTE_VOCE.al%TYPE;
D_imvo_dal       IMPONIBILI_VOCE.dal%TYPE;
D_imvo_al        IMPONIBILI_VOCE.al%TYPE;
D_val_voce_ipn   RITENUTE_VOCE.val_voce_ipn%TYPE;
D_cod_voce_ipn   RITENUTE_VOCE.cod_voce_ipn%TYPE;
D_sub_voce_ipn   RITENUTE_VOCE.sub_voce_ipn%TYPE;
D_moltiplica     RITENUTE_VOCE.moltiplica%TYPE;
D_divide         RITENUTE_VOCE.divide%TYPE;
D_per_ipn        RITENUTE_VOCE.per_ipn%TYPE;
D_sign_lim_inf   RITENUTE_VOCE.lim_inf%TYPE;
D_lim_inf        RITENUTE_VOCE.lim_inf%TYPE;
D_lim_sup        RITENUTE_VOCE.lim_sup%TYPE;
D_per_rit_ac     RITENUTE_VOCE.per_rit_ac%TYPE;
D_per_rit_ap     RITENUTE_VOCE.per_rit_ap%TYPE;
D_arrotonda      RITENUTE_VOCE.arrotonda%TYPE;
D_precisione     NUMBER;
/* modifica 20/07/2004 */
D_val_voce_rid   RITENUTE_VOCE.val_voce_rid%TYPE;
D_cod_voce_rid   RITENUTE_VOCE.cod_voce_rid%TYPE;
/* fine modifica 20/07/2004 */
/* modifica del 02/05/2007 */
D_cassa_competenza     IMPONIBILI_VOCE.cassa_competenza%TYPE;
/* fine modifica del 02/05/2007 */
--
D_per_ac         RITENUTE_VOCE.per_rit_ac%TYPE;
D_per_ap         RITENUTE_VOCE.per_rit_ap%TYPE;
D_ipn_tot_ass    CALCOLI_CONTABILI.tar%TYPE;
D_ipn_tot_nas    CALCOLI_CONTABILI.tar%TYPE;
D_ipn_ac_ass     CALCOLI_CONTABILI.tar%TYPE;
D_ipn_s_ass      CALCOLI_CONTABILI.tar%TYPE;
D_ipn_l_ass      CALCOLI_CONTABILI.tar%TYPE;
D_ipn_e_ass      CALCOLI_CONTABILI.tar%TYPE;
D_ipn_t_ass      CALCOLI_CONTABILI.tar%TYPE;
D_ipn_a_ass      CALCOLI_CONTABILI.tar%TYPE;
D_ipn_ap_ass     CALCOLI_CONTABILI.tar%TYPE;
D_ipn_pre        CALCOLI_CONTABILI.tar%TYPE;
D_ipn_dis        CALCOLI_CONTABILI.tar%TYPE;
D_ipn_res        CALCOLI_CONTABILI.tar%TYPE;
D_ipn_cum        CALCOLI_CONTABILI.tar%TYPE;
D_ipn_cum_ap     CALCOLI_CONTABILI.tar%TYPE;
/* modifica del 02/05/2007 */
D_ipn_cum_comp   CALCOLI_CONTABILI.tar%TYPE;
D_ipn_cum_comp_ap CALCOLI_CONTABILI.tar%TYPE;
D_se_cassa_competenza NUMBER;
/* fine modifica del 02/05/2007 */
D_qta            CALCOLI_CONTABILI.qta%TYPE;
D_imp            CALCOLI_CONTABILI.imp%TYPE;
D_imp_c          CALCOLI_CONTABILI.ipn_c%TYPE;
D_imp_s          CALCOLI_CONTABILI.ipn_s%TYPE;
D_imp_p          CALCOLI_CONTABILI.ipn_p%TYPE;
D_imp_l          CALCOLI_CONTABILI.ipn_l%TYPE;
D_imp_e          CALCOLI_CONTABILI.ipn_e%TYPE;
D_imp_t          CALCOLI_CONTABILI.ipn_t%TYPE;
D_imp_a          CALCOLI_CONTABILI.ipn_a%TYPE;
D_imp_ap         CALCOLI_CONTABILI.ipn_ap%TYPE;
D_ipn_eap        CALCOLI_CONTABILI.ipn_eap%TYPE;
D_effe_cong      VARCHAR(1);
D_cod_agev       VARCHAR(10);
--
BEGIN
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
  D_numero_voci := 0;
  BEGIN  -- RITENUTA su voci gia' presenti
         -- (voci Comunicate o ritenute su Progressivi
         --                  e ritenute a  Riduzione di Importo)
     P_stp := 'VOCI_RITENUTA-01';
     FOR CURV IN
        (SELECT caco.voce
             , caco.sub
             , caco.arr
             , caco.riferimento
             , caco.qta
             , caco.imp
/* modifica del 28/04/2004 */
             , caco.sede_del
             , caco.anno_del
             , caco.numero_del
             , caco.delibera
/* fine modifica del 28/04/2004 */
             , caco.ROWID
          FROM CALCOLI_CONTABILI caco
         WHERE caco.estrazione = P_estrazione
        )
     LOOP
     D_numero_voci := D_numero_voci + 1;
     IF curv.qta  = 0 AND
        curv.imp IS NULL THEN
        P_stp := 'VOCI_RITENUTA-01';
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        BEGIN  -- Preleva parametri di valorizzazione Ritenuta
          P_stp := 'VOCI_RITENUTA-02';
          SELECT rivo.val_voce_ipn
               , rivo.cod_voce_ipn
               , rivo.sub_voce_ipn
               , rivo.per_rit_ac
               , rivo.per_rit_ap
               , voeci.memorizza
/* modifica del 01/12/2004 */
               , decode ( P_estrazione
                        , 'RY', decode( voeci.specie, 'T', 'SI', null)
                              , null)
/* fine modifica del 01/12/2004 */
               , rivo.dal
               , rivo.al
            INTO D_val_voce_ipn
               , D_cod_voce_ipn
               , D_sub_voce_ipn
               , D_per_rit_ac
               , D_per_rit_ap
               , D_memo_voce_ipn
               , D_ritenute_frazionate
               , D_rivo_dal
               , D_rivo_al
            FROM VOCI_ECONOMICHE voeci
               , RITENUTE_VOCE rivo
           WHERE voeci.codice = rivo.cod_voce_ipn
             AND rivo.voce    = curv.voce
             AND rivo.sub     = curv.sub
             AND curv.riferimento
                BETWEEN NVL(rivo.dal,TO_DATE(2222222,'j'))
                    AND NVL(rivo.al ,TO_DATE(3333333,'j'))
          ;
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        EXCEPTION
          WHEN NO_DATA_FOUND THEN
            D_val_voce_ipn := ' ';
        END;
        IF curv.arr IS NULL AND
          (   D_val_voce_ipn IN ( 'I', 'T' )
           OR D_val_voce_ipn in ('C','P') AND
              D_memo_voce_ipn NOT IN ( 'M', 'S')
          )
        THEN
          BEGIN  -- Trasferimento Importo del MESE in Imponibile
             P_stp := 'VOCI_RITENUTA-03';
             UPDATE CALCOLI_CONTABILI x
               SET ( competenza
                   , tar
                   , ipn_s, ipn_p, ipn_l, ipn_e, ipn_t
                   , ipn_a, ipn_ap, ipn_eap
                   ) =
               (SELECT decode( x.estrazione
                             , 'RX', x.competenza    -- 28/04/2004 - 09/07/2004
                             , 'RY', x.competenza    -- 01/12/2004
                                   , NVL(MAX(caco.competenza),x.competenza))
                    , x.tar
                    + NVL( SUM( caco.imp
                             * DECODE(D_val_voce_ipn,'T',0,1)
                             )
                        , 0 )
                    + NVL( MAX( caco.tar
                             * DECODE(D_val_voce_ipn,'T',1,0)
                             )
                        , 0 )
                    , x.ipn_s + NVL( SUM(ipn_s), 0 )
                    , x.ipn_p + NVL( SUM(ipn_p), 0 )
                    , x.ipn_l + NVL( SUM(ipn_l), 0 )
                    , x.ipn_e + NVL( SUM(ipn_e), 0 )
                    , x.ipn_t + NVL( SUM(ipn_t), 0 )
                    , x.ipn_a + NVL( SUM(ipn_a), 0 )
                    , x.ipn_ap + NVL( SUM(ipn_ap), 0 )
                    , NVL( SUM(ipn_p), 0 )
                 FROM CALCOLI_CONTABILI caco
                WHERE caco.voce = D_cod_voce_ipn
                  AND caco.sub  = D_sub_voce_ipn
/* modifica del 28/04/2004 */
                  AND nvl(caco.sede_del,' ')= nvl(CURV.sede_del, nvl(caco.sede_del,' '))
                  AND nvl(caco.anno_del,0)  = nvl(CURV.anno_del, nvl(caco.anno_del,0))
                  AND nvl(caco.numero_del,0)= nvl(CURV.numero_del, nvl(caco.numero_del,0))
                  AND nvl(caco.delibera,'*')= nvl(CURV.delibera, nvl(caco.delibera,'*'))
/* fine modifica del 28/04/2004 */
/* modifica del 01/12/2004 */
                  AND (      x.estrazione  != 'RY'
                         AND D_val_voce_ipn = 'P'
                      OR     x.estrazione   = 'RY'
                         AND D_val_voce_ipn in ('P', 'C')  --01/12/2004
-- modifica 12/09/2006
                         AND not exists
                            (select 'x'
                               from righe_delibera_retributiva rdre
                                  , contabilita_voce           covo
                              where  rdre.sede        = caco.sede_del
                                and rdre.anno        = caco.anno_del
                                and rdre.numero      = caco.numero_del
                                and rdre.tipo        = nvl(caco.delibera,'*')
                                and rdre.bilancio    = covo.bilancio
                                and covo.voce = x.voce
                                and covo.sub  = x.sub
                                and (nvl(caco.sede_del,' ') != nvl(x.sede_del,' ') or
                                     nvl(caco.anno_del,0)   != nvl(x.anno_del,0) or
                                     nvl(caco.numero_del,0) != nvl(x.numero_del,0) or
                                     nvl(caco.delibera,'*') != nvl(x.delibera,'*'))
                            )
-- fine modifica 12/09/2006
--                         AND D_val_voce_ipn = 'P'
--                         AND NVL(caco.competenza,caco.riferimento) = x.riferimento
                         AND caco.riferimento = x.riferimento       -- essendo 'RY' leggiamo l'esatto imponibile
                         AND caco.competenza  = x.competenza        -- per cui ? stata prodotta la ritenuta da stornare
                      OR     x.estrazione   = 'RX'
                         AND caco.riferimento = x.riferimento       -- essendo 'RX' leggiamo l'esatto imponibile
                         AND caco.competenza  = x.competenza        -- per cui ? stata prodotta la ritenuta da stornare
--                      OR     x.estrazione != 'RY'
                      OR     x.estrazione not in ('RX','RY')
                         AND NVL(caco.competenza,caco.riferimento)
                             BETWEEN NVL(D_rivo_dal,TO_DATE('2222222','j'))
                                 AND NVL(D_rivo_al,TO_DATE('3333333','j'))
                      )
/* fine modifica del 01/12/2004 */
                  AND DECODE( TO_CHAR( NVL( caco.competenza
                                        ,caco.riferimento)
                                    ,'yyyy')
                           , P_anno, 'C'
                                  , 'P'
                           ) LIKE DECODE( D_per_rit_ac
                                      , 0, 'P'
                                         , DECODE( D_per_rit_ap
                                                , 0, 'C'
                                                  , '%'
                                                )
                                      )
                  AND caco.ci   = P_ci
               )
              WHERE ROWID = curv.ROWID
             ;
           Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
          END;
        END IF;
     END IF;  -- voci con curv.qta = 0 and curv.imp is null
     END LOOP;
  END;
  BEGIN  -- Ritenute da Voci ad ESTRAZIONE CONDIZIONATA
        --  su IMPORTO delle voci del MESE
     P_stp := 'VOCI_RITENUTA-04';
     INSERT INTO CALCOLI_CONTABILI
     ( ci, voce, sub
     , riferimento
     , competenza
     , input
     , estrazione
     , tar
     , ipn_s, ipn_p, ipn_l, ipn_e, ipn_t, ipn_a, ipn_ap
/* modifica del 31/03/2005 */
     , ipn_eap
/* fine modifica del 31/03/2005 */
     , risorsa_intervento, capitolo, articolo, impegno, anno_impegno, sub_impegno, anno_sub_impegno, conto
     , anno_del, numero_del, sede_del, delibera ,codice_siope
     )
     SELECT P_ci, rivo.voce, rivo.sub
          , MAX(caco.riferimento)
          , max(caco.competenza)
          , DECODE(MIN(pere.competenza),'P','c','C')
          , P_estrazione
          , NVL( SUM( caco.imp * DECODE(SIGN(pere.rap_ore),-1,-1,1)
                             * DECODE(pere.competenza,'P',-1,1)
                             / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
                             * DECODE(rivo.val_voce_ipn,'T',0,1)
                   )
               , 0
               )
          + NVL( MAX( caco.tar * DECODE(SIGN(pere.rap_ore),-1,-1,1)
                             * DECODE(pere.competenza,'P',-1,1)
                             / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
                             * DECODE(rivo.val_voce_ipn,'T',1,0)
                   )
               , 0
               ) tar
          , NVL( SUM( caco.ipn_s * DECODE(SIGN(pere.rap_ore),-1,-1,1)
                              * DECODE(pere.competenza,'P',-1,1)
                             / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
                   )
               , 0
               ) ipn_s
          , NVL( SUM( caco.ipn_p * DECODE(SIGN(pere.rap_ore),-1,-1,1)
                              * DECODE(pere.competenza,'P',-1,1)
                             / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
                   )
               , 0
               ) ipn_p
          , NVL( SUM( caco.ipn_l * DECODE(SIGN(pere.rap_ore),-1,-1,1)
                              * DECODE(pere.competenza,'P',-1,1)
                             / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
                   )
               , 0
               ) ipn_l
          , NVL( SUM( caco.ipn_e * DECODE(SIGN(pere.rap_ore),-1,-1,1)
                              * DECODE(pere.competenza,'P',-1,1)
                             / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
                   )
               , 0
               ) ipn_e
          , NVL( SUM( caco.ipn_t * DECODE(SIGN(pere.rap_ore),-1,-1,1)
                              * DECODE(pere.competenza,'P',-1,1)
                             / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
                   )
               , 0
               ) ipn_t
          , NVL( SUM( caco.ipn_a * DECODE(SIGN(pere.rap_ore),-1,-1,1)
                              * DECODE(pere.competenza,'P',-1,1)
                             / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
                   )
               , 0
               ) ipn_a
          , NVL( SUM( caco.ipn_ap * DECODE(SIGN(pere.rap_ore),-1,-1,1)
                              * DECODE(pere.competenza,'P',-1,1)
                             / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
                   )
               , 0
               ) ipn_ap
/* modifica del 31/03/2005
   memorizza nel campo ipn_eap l'imponibile AP del mese, come fa
   per le voci calcolate sul Progressivo; serve per le voci calcolate sul Cumulo */
          , NVL( SUM( caco.ipn_p * DECODE(SIGN(pere.rap_ore),-1,-1,1)
                              * DECODE(pere.competenza,'P',-1,1)
                             / NVL(pere.intero,1) * NVL(pere.QUOTA,1)
                   )
               , 0
               ) ipn_eap
/* fine modifica del 31/03/2005 */
/* modifica del 28/04/2004 */
          , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.risorsa_intervento) )
          , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.capitolo          ) )
          , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.articolo          ) )
          , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.impegno           ) )
          , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.anno_impegno      ) )
          , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.sub_impegno       ) )
          , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.anno_sub_impegno  ) )
          , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.conto             ) )
          , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.anno_del          ) )
          , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.numero_del        ) )
/* modifica del 04/03/2005 */
          , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.sede_del          ) )
/* fine modifica del 04/03/2005 */
          , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.delibera          ) )
/* fine modifica del 28/04/2004 */
          , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.codice_siope      ) )
        FROM CALCOLI_CONTABILI   caco
          , VOCI_INAIL         voin
          , PERIODI_RETRIBUTIVI pere
          , CONTABILITA_VOCE    covo
          , RITENUTE_VOCE       rivo
          , IMPONIBILI_VOCE     imvo                 -- 02/05/2007
/* modifica del 03/08/2005 */
       WHERE caco.ci+0 = P_ci
--       WHERE caco.ci+0 = pere.ci+0
/* fine modifica del 03/08/2005 */
        AND caco.voce = rivo.cod_voce_ipn||''
        AND caco.sub  = rivo.sub_voce_ipn
        AND caco.riferimento
               BETWEEN pere.dal
                   AND pere.al
        AND caco.riferimento
            BETWEEN NVL(covo.dal,TO_DATE(2222222,'j'))
               AND NVL(covo.al ,TO_DATE(3333333,'j'))
/* modifica del 02/05/2007 */
        AND imvo.voce(+) = caco.voce
        AND caco.riferimento
            BETWEEN NVL(imvo.dal,TO_DATE(2222222,'j'))
               AND NVL(imvo.al ,TO_DATE(3333333,'j'))
        AND (  (    nvl(imvo.cassa_competenza,'NO') = 'SI'
                AND rivo.lim_inf is not null
                AND caco.riferimento
                    BETWEEN NVL(rivo.dal,TO_DATE(2222222,'j'))
                        AND NVL(rivo.al ,TO_DATE(3333333,'j')))
             OR ((   nvl(imvo.cassa_competenza,'NO') = 'NO'
                  OR rivo.lim_inf is null)
                 AND nvl(caco.competenza,caco.riferimento)
                     BETWEEN NVL(rivo.dal,TO_DATE(2222222,'j'))
                         AND NVL(rivo.al ,TO_DATE(3333333,'j')))
             )
/* fine modifica del 02/05/2007 */
        AND TO_CHAR(caco.riferimento,'yyyy') =
            DECODE( TRANSLATE( rivo.sub, '0123456789', '999999999' )
                 , '-9', TO_CHAR( TO_NUMBER(
                                    TO_CHAR(pere.periodo,'yyyy')
                                        ) + TO_NUMBER(rivo.sub)
                              )
                      , TO_CHAR(caco.riferimento,'yyyy')
                 )
        AND DECODE( TO_CHAR( NVL(caco.competenza,caco.riferimento)
                          ,'yyyy')
                 , P_anno, 'C'
                        , 'P'
                 ) LIKE DECODE( rivo.per_rit_ac
                             , 0, 'P'
                               , DECODE( rivo.per_rit_ap
                                      , 0, 'C'
                                         , '%'
                                      )
                             )
        AND voin.voce (+) = covo.voce||''
        AND voin.sub  (+) = covo.sub
        AND NVL( voin.codice
               , DECODE( P_data_inail
                      , NULL, 'x'
                           , NVL( P_posizione_inail,'x')
                      )
               ) = DECODE( P_data_inail
                       , NULL, 'x'
                             , NVL( P_posizione_inail
                                 , NVL(voin.codice,'x')
                                 )
                       )
/* modifica del 03/08/2005 */
        AND pere.ci         = caco.ci
--        AND pere.ci         = P_ci
/* fine modifica del 03/08/2005 */
        AND pere.periodo     = P_fin_ela
        AND (     caco.estrazione != 'I'
             AND (    caco.input       = UPPER(caco.input)
                 AND pere.competenza IN ('C','A')
                 OR  caco.input      != UPPER(caco.input)
                 AND pere.competenza  = 'P'
                )
             OR    caco.estrazione = 'I'
             AND (    pere.competenza IN ('C','A')
                 OR  pere.competenza  = 'P'
                 AND NOT EXISTS
                    (SELECT 'x'
                      FROM PERIODI_RETRIBUTIVI
                      WHERE ci         = P_ci
                       AND periodo     = P_fin_ela
                       AND competenza IN ('C','A')
                       AND caco.riferimento
                                BETWEEN dal AND al
                    )
                )
            )
        AND covo.voce = rivo.voce||''
        AND covo.sub  = rivo.sub
        AND rivo.val_voce_ipn != 'P'
        AND NVL(rivo.val_voce_rid,'C') = 'C'
        AND rivo.voce IN
           (SELECT codice
              FROM VOCI_ECONOMICHE
             WHERE classe     = 'R'
               AND estrazione = SUBSTR(P_estrazione,2,1)
           )
        AND EXISTS
     (SELECT 'x'
        FROM ESTRAZIONI_VOCE esvo
       WHERE esvo.voce          = rivo.voce
        AND esvo.sub           = rivo.sub
        AND esvo.richiesta      = 'C'
        AND pere.gestione    LIKE esvo.gestione
        AND pere.contratto   LIKE esvo.contratto
        AND pere.trattamento LIKE esvo.trattamento
        AND (   esvo.condizione = 'S'
             OR esvo.condizione = 'F' AND P_mese = 12 AND
                                      P_tipo = 'N'
             OR P_mens_codice LIKE esvo.condizione
             OR SUBSTR(esvo.condizione,1,1) = 'P' AND
               SUBSTR(esvo.condizione,2,1) = P_periodo
             OR esvo.condizione = 'C' AND P_conguaglio = 2
             OR esvo.condizione = 'I' AND P_conguaglio IN (1,2,3)
             OR esvo.condizione = 'N' AND P_anno != P_anno_ret
             OR esvo.condizione = 'M' AND P_tipo       = 'N' AND
                                      pere.gg_fis != 0
             OR EXISTS
               (SELECT 'x'
                 FROM PERIODI_RETRIBUTIVI
                WHERE  ci      = P_ci
                  AND  periodo = P_fin_ela
                  AND TO_NUMBER( TO_CHAR(mese)||TO_CHAR(anno) )
                             =
                      TO_NUMBER( TO_CHAR(P_fin_ela,'mmyyyy') )
               HAVING (    esvo.condizione    = 'R'
                      AND P_tipo            = 'N'
                      AND SUM(NVL(gg_rat,0)) > 14
                      OR  esvo.condizione    = 'G'
                      AND SUM(NVL(gg_rid,0)) > 0
                      )
               )
            )
     )
      GROUP BY rivo.voce, rivo.sub
             , DECODE( rivo.val_voce_ipn
                     , 'C', rivo.al
                          , caco.riferimento
                     )
             , DECODE( rivo.val_voce_ipn             -- 01/12/2004
                     , 'C', rivo.al
                          , caco.competenza
                     )
--             , caco.competenza
/* modifica del 28/04/2004 */
             , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.risorsa_intervento) )
             , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.capitolo          ) )
             , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.articolo          ) )
             , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.impegno           ) )
             , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.anno_impegno      ) )
             , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.sub_impegno       ) )
             , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.anno_sub_impegno  ) )
             , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.conto             ) )
             , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.anno_del          ) )
             , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.sede_del          ) )
             , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.numero_del        ) )
             , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.delibera          ) )
             , DECODE( rivo.val_voce_ipn,'C',NULL, DECODE(caco.estrazione,'I',NULL,caco.codice_siope      ) )
/* fine modifica del 28/04/2004 */
      HAVING NOT EXISTS
            (SELECT 'x'
               FROM CALCOLI_CONTABILI
              WHERE arr IS NULL
               AND voce = rivo.voce
               AND sub  = rivo.sub
               AND ci   = P_ci
            )
     ;
     D_numero_voci := D_numero_voci + SQL%ROWCOUNT;
  Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  IF D_numero_voci != 0 THEN
  BEGIN  -- Calcolo Ritenuta sulla singola Voce
     P_stp := 'VOCI_RITENUTA-05';
     FOR CURC IN
        (SELECT caco.voce, caco.sub
             , caco.riferimento
             , to_char(to_date('3112'||to_number(to_char(caco.riferimento,'yyyy')) -1,'ddmmyyyy')) riferimento_onaosi
             , caco.competenza
             , caco.tar
             , caco.ipn_s
             , caco.ipn_p
             , caco.ipn_l
             , caco.ipn_e
             , caco.ipn_t
             , caco.ipn_a
             , caco.ipn_ap
             , NVL(caco.ipn_eap,0) ipn_eap
             , caco.ROWID
/* modifica del 01/12/2004 */
             , caco.sede_del
             , caco.anno_del
             , caco.numero_del
             , caco.delibera
/* fine modifica del 01/12/2004 */
             , caco.data
          FROM CALCOLI_CONTABILI caco
         WHERE caco.ci          = P_ci
           AND caco.estrazione  = P_estrazione
           AND caco.imp        IS NULL
        ) LOOP
-- if curc.voce = 'R.CPDEL' and curc.sub = '2' then
-- dbms_output.put_line('CMORE9 05 voce '||curc.voce||'.'||curc.sub||' rif'||curc.riferimento||' comp'||curc.competenza||' tar '||curc.tar);
-- end if;
        P_stp := 'VOCI_RITENUTA-05.1';
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        <<tratta_voce>>
        BEGIN  -- Trattamento singola Voce di Ritenuta

          BEGIN  -- 18/06/2007 Preleva parametri di imvo se esiste
                 -- se la voce ? calcolata su una totalizzazione li forza con valoi convenzionali
             P_stp := 'VOCI_RITENUTA-06';
             SELECT nvl(min(imvo.dal),to_date('2222222','j'))
                  , nvl(max(imvo.al),to_date('3333333','j'))
                  , nvl(max(imvo.cassa_competenza),'NO')      -- 02/05/2007
               INTO D_imvo_dal
                  , D_imvo_al
                  , D_cassa_competenza                        -- 02/05/2007
               FROM RITENUTE_VOCE   rivo
                  , IMPONIBILI_VOCE imvo                      -- 02/05/2007
              WHERE rivo.voce    = curc.voce
                AND rivo.sub     = curc.sub
                AND imvo.voce    = rivo.cod_voce_ipn
                AND curc.riferimento
                    BETWEEN NVL(imvo.dal,TO_DATE(2222222,'j'))
                        AND NVL(imvo.al ,TO_DATE(3333333,'j'))
        AND (  (    nvl(imvo.cassa_competenza,'NO') = 'SI'
                AND rivo.lim_inf is not null
                AND curc.riferimento
                    BETWEEN NVL(rivo.dal,TO_DATE(2222222,'j'))
                        AND NVL(rivo.al ,TO_DATE(3333333,'j')))
             OR ((   nvl(imvo.cassa_competenza,'NO') = 'NO'
                  OR rivo.lim_inf is null)
                 AND nvl(curc.competenza,curc.riferimento)
                     BETWEEN NVL(rivo.dal,TO_DATE(2222222,'j'))
                         AND NVL(rivo.al ,TO_DATE(3333333,'j')))
             )
/* fine modifica del 02/05/2007 */
             ;
             Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
          END;
          BEGIN  -- Preleva parametri di valorizzazione Ritenuta
                 -- NON tratta IMVO in join perch? per le voci calcolate ad es. su una
                 -- totalizzazione IMVO dnon esiste (quindi lo step non tornava nulla)
             P_stp := 'VOCI_RITENUTA-06.1';
             SELECT DECODE(voec.tipo,'T',-1,1)
                  , voec.specifica
                  , voec.memorizza
                  , rivo.dal
                  , rivo.al
                  , rivo.val_voce_ipn
                  , rivo.cod_voce_ipn
                  , rivo.sub_voce_ipn
                  , NVL(rivo.moltiplica,1) moltiplica
                  , NVL(rivo.divide,1) divide
                  , NVL(rivo.per_ipn,100) per_ipn
                  , SIGN(NVL(rivo.lim_inf,0))
                  , rivo.lim_inf
                  , rivo.lim_sup
                  , NVL(rivo.per_rit_ac,0) per_rit_ac
                  , NVL(rivo.per_rit_ap,0) per_rit_ap
                  , rivo.arrotonda arrotonda
                  , DECODE( SIGN(NVL(rivo.arrotonda,1))
                          , -1, .4999999999
                              , 0
                          ) precisione
/* modifica 20/07/2004 */
                  , rivo.val_voce_rid
                  , rivo.cod_voce_rid
/* fine modifica 20/07/2004 */
               INTO D_segno
                  , D_specifica
                  , D_memo_voce
                  , D_dal
                  , D_al
                  , D_val_voce_ipn
                  , D_cod_voce_ipn
                  , D_sub_voce_ipn
                  , D_moltiplica
                  , D_divide
                  , D_per_ipn
                  , D_sign_lim_inf
                  , D_lim_inf
                  , D_lim_sup
                  , D_per_rit_ac
                  , D_per_rit_ap
                  , D_arrotonda
                  , D_precisione
                  , D_val_voce_rid
                  , D_cod_voce_rid
               FROM VOCI_ECONOMICHE voec
                  , RITENUTE_VOCE   rivo
              WHERE voec.codice = rivo.voce||''
                AND rivo.voce    = curc.voce
                AND rivo.sub     = curc.sub
/* modifica del 02/05/2007 */
        AND (  (    D_cassa_competenza = 'SI'
                AND rivo.lim_inf is not null
                AND curc.riferimento
                    BETWEEN NVL(rivo.dal,TO_DATE(2222222,'j'))
                        AND NVL(rivo.al ,TO_DATE(3333333,'j')))
             OR ((   D_cassa_competenza = 'NO'
                  OR rivo.lim_inf is null)
                 AND nvl(curc.competenza,curc.riferimento)
                     BETWEEN NVL(rivo.dal,TO_DATE(2222222,'j'))
                         AND NVL(rivo.al ,TO_DATE(3333333,'j')))
             )
/* fine modifica del 02/05/2007 */
             ;
             Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
          END;
/* modifica del 05/10/2005 */
       IF D_specifica = 'ONAOSI' THEN
          D_imp := 0;
          peccmore_onaosi.cal_onaosi ( P_ci, P_anno, curc.riferimento, curc.riferimento_onaosi
                                     , curc.voce, curc.sub, curc.data, D_imp
                                     , p_trc, p_prn, p_pas, p_prs, p_stp, p_tim);
          BEGIN  -- Aggiornamento della Voce calcolata
             P_stp := 'VOCI_RITENUTA-06.a';
             UPDATE CALCOLI_CONTABILI
                SET tar     = null
                  , qta     = null
                  , imp     = D_imp * D_segno
                  , ipn_eap = 0
                  , ipn_p   = 0
                  , IPN_S   = 0
                  , IPN_L   = 0
                  , IPN_E   = 0
                  , IPN_T   = 0
                  , IPN_A   = 0
                  , IPN_AP  = 0
              WHERE ROWID = curc.ROWID
             ;
            Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
          END;
       ELSE
/* fine modifica del 05/10/2005 */
          --
          -- Assestamento dell'Imponibile
          -- imponibilita' e limiti inferiore e superiore
          -- D_ipn_tot_ass = Imponibile Totale assestato
          -- D_ipn_tot_nas = Imponibile Totale non assestato
          -- D_ipn_ac_ass  = Imponibile Anno Corrente assestato
          --
          D_ipn_cum         := 0;
          D_ipn_cum_ap      := 0;
          D_ipn_cum_comp    := 0;                -- 02/05/2007
          D_ipn_cum_comp_ap := 0;                -- 02/05/2007
          IF D_val_voce_ipn  = 'C' THEN
/* modifica 20/07/2004 */
             --
             -- Somma il cumulo della voce indicata dai Movimenti Contabili precedenti
             -- e non pi? prelevando da Progressivi Contabili
             --
             BEGIN  -- Preleva Cumulo Importo del Periodo per Riferimento
               P_stp := 'VOCI_RITENUTA-06.1';
               SELECT NVL(SUM(moco.imp),0)
                    , NVL(SUM(moco.ipn_p),0)
                 INTO D_ipn_cum
                    , D_ipn_cum_ap
                 -- FROM progressivi_contabili prco                              -- 20/07/2004
                 FROM movimenti_contabili moco
                WHERE moco.voce    = D_cod_voce_ipn
                  AND moco.sub     = D_sub_voce_ipn
                  -- AND prco.riferimento  -- 20/07/2004
                  -- AND nvl(moco.competenza, moco.riferimento)  -- 02/05/2007
                  AND moco.riferimento
                             between nvl(D_dal,to_date('2222222','j'))
                                 and nvl(D_al ,to_date('3333333','j'))
                  -- AND decode( to_char(prco.riferimento,'yyyy')                -- 20/07/2004
                  -- AND decode( to_char(nvl(moco.competenza, moco.riferimento),'yyyy')  -- 02/05/2007
                  AND decode( to_char(moco.riferimento,'yyyy')
                            , P_anno, 'C'
                                    , 'P'
                            ) LIKE decode( D_per_rit_ac
                                         , 0, 'P'
                                            , decode( D_per_rit_ap
                                                    , 0, 'C'
                                                       , '%'
                                                    )
                                         )
                  AND moco.ci    = P_ci
                  AND moco.anno >= to_number(to_char(D_dal,'yyyy'))
                  AND moco.anno <= P_anno
                  AND moco.mese <= decode(moco.anno, P_anno, P_mese, 12)
                  -- AND prco.anno      = P_anno
                  -- AND prco.mese      = P_mese
                  -- AND prco.MENSILITA = P_mensilita
/* fine modifica 20/07/2004 */
/* modifica del 01/12/2004 */
/* modifica del 28/01/2005: commentata la mod. precedente */
--                  AND nvl(moco.sede_del,' ')= nvl(CURC.sede_del, nvl(moco.sede_del,' '))
--                  AND nvl(moco.anno_del,0)  = nvl(CURC.anno_del, nvl(moco.anno_del,0))
--                  AND nvl(moco.numero_del,0)= nvl(CURC.numero_del, nvl(moco.numero_del,0))
--                  AND nvl(moco.delibera,'*')= nvl(CURC.delibera, nvl(moco.delibera,'*'))
/* fine modifica del 28/01/2005 */
/* fine modifica del 01/12/2004 */
               ;
               Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
             EXCEPTION
               WHEN OTHERS THEN
                    D_ipn_cum         := 0;
                    D_ipn_cum_ap      := 0;
             END;
/* modifica del 02/05/2007 */
             BEGIN  -- Preleva Cumulo Importo del Periodo per Competenza
               P_stp := 'VOCI_RITENUTA-06.2';
               SELECT NVL(SUM(moco.imp),0)
                    , NVL(SUM(moco.ipn_p),0)
                 INTO D_ipn_cum_comp
                    , D_ipn_cum_comp_ap
                 FROM movimenti_contabili moco
                WHERE moco.voce    = D_cod_voce_ipn
                  AND moco.sub     = D_sub_voce_ipn
/* modifica del 18/06/2007: in caso di competenza nulla la consideriamo uguale al riferimento */
                  AND nvl(moco.competenza,moco.riferimento)
                             between nvl(D_dal,to_date('2222222','j'))
                                 and nvl(D_al ,to_date('3333333','j'))
                  AND decode( to_char(nvl(moco.competenza,moco.riferimento),'yyyy')
                            , P_anno, 'C'
                                    , 'P'
                            ) LIKE decode( D_per_rit_ac
                                         , 0, 'P'
                                            , decode( D_per_rit_ap
                                                    , 0, 'C'
                                                       , '%'
                                                    )
                                         )
                  AND moco.ci    = P_ci
                  AND moco.anno >= to_number(to_char(D_dal,'yyyy'))
                  AND moco.anno <= P_anno
                  AND moco.mese <= decode(moco.anno, P_anno, P_mese, 12)
               ;
               Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
             EXCEPTION
               WHEN OTHERS THEN
                    D_ipn_cum_comp    := 0;
                    D_ipn_cum_comp_ap := 0;
             END;
/* fine modifica del 02/05/2007 */
          END IF;
          IF D_specifica LIKE '%SAP' AND
            (   D_val_voce_ipn = 'P'
             OR D_val_voce_ipn = 'C'
            )
          THEN
             BEGIN  -- Preleva progressivo Storico Anno Precedente (SAP) per Riferimento
               P_stp := 'VOCI_RITENUTA-06.3';
               SELECT D_ipn_cum    + NVL(SUM( tar - ipn_p ),0)
                    , D_ipn_cum_ap + NVL(SUM( tar - ipn_p ),0)
                 INTO D_ipn_cum
                    , D_ipn_cum_ap
                 FROM MOVIMENTI_CONTABILI
                WHERE ci       = P_ci
                  AND anno      = P_anno
                  AND mese      = 1
                  AND MENSILITA = '*AP'
                  AND voce      = D_cod_voce_ipn
                  AND sub       = D_sub_voce_ipn
                  AND input     = 'S'
/* modifica del 02/05/2007 */
                  -- AND TO_CHAR( NVL( competenza,riferimento),'yyyy')
                  --   = TO_CHAR( NVL( curc.competenza,curc.riferimento),'yyyy')
                  AND TO_CHAR( riferimento,'yyyy')
                    = TO_CHAR( curc.riferimento,'yyyy')
/* fine modifica del 02/05/2007 */
               ;
               Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
             EXCEPTION
               WHEN OTHERS THEN
                    D_ipn_cum    := 0;
                    D_ipn_cum_ap := 0;
             END;
/* modifica del 02/05/2007 */
             BEGIN  -- Preleva progressivo Storico Anno Precedente (SAP) per Competenza
               P_stp := 'VOCI_RITENUTA-06.4';
               SELECT D_ipn_cum_comp    + NVL(SUM( tar - ipn_p ),0)
                    , D_ipn_cum_comp_ap + NVL(SUM( tar - ipn_p ),0)
                 INTO D_ipn_cum_comp
                    , D_ipn_cum_comp_ap
                 FROM MOVIMENTI_CONTABILI
                WHERE ci       = P_ci
                  AND anno      = P_anno
                  AND mese      = 1
                  AND MENSILITA = '*AP'
                  AND voce      = D_cod_voce_ipn
                  AND sub       = D_sub_voce_ipn
                  AND input     = 'S'
/* modifica del 18/06/2007: in caso di competenza nulla la consideriamo uguale al riferimento */
                  AND TO_CHAR( nvl(competenza,riferimento),'yyyy')
                    = TO_CHAR( curc.competenza,'yyyy')
               ;
               Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
             EXCEPTION
               WHEN OTHERS THEN
                    D_ipn_cum_comp    := 0;
                    D_ipn_cum_comp_ap := 0;
             END;
/* fine modifica del 02/05/2007 */
          END IF;
-- IF curc.voce = 'C.CPDEL' and curc.sub = '1' and P_estrazione = 'RY' THEN
--    dbms_output.put_line('riferimento '||curc.riferimento||' comp. '||curc.competenza);
-- END IF;
          IF     P_estrazione       = 'RY'
             AND TO_CHAR( curc.competenza,'yyyy') != TO_CHAR( curc.riferimento,'yyyy')
          THEN
                 null;
          ELSIF
--     nvl(P_cassa_competenza,'NO') = 'SI'         -- da RAGI x l'individuo in elab.
-- AND
                 nvl(D_cassa_competenza,'NO') = 'SI'         -- da IMVO
             AND D_lim_inf IS NOT NULL             -- sub 2
          THEN                                     -- Calcolo Per Riferimento
          curc.tar   := curc.tar   + D_ipn_cum;
          curc.ipn_p := curc.ipn_p + D_ipn_cum_ap;
          ELSE                                     -- Calcolo Per Competenza
/* modifica del 02/05/2007 */
          curc.tar   := curc.tar   + D_ipn_cum_comp;
          curc.ipn_p := curc.ipn_p + D_ipn_cum_comp_ap;
/* fine modifica del 02/05/2007 */
          END IF;
          IF D_lim_inf IS NULL THEN
             D_ipn_tot_ass := E_Round( curc.tar * D_moltiplica
                                          / D_divide
                                          * D_per_ipn / 100
                                 , 'I');
          ELSE
             D_ipn_tot_ass := GREATEST( 0
                                   , E_Round( curc.tar
                                         * D_moltiplica
                                         / D_divide
                                         * D_per_ipn / 100
                                         ,'I')
                                   - NVL(D_lim_inf,0)
                                   );
          END IF;
          D_ipn_tot_ass := LEAST( NVL( D_lim_sup
                                  - NVL(D_lim_inf,0)
                                  , 9999999999
                                  )
                             , D_ipn_tot_ass
                             );
          D_ipn_tot_nas := curc.tar;
          --
          -- Determinazione parte imponibile AP
          --  calcolata in Anticipo su AC (AAP)
          --  o sulla parte residua dello scaglione
          --
          IF NVL(D_specifica,' ') NOT LIKE 'SSN%' THEN
             --
             -- Tratamento Normale, AP anticipa AC
             --
             -- Memorizza provvisioriamente AP in D_ipn_ac_ass
             D_ipn_ac_ass := E_Round( curc.ipn_p
                                    * D_moltiplica
                                    / D_divide
                                    * D_per_ipn / 100
                                    , 'I');
             D_ipn_eap := LEAST( D_ipn_ac_ass
                             , NVL(D_lim_sup,9999999999)
                             );
             IF D_lim_inf IS NOT NULL THEN
               D_ipn_eap := D_ipn_eap
                         - LEAST( LEAST( D_ipn_ac_ass
                                     , NVL(D_lim_sup,9999999999)
                                     )
                               , D_lim_inf
                               );
             END IF;
             -- Memorizza totale AP + AC in D_ipn_ac_ass
             D_ipn_ac_ass := E_Round( curc.tar
                                     * D_moltiplica
                                     / D_divide
                                     * D_per_ipn / 100
                                    , 'I');
          ELSE
             --
             -- Trattamento con specifica SSN ( AP successivo ad AC )
             --
/* modifica del 31/03/2005 */
             IF D_val_voce_ipn in ('C','P') THEN
/* fine modifica del 31/03/2005 */
               -- Memorizza in D_ipn_ac_ass il totale dedotto
               --  di imponibile AP delle sole voci del mese
               --  per evitare la ridistribuzione nelle fasce
               D_ipn_ac_ass := E_Round( ( curc.tar - curc.ipn_eap )
                                         * D_moltiplica
                                         / D_divide
                                         * D_per_ipn / 100
                                      , 'I');
             ELSE
               -- Memorizza in D_ipn_ac_ass il totale dedotto
               --  di imponibile AP del progressivo
               D_ipn_ac_ass := E_Round( ( curc.tar - curc.ipn_p )
                                       * D_moltiplica
                                       / D_divide
                                       * D_per_ipn / 100
                                      , 'I');
             END IF;
             D_ipn_eap := D_ipn_tot_ass
                      - LEAST( D_ipn_ac_ass
                             , NVL(D_lim_sup,9999999999)
                             );
             IF D_lim_inf IS NOT NULL THEN
               D_ipn_eap := D_ipn_eap
                         + LEAST( LEAST( D_ipn_ac_ass
                                     , NVL(D_lim_sup,9999999999)
                                     )
                               , D_lim_inf
                               );
             END IF;
          END IF;
          -- Calcolo RITENUTA Totale
          --  Calcola i  D_imp_x
          --  in ritenute parziali in proporzione sul totale
          -- ( D_ipn_tot_nas = (ipn_corrente)
          --               + ipn_s+ipn_p+ipn_l+ipn_e )
          D_per_ac := D_per_rit_ac;
          D_per_ap := D_per_rit_ap;
          IF P_anno  != TO_CHAR( NVL(curc.competenza,curc.riferimento)
                             ,'yyyy') THEN
             D_per_ac := D_per_rit_ap;
          ELSIF
             D_per_rit_ap = 0 THEN
             D_per_ap := D_per_rit_ac;
          END IF;
          D_qta     := D_per_ac * D_segno;
          D_imp_p := E_Round( D_ipn_eap
                             * D_per_ap / 100
                            ,'I') * D_segno;
          IF D_per_ac = D_per_ap THEN
             D_imp := E_Round( D_ipn_tot_ass * D_per_ac / 100
                             ,'I') * D_segno;
          ELSIF
             D_ipn_tot_nas = 0 THEN
             D_imp := 0;
          ELSE
             D_imp := E_Round( ( D_ipn_tot_ass - D_ipn_eap )
                              * D_per_ac / 100
                              + ( D_ipn_eap )
                                 * D_per_ap / 100
                             ,'I') * D_segno;
          END IF;
          IF D_ipn_tot_nas - curc.ipn_p = 0 THEN
             D_imp_s := 0;
             D_imp_l := 0;
             D_imp_e := 0;
             D_imp_t := 0;
             D_imp_a := 0;
          ELSE
             BEGIN
             -- D_ipn_s_ass = Imponibile Separato assestato
             -- D_ipn_l_ass = Imponibile Liquidazione assestato
             -- D_ipn_e_ass = Imponibile Esente assestato
             -- D_ipn_t_ass = Imponibile Trasferta assestato
             -- D_ipn_a_ass = Imponibile Redditi Assimilati assestato
             -- D_ipn_ap_ass = Imponibile Redditi Ass. AP assestato
             -- D_ipn_pre   = Imponibile precedente da considerare
             -- D_ipn_dis   = Disponibilita` fino al limite superiore
             -- D_ipn_res   = Residuo di imponibile da emettere
             --
             D_ipn_s_ass := E_Round( curc.ipn_s * D_moltiplica / D_divide * D_per_ipn / 100 ,'I');
             D_ipn_l_ass := E_Round( curc.ipn_l * D_moltiplica / D_divide * D_per_ipn / 100 , 'I');
             D_ipn_e_ass := E_Round( curc.ipn_e * D_moltiplica / D_divide * D_per_ipn / 100 , 'I');
             D_ipn_t_ass := E_Round( curc.ipn_t * D_moltiplica / D_divide * D_per_ipn / 100 , 'I');
             D_ipn_a_ass := E_Round( curc.ipn_a * D_moltiplica / D_divide * D_per_ipn / 100 , 'I');
             --
             -- Calcolo  ipn_s
             -- --------------
             D_ipn_pre := D_ipn_ac_ass - D_ipn_s_ass - D_ipn_l_ass;
             D_ipn_dis := NVL(D_lim_sup,999999999)
                        - LEAST( NVL(D_lim_sup,999999999)
                               , D_ipn_pre
                               );
             D_ipn_res := D_ipn_s_ass
                        - LEAST( NVL(D_lim_inf,0) - LEAST( NVL(D_lim_inf,0), D_ipn_pre )
                               , D_ipn_s_ass * D_sign_lim_inf
                               );
             D_imp_s   := E_Round( LEAST(D_ipn_dis,D_ipn_res) * D_per_ac / 100, 'I' ) * D_segno;
             --
             -- Calcolo  ipn_l
             -- --------------
             D_ipn_pre := D_ipn_ac_ass - D_ipn_l_ass;
             D_ipn_dis := NVL( D_lim_sup,999999999) - LEAST( NVL(D_lim_sup,999999999), D_ipn_pre );
             D_ipn_res := D_ipn_l_ass
                        - LEAST( NVL(D_lim_inf,0) - LEAST( NVL(D_lim_inf,0) , D_ipn_pre )
                               , D_ipn_l_ass * D_sign_lim_inf
                               );
             D_imp_l   := E_Round( LEAST(D_ipn_dis,D_ipn_res) * D_per_ac / 100 , 'I' ) * D_segno;
             --
             -- Calcolo  ipn_e
             -- --------------
             D_ipn_pre := D_ipn_ac_ass - D_ipn_e_ass
                                       - D_ipn_s_ass
                                       - D_ipn_l_ass;
             D_ipn_dis := NVL(D_lim_sup,999999999) - LEAST( NVL(D_lim_sup,999999999), D_ipn_pre );
             D_ipn_res := D_ipn_e_ass
                        - LEAST( NVL(D_lim_inf,0) - LEAST( NVL(D_lim_inf,0), D_ipn_pre )
                               , D_ipn_e_ass * D_sign_lim_inf
                               );
             D_imp_e   := E_Round( LEAST(D_ipn_dis,D_ipn_res)* D_per_ac / 100, 'I' ) * D_segno;
             --
             -- Calcolo  ipn_t  ( D_ipn_pre sempre = 0 )
             -- --------------
             D_ipn_pre := 0;
             D_ipn_dis := NVL(D_lim_sup,999999999) - LEAST( NVL(D_lim_sup,999999999), D_ipn_pre );
             D_ipn_res := D_ipn_t_ass
                        - LEAST( NVL(D_lim_inf,0) - LEAST( NVL(D_lim_inf,0), D_ipn_pre )
                               , D_ipn_t_ass * D_sign_lim_inf
                               );
             D_imp_t   := E_Round( LEAST(D_ipn_dis,D_ipn_res) * D_per_ac / 100, 'I' ) * D_segno;
             --
             -- Calcolo  ipn_a  ( D_ipn_pre sempre = 0 )
             -- --------------
             D_ipn_pre := 0;
             D_ipn_dis := NVL(D_lim_sup,999999999) - LEAST( NVL(D_lim_sup,999999999), D_ipn_pre );
             D_ipn_res := D_ipn_a_ass
                        - LEAST( NVL(D_lim_inf,0) - LEAST( NVL(D_lim_inf,0), D_ipn_pre )
                               , D_ipn_a_ass * D_sign_lim_inf
                               );
             D_imp_a   := E_Round( LEAST(D_ipn_dis,D_ipn_res) * D_per_ac / 100, 'I' ) * D_segno;
             END;
          END IF;
          --
          -- Calcolo  ipn_ap  ( D_ipn_pre sempre = 0 )
          -- ---------------
          D_ipn_ap_ass  := E_Round( curc.ipn_ap * D_moltiplica / D_divide * D_per_ipn / 100
                                  , 'I');
          D_ipn_pre     := 0;
          D_ipn_dis     := NVL(D_lim_sup,999999999) - LEAST( NVL(D_lim_sup,999999999), D_ipn_pre );
          D_ipn_res     := D_ipn_ap_ass
                         - LEAST( NVL(D_lim_inf,0) - LEAST( NVL(D_lim_inf,0), D_ipn_pre )
                                , D_ipn_ap_ass * D_sign_lim_inf
                                );
          D_imp_ap      := E_Round( LEAST(D_ipn_dis,D_ipn_res) * D_per_ap / 100, 'I' ) * D_segno;
/* modifica 20/07/2004 */
          IF  nvl(D_val_voce_rid,'C') = 'C'
          AND D_cod_voce_rid         is null
          AND D_lim_inf              is null
          AND D_lim_sup              is null THEN
             --
             -- Riduzione immediata del valore del Cumulo solo se:
             --  - non indicata la Voce di Riduzione
             --  - in assenza di limiti inferiori e superiori
             -- per determinare l'imponibile e l'imposta recuperando gli arrotondamenti mensili (quindi parziali)
             --
             D_ipn_eap     := D_ipn_eap - D_ipn_cum_ap;
             D_imp_p       := D_imp_p - E_Round( D_ipn_cum_ap * D_per_ap / 100, 'I' ) * D_segno;
             D_ipn_tot_ass := D_ipn_tot_ass - D_ipn_cum;
             D_imp         := D_imp - E_Round( (D_ipn_cum - D_ipn_cum_ap) * D_per_ac / 100, 'I' ) * D_segno
                                    - E_Round( D_ipn_cum_ap * D_per_ap / 100,'I' ) * D_segno;
          END IF;
/* fine modifica 20/07/2004 */
/* modifica 03/05/2004 */
          -- D_imp         := E_Round( D_imp / D_arrotonda + D_precisione, 'I') * D_arrotonda;
          IF nvl(D_arrotonda,0) = 0 THEN
            D_imp := D_imp;
          ELSE
            D_imp := round( D_imp / D_arrotonda + D_precisione) * D_arrotonda;
          END IF;
/* fine modifica 03/05/2004 */
          -- Calcolo RITENUTA corrente (ipn_c) per differenza
          D_imp_c := D_imp - D_imp_s - D_imp_p - D_imp_l - D_imp_e;
          BEGIN  -- Aggiornamento della Voce calcolata
             P_stp := 'VOCI_RITENUTA-07';
             UPDATE CALCOLI_CONTABILI
               SET tar     = D_ipn_tot_ass
                 , qta     = D_qta
                 , imp     = D_imp
                 , ipn_c   = D_imp_c
                 , ipn_s   = D_imp_s
                 , ipn_p   = D_imp_p
                 , ipn_l   = D_imp_l
                 , ipn_e   = D_imp_e
                 , ipn_t   = D_imp_t
                 , ipn_a   = D_imp_a
                 , ipn_ap  = D_imp_ap
                 , ipn_eap = D_ipn_eap
              WHERE ROWID = curc.ROWID
             ;
            Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
          END;
        END IF;                    -- Voce non ONAOSI        05/10/2005
        EXCEPTION
          WHEN NO_DATA_FOUND THEN  -- Voce non Valorizzabile
             NULL;
        END tratta_voce;
-- IF curc.voce = 'C.CPDEL' and curc.sub = '1' and P_estrazione = 'RY' THEN
--    dbms_output.put_line('fine calcolo ritenuta: D_imp '||D_imp);
-- END IF;
     END LOOP;
  END;
  BEGIN  -- Riduzione Importo sulla singola Voce
     P_stp := 'VOCI_RITENUTA-08';
     FOR CURR IN
        (SELECT caco.voce, caco.sub
             , caco.tar
             , caco.imp
             , caco.ipn_c
             , caco.ipn_s
             , caco.ipn_p
             , caco.ipn_l
             , caco.ipn_e
             , caco.ipn_t
             , caco.ipn_a
             , caco.ipn_ap
             , NVL(caco.ipn_eap,0) ipn_eap
             , caco.ROWID
             , caco.riferimento
             , caco.competenza
/* modifica del 28/04/2004 */
             , caco.sede_del
             , caco.anno_del
             , caco.numero_del
             , caco.delibera
/* fine modifica del 28/04/2004 */
             , rivo.dal
             , rivo.al
             , rivo.val_voce_ipn
             , NVL(rivo.arrotonda,1) arrotonda
             , DECODE( SIGN(NVL(rivo.arrotonda,1))
                    , -1, .4999999999
                       , 0
                    ) precisione
             , rivo.val_voce_rid
             , rivo.cod_voce_rid
             , rivo.sub_voce_rid
             , rivo.LIM_INF
             , imvo.cassa_competenza
          FROM RITENUTE_VOCE rivo
             , CALCOLI_CONTABILI caco
             , imponibili_voce imvo
         WHERE imvo.voce (+)   = rivo.cod_voce_ipn         -- modifica del 21/09/2007
           AND caco.riferimento
               BETWEEN NVL(imvo.dal,TO_DATE(2222222,'j'))
                   AND NVL(imvo.al ,TO_DATE(3333333,'j'))
           AND caco.ci            = P_ci
           AND caco.estrazione    = P_estrazione
           AND caco.tar          IS NOT NULL
           AND UPPER(caco.input) IN ( 'R', 'C', 'A', 'N', '*') -- N = ritenute x scorporo negative  26/05/2005
           AND rivo.cod_voce_rid IS NOT NULL
           AND rivo.voce          = caco.voce||''
           AND rivo.sub           = caco.sub
/* 18/06/2007 - modifica per trattamento ripresi per arretrati: sostituita la cond. su RIVO
                che determina il dal-al da considerare nello step successivo di riduzione ritenuta */
--          AND caco.riferimento
--              BETWEEN NVL(rivo.dal,TO_DATE(2222222,'j'))
--                 AND NVL(rivo.al ,TO_DATE(3333333,'j'))
        AND (  (    nvl(imvo.cassa_competenza,'NO') = 'SI'
                AND rivo.lim_inf is not null
                AND caco.riferimento
                    BETWEEN NVL(rivo.dal,TO_DATE(2222222,'j'))
                        AND NVL(rivo.al ,TO_DATE(3333333,'j')))
             OR ((   nvl(imvo.cassa_competenza,'NO') = 'NO'
                  OR rivo.lim_inf is null)
                 AND nvl(caco.competenza,caco.riferimento)
                     BETWEEN NVL(rivo.dal,TO_DATE(2222222,'j'))
                         AND NVL(rivo.al ,TO_DATE(3333333,'j')))
             )
        ) LOOP          
          IF     P_estrazione       = 'RY'
             AND TO_CHAR( curr.competenza,'yyyy') != TO_CHAR( curr.riferimento,'yyyy')
          THEN
                 D_se_cassa_competenza := 9;   -- Nel caso di ritenuta x storno (riferimento) il calcolo dell'imprto avviene SEMPRE e SOLO sull'imponibile relativo.
          ELSIF  nvl(curr.cassa_competenza,'NO') = 'SI'         -- da IMVO
             AND curr.lim_inf IS NOT NULL                       -- sub 2
          THEN                                     -- Calcolo Per Riferimento
                 D_se_cassa_competenza := 1;
          ELSIF  nvl(curr.cassa_competenza,'NO') = 'SI'   
          THEN                                      -- Calcolo Per Competenza
                 D_se_cassa_competenza := 2;
          ELSE
                 D_se_cassa_competenza := 0;        -- Calcolo normale
          END IF;
        P_stp := 'VOCI_RITENUTA-08';
        Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
        <<tratta_voce_rid>>
        BEGIN  -- Trattamento singola Voce da ridurre
          BEGIN  -- Preleva specifiche di Voce
             P_stp := 'VOCI_RITENUTA-09';
             SELECT voec.specifica
                 , voecr.memorizza
               INTO D_specifica
                 , D_memo_voce_rid
               FROM VOCI_ECONOMICHE voec
                 , VOCI_ECONOMICHE voecr
              WHERE voec.codice  = curr.voce
               AND voecr.codice = curr.cod_voce_rid
             ;
          Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
          END;
           -- Assegnazione valori ad aree di lavoro
           D_ipn_tot_ass := curr.tar;
           D_imp         := curr.imp;
           D_imp_c       := curr.ipn_c;
           D_imp_s       := curr.ipn_s;
           D_imp_p       := curr.ipn_p;
           D_imp_l       := curr.ipn_l;
           D_imp_e       := curr.ipn_e;
           D_imp_t       := curr.ipn_t;
           D_imp_a       := curr.ipn_a;
           D_imp_ap      := curr.ipn_ap;
           D_ipn_eap     := curr.ipn_eap;
           -- Eventuale Sottrazione Voce Riduzione
           IF curr.val_voce_rid = 'P'
           -- OR curr.val_voce_rid = 'C'                           -- 20/07/2004
           THEN
              BEGIN  -- Sottrazione Voce Riduzione dai Progressivi
                P_stp := 'VOCI_RITENUTA-10';
SELECT curr.tar   - NVL(SUM(prco.p_tar),0)
     , curr.imp   - E_Round( NVL
                             ( SUM(prco.p_imp)
                             , 0) / curr.arrotonda - curr.precisione
                           , 'I') * curr.arrotonda
     , curr.ipn_c - E_Round( NVL
                             ( SUM
                               ( DECODE
                                 ( curr.val_voce_ipn||SUBSTR(D_specifica,1,3)
                                 , 'PSSN', prco.p_imp
                                         , prco.p_imp - ( prco.p_imp / DECODE(prco.p_tar, 0, 1, prco.p_tar)
                                                                     * prco.p_ipn_eap )
                                 )
                               )
                             , 0) / curr.arrotonda - curr.precisione
                           , 'I') * curr.arrotonda
    , DECODE( curr.val_voce_ipn||SUBSTR(D_specifica,1,3)
            , 'PSSN', curr.ipn_p
                    , curr.ipn_p
                    - E_Round( NVL
                               ( SUM( prco.p_imp / DECODE(prco.p_tar, 0, 1, prco.p_tar)
                                                 * prco.p_ipn_eap )
                               , 0) / curr.arrotonda - curr.precisione
                             , 'I') * curr.arrotonda
            )
    , DECODE( curr.val_voce_ipn||SUBSTR(D_specifica,1,3)
            , 'PSSN', curr.ipn_eap
                    , curr.ipn_eap - NVL(SUM(prco.p_ipn_eap),0)
            )
  INTO D_ipn_tot_ass
     , D_imp
     , D_imp_c
     , D_imp_p
     , D_ipn_eap
  FROM progressivi_contabili prco
 WHERE prco.ci       = P_ci
   AND prco.anno      = P_anno
   AND prco.mese      = P_mese
   AND prco.mensilita = P_mensilita
   AND prco.voce      = curr.cod_voce_rid
   AND prco.sub       = curr.sub_voce_rid
/* modifica del 02/05/2007 */
   AND (   D_se_cassa_competenza = 1
           AND prco.riferimento
               between nvl(curr.dal,to_date('2222222','j'))
                   and nvl(curr.al ,to_date('3333333','j'))
        OR D_se_cassa_competenza = 2
           AND nvl(prco.competenza,prco.riferimento)
               between nvl(curr.dal,to_date('2222222','j'))
                   and nvl(curr.al ,to_date('3333333','j'))
        OR D_se_cassa_competenza = 0
       )
/* fine modifica del 02/05/2007 */
/* modifica del 28/04/2004 */
/* modifica annullata 21/06/2004 - Annalena
--   AND nvl(prco.sede_del,' ')= nvl(CURR.sede_del, nvl(prco.sede_del,' '))
--   AND nvl(prco.anno_del,0)  = nvl(CURR.anno_del, nvl(prco.anno_del,0))
--   AND nvl(prco.numero_del,0)= nvl(CURR.numero_del, nvl(prco.numero_del,0))
--   AND nvl(prco.delibera,'*')= nvl(CURR.delibera, nvl(prco.delibera,'*'))
/* fine modifica del 28/04/2004 */
/* modifica 20/07/2004 */
--   AND (   curr.val_voce_rid     != 'C'
--      OR   curr.val_voce_rid      = 'C'
--       AND prco.riferimento BETWEEN NVL(curr.dal,TO_DATE('2222222','j'))
--                                AND NVL(curr.al ,TO_DATE('3333333','j'))
--       )
/* fine modifica 20/07/2004 */
;
           Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
              EXCEPTION
                WHEN NO_DATA_FOUND THEN -- Voce riduzione non presente
                    NULL;
              END;
           END IF;
/* modifica del 20/07/2004 */
           IF curr.val_voce_rid = 'C'
           THEN
              BEGIN  -- Sottrazione Voce Riduzione Cumulo dai Movimenti Precedenti
                P_stp := 'VOCI_RITENUTA-10.1';
SELECT curr.tar   - NVL(SUM(moco.tar),0)
     , curr.imp   - E_Round( NVL
                             ( SUM(moco.imp)
                             , 0) / curr.arrotonda - curr.precisione
                           , 'I') * curr.arrotonda
/* modifica del 31/03/2005 - aggiunta specifica SSN */
     , curr.ipn_c - E_Round( NVL
/* modifica del 08/03/2005 */
                             ( decode( curr.val_voce_ipn||SUBSTR(D_specifica,1,3)
                                     , 'CSSN',SUM(moco.imp)
                                             ,SUM(moco.imp) - (sum( moco.imp )/ DECODE( sum(moco.tar)
                                                                                      , 0, 1, sum(moco.tar))
                                                                              * sum( moco.ipn_eap )
                                                              )
                                     )
                             , 0) / curr.arrotonda - curr.precisione
                           , 'I') * curr.arrotonda
     , DECODE( curr.val_voce_ipn||SUBSTR(D_specifica,1,3)
             , 'CSSN', curr.ipn_p
                     , curr.ipn_p - E_Round( NVL
                             ( SUM( moco.imp ) / DECODE(sum(moco.tar), 0, 1, sum(moco.tar))
                                             * sum( moco.ipn_eap )
/* fine modifica del 08/03/2005 */
                             , 0) / curr.arrotonda - curr.precisione
                           , 'I') * curr.arrotonda
             )
     , DECODE( curr.val_voce_ipn||SUBSTR(D_specifica,1,3)
             , 'CSSN', curr.ipn_eap
                     , curr.ipn_eap - NVL(SUM(moco.ipn_eap),0)
             )
/* fine modifica del 317=3/2005 */
  INTO D_ipn_tot_ass
     , D_imp
     , D_imp_c
     , D_imp_p
     , D_ipn_eap
  FROM movimenti_contabili moco
 WHERE moco.ci    = P_ci
   AND moco.anno >= to_number(to_char(curr.dal,'yyyy'))
   AND moco.anno <= P_anno
   AND moco.mese <= decode(moco.anno, P_anno, P_mese, 12)
   AND moco.voce  = curr.cod_voce_rid
   AND moco.sub   = curr.sub_voce_rid
/* modifica del 02/05/2007 */
   AND (   D_se_cassa_competenza = 1
           AND moco.riferimento
               between nvl(curr.dal,to_date('2222222','j'))
                   and nvl(curr.al ,to_date('3333333','j'))
        OR D_se_cassa_competenza = 2
           AND nvl(moco.competenza,moco.riferimento)
               between nvl(curr.dal,to_date('2222222','j'))
                   and nvl(curr.al ,to_date('3333333','j'))
        OR D_se_cassa_competenza = 0                              -- modifica del 21/09/2007
           AND nvl(moco.competenza,moco.riferimento)
               between nvl(curr.dal,to_date('2222222','j'))
                   and nvl(curr.al ,to_date('3333333','j'))
       )
/* fine modifica del 02/05/2007 */
;
           Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
              EXCEPTION
                WHEN NO_DATA_FOUND THEN -- Voce riduzione non presente
                    NULL;
              END;
-- IF curr.voce = 'C.CPDEL' and curr.sub = '1' and P_estrazione = 'RY' THEN
--    dbms_output.put_line('fine riduzione D_ipn_tot_ass '||D_ipn_tot_ass||' D_imp '||D_imp||' flag '||D_se_cassa_competenza);
-- END IF;
            END IF;
/* fine modifica del 20/07/2004 */
           IF  (   NVL(curr.cod_voce_rid, curr.voce) != curr.voce
               OR NVL(curr.sub_voce_rid, curr.sub ) != curr.sub
               )
           AND (   curr.val_voce_rid  NOT IN ('P','C')
               OR curr.val_voce_rid      IN ('P','C') AND
                  D_memo_voce_rid NOT IN ( 'M', 'S' )
               )
           THEN
              BEGIN  -- Sottrazione Voce Riduzione dal mese Corrente
                P_stp := 'VOCI_RITENUTA-11';
SELECT D_ipn_tot_ass - NVL(SUM(caco.tar),0)
    , D_imp    - E_Round( NVL(SUM(caco.imp),0)
                        / curr.arrotonda - curr.precisione
                        ,'I') * curr.arrotonda
    , D_imp_c  - E_Round( NVL(SUM(caco.ipn_c),0)
                        / curr.arrotonda - curr.precisione
                        ,'I') * curr.arrotonda
    , D_imp_s  - E_Round( NVL(SUM(caco.ipn_s),0)
                        / curr.arrotonda - curr.precisione
                        ,'I') * curr.arrotonda
    , D_imp_p  - E_Round( NVL(SUM(caco.ipn_p),0)
                        / curr.arrotonda - curr.precisione
                        ,'I') * curr.arrotonda
    , D_imp_l  - E_Round( NVL(SUM(caco.ipn_l),0)
                        / curr.arrotonda - curr.precisione
                        ,'I') * curr.arrotonda
    , D_imp_e  - E_Round( NVL(SUM(caco.ipn_e),0)
                        / curr.arrotonda - curr.precisione
                        ,'I') * curr.arrotonda
    , D_imp_t  - E_Round( NVL(SUM(caco.ipn_t),0)
                        / curr.arrotonda - curr.precisione
                        ,'I') * curr.arrotonda
    , D_imp_a  - E_Round( NVL(SUM(caco.ipn_a),0)
                        / curr.arrotonda - curr.precisione
                        ,'I') * curr.arrotonda
    , D_imp_ap - E_Round( NVL(SUM(caco.ipn_ap),0)
                        / curr.arrotonda - curr.precisione
                        ,'I') * curr.arrotonda
    , D_ipn_eap         - NVL(SUM(caco.ipn_eap),0)
 INTO D_ipn_tot_ass
    , D_imp
    , D_imp_c
    , D_imp_s
    , D_imp_p
    , D_imp_l
    , D_imp_e
    , D_imp_t
    , D_imp_a
    , D_imp_ap
    , D_ipn_eap
 FROM CALCOLI_CONTABILI caco
 WHERE caco.ci = p_ci
  AND caco.voce = curr.cod_voce_rid
  AND caco.sub  = curr.sub_voce_rid
/* modifica del 28/04/2004 */
  AND nvl(caco.sede_del,' ')= nvl(CURR.sede_del, nvl(caco.sede_del,' '))
  AND nvl(caco.anno_del,0)  = nvl(CURR.anno_del, nvl(caco.anno_del,0))
  AND nvl(caco.numero_del,0)= nvl(CURR.numero_del, nvl(caco.numero_del,0))
  AND nvl(caco.delibera,'*')= nvl(CURR.delibera, nvl(caco.delibera,'*'))
/* fine modifica del 28/04/2004 */
  AND (    curr.val_voce_rid != 'C'
       OR  curr.val_voce_rid  = 'C'
       AND nvl(caco.competenza, caco.riferimento)                          -- 20/07/2004
                        BETWEEN nvl(curr.dal,to_date('2222222','j'))
                            AND nvl(curr.al ,to_date('3333333','j'))
     )
                ;
           Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
              EXCEPTION
                WHEN NO_DATA_FOUND THEN -- Voce riduzione non presente
                    NULL;
              END;
           END IF;
/* modifica del 28/12/2005 */
      IF D_ipn_eap = D_ipn_tot_ass AND abs(D_imp_p - D_imp) = 0.01
      THEN
         D_imp_c := D_imp_c + (D_imp_p - D_imp);
         D_imp_p := D_imp_p - (D_imp_p - D_imp);
      END IF;
/* fine modifica del 28/12/2005 */
           BEGIN  -- Aggiornamento della Voce calcolata
              P_stp := 'VOCI_RITENUTA-12';
              UPDATE CALCOLI_CONTABILI
                SET tar     = D_ipn_tot_ass
                  , imp     = D_imp
                  , ipn_c   = D_imp_c
                  , ipn_s   = D_imp_s
                  , ipn_p   = D_imp_p
                  , ipn_l   = D_imp_l
                  , ipn_e   = D_imp_e
                  , ipn_t   = D_imp_t
                  , ipn_a   = D_imp_a
                  , ipn_ap  = D_imp_ap
                  , ipn_eap = D_ipn_eap
              WHERE ROWID = curr.ROWID
              ;
           Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
           END;
        EXCEPTION
          WHEN NO_DATA_FOUND THEN  -- Voce non Valorizzabile
             NULL;
        END tratta_voce_rid;
     END LOOP;
  END;
/* modifica del 01/12/2004 */
  IF P_estrazione not in ('RX','RY') THEN
     Peccmore.VOCI_TOTALE  -- Totalizzazione delle Voci a Ritenuta
        (P_ci, P_al, P_fin_ela, P_tipo, P_estrazione
            , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
        );
  END IF;
/* fine modifica del 01/12/2004 */
  END IF;  -- su D_numero_voci != 0
--
-- Gestione "IMPORTO AGEVOLAZIONE"
--
IF p_estrazione = 'RC' THEN
                BEGIN
                SELECT codice
                  into D_cod_agev
                  FROM VOCI_ECONOMICHE
                 WHERE INSTR(UPPER(note),'IMPORTO AGEVOLAZIONE') != 0;
                EXCEPTION
                  WHEN NO_DATA_FOUND THEN  -- Voce non Valorizzabile
                       D_cod_agev := '';
                END;
                IF D_cod_agev is not null THEN
                BEGIN
                SELECT NVL( SUM( NVL(prco.p_imp,0)
                               )
                          , 0
                          )
                     , NVL( SUM( NVL(prco.p_imp,0)
                               )
                          , 0
                          )
                  INTO D_confronto, D_effettivo_mp
                  FROM progressivi_contabili prco
                 WHERE prco.ci        = P_ci
                   AND prco.anno      = P_anno
                   AND prco.mese      = P_mese
                   AND prco.MENSILITA = P_mensilita
                   AND prco.voce      IN
                      (SELECT cod_voce_ipn FROM RITENUTE_VOCE
                        WHERE voce = D_cod_agev
                      )
                ;
                END;
                BEGIN
                SELECT NVL( SUM( NVL(caco.imp,0)
                               )
                          , 0
                          ) + D_confronto
                     , NVL( SUM( NVL(caco.imp,0)
                               )
                          , 0
                          )
                  INTO D_confronto, D_effettivo
                  FROM CALCOLI_CONTABILI caco
                 WHERE caco.ci        = P_ci
                   AND caco.voce      IN
                      (SELECT cod_voce_ipn FROM RITENUTE_VOCE
                        WHERE voce = D_cod_agev
                      )
                ;
                END;
                BEGIN
                SELECT NVL( SUM( NVL(prco.p_imp,0)
                               )
                          , 0
                          ) + D_confronto
                     , NVL( SUM( NVL(prco.p_imp,0)
                               )
                          , 0
                          ) + D_effettivo_mp
                  INTO D_confronto, D_effettivo_mp
                  FROM progressivi_contabili prco
                 WHERE prco.ci        = P_ci
                   AND prco.anno      = P_anno
                   AND prco.mese      = P_mese
                   AND prco.MENSILITA = P_mensilita
                   AND prco.voce      =
                       (SELECT codice FROM VOCI_ECONOMICHE
                         WHERE INSTR(UPPER(note),'PEGASO AZIENDALE') != 0
                       )
                ;
                END;
                BEGIN
                SELECT NVL( SUM( NVL(caco.imp,0)
                               )
                          , 0
                          ) + D_confronto
                     , NVL( SUM( NVL(caco.imp,0)
                               )
                          , 0
                          ) + D_effettivo
                  INTO D_confronto,D_effettivo
                  FROM CALCOLI_CONTABILI caco
                 WHERE caco.ci        = P_ci
                   AND caco.voce      =
                       (SELECT codice FROM VOCI_ECONOMICHE
                         WHERE INSTR(UPPER(note),'PEGASO AZIENDALE') != 0
                       )
                ;
                END;
                SELECT DECODE(Valuta,'L',500001,258.23)
                  INTO D_rif_confronto
                  FROM dual
                ;
                -- 1/2004: in caso di mese normale (non conguaglio) azzera la voce di ass. fiscale
                -- cos? rimane assoggettato solo il pagato, in caso di cong. fiscale v. step succ.
                IF  (P_mese                        != 12              or
                     P_tipo                       not IN ( 'S', 'N' ) )
                AND (P_conguaglio         = 0                         or
                     NVL(D_effe_cong,' ') = 'N' )
                AND (NVL(D_effe_cong,' ') != 'M') THEN
                BEGIN
                delete from calcoli_contabili caco
                 where ci = P_ci
                   and voce = D_cod_agev
--                   and not exists (select 'x' from calcoli_contabili
--                                   where ci = P_ci
--                                      and voce = (SELECT cod_voce_ipn FROM RITENUTE_VOCE
--                                                   WHERE voce = caco.voce))
                 ;
                END;
/* sostituito con la delete
                   BEGIN
                   UPDATE CALCOLI_CONTABILI caco
                   SET imp = 0
                     , qta = 0
                     , ipn_c = 0
                     , ipn_s = 0
                     , ipn_p = 0
                     , ipn_l = 0
                     , ipn_e = 0
                     , ipn_t = 0
                     , ipn_eap = 0
                     , ipn_a = 0
                     , ipn_ap = 0
                   WHERE ci = P_ci
                   AND voce = d_cod_agev
                   ;
                END;
*/
                END IF;
                -- 1/2004: in caso di cong. fiscale, se la somma del pagato ? oltre il limite
                -- recupera l'eventuale assestamento gi? attribuito; se la somma ? sotto il limite
                -- lascia l'assestamento cos? come calcolato dai parametri, e cio? pari al progressivo
                -- del pagato (che nei vari mesi ? stato asogg. e che adesso viene restituto)
                IF (   P_mese                        = 12           AND
                       P_tipo                       IN ( 'S', 'N' )
                    OR P_conguaglio         != 0                    AND
                       NVL(D_effe_cong,' ') != 'N'
                    OR NVL(D_effe_cong,' ') = 'M'
                   )
                AND D_confronto > D_rif_confronto THEN
                   update CALCOLI_CONTABILI caco
                   SET (tar,qta,imp) =
                       (select nvl(caco.tar,0)+sum(p_tar),sum(p_qta),sum(p_imp)*-1
                         FROM progressivi_contabili prco
                        WHERE prco.ci        = P_ci
                          AND prco.anno      = P_anno
                          AND prco.mese      = P_mese
                          AND prco.MENSILITA = P_mensilita
                          AND prco.voce      = caco.voce
                          AND prco.sub       = caco.sub
                       )
                   WHERE ci = P_ci
                   AND voce = d_cod_agev
                   ;
                END IF;
                BEGIN
                select NVL( SUM( NVL(prco.p_imp,0)
                               )
                          , 0
                          )
                  into D_assesta_mp
                  FROM progressivi_contabili prco
                 WHERE prco.ci        = P_ci
                   AND prco.anno      = P_anno
                   AND prco.mese      = P_mese
                   AND prco.MENSILITA = P_mensilita
                   AND prco.voce      = d_cod_agev
                   ;
                END;
                BEGIN
                select NVL( SUM( NVL(caco.imp,0)
                               )
                          , 0
                          )
                  into D_assesta
                  FROM calcoli_contabili caco
                 WHERE caco.ci        = P_ci
                   AND caco.voce      = d_cod_agev
                   ;
                END;
                IF D_assesta + D_effettivo != 0 THEN
                   update calcoli_contabili caco
                     set imp = D_assesta + D_effettivo
                     WHERE caco.ci        = P_ci
                       AND caco.voce      = (SELECT codice FROM VOCI_ECONOMICHE
                                              WHERE INSTR(UPPER(note),'IMPONIBILE AGEVOLAZIONE') != 0)
                   ;
                ELSE
                   delete from calcoli_contabili caco
                     WHERE caco.ci        = P_ci
                       AND caco.voce      = (SELECT codice FROM VOCI_ECONOMICHE
                                              WHERE INSTR(UPPER(note),'IMPONIBILE AGEVOLAZIONE') != 0)
                   ;
                END IF;
            END IF;
          END IF;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     Peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
END;
/
