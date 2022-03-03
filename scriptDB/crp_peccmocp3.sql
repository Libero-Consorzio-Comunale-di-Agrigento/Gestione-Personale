CREATE OR REPLACE PACKAGE peccmocp3 IS
/******************************************************************************
 NOME:        PECCMOCP3
 DESCRIZIONE: Calcolo VOCI Auto Fam AF Previsione
              Calcolo VOCI Auto Fam DF Previsione
              
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1    28/12/2004 NN     Lancio procedure Gp4_cafa.calcolo_assegno x calcolo
                        assegno familiare.
 1.1  29/09/2006 AM     Attiva amod. per limitare la lettura di PERE in caso di incarichi
 1.2  17/10/2006 MS     Modificata lettura dell'IPN_FAM ( A17262 )
 1.3  03/08/2007 MS     Eliminata gestione ass.fam da CAFA ( att. 2239 )
******************************************************************************/

revisione varchar2(30) := '1.3 del 03/08/2007';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

PROCEDURE voci_auto_fam_af
(
 p_ci         number
,p_al         date    --Data di Termine o Fine Anno
,p_anno       number
,p_mese       number
,p_mensilita   VARCHAR2
,p_fin_ela     date
,p_voce_ass    VARCHAR2
,p_cond_fam    IN OUT VARCHAR2
,p_nucleo_fam  IN OUT number
,p_figli_fam   IN OUT number
,p_mese_car    number       --Mese di riferimento del Carico Familiare
,p_giorni      number       --Giorni Fissi di Carico
,p_cong_af IN OUT number    --Mese di carico gia` Conguagliato
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       --Step elaborato
,p_tim    IN OUT VARCHAR2       --Time impiegato in secondi
);
PROCEDURE voci_auto_FAM_DF
(
 p_ci         number
,p_al         date    -- Data di Termine o Fine Anno
,p_anno       number
,p_mese       number
,p_mensilita   VARCHAR2
,p_fin_ela     date
,p_base_det    VARCHAR2
,p_voce_det    VARCHAR2
,p_cond_det    VARCHAR2
,p_specie_det  VARCHAR2
,p_scaglione   number
,p_numero_det  number
,p_mese_car    number       -- Mese di riferimento del Carico Familiare
,p_giorni      number       -- Giorni Fissi di Carico
,p_cong_dt IN OUT number    -- Mese di carico gia` Conguagliato
,p_imponibile IN   number
,p_divisore   IN   number
,p_conguaglio  IN  number
-- Parametri per Trace
,p_trc    IN     number     -- Tipo di Trace
,p_prn    IN     number     -- Numero di Prenotazione elaborazione
,p_pas    IN     number     -- Numero di Passo procedurale
,p_prs    IN OUT number     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
) ;
END;
/
CREATE OR REPLACE PACKAGE BODY peccmocp3 IS
form_trigger_failure exception;

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

--Determinazione dell'Assegno per Nucleo Familiare
PROCEDURE voci_auto_fam_af
(
 p_ci         number
,p_al         date    --Data di Termine o Fine Anno
,p_anno       number
,p_mese       number
,p_mensilita   VARCHAR2
,p_fin_ela     date
,p_voce_ass    VARCHAR2
,p_cond_fam     IN OUT VARCHAR2
,p_nucleo_fam   IN OUT number
,p_figli_fam    IN OUT number
,p_mese_car    number    --Mese di riferimento del Carico Familiare
,p_giorni      number    --Giorni Fissi di Carico
,p_cong_af IN OUT number --Mese di carico gia` Conguagliato
--Parametri per Trace
,p_trc    IN     number  --Tipo di Trace
,p_prn    IN     number  --Numero di Prenotazione elaborazione
,p_pas    IN     number  --Numero di Passo procedurale
,p_prs    IN OUT number  --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2    --Step elaborato
,p_tim    IN OUT VARCHAR2    --Time impiegato in secondi
) IS
D_ipn_fam   number;
D_imp_ass   number;
D_imp_fg1   number;
D_imp_fg2   number;
D_sub_a     VARCHAR2(1);
D_sub_i     VARCHAR2(1);
D_errore        VARCHAR2(6);
D_descrizione   VARCHAR2(50);
D_con_inps  contratti_storici.con_inps%type;
D_gg_lavoro contratti_storici.gg_lavoro%type;
D_tabella       condizioni_familiari.tabella%type;
D_cod_scaglione condizioni_familiari.cod_scaglione%type;
BEGIN
  BEGIN
     P_stp := 'VOCI_AUTO_FAM_AF-02';

/* Eliminazione del 03/08/2007:
   cancellato il codice per il calcolo automatico degli assegni familiari in base
   a CAFA in quanto non è possibile attivarlo per tutto l'anno di elaborazione
   pertanto le voci vengono trattate direttamente dalle informazioni_retributive_bp
*/
     /* Verifica esistenza sub A e I della voce con automatismo ASS_FAM. */
     BEGIN
       select 'Y'
        into D_sub_a
        from voci_economiche voec,
             voci_contabili voco
        where voec.automatismo = 'ASS_FAM'
         and voco.voce       = voec.codice
         and voco.sub        = 'A';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN D_sub_a := 'N';
     END;
     BEGIN
       select 'Y'
        into D_sub_i
        from voci_economiche voec,
             voci_contabili voco
        where voec.automatismo = 'ASS_FAM'
         and voco.voce       = voec.codice
         and voco.sub        = 'I';
     EXCEPTION
       WHEN NO_DATA_FOUND THEN D_sub_i := 'N';
     END;
     peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN
     P_stp := 'VOCI_AUTO_FAM_AF-03';
     select con_inps
         , decode(gg_lavoro,0,1,gg_lavoro)
       into D_con_inps
         , D_gg_lavoro
       from contratti_storici cost
         , periodi_retributivi_bp pere
      where cost.contratto =
          (select contratto
             from qualifiche_giuridiche
            where numero = pere.qualifica
              and pere.al
                  between nvl(dal,to_date(2222222,'j'))
                      and nvl(al ,to_date(3333333,'j'))
          )
        and pere.al between nvl(cost.dal,to_date(2222222,'j'))
                      and nvl(cost.al ,to_date(3333333,'j'))
        and pere.ci       = P_ci
/* modifica del 28/12/2004 */
--        and pere.periodo  = P_fin_ela
--        and pere.anno+0   = to_number(to_char(P_fin_ela,'yyyy'))
--        and pere.competenza = 'A'
   and (pere.periodo, pere.al)     = 
      (select nvl(max(periodo), P_fin_ela), max(al)
	   from periodi_retributivi 
	  where ci       = P_ci
          and periodo >= last_day(to_date(to_char(nvl(P_mese_car,12))||'/'||to_char(P_anno),'mm/yyyy')) 
          and periodo <= P_fin_ela
          and to_number(to_char(al,'yyyymm')) = to_number(P_anno||lpad(P_mese_car,2,0)) 
          and nvl(tipo,' ') not in ('R','F') 
      ) 
        and pere.competenza in ('A','C')
/* modifica del 29/09/2006 */
        and pere.servizio = 'Q'
/* fine modifica del 29/09/2006 */
/* fine modifica del 28/12/2004 */
     ;
     peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  IF P_mese_car = P_mese AND   --Carico Nucleo del mese attuale
     P_giorni  is null   THEN  --senza giorni Fissi
     BEGIN  
    /* Determinazione dell'Assegno per Nucleo Familiare
       per la mensilita` Corrente
       NON CALCOLA
       arretrati a Giorni di mesi a Conguaglio Giuridico
    */
        P_stp := 'VOCI_AUTO_FAM_AF-04';
        insert into calcoli_contabili
        ( ci, voce, sub
        , riferimento
        , input
        , estrazione
        , arr
        , tar
        , qta
        , imp
        )
        select
           P_ci, P_voce_ass, covo.sub
         , least( P_al
               , max(pere.al)
               )
         , 'C'
         , 'AR'
         , null
         , decode(covo.sub,'*',  D_imp_ass
                             + decode(D_sub_i,'N',D_imp_fg1,0)
                             + decode(D_sub_a,'N',D_imp_fg2,0)
                        ,'I',  D_imp_fg1
                        ,'A',  D_imp_fg2)
         / decode( max(covo.rapporto)
                , 'A', decode(D_gg_lavoro,30,30,26)
                , 'R', D_gg_lavoro
                , 'G', D_gg_lavoro
                , 'P', max(pere.gg_lav)
                , 'I', 26
                , 'C', 26
                , 'O', 1
                     , 30
                )
         , decode( max(covo.rapporto)
                , 'A', sum(pere.gg_af)
                , 'R', sum(pere.gg_rap)
                , 'G', sum(pere.gg_rid)
                , 'P', sum(pere.gg_pre)
                , 'I', sum(pere.gg_inp)
                , 'C', sum(pere.gg_inp * abs(pere.rap_ore))
                , 'O', decode( sum(pere.gg_fis)
                            , 0, sum(pere.rap_ore)
                              , sum( abs(pere.rap_ore)
                                   * pere.gg_fis
                                   )
                              / abs(sum(pere.gg_fis))
                            )
                     , sum(pere.gg_fis)
                )
         , decode( D_con_inps
                , 'EP', decode(covo.sub,'*',
                                  D_imp_ass
                                + decode(D_sub_i,'N',D_imp_fg1,0)
                                + decode(D_sub_a,'N',D_imp_fg2,0)
                                     ,'I',  D_imp_fg1
                                     ,'A',  D_imp_fg2)
                * decode( max(covo.rapporto)
                       , 'A', sum(pere.gg_af)
                            / decode(D_gg_lavoro,30,30,26)
                       , 'R', sum(pere.gg_rap)/D_gg_lavoro
                       , 'G', sum(pere.gg_rid)/D_gg_lavoro
                       , 'P', sum(pere.gg_pre)/max(pere.gg_lav)
                       , 'I', sum(pere.gg_inp)/26
                       , 'C', sum(pere.gg_inp * abs(pere.rap_ore))/26
                       , 'O', decode( sum(pere.gg_fis)
                                   , 0, sum(pere.rap_ore)
                                     , sum( abs(pere.rap_ore)
                                          * pere.gg_fis
                                          )
                                     / abs(sum(pere.gg_fis))
                                   )
                            , sum(pere.gg_fis)/30
                       )
                , round( decode(covo.sub,'*',
                                  D_imp_ass
                                + decode(D_sub_i,'N',D_imp_fg1,0)
                                + decode(D_sub_a,'N',D_imp_fg2,0)
                                     ,'I',  D_imp_fg1
                                     ,'A',  D_imp_fg2)
                * decode( max(covo.rapporto)
                       , 'A', sum(pere.gg_af)
                            / decode(D_gg_lavoro,30,30,26)
                       , 'R', sum(pere.gg_rap)/D_gg_lavoro
                       , 'G', sum(pere.gg_rid)/D_gg_lavoro
                       , 'P', sum(pere.gg_pre)/max(pere.gg_lav)
                       , 'I', sum(pere.gg_inp)/26
                       , 'C', sum(pere.gg_inp * abs(pere.rap_ore))/26
                       , 'O', decode( sum(pere.gg_fis)
                                   , 0, sum(pere.rap_ore)
                                     , sum( abs(pere.rap_ore)
                                          * pere.gg_fis
                                          )
                                     / abs(sum(pere.gg_fis))
                                   )
                            , sum(pere.gg_fis)/30
                       ) 
                      , decode(valuta,'L',0,2)
                      )
                )
         from contabilita_voce covo
            , periodi_retributivi_bp pere
        where covo.voce       = P_voce_ass
          and covo.sub        in ('*','A','I')
          and pere.al    between nvl(covo.dal,to_date(2222222,'j'))
                           and nvl(covo.al ,to_date(3333333,'j'))
          and pere.ci         = P_ci
          and pere.periodo     = P_fin_ela
          and pere.anno+0      = P_anno
          and to_char(pere.al,'yyyy') = P_anno
          and pere.mese       = P_mese
          and pere.competenza in ('C','A')
          and pere.servizio    = 'Q'
          and decode(covo.sub,'*', D_imp_ass
                              + decode(D_sub_i,'N',D_imp_fg1,0)
                              + decode(D_sub_a,'N',D_imp_fg2,0)
                           ,'I',  D_imp_fg1
                           ,'A',  D_imp_fg2) > 0
        group by pere.ci, covo.voce, covo.sub
        having max(pere.al) is not null
        --esclude record fittizio generato da funzione MAX
        ;
        peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF;
  IF P_giorni is not null THEN  --Assegni Fissi di mese corrente
                             --o arretrato
     BEGIN  --Attribuzione dell'Assegno a giorni Fissi
        P_stp := 'VOCI_AUTO_FAM_AF-05';
        insert into calcoli_contabili
        ( ci, voce, sub
        , riferimento
        , input
        , estrazione
        , arr
        , tar
        , qta
        , imp
        )
        select P_ci, P_voce_ass, covo.sub
            , least( P_al
                  , last_day( to_date( to_char(P_anno)||'/'||
                                    to_char(P_mese_car)
                                   , 'yyyy/mm' ) )
                  )
            , 'C'
            , 'AR'
            , decode( P_mese_car
                   , P_mese, null
                          , 'C'
                   )
            , decode(covo.sub,'*', D_imp_ass
                              + decode(D_sub_i,'N',D_imp_fg1,0)
                              + decode(D_sub_a,'N',D_imp_fg2,0)
                           ,'I',  D_imp_fg1
                           ,'A',  D_imp_fg2)
            / decode( max(covo.rapporto)
                   , 'A', decode(D_gg_lavoro,30,30,26)
                   , 'R', D_gg_lavoro
                   , 'G', D_gg_lavoro
                   , 'P', decode(D_gg_lavoro,30,26,22)
                   , 'I', 26
                   , 'C', 26
                   , 'O', 1
                       , 30
                   )
            , P_giorni
            , decode
              ( D_con_inps
              , 'EP', decode(covo.sub,'*', D_imp_ass
                              + decode(D_sub_i,'N',D_imp_fg1,0)
                              + decode(D_sub_a,'N',D_imp_fg2,0)
                                  ,'I',  D_imp_fg1
                                  ,'A',  D_imp_fg2)
                   * P_giorni
                   / decode( max(covo.rapporto)
                          , 'A', decode(D_gg_lavoro,30,30,26)
                          , 'R', D_gg_lavoro
                          , 'G', D_gg_lavoro
                          , 'P', decode(D_gg_lavoro,30,26,22)
                          , 'I', 26
                          , 'C', 26
                          , 'O', 1
                              , 30
                          )
                   , round ( decode(covo.sub,'*', D_imp_ass
                              + decode(D_sub_i,'N',D_imp_fg1,0)
                              + decode(D_sub_a,'N',D_imp_fg2,0)
                                         ,'I',  D_imp_fg1
                                         ,'A',  D_imp_fg2)
                     * P_giorni
                     / decode( max(covo.rapporto)
                            , 'A', decode(D_gg_lavoro,30,30,26)
                            , 'R', D_gg_lavoro
                            , 'G', D_gg_lavoro
                            , 'P', decode(D_gg_lavoro,30,26,22)
                            , 'I', 26
                            , 'C', 26
                            , 'O', 1
                                , 30
                            )
                     , decode(valuta,'L',0,2)
                     )
              )
         from contabilita_voce    covo
        where covo.voce       = P_voce_ass
          and covo.sub       in ('*','A','I')
          and last_day( to_date( to_char(P_anno)||'/'||
                              to_char(P_mese_car)
                             , 'yyyy/mm' ) )
                      between nvl(covo.dal,to_date(2222222,'j'))
                          and nvl(covo.al ,to_date(3333333,'j'))
          and decode(covo.sub,'*', D_imp_ass
                              + decode(D_sub_i,'N',D_imp_fg1,0)
                              + decode(D_sub_a,'N',D_imp_fg2,0)
                           ,'I',  D_imp_fg1
                           ,'A',  D_imp_fg2) > 0
        group by covo.voce, covo.sub
        having covo.voce is not null
        --esclude record fittizio generato da funzione MAX
        ;
        peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF;
  IF P_mese_car != P_mese AND --Carico Assegni arretrati
     P_giorni is null THEN  --A giornate contrattuali
     BEGIN  --Attribuzione degli Assegni del mese arretrato
           --con Conguaglio Giuridico giorni dei mesi sucessivi
           --conpreso quello conguagliato nel mese in elaborazione
        P_stp := 'VOCI_AUTO_FAM_AF-06';
        insert into calcoli_contabili
        ( ci, voce, sub
        , riferimento
        , input
        , estrazione
        , arr
        , tar
        , qta
        , imp
        )
        select
           P_ci, P_voce_ass, covo.sub
         , least( P_al
               , max(pere.al)
               )
         , 'C'
         , 'AR'
         , 'C'
         , decode(covo.sub,'*', D_imp_ass
                            + decode(D_sub_i,'N',D_imp_fg1,0)
                            + decode(D_sub_a,'N',D_imp_fg2,0)
                        ,'I',  D_imp_fg1
                        ,'A',  D_imp_fg2)
         / decode( max(covo.rapporto)
                , 'A', decode(D_gg_lavoro,30,30,26)
                , 'R', D_gg_lavoro
                , 'G', D_gg_lavoro
                , 'P', max(pere.gg_lav)
                , 'I', 26
                , 'C', 26
                , 'O', 1
                     , 30
                )
         , decode( max(covo.rapporto)
                , 'A', sum(pere.gg_af)
                , 'R', sum(pere.gg_rap)
                , 'G', sum(pere.gg_rid)
                , 'P', sum(pere.gg_pre)
                , 'I', sum(pere.gg_inp)
                , 'C', sum(pere.gg_inp * abs(pere.rap_ore))
                , 'O', decode( sum(pere.gg_fis)
                            , 0, sum(pere.rap_ore)
                              , sum( abs(pere.rap_ore)
                                   * pere.gg_fis
                                   )
                              / abs(sum(pere.gg_fis))
                            )
                     , sum(pere.gg_fis)
                )
         , decode( D_con_inps
                , 'EP', decode(covo.sub,'*', D_imp_ass
                              + decode(D_sub_i,'N',D_imp_fg1,0)
                              + decode(D_sub_a,'N',D_imp_fg2,0)
                                    ,'I',  D_imp_fg1
                                    ,'A',  D_imp_fg2)
                * decode( max(covo.rapporto)
                       , 'A', sum(pere.gg_af)
                            / decode(D_gg_lavoro,30,30,26)
                       , 'R', sum(pere.gg_rap)/D_gg_lavoro
                       , 'G', sum(pere.gg_rid)/D_gg_lavoro
                       , 'P', sum(pere.gg_pre)/max(pere.gg_lav)
                       , 'I', sum(pere.gg_inp)/26
                       , 'C', sum(pere.gg_inp * abs(pere.rap_ore))/26
                       , 'O', decode( sum(pere.gg_fis)
                                   , 0, sum(pere.rap_ore)
                                     , sum( abs(pere.rap_ore)
                                          * pere.gg_fis
                                          )
                                     / abs(sum(pere.gg_fis))
                                   )
                            , sum(pere.gg_fis)/30
                       )
                , round( decode(covo.sub,'*', D_imp_ass
                              + decode(D_sub_i,'N',D_imp_fg1,0)
                              + decode(D_sub_a,'N',D_imp_fg2,0)
                                     ,'I',  D_imp_fg1
                                     ,'A',  D_imp_fg2)
                * decode( max(covo.rapporto)
                       , 'A', sum(pere.gg_af)
                            / decode(D_gg_lavoro,30,30,26)
                       , 'R', sum(pere.gg_rap)/D_gg_lavoro
                       , 'G', sum(pere.gg_rid)/D_gg_lavoro
                       , 'P', sum(pere.gg_pre)/max(pere.gg_lav)
                       , 'I', sum(pere.gg_inp)/26
                       , 'C', sum(pere.gg_inp * abs(pere.rap_ore))/26
                       , 'O', decode( sum(pere.gg_fis)
                                   , 0, sum(pere.rap_ore)
                                     , sum( abs(pere.rap_ore)
                                          * pere.gg_fis
                                          )
                                     / abs(sum(pere.gg_fis))
                                   )
                            , sum(pere.gg_fis)/30
                       )
                      , decode(valuta,'L',0,2)
                      )
                )
         from contabilita_voce covo
            , periodi_retributivi_bp pere
        where covo.voce       = P_voce_ass
          and covo.sub       in ('*','A','I')
          and pere.al   between nvl(covo.dal,to_date(2222222,'j'))
                          and nvl(covo.al ,to_date(3333333,'j'))
          and pere.ci      = P_ci
          and pere.periodo
                    between to_date( to_char(P_anno)||'/'||
                                   to_char(P_mese_car), 'yyyy/mm' )
                       and P_fin_ela
          and pere.anno+0       = P_anno
          and to_char(pere.al,'yyyy') = P_anno
          and pere.mese        = P_mese_car
          and pere.competenza in ('P','C','A')
          and pere.servizio     = 'Q'
          and decode(covo.sub,'*', D_imp_ass
                              + decode(D_sub_i,'N',D_imp_fg1,0)
                              + decode(D_sub_a,'N',D_imp_fg2,0)
                           ,'I',  D_imp_fg1
                           ,'A',  D_imp_fg2) > 0
        group by pere.ci, covo.voce, covo.sub
        having max(pere.al) is not null
        --esclude record fittizio generato da funzione MAX
        ;
        peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF;
/* Annalena - Nadia 21/09/04
 Eliminato uno step che non ha senso per il bilancio di previsione   
 Non si devono recuperare detrazioni già pagate nè in mesi
 al di fuori del periodo di previsione, nè compresi nel
 periodo di previsione
*/
EXCEPTION
  WHEN NO_DATA_FOUND THEN  --Assegno non valorizzato
     null;
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     peccmocp.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
-- Determinazione della Detrazione Fiscale
--
PROCEDURE voci_auto_FAM_DF
(
 p_ci     number
,p_al     date    -- Data di Termine o Fine Anno
,p_anno   number
,p_mese   number
,p_mensilita   VARCHAR2
,p_fin_ela date
,p_base_det    VARCHAR2
,p_voce_det    VARCHAR2
,p_cond_det    VARCHAR2
,p_specie_det  VARCHAR2
,p_scaglione   number
,p_numero_det  number
,p_mese_car    number   -- Mese di riferimento del Carico Familiare
,p_giorni      number       --Giorni Fissi di Carico
,p_cong_dt IN OUT number    --Mese di carico gia` Conguagliato
,p_imponibile    number
,p_divisore      number
,p_conguaglio    number
-- Parametri per Trace
,p_trc    IN number -- Tipo di Trace
,p_prn    IN number -- Numero di Prenotazione elaborazione
,p_pas    IN number -- Numero di Passo procedurale
,p_prs    IN OUT number -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2   -- Step elaborato
,p_tim    IN OUT VARCHAR2   -- Time impiegato in secondi
) IS
D_base_det       VARCHAR2(1);
D_importo        NUMBER;
D_mesi_irpef     NUMBER;
BEGIN
  select nvl(mesi_irpef,12)
    into D_mesi_irpef
    from ente
  ;
  P_stp := 'VOCI_AUTO_FAM_DF-00';
  Peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  IF P_specie_det = 'CN'
  OR P_specie_det = 'FG'
  OR P_specie_det = 'FD'
  OR P_specie_det = 'FM'
  OR P_specie_det = 'MD'
  OR P_specie_det = 'FH'
  OR P_specie_det = 'HD'
  OR P_specie_det = 'AL' THEN
     D_base_det := 'M';
     ELSIF P_specie_det in ('UD','P1','P2','AD','AP') and p_anno >= 2003 
OR P_specie_det = 'RP' THEN 
        D_base_det := 'I';
      ELSE
        D_base_det := 'G';
  END IF;
  BEGIN
    select e_round(defi.importo / p_divisore,'I')
      into d_importo
      from detrazioni_fiscali defi
     where defi.codice = P_cond_det
       and defi.tipo   = P_specie_det
       and last_day( to_date( to_char(P_anno)||'/'||
                              to_char(P_mese),'yyyy/mm'))
            between defi.dal
                and nvl(defi.al ,to_date(3333333,'j'))
       and  P_scaglione != 99
       and defi.scaglione = P_scaglione
       and nvl(defi.numero,0) = nvl(P_numero_det,0)
       and p_conguaglio = 0       
    ;    
  EXCEPTION
    WHEN NO_DATA_FOUND THEN
      BEGIN
        select e_round(defi.importo / p_divisore,'I')
          into d_importo
          from detrazioni_fiscali defi
         where defi.codice = P_cond_det
           and defi.tipo   = P_specie_det
           and last_day( to_date( to_char(P_anno)||'/'||
                              to_char(P_mese),'yyyy/mm'))
                between defi.dal
                    and nvl(defi.al ,to_date(3333333,'j'))
           and defi.scaglione = P_scaglione - 50
           and nvl(defi.numero,0) = nvl(P_numero_det,0)
           and P_scaglione between 51 
                               and 98
        ;    
      EXCEPTION
        WHEN NO_DATA_FOUND THEN
          BEGIN
            select e_round(defi.importo / p_divisore,'I')
              into d_importo
              from detrazioni_fiscali defi
              where defi.codice = P_cond_det
                and defi.tipo   = P_specie_det
                and last_day( to_date( to_char(P_anno)||'/'||
                              to_char(P_mese),'yyyy/mm'))
                    between defi.dal
                        and nvl(defi.al ,to_date(3333333,'j'))
                and nvl(P_scaglione,99) = 99
                and nvl(defi.numero,0) = nvl(P_numero_det,0)
                and defi.scaglione not between 51 
                                           and 98
                and defi.imponibile = (select max(d.imponibile)
                                         from detrazioni_fiscali d
                                        where d.codice = P_cond_det
                                          and d.tipo   = P_specie_det
                                          and d.scaglione not between 51 
                                                                  and 98
                                          and nvl(d.numero,0) = nvl(P_numero_det,0)
                                          and last_day( to_date( to_char(P_anno)||'/'||
                                                      to_char(P_mese),'yyyy/mm'))
                                              between d.dal
                                                  and nvl(d.al ,to_date(3333333,'j'))
                                          and d.imponibile <= decode(p_conguaglio,0,p_imponibile * d_mesi_irpef,p_imponibile)
                                      )
            ;     
          EXCEPTION
            WHEN NO_DATA_FOUND THEN
              BEGIN
                select e_round(defi.importo / p_divisore,'I')
                  into d_importo
                  from detrazioni_fiscali defi
                 where defi.codice = P_cond_det
                   and defi.tipo   = P_specie_det
                   and last_day( to_date( to_char(P_anno)||'/'||
                                 to_char(P_mese),'yyyy/mm'))
                       between defi.dal
                           and nvl(defi.al ,to_date(3333333,'j'))
                   and P_scaglione is not null 
                   and nvl(defi.numero,0) = nvl(P_numero_det,0)
                   and p_conguaglio != 0
                   and defi.scaglione not between 51 
                                              and 98
                   and defi.imponibile = (select max(d.imponibile)
                                            from detrazioni_fiscali d
                                           where d.codice = P_cond_det
                                             and d.tipo   = P_specie_det
                                             and d.scaglione not between 51 
                                                                     and 98
                                             and nvl(d.numero,0) = nvl(P_numero_det,0)
                                             and last_day( to_date( to_char(P_anno)||'/'||
                                                           to_char(P_mese),'yyyy/mm'))
                                                 between d.dal
                                                     and nvl(d.al ,to_date(3333333,'j'))
                                             and d.imponibile <= decode(p_conguaglio,0,p_imponibile * d_mesi_irpef,p_imponibile)
                                         )
                ;    
              EXCEPTION
                WHEN NO_DATA_FOUND THEN
                  d_importo := 0;
              END;
          END;
      END; 
  END;
  IF P_giorni is not null and d_importo != 0 THEN  --Detrazioni Fisse di mese corrente
                             --o arretrato
     BEGIN  --Attribuzione della detrazione Fissa
        P_stp := 'VOCI_AUTO_FAM_DF-02';
        insert into calcoli_contabili
        ( ci, voce, sub
        , riferimento
        , input
        , estrazione
        , arr
        , tar
        , qta
        , imp
        )
        select
           P_ci, P_voce_det, '*'
         , least( P_al
               , last_day( to_date( to_char(P_anno)||'/'||
                                  to_char(P_mese_car)
                                , 'yyyy/mm' ) )
               )
         , 'C'
         , 'AF'
         , decode( P_mese_car
                , P_mese, null
                       , 'C'
                )
         , d_importo
         , decode( d_base_det  --attivazione su Base effettiva
                , 'G', P_giorni
                , 'M', ceil( P_giorni / 30 ) * 30
                , 'I', 1   
                )
         , e_round(d_importo
         / 30
         * decode( d_base_det  --attivazione su Base effettiva
                , 'G', P_giorni
                , 'M', ceil( P_giorni / 30 ) * 30
                , 'I', 30  
                )
               , 'I')
         from dual
        ;
        peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF;
--   P_mese_car != P_mese AND   --Carico Detrazioni arretrate
  IF P_giorni is null and d_importo != 0  THEN  --A giornate contrattuali
     BEGIN  --Attribuzione della detrazione del mese arretrato
           --con Conguaglio Giuridico giorni dei mesi sucessivi
           --con esclusione del mese in elaborazione
           --gia` conguagliato con step precedente
        P_stp := 'VOCI_AUTO_FAM_DF-03';
        insert into calcoli_contabili
        ( ci, voce, sub
        , riferimento
        , input
        , estrazione
        , arr
        , tar
        , qta
        , imp
        )
        select
           P_ci, P_voce_det, '*'
         , least( P_al
               , max(pere.al)
               )
         , 'C'
         , 'AF'
         , decode( P_mese_car
                , P_mese, null
                       , 'C'
                )
         , d_importo
         , decode( D_base_det
                , 'G', sum(pere.gg_det)
                , 'M', ceil( sum( pere.gg_af
                              * decode(pere.competenza,'P',0,1)
                              )
                              / decode(max(cost.gg_lavoro),30,30,26)
                          )
                          * decode(max(cost.gg_lavoro),30,30,26)
                     + floor( sum( pere.gg_af
                               * decode(pere.competenza,'P',1,0)
                               )
                              / decode(max(cost.gg_lavoro),30,30,26)
                           )
                           * decode(max(cost.gg_lavoro),30,30,26)
                , 'I', max(decode(pere.competenza,'P',-1,1)))
         , e_round(d_importo
         / decode( D_base_det
                , 'G', 30
                     , decode(max(cost.gg_lavoro),30,30,26)
                )
         * decode( D_base_det
                , 'G', sum(pere.gg_det)
                , 'M', ceil( sum( pere.gg_af
                              * decode(pere.competenza,'P',0,1)
                              )
                              / decode(max(cost.gg_lavoro),30,30,26)
                          )
                          * decode(max(cost.gg_lavoro),30,30,26)
                     + floor( sum( pere.gg_af
                               * decode(pere.competenza,'P',1,0)
                               )
                               / decode(max(cost.gg_lavoro),30,30,26)
                           )
                           * decode(max(cost.gg_lavoro),30,30,26)
                , 'I', decode(max(cost.gg_lavoro),30,30,26) * max(decode(pere.competenza,'P',-1,1)))
               ,'I')
         from contratti_storici cost
            , periodi_retributivi_BP pere
        where cost.contratto = pere.contratto
          and pere.al between cost.dal
                        and nvl(cost.al,to_date('3333333','j'))
          and pere.ci      = P_ci
          and pere.periodo = P_fin_ela
          and pere.anno+0       = P_anno
          and to_char(pere.al,'yyyy') = P_anno
          and pere.mese        = P_mese_car
          and pere.competenza in ('P','C','A')
          and pere.servizio     = 'Q'
        group by pere.ci
        having max(pere.al) is not null
        --esclude record fittizio generato da funzione MAX
        ;
        peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF;
/* Annalena - Nadia 21/09/04
   Eliminato uno step che non ha senso per il bilancio di previsione   
   Non si devono recuperare assegni già pagati nè in mesi
   al di fuori del periodo di previsione, nè compresi nel
   periodo di previsione
*/
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     peccmocp.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
END;
/
