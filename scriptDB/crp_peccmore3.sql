CREATE OR REPLACE PACKAGE peccmore3 IS
/******************************************************************************
 NOME:        Peccmore3
 DESCRIZIONE: Calcolo VOCI Automatiche di Carico per Assegni Familiari.
              Calcolo VOCI Automatiche di Carico per Detrazioni e Deduzioni Fiscali.
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1    23/12/2004 MF     Introduzione calcolo Deduzioni Familiari per Finanziaria 2005.
                        Riferimenti al Package GP4_DEFI.
 2    28/12/2004 NN     Lancio procedure Gp4_cafa.calcolo_assegno x calcolo
                        assegno familiare.
 2.1  17/01/2005 AM     Sisitemata lettura gg_contrattuali x ass.fam. in caso di incarichi
 2.2  20/01/2005 AM     sistemato oraerr in caso di Oracle versione 7
 2.3  24/01/2005 AM-NN  nel calcolo carichi fam. a conguaglio, trattato solo PERE ultimo cong.
                        per determinare il valore positivo da attribuire per il mese in analisi
 2.4  21/03/2005 NN     Esegue conguaglio carichi familiari solo in caso di conguaglio fiscale
                        o, in caso di conguaglio giuridico, solo se sono variati i relativi
                        giorni di spettanza.
 2.5  23/03/2005 NN     Gestitione errori in gp4_defi.get_importo
 2.6  17/10/2006 MS     Modificata lettura dell'IPN_FAM ( A17262 )
 3    15/11/2006 AM-ML  Legge Finanziaria 2007: modificato il trattamento dell'importo ceh viene
                        letto dal dizionario per il calcolo detrazioni a base Giorni: precedentemente
                        attribuiva nel mese 1/360esimo x i gg effettivi (31,28,ecc.), e solo a
                        conguaglio attribuiva 1/365esimo per i dgg effettivi; la modifica calcola
                        gia per il mese in 365esimi
 3.1  19/01/2007 AM-ML  Modificata base_det per voce DET_CON perche la inseriva anche per
                        i mesi precedenti se nel mese non c'erano gioni lavorati (A19308)
 3.2  30/01/2007 ML     Inibito il recupero delle detrazioni per spese l'imponibile e negativo (A19416).
 3.3  23/03/2007 ML     Modificata la chiamata a gp4_defi.get_importo che è diventata get_imp_aum (A20236).
 3.4  25/07/2007 AM     Sistemato conguaglio ass.fam. in caso di conguaglio (su adss.fam.) anni porecedenti
 3.5  22/10/2007 NN     Utilizzato il nuovo campo pere.gg_df per il calcolo delle detrazioni familiari.
******************************************************************************/
revisione varchar2(30) := '3.5 del 22/10/2007';
FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);
PROCEDURE voci_auto_fam_AF
(
 p_ci         number
,p_al         date    --Data di Termine o Fine Mese
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
PROCEDURE voci_auto_fam_DF
(
 p_ci         number
,p_al         date    -- Data di Termine o Fine Mese
,p_anno       number
,p_mese       number
,p_tipo       VARCHAR2
,p_fin_ela     date
,p_rilevanza   VARCHAR2     -- Rilevanza 'D': Detrazioni, 'E': Deduzioni
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
,p_nr_figli    IN  number
-- Parametri per Trace
,p_trc    IN     number     -- Tipo di Trace
,p_prn    IN     number     -- Numero di Prenotazione elaborazione
,p_pas    IN     number     -- Numero di Passo procedurale
,p_prs    IN OUT number     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
, P_ded_per      NUMBER DEFAULT 100
) ;
END;
/
CREATE OR REPLACE PACKAGE BODY peccmore3 IS
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
PROCEDURE voci_auto_fam_AF
(
 p_ci           number
,p_al           date    --Data di Termine o Fine Mese
,p_anno         number
,p_mese         number
,p_mensilita    VARCHAR2
,p_fin_ela      date
,p_voce_ass     VARCHAR2
,p_cond_fam     IN OUT VARCHAR2
,p_nucleo_fam   IN OUT number
,p_figli_fam    IN OUT number
,p_mese_car     number    --Mese di riferimento del Carico Familiare
,p_giorni       number    --Giorni Fissi di Carico
,p_cong_af IN OUT number --Mese di carico gia` Conguagliato
--Parametri per Trace
,p_trc   IN     number  --Tipo di Trace
,p_prn   IN     number  --Numero di Prenotazione elaborazione
,p_pas   IN     number  --Numero di Passo procedurale
,p_prs   IN OUT number  --Numero progressivo di Segnalazione
,p_stp   IN OUT VARCHAR2    --Step elaborato
,p_tim   IN OUT VARCHAR2    --Time impiegato in secondi
) IS
D_ipn_fam       number;
D_imp_ass       number;
D_imp_fg1       number;
D_imp_fg2       number;
D_imp_ass_tot   number;
D_sub_a         VARCHAR2(1);
D_sub_i         VARCHAR2(1);
D_errore        VARCHAR2(6);
D_descrizione   VARCHAR2(50);
D_con_inps      contratti_storici.con_inps%type;
D_gg_lavoro     contratti_storici.gg_lavoro%type;
D_tabella       condizioni_familiari.tabella%type;
D_cod_scaglione condizioni_familiari.cod_scaglione%type;
BEGIN
  BEGIN
     P_stp := 'VOCI_AUTO_FAM_AF-02';
     Gp4_cafa.calcola_assegno (P_ci, P_anno, P_mese_car, P_cond_fam, P_nucleo_fam, P_figli_fam,
                               D_imp_ass, D_imp_fg1, D_imp_fg2, D_imp_ass_tot,
                               D_errore, D_descrizione
                               );
     /* Verifica esistenza sub A e I della voce con automatismo */
     /* ASS_FAM.                                          */
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
     peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN
     P_stp := 'VOCI_AUTO_FAM_AF-03';
     select con_inps
         , decode(gg_lavoro,0,1,gg_lavoro)
       into D_con_inps
         , D_gg_lavoro
       from contratti_storici cost
         , periodi_retributivi pere
      where cost.contratto =
          (select contratto
             from qualifiche_giuridiche
            where numero = pere.qualifica
              and pere.al
                  between nvl(dal,to_date(2222222,'j'))
                      and nvl(al ,to_date(3333333,'j'))
          )
        and pere.al between cost.dal
                      and nvl(cost.al ,to_date(3333333,'j'))
        and pere.ci       = P_ci
   and (pere.periodo, pere.al)     =
      (select nvl(max(periodo), P_fin_ela), max(al)
	   from periodi_retributivi
	  where ci       = P_ci
          and periodo >= last_day(to_date(lpad(nvl(P_mese_car,12),2,0)||'/'||to_char(P_anno),'mm/yyyy'))
          and periodo <= P_fin_ela
          and to_number(to_char(al,'yyyymm')) = to_number(P_anno||lpad(P_mese_car,2,0))
          and nvl(tipo,' ') not in ('R','F')
      )
        and pere.competenza in ('A','C')
        and pere.servizio = 'Q'
     ;
     peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  IF P_mese_car = P_mese AND   --Carico Nucleo del mese attuale
     P_giorni  is null   THEN  --senza giorni Fissi
     BEGIN  --Determinazione dell'Assegno per Nucleo Familiare
           --per la mensilita` Corrente
           --NON CALCOLA
           --arretrati a Giorni di mesi a Conguaglio Giuridico
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
            , periodi_retributivi pere
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
        peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
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
        peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF;
  IF P_mese_car != P_mese AND   --Carico Assegni arretrati
     P_giorni   is null   THEN  --A giornate contrattuali
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
            , periodi_retributivi pere
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
        peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF;
  IF  P_mese_car != P_mese      --Carico Assegni arretrati
  AND P_cong_af  != P_mese_car  --Conguaglio non ancora avvenuto
  THEN
     P_cong_af := P_mese_car;
     BEGIN  --Recupero in Negativo degli Assegni gia` Pagati
        P_stp := 'VOCI_AUTO_FAM_AF-07';
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
        select P_ci, P_voce_ass, moco.sub
            , least( P_al
                  , moco.riferimento
                  )
            , 'C'
            , 'AR'
            , 'C'
            , sum(moco.tar) * -1
            , sum(moco.qta) * -1
            , sum(moco.imp) * -1
         from movimenti_contabili moco
        where moco.ci          = P_ci
          and moco.anno   between P_anno
                            and to_number(to_char(P_fin_ela,'yyyy'))
/* modifica del 25/07/2007
--          and moco.mese   between P_mese_car
--                            and P_mese
*/
          and to_date( to_char(moco.anno)||'/'||
                      to_char(moco.mese),'yyyy/mm')
                        between
              to_date( to_char(P_anno)||'/'||
                      to_char(P_mese_car),'yyyy/mm')
                            and
              to_date( to_char(P_fin_ela,'yyyy')||'/'||
                      to_char(P_mese),'yyyy/mm')
          and moco.voce        = P_voce_ass
          and to_date(to_char(moco.riferimento,'yyyy/mm'),'yyyy/mm')
                             =
              to_date( to_char(P_anno)||'/'||
                      to_char(P_mese_car),'yyyy/mm' )
        group by moco.sub, moco.riferimento
        ;
        peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF;
EXCEPTION
  WHEN NO_DATA_FOUND THEN  --Assegno non valorizzato
     null;
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
--
--Determinazione della Detrazione Fiscale
--
PROCEDURE voci_auto_fam_DF
(
 p_ci         number
,p_al         date    --Data di Termine o Fine Mese
,p_anno       number
,p_mese       number
,p_tipo       VARCHAR2
,p_fin_ela     date
,p_rilevanza   VARCHAR2     -- Rilevanza 'D': Detrazioni, 'E': Deduzioni
,p_voce_det    VARCHAR2
,p_cond_det    VARCHAR2
,p_specie_det  VARCHAR2
,p_scaglione   number
,p_numero_det  number
,p_mese_car    number       --Mese di riferimento del Carico Familiare
,p_giorni      number       --Giorni Fissi di Carico
,p_cong_dt IN OUT number    --Mese di carico gia` Conguagliato
,p_imponibile    number
,p_divisore      number
,p_conguaglio    number     -- 1 = Conguaglio Fiscale nel mese ; 0 = non Conguaglia
,p_nr_figli      number
--Parametri per Trace
,p_trc    IN     number     --Tipo di Trace
,p_prn    IN     number     --Numero di Prenotazione elaborazione
,p_pas    IN     number     --Numero di Passo procedurale
,p_prs    IN OUT number     --Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2   --Step elaborato
,p_tim    IN OUT VARCHAR2   --Time impiegato in secondi
, P_ded_per      NUMBER DEFAULT 100
) IS
D_base_det         VARCHAR2(1);
D_tipo_det         VARCHAR2(1);  -- F = carichi familiari, A = altre detrazioni
D_importo          NUMBER;
D_aumento          NUMBER;
D_scaglione_coniuge NUMBER;
D_diff_det_coniuge NUMBER;
D_attribuzione   NUMBER;
BEGIN
-- dbms_output.put_line('1 P_specie_det '||P_specie_det||' D_importo '||D_importo);
-- dbms_output.put_line('1 P_ded_per '||P_ded_per);
  P_stp := 'VOCI_AUTO_FAM_DF-00';
  Peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  D_diff_det_coniuge := GP4_DEFI.get_diff_det_con
                        ( P_anno, P_mese, 'CC', 'CN', 1
                        , P_ci                                         -- 23/03/2005
                        , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);    -- 23/03/2005
  IF    P_specie_det = 'CN'
     OR P_specie_det = 'FG'
     OR P_specie_det = 'FD'
     OR P_specie_det = 'FM'
     OR P_specie_det = 'MD'
     OR P_specie_det = 'FH'
     OR P_specie_det = 'HD'
     OR P_specie_det = 'AL' THEN
        D_tipo_det := 'F';
        IF P_rilevanza in ('F','E')
        THEN
           D_base_det := '%';
        ELSE
           D_base_det := 'M';
        END IF;
  ELSIF P_specie_det in ('UD','P1','P2','AD','AP') AND P_anno between 2003 and 2006
     OR P_specie_det = 'RP' THEN
        D_base_det := 'I';
        D_tipo_det := 'A';
   ELSE
        D_base_det := 'G';
        D_tipo_det := 'A';
  END IF;
  BEGIN
     D_attribuzione := GP4_RARE.get_attribuzione_spese(P_ci);
    -- Estrazione Importo sostituita con Package GP4_DEFI
-- dbms_output.put_line ('P_cond_det '||P_cond_det||
--                      'P_specie_det '||P_specie_det||
--                      'P_scaglione '||P_scaglione||
--                      'P_numero_det '||P_numero_det||
--                      'P_imponibile '||P_imponibile);
    IF P_cond_det = '*' and P_rilevanza ='F'
       THEN
         IF P_imponibile >= 0
            THEN D_importo := GP4_RARE.get_det_spe( P_ci, P_fin_ela, P_anno, P_mese, P_scaglione, P_specie_det
                                             , P_imponibile, 'M', P_conguaglio, P_rilevanza
                                             , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
         END IF;
-- dbms_output.put_line('P_specie_det '||P_specie_det||' D_attribuzione '||nvl(D_attribuzione,0)||' D_base_det '||D_base_det||' P_gioni '||P_giorni);
       IF P_specie_det = 'DA' and nvl(D_attribuzione,0) != 0 THEN
          D_importo := 0;
       END IF;
       ELSE D_importo := GP4_DEFI.get_imp_aum( P_anno, P_mese, P_cond_det, P_specie_det
                                             , P_scaglione, P_numero_det, P_imponibile, P_conguaglio, 1   -- 23/03/2005
                                             , P_ci,'I'                                                       -- 23/03/2005
                                             , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);                 -- 23/03/2005
            D_aumento := GP4_DEFI.get_imp_aum( P_anno, P_mese, P_cond_det, P_specie_det
                                             , P_scaglione, P_numero_det, P_imponibile, P_conguaglio, 1   -- 23/03/2005
                                             , P_ci,'A'                                                       -- 23/03/2005
                                             , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);                 -- 23/03/2005
            IF P_nr_figli > 3 THEN
               D_importo := D_importo + nvl(D_aumento,0);
            END IF;
            IF P_specie_det = 'CN' and P_numero_det is not null and P_rilevanza ='F' THEN
               D_scaglione_coniuge := GP4_DEFI.get_nr_scaglione
                               ( P_anno, P_mese, P_cond_det, 'CN', P_numero_det, P_conguaglio, P_scaglione
                               , P_imponibile
                               , P_ci
                               , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim);
-- dbms_output.put_line('^^^^^D_scaglione_coniuge '||D_scaglione_coniuge||' P_conguaglio '||P_conguaglio||' P_imponibile '||P_imponibile);
               IF trunc(D_scaglione_coniuge/10) = 1 THEN
                  D_base_det := 'M';
               ELSIF D_scaglione_coniuge = 0 THEN
                     D_importo := D_importo - (D_diff_det_coniuge * P_ded_per / 100);
                     D_base_det := 'M';
               ELSE D_base_det := '%';
-- dbms_output.put_line('^^^^^D_base_det '||D_base_det||' P_ded_per '||P_ded_per);
               END IF;
            END IF;
    END IF;
-- dbms_output.put_line('GP4_DEFI.get_importo '||D_importo);
  END;
  IF P_giorni is not null and d_importo != 0 THEN  -- Detrazioni Fisse di mese corrente
                                                   -- o arretrato
    BEGIN  --Attribuzione della detrazione Fissa
        P_stp := 'VOCI_AUTO_FAM_DF-02';
-- dbms_output.put_line('inserisco '||P_VOCE_DET||' '||D_importo);
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
         , e_round( decode( d_base_det
                          , 'G', d_importo / 365
                               , d_importo / 12)
                  , 'T')
         , decode( d_base_det  --attivazione su Base effettiva
                , '%', ceil( P_giorni / 30 ) * P_ded_per
                , 'G', P_giorni
                , 'M', ceil( P_giorni / 30 ) * 30
                , 'I', 1
                )
         , e_round(decode( d_base_det
                          , 'G', d_importo / 365
                               , d_importo / 360)
         * decode( d_base_det  --attivazione su Base effettiva
                , '%', ceil( P_giorni / 30 ) * 30 * P_ded_per / 100
                , 'G', P_giorni
                , 'M', ceil( P_giorni / 30 ) * 30
                , 'I', 30
                )
               , 'I')
         from dual
        ;
        peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF;  -- Fine Detrazioni Fisse di mese corrente o arretrato
--   P_mese_car != P_mese AND   --Carico Detrazioni arretrate
  IF P_giorni is null and d_importo != 0  THEN  --A giornate contrattuali
     BEGIN  -- Attribuzione della detrazione del mese arretrato
            -- con Conguaglio Giuridico giorni dei mesi sucessivi
            -- con esclusione del mese in elaborazione
            -- gia` conguagliato con step precedente
        P_stp := 'VOCI_AUTO_FAM_DF-03';
-- dbms_output.put_line('inserisco 2 '||P_VOCE_DET||' '||D_importo||' D_base_Det '||D_base_det||
--                     ' P_ded_per '||P_ded_per||' P_mese_car '||P_mese_car);
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
         , e_round( decode( D_base_det
                          , 'G', d_importo / 365
                               , d_importo / 12)
                  , 'T')
         , decode( D_base_det
                , '%', P_ded_per
                , 'G', sum(pere.gg_det)
                , 'M', ceil( sum( pere.gg_df
                              * decode(pere.competenza,'P',0,1)
                              )
                              / decode(max(cost.gg_lavoro),30,30,26)
                          )
                          * decode(max(cost.gg_lavoro),30,30,26)
                     + floor( sum( pere.gg_df
                               * decode(pere.competenza,'P',1,0)
                               )
                              / decode(max(cost.gg_lavoro),30,30,26)
                           )
                           * decode(max(cost.gg_lavoro),30,30,26)
                , 'I', max(decode(pere.competenza,'P',-1,1)))
         , e_round(decode( D_base_det
                          , 'G', d_importo
                               , d_importo / 12)
         / decode( D_base_det
                , '%', decode(max(cost.gg_lavoro),30,30,26)
                , 'G', 365
                     , decode(max(cost.gg_lavoro),30,30,26)
                )
         * decode( D_base_det
                , '%', (  ceil( sum( pere.gg_df
                                * decode(pere.competenza,'P',0,1)
                                )
                                / decode(max(cost.gg_lavoro),30,30,26)
                            )
                            * decode(max(cost.gg_lavoro),30,30,26)
                       + floor( sum( pere.gg_df
                                 * decode(pere.competenza,'P',1,0)
                                 )
                                 / decode(max(cost.gg_lavoro),30,30,26)
                             )
                             * decode(max(cost.gg_lavoro),30,30,26)
                       ) * P_ded_per / 100
                , 'G', sum(pere.gg_det)
                , 'M', ceil( sum( pere.gg_df
                              * decode(pere.competenza,'P',0,1)
                              )
                              / decode(max(cost.gg_lavoro),30,30,26)
                          )
                          * decode(max(cost.gg_lavoro),30,30,26)
                     + floor( sum( pere.gg_df
                               * decode(pere.competenza,'P',1,0)
                               )
                               / decode(max(cost.gg_lavoro),30,30,26)
                           )
                           * decode(max(cost.gg_lavoro),30,30,26)
                , 'I', decode(max(cost.gg_lavoro),30,30,26) * max(decode(pere.competenza,'P',-1,1)))
               ,'I')
         from contratti_storici cost
            , periodi_retributivi pere
        where cost.contratto = pere.contratto
          and pere.al between cost.dal
                        and nvl(cost.al,to_date('3333333','j'))
          and pere.ci      = P_ci
          and pere.periodo =
             (select nvl( max(periodo)
                        , last_day(to_date(to_char(nvl(P_mese_car,12))||'/'||to_char(P_anno),'mm/yyyy')))
	   from periodi_retributivi
	  where ci       = P_ci
          and periodo >= to_date(P_anno||lpad(P_mese_car,2,0),'yyyymm')
          and periodo <= P_fin_ela
          and to_number(to_char(al,'yyyymm')) = to_number(P_anno||lpad(P_mese_car,2,0))
          and nvl(tipo,' ') not in ('R','F')
             )
-- vecchia versione:
--          and pere.periodo
--                    between last_day( to_date( to_char(P_anno)||'/'||
--                                           to_char(P_mese_car)
--                                         , 'yyyy/mm' ) )
--                       and P_fin_ela
--          and pere.anno+0       = P_anno
--          and to_char(pere.al,'yyyy') = P_anno
--          and pere.mese        = P_mese_car
--          and pere.competenza in ('P','C','A')
          and (   to_number(to_char(pere.al,'yyyymm')) = to_number(P_anno||lpad(P_mese_car,2,0)) and
                  D_tipo_det = 'F' and
                  pere.competenza in ('C','A')
               OR D_tipo_det = 'A'  and
                  pere.competenza in ('C','A','P') and
                  (   to_number(to_char(pere.al,'yyyy')) = to_number(P_anno)
                   OR gp4_ente.get_detrazioni_ap = 'SI'
                  )
               )
          and pere.servizio     = 'Q'
          and (P_conguaglio = 1
               or
               P_mese_car != P_mese
               or
               D_tipo_det = 'A'
               or
               exists (select 'x'
                         from periodi_retributivi pere2
                        where pere2.ci = P_ci
                          and pere2.periodo = pere.periodo
                          and to_number(to_char(pere2.al,'yyyymm')) =
                              to_number(P_anno||lpad(P_mese_car,2,0))
                          and nvl(pere2.tipo,' ') not in ('R','F')
                          and pere2.competenza in ('C','A','P')
                          and pere2.servizio     = 'Q'
                       having ( D_base_det = 'G' and sum(pere2.gg_det) != 0)
                           or ( D_base_det in ('%','M')
                                                 and ceil( sum( pere2.gg_df
                                                            * decode(pere2.competenza,'P',0,1)
                                                            )
                                                            / decode(max(cost.gg_lavoro),30,30,26)
                                                        )
                                                        * decode(max(cost.gg_lavoro),30,30,26)
                                                   + floor( sum( pere2.gg_df
                                                             * decode(pere2.competenza,'P',1,0)
                                                             )
                                                            / decode(max(cost.gg_lavoro),30,30,26)
                                                         )
                                                         * decode(max(cost.gg_lavoro),30,30,26) != 0)
                           or ( D_base_det not in ('%','G','M'))
                      )
              )
        group by pere.ci,decode(D_tipo_det,'A',pere.mese,null)
        having max(pere.al) is not null
        --esclude record fittizio generato da funzione MAX
        ;
        peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF; -- Fine Attribuzione della detrazione del mese arretrato
-- dbms_output.put_Line('forse qui c''e il cong. P_cong_dt '||P_cong_dt||' P_mese_car '||P_mese_car||' P_mese '||P_mese||' P_tipo '||P_tipo);
  IF (   P_mese_car != P_mese
     OR  P_mese_car  = P_mese
       AND P_mese      = 12
     OR  P_mese_car  = P_mese
       AND P_tipo    = 'S'
     )
     AND P_cong_dt  != P_mese_car  --Conguaglio non ancora avvenuto
  THEN
     P_cong_dt := P_mese_car;
     BEGIN  -- Recupero in Negativo delle detrazioni gia` Pagate
        P_stp := 'VOCI_AUTO_FAM_DF-04';
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
        select P_ci, P_voce_det, '*'
            , least( P_al
                  , moco.riferimento
                  )
            , 'C'
            , 'AF'
            , decode( to_char(least( P_al, moco.riferimento),'mm')
                   , P_mese, null
                          , 'C'
                   )
            , sum(moco.tar) * -1
            , sum(moco.qta) * -1
            , sum(moco.imp) * -1
         from movimenti_contabili moco
        where moco.ci          = P_ci
          and moco.anno        = P_anno
          and moco.mese   between P_mese_car
                            and P_mese
          and moco.voce        = P_voce_det
          and to_date(to_char(moco.riferimento,'yyyy/mm'),'yyyy/mm')
                             =
              to_date( to_char(P_anno)||'/'||
                      to_char(P_mese_car),'yyyy/mm' )
          and (P_conguaglio = 1
               or
               P_mese_car != P_mese
               or
               exists (select 'x'
                         from contratti_storici cost
                            , periodi_retributivi pere
                        where cost.contratto = pere.contratto
                          and pere.al between cost.dal
                          and nvl(cost.al,to_date('3333333','j'))
                          and pere.ci = P_ci
                          and pere.periodo =
                             (select nvl( max(periodo)
                                        , last_day(to_date(to_char(nvl(P_mese_car,12))||'/'||to_char(P_anno),'mm/yyyy')))
                	             from periodi_retributivi
                	            where ci       = P_ci
                                 and periodo >= to_date(P_anno||lpad(P_mese_car,2,0),'yyyymm')
                                 and periodo <= P_fin_ela
                                 and to_number(to_char(al,'yyyymm')) = to_number(P_anno||lpad(P_mese_car,2,0))
                                 and nvl(tipo,' ') not in ('R','F')
                              )
                          and to_number(to_char(pere.al,'yyyymm')) =
                              to_number(P_anno||lpad(P_mese_car,2,0))
                          and nvl(pere.tipo,' ') not in ('R','F')
                          and pere.competenza in ('C','A','P')
                          and pere.servizio     = 'Q'
                       having ( D_base_det = 'G' and sum(pere.gg_det) != 0)
                           or ( D_base_det in ('M','%')
                                                 and ceil( sum( pere.gg_df
                                                            * decode(pere.competenza,'P',0,1)
                                                            )
                                                            / decode(max(cost.gg_lavoro),30,30,26)
                                                        )
                                                        * decode(max(cost.gg_lavoro),30,30,26)
                                                   + floor( sum( pere.gg_df
                                                             * decode(pere.competenza,'P',1,0)
                                                             )
                                                            / decode(max(cost.gg_lavoro),30,30,26)
                                                         )
                                                         * decode(max(cost.gg_lavoro),30,30,26) != 0)
                           or ( D_base_det not in ('%','G','M'))
                      )
              )
        group by moco.riferimento
        ;
        peccmore.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
     END;
  END IF; -- Fine Recupero in Negativo delle detrazioni gia` Pagate
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
     RAISE;
  WHEN OTHERS THEN
     peccmore.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
     RAISE FORM_TRIGGER_FAILURE;
END;
END;
/
