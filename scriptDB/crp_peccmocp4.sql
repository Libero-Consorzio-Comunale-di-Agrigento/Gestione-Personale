CREATE OR REPLACE PACKAGE peccmocp4 IS
/******************************************************************************
 NOME:        PECCMOCP4
 DESCRIZIONE: Calcolo del Bilancio di Previsione
 ANNOTAZIONI: -
 REVISIONI:
 Rev. Data       Autore Descrizione
 ---- ---------- ------ ------------------------------------------------------
 0    ?          __     Prima emissione.
 1    28/04/2004 MF     Estrazione anche del TIPO delibera.
 2    28/06/2005 CB     Gestione codice_siope
******************************************************************************/

revisione varchar2(30) := '2 del 28/06/2005';

FUNCTION VERSIONE  RETURN varchar2;
pragma restrict_references(VERSIONE,WNDS,WNPS);

  PROCEDURE voci_retributive
(
 p_ci           number
,p_anno_ret      number
,p_al           date    -- Data di Termine o Fine Anno
,p_cong_ind      number
,p_d_cong       date
,p_d_cong_al    date
,p_anno         number
,p_mese         number
,p_mensilita     VARCHAR2
,p_fin_ela       date
,p_tipo         VARCHAR2
,p_conguaglio    number
,p_mens_codice   VARCHAR2
,p_periodo       VARCHAR2
,p_ricalcolo     VARCHAR2
-- Parametri per Trace
,p_trc    IN     number     -- Tipo di Trace
,p_prn    IN     number     -- Numero di Prenotazione elaborazione
,p_pas    IN     number     -- Numero di Passo procedurale
,p_prs    IN OUT number     -- Numero progressivo di Segnalazione
,p_stp    IN OUT VARCHAR2       -- Step elaborato
,p_tim    IN OUT VARCHAR2       -- Time impiegato in secondi
);
END;
/

CREATE OR REPLACE PACKAGE BODY peccmocp4 IS
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

-- Valorizzazione Voci Retributive a Conguaglio
--
PROCEDURE voci_retr_con
(
 p_ci    number
,p_anno_ret  number
,p_al    date  -- Data di Termine o Fine Anno
,p_cong_ind  number
,p_d_cong  date
,p_d_cong_al date
,p_anno   number
,p_mese   number
,p_mensilita VARCHAR2
,p_fin_ela  date
,p_tipo   VARCHAR2
,p_periodo  VARCHAR2
-- Parametri per Trace
,p_trc  IN   number   -- Tipo di Trace
,p_prn  IN   number   -- Numero di Prenotazione elaborazione
,p_pas  IN   number   -- Numero di Passo procedurale
,p_prs  IN OUT number   -- Numero progressivo di Segnalazione
,p_stp  IN OUT VARCHAR2    -- Step elaborato
,p_tim  IN OUT VARCHAR2    -- Time impiegato in secondi
) IS
BEGIN
  --IF P_tipo     = 'N' AND --Tolto per cong.Acc. in Mens.Agg.
  IF P_cong_ind >  0  AND   --Conguaglio Competenze Fisse o Accessorie
     P_d_cong   < to_date( '01/'||
                        to_char(P_fin_ela,'mm/yyyy')
                      , 'dd/mm/yyyy'
                      ) AND
     nvl(P_d_cong_al,P_fin_ela) >= P_fin_ela
  THEN
   BEGIN  -- Inserimento in negativo delle Voci gia` percepite
      -- relative ai periodi richiesti per il Conguaglio
      --  ( inserito anche IPN_EAP * -1 )
    P_stp := 'VOCI_RETR_CON-01';
        insert into calcoli_contabili
        ( ci, voce, sub
        , riferimento
        , competenza
        , arr
        , input
        , estrazione
        , qualifica, tipo_rapporto, ore
        , tar
        , qta
        , imp
        , ipn_c
        , ipn_s
        , ipn_p
        , ipn_l
        , ipn_e
        , ipn_t
        , ipn_a
        , ipn_ap
        , ipn_eap
        )
select
 P_ci, moco.voce, moco.sub
, moco.riferimento
, moco.competenza
/* modifica del 20/05/99 */
, decode( P_cong_ind,2,'C',4,'C'
       , decode( least(moco.anno,to_char(moco.riferimento,'yyyy'))
              , P_anno, nvl(moco.arr,'C')
                     , 'P'
              )
       )
/* fine modifica del 20/05/99 */
, decode( upper(moco.input)
       , 'R' , 'r'
       , 'B' , 'r'
       , 'C' , 'c'
            , 'a'
       )
, decode( voec.classe
       , 'Q', 'Q'
       , 'C', 'C'||nvl(voec.estrazione,'B')
       , 'R', 'R'||nvl(voec.estrazione,'I')
           , 'AR'
           ) estrazione
, moco.qualifica, moco.tipo_rapporto, moco.ore
, moco.tar * -1
, decode( upper(moco.input), 'R', moco.qta * -1
                       , 'C', moco.qta * -1
                            , decode
                             ( moco.input
                             , 'a', moco.qta * -1
                                  , 0
                             )
       )


, moco.imp * -1
, decode( voec.classe, 'R', (moco.imp - moco.ipn_p) * -1, null)
, decode( voec.classe, 'R', 0, null)
, moco.ipn_p * -1
, decode( voec.classe, 'R', 0, null)
, decode( voec.classe, 'R', 0, null)
, decode( voec.classe, 'R', 0, null)
, decode( voec.classe, 'R', 0, null)
, decode( voec.classe, 'R', 0, null)
, moco.ipn_eap * -1
 from voci_economiche voec
    , movimenti_contabili moco
 where voec.codice       = moco.voce||''
  and moco.riferimento between P_d_cong
                           and nvl(P_d_cong_al,moco.riferimento)
  and (   upper(moco.input) in ( 'R', 'B' )   and
         nvl(voec.specifica,' ') <> 'NCC' and
         nvl(voec.specifica,' ') <> 'CCA'
         and P_tipo = 'N'
       or voec.specifica  = 'CCF'
         and P_tipo = 'N'
       or P_cong_ind      in ( 3, 4 ) and  --conguaglio Comp.Accessorie
         (   upper(moco.input) in ( 'A', 'I', 'D', 'P') and
             nvl(voec.specifica,' ') <> 'NCC' and
             nvl(voec.specifica,' ') not like 'RGA%'
          or voec.specifica  = 'CCA'
         )
      )
  and (   upper(moco.input) not in ('A', 'I', 'D', 'P')
       or upper(moco.input)     in ('A', 'I', 'D', 'P') and
         nvl(moco.tar,0) != 0 and        --null = forzate a importo
         nvl(moco.imp,0) != 0
      )
  and (moco.anno, moco.mese, moco.ci) in
     (select distinct anno, mese, ci
        from movimenti_fiscali
       where ci    = P_ci
        and anno >= to_number(to_char(P_d_cong,'yyyy'))
        and last_day
            (to_date(to_char(anno)||'/'||to_char(mese),'yyyy/mm'))
                >= P_d_cong
        and last_day
            (to_date(to_char(anno)||'/'||to_char(mese),'yyyy/mm'))
                <= nvl(P_d_cong_al,P_fin_ela)
     )
  and moco.mensilita != '*AP'
/* Modifica del 20/1/2004; Attività 838
  and (   upper(moco.input) in ('R','B')
       or not exists
        (select 'x'
           from calcoli_contabili
          where voce = moco.voce
            and sub  = moco.sub
            and nvl(arr,' ') =
               decode( moco.anno
                     , P_anno, nvl(moco.arr, 'C')
                            , decode(P_cong_ind,2,'C',4,'C','P')
                     )
            and upper(input) not in ('R','C','A')
            and ci   = P_ci
        )
      )
*/
     ;
   peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
   END;
   BEGIN  -- Inserimento in positivo delle Voci Accessorie
      --  relative ai periodi richiesti per il Conguaglio
   P_stp := 'VOCI_RETR_CON-02';
   insert into calcoli_contabili
     ( ci, voce, sub
     , riferimento
     , competenza
     , arr
     , input
     , estrazione
     , tar
     , qta
     , ipn_c
     , ipn_s
     , ipn_p
     , ipn_l
     , ipn_e
     , ipn_t
     , ipn_a
     , ipn_ap
     , ipn_eap
--, sede_del, numero_del, anno_del
--, risorsa_intervento, capitolo, articolo, conto 
--, impegno,  anno_impegno, sub_impegno, anno_sub_impegno
   )
select
 moco.ci, moco.voce, moco.sub
, least(moco.riferimento,P_al)
, moco.competenza
/* modifica del 18/06/99 */
, decode( to_char(moco.riferimento,'yyyy')
/* fine modifica del 18/06/99 */
       , P_anno, nvl(moco.arr, 'C')
              , decode(P_cong_ind,2,'C',4,'C','P')
       )
, decode( moco.input
       , 'R' , 'r'
       , 'B' , 'r'
       , 'C' , 'c'
            , 'a'
       )
, decode( voec.classe
       , 'Q', 'Q'
       , 'C', 'C'||nvl(voec.estrazione,'B')
       , 'R', 'R'||nvl(voec.estrazione,'I')
           , 'AR'
           ) estrazione
, decode( voec.classe
       , 'Q', null
       , 'C', null
           , moco.tar
       )
, decode( voec.classe
       , 'Q', moco.qta
       , 'C', moco.qta
           , 0
       )
, decode( voec.classe, 'R', 0, null)
, decode( voec.classe, 'R', 0, null)
, decode( voec.classe, 'R', moco.ipn_eap, null)
, decode( voec.classe, 'R', 0, null)
, decode( voec.classe, 'R', 0, null)
, decode( voec.classe, 'R', 0, null)
, decode( voec.classe, 'R', 0, null)
, decode( voec.classe, 'R', 0, null)
, decode( voec.classe, 'R', moco.ipn_eap, null)
 --, moco.sede_del, moco.numero_del, moco.anno_del
 --, moco.risorsa_intervento, moco.capitolo, moco.articolo, moco.conto
 --, moco.impegno, moco.anno_impegno, moco.sub_impegno, moco.anno_sub_impegno
 from voci_economiche voec
  , movimenti_contabili moco
 where     voec.codice       = moco.voce||''
  and     moco.riferimento between P_d_cong
                               and nvl(P_d_cong_al,moco.riferimento)
  and     moco.input       = upper(moco.input)
  and (   voec.specifica = 'CCF' and
         P_tipo = 'N' and
         (   moco.input in ( 'A', 'I', 'D', 'P' )
          or voec.classe    in ('R','C')
         )
       or P_cong_ind      in ( 3, 4 ) and  --conguaglio Comp.Accessorie
         (   moco.input in ( 'A', 'I', 'D', 'P') and
             nvl(voec.specifica,' ') <> 'NCC' and
             nvl(voec.specifica,' ') not like 'RGA%'
          or voec.specifica  = 'CCA' and
             (   moco.input in ( 'A', 'I', 'D', 'P' )
              or voec.classe    in ('R','C')
             )
         )
      )
  and (   moco.input not in ('A', 'I', 'D', 'P')
       or moco.input     in ('A', 'I', 'D', 'P') and
         nvl(moco.tar,0) != 0 and        --null = forzate a importo
         nvl(moco.qta,0) != 0 and
         nvl(moco.imp,0) != 0
      )
  and  (moco.anno, moco.mese, moco.ci) in
   (select distinct anno, mese, ci
    from movimenti_fiscali
    where ci  = P_ci
    and anno >= to_number(to_char(P_d_cong,'yyyy'))
    and last_day
      (to_date(to_char(anno)||'/'||to_char(mese),'yyyy/mm'))
        >= P_d_cong
    and last_day
      (to_date(to_char(anno)||'/'||to_char(mese),'yyyy/mm'))
        <= nvl(P_d_cong_al,P_fin_ela)
   )
  and moco.mensilita != '*AP'
/* Modifica del 20/1/2004; Attività 838
  and not exists
   (select 'x'
    from calcoli_contabili
    where voce = moco.voce
    and sub  = moco.sub
    and nvl(arr,' ') =
        decode( moco.anno
             , P_anno, nvl(moco.arr, 'C')
                    , decode(P_cong_ind,2,'C',4,'C','P')
             )
    and upper(input) not in ('R','C','A')
    and ci  = P_ci
   )
*/
    ;
    peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT
          ,P_tim
       );
   END;
  END IF;
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
   RAISE;
  WHEN OTHERS THEN
   peccmocp.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
   RAISE FORM_TRIGGER_FAILURE;
END;
--Valorizzazione Voci Retributive
--Emissione Voci Retributive Base e Individuali
--e Variabili Retributive
PROCEDURE voci_retributive
(
 p_ci   number
,p_anno_ret  number
,p_al   date  --Data di Termine o Fine Anno
,p_cong_ind  number
,p_d_cong  date
,p_d_cong_al    date
,p_anno  number
,p_mese  number
,p_mensilita  VARCHAR2
,p_fin_ela  date
,p_tipo  VARCHAR2
,p_conguaglio  number
,p_mens_codice VARCHAR2
,p_periodo  VARCHAR2
,p_ricalcolo  VARCHAR2
--Parametri per Trace
,p_trc  IN  number  --Tipo di Trace
,p_prn  IN  number  --Numero di Prenotazione elaborazione
,p_pas  IN  number  --Numero di Passo procedurale
,p_prs  IN OUT number  --Numero progressivo di Segnalazione
,p_stp  IN OUT VARCHAR2  --Step elaborato
,p_tim  IN OUT VARCHAR2  --Time impiegato in secondi
) IS
w_dummy varchar2(1);
BEGIN
  IF p_tipo = 'N' THEN
  BEGIN  --Inserimento delle Voci BASE e PROGRESSIONE di Stipendio
  P_stp := 'VOCI_RETRIBUTIVE-01';
insert into calcoli_contabili
( ci, voce, sub
, riferimento
, arr
, input
, estrazione
, qualifica, tipo_rapporto, ore
, tar
, qta
, imp
, ipn_eap
)
select distinct
 P_ci, inre.voce, decode( pere.servizio, 'N', 'I', pere.servizio )
, least(pere.al,P_al)
, decode( to_char( least(pere.al,P_al),'yyyy')
   , P_anno, decode( pere.mese
       , P_mese, null
          ,'C'
       )
      , decode(P_cong_ind,2,'C',4,'C','P')
   )
, 'R'
, 'AR'
, pere.qualifica, pere.tipo_rapporto, pere.ore
, inre.tariffa * decode( pere.servizio, 'N', -1, 1 )
, decode( covo.rapporto
   , 'A', pere.gg_af
   , 'R', pere.gg_con
   , 'G', pere.gg_rid
   , 'L', pere.gg_pre * cost.ore_gg * abs(pere.rap_ore)
   , 'P', pere.gg_pre
   , 'I', pere.gg_inp
   , 'C', pere.gg_con
   , 'O', pere.ore / 30 * pere.gg_fis
     , decode( voec.specie
      , null, null
         , pere.gg_fis
      )
   ) * decode( voec.tipo, 'T', -1, 1 )
    * decode( pere.servizio, 'N', 0, 1 )
, decode( covo.rapporto
   , 'A', inre.tariffa / decode( cost.gg_lavoro
           , 30, 30
             , 26
           ) * pere.gg_af
   , 'R', inre.tariffa / decode(cost.gg_lavoro,0,1,cost.gg_lavoro)
        * pere.gg_rap
   , 'C', inre.tariffa / 26 -- decode(pere.gg_rap,cost.gg_lavoro,cost.gg_lavoro,26)
                       * decode( pere.competenza
                                ,'A',
--                                 ((decode(pere.gg_rid,cost.gg_lavoro,26,cost.gg_lavoro) * pere.rap_ore) -
                                 ((26 * pere.rap_ore) -
                                       decode( (cost.gg_lavoro - pere.gg_rid)
                                               ,cost.gg_lavoro,26 * pere.rap_ore
                                                              ,(cost.gg_lavoro - pere.gg_rid)*
                                                                pere.rap_ore
                                             )
                                 )
                                 ,'C',decode(least(pere.al,p_al),p_fin_ela
                                 ,pere.gg_rap
                                 ,((26 * pere.rap_ore) -
                                        decode( (cost.gg_lavoro - pere.gg_rid)
                                               ,cost.gg_lavoro,26 * pere.rap_ore
                                                              ,(cost.gg_lavoro - pere.gg_rid)*
                                                                pere.rap_ore
                                              )
                                  )
                                           )
                               )
   , 'G', inre.tariffa / decode(cost.gg_lavoro,0,1,cost.gg_lavoro)
        *  pere.gg_rid
   , 'L', inre.tariffa / pere.gg_lav
        * pere.gg_pre * abs(pere.rap_ore)
   , 'P', inre.tariffa / pere.gg_lav * pere.gg_pre
   , 'I', inre.tariffa / 26 * pere.gg_inp
   , 'O', inre.tariffa / 30 * pere.gg_fis * abs(pere.rap_ore)
     , decode( nvl(voec.specie,'I')
      , 'T' , inre.tariffa / 30 * pere.gg_fis
         , inre.tariffa * decode( pere.competenza
               , 'A', 1
                , 0
               )
      )
   ) * decode( voec.tipo, 'T', -1, 1 )
, decode( covo.rapporto
   , 'R', inre.tariffa / decode(cost.gg_lavoro,0,1,cost.gg_lavoro)
        *  pere.gg_con * abs(pere.rap_ore)
   , 'C', inre.tariffa / 26 -- decode(pere.gg_rap,cost.gg_lavoro,cost.gg_lavoro,26)
        * abs(pere.rap_ore) *
                         decode( pere.competenza
                                ,'A',
 --                                 ((decode(pere.gg_rid,cost.gg_lavoro,26,cost.gg_lavoro) * pere.rap_ore) -
                                 ((26 * pere.rap_ore) -
                                      decode( (cost.gg_lavoro - pere.gg_rid)
                                               ,cost.gg_lavoro,26 * pere.rap_ore
                                                              ,(cost.gg_lavoro - pere.gg_rid)*
                                                                pere.rap_ore
                                             )
                                 )
                                 ,'C',decode(least(pere.al,p_al),p_fin_ela
                                 ,pere.gg_rap
                                 ,((26 * pere.rap_ore) -
                                        decode( (cost.gg_lavoro - pere.gg_rid)
                                               ,cost.gg_lavoro,26 * pere.rap_ore
                                                              ,(cost.gg_lavoro - pere.gg_rid)*
                                                                pere.rap_ore
                                              )
                                  )
                                           )
                               )
  , 'G', inre.tariffa / decode(cost.gg_lavoro,0,1,cost.gg_lavoro)
        * pere.gg_rid
     , null
   ) * decode( voec.tipo, 'T', -1, 1 )
 from contratti_storici  cost
  , contabilita_voce   covo
  , voci_economiche  voec
  , informazioni_retributive_bp inre
  , periodi_retributivi_bp  pere
 where exists
   (select 'x'
    from qualifiche_giuridiche
   where numero    =   inre.qualifica
    and least(pere.al,P_al)
        between nvl(dal,to_date(2222222,'j'))
         and nvl(al ,to_date(3333333,'j'))
    and contratto = cost.contratto
   )
  and least(pere.al,P_al)
      between nvl(cost.dal,to_date(2222222,'j'))
       and nvl(cost.al ,to_date(3333333,'j'))
  and covo.voce  = inre.voce||''
  and covo.sub  = inre.sub
  and least(pere.al,P_al)
   between nvl(covo.dal,to_date(2222222,'j'))
    and nvl(covo.al ,to_date(3333333,'j'))
  and covo.budget is not null
  and voec.codice  = inre.voce||''
  and not exists
  (select 'x'
  from informazioni_retributive_bp
  where ci  = P_ci
  and voce  = inre.voce
  and tipo  != 'B'
  and least(pere.al,P_al)
   between nvl(dal,to_date(2222222,'j'))
   and nvl(al ,to_date(3333333,'j'))
  )
  and  inre.qualifica+0  =  pere.qualifica
  and nvl(inre.tipo_rapporto,' ') = nvl(pere.tipo_rapporto,' ')
  and least(pere.al,P_al)
   between nvl(inre.dal,to_date(2222222,'j'))
   and nvl(inre.al ,to_date(3333333,'j'))
  and  inre.tipo||''  = 'B'
  and  inre.ci  = P_ci
  and ( last_day(least(pere.al,P_al)) >= P_fin_ela
  or nvl(voec.specifica,' ') not in ( 'NCC', 'CCA')
  or voec.specifica = 'CCA' and P_cong_ind > 2
  or covo.rapporto  is null and
  nvl(voec.specie,'I')  != 'T' and
  pere.competenza   = 'A' and
  nvl(voec.specifica,'CCA') != 'CCA'
  )
  and  pere.competenza in ( 'C', 'A' )
  and  pere.ci  = P_ci
  and  pere.periodo  = P_fin_ela
;
  peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  --Inserimento delle Voci di FORMAZIONE Stipendio
   --(calcolo Importo su rapporto della Tariffa)
  P_stp := 'VOCI_RETRIBUTIVE-02';
insert into calcoli_contabili
( ci, voce, sub
, riferimento
, arr
, input
, estrazione
, tar
, qta
, imp
, ipn_eap
)
select
 P_ci, inre.voce, inre.sub
, pere.al
, decode( pere.anno
   , P_anno, decode( pere.mese
       , P_mese, null
          ,'C'
       )
      , 'P'
   )
, 'R'
, 'AR'
, inre.tariffa * decode( pere.servizio, 'N', -1, 1 )
, decode( covo.rapporto
  , 'A', pere.gg_af
  , 'R', pere.gg_con
  , 'G', pere.gg_rid
  , 'C', pere.gg_con -- * abs(pere.rap_ore)
  , 'L', pere.gg_pre * cost.ore_gg * abs(pere.rap_ore)
  , 'P', pere.gg_pre
  , 'I', pere.gg_inp
  , 'O', pere.ore / 30 * pere.gg_fis
   , pere.gg_fis
  ) * decode( voec.tipo, 'T', -1, 1 )
, decode( covo.rapporto
  ,'A', inre.tariffa / decode( cost.gg_lavoro
     , 30, 30
      , 26
     ) * pere.gg_af
  ,'R', inre.tariffa / decode(cost.gg_lavoro,0,1,cost.gg_lavoro)
    * pere.gg_rap
   ,'C', inre.tariffa / 26 -- decode(pere.gg_rap,cost.gg_lavoro,cost.gg_lavoro,26)
                       * decode( pere.competenza
                                ,'A',
--                                 ((decode(pere.gg_rid,cost.gg_lavoro,26,cost.gg_lavoro) * pere.rap_ore) -
                                 ((26 * pere.rap_ore) -
                                       decode( (cost.gg_lavoro - pere.gg_rid)
                                               ,cost.gg_lavoro,26 * pere.rap_ore
                                                              ,(cost.gg_lavoro - pere.gg_rid)*
                                                                pere.rap_ore
                                             )
                                 )
                                 ,'C',decode(least(pere.al,p_al),p_fin_ela
                                 ,pere.gg_rap
                                 ,((26 * pere.rap_ore) -
                                        decode( (cost.gg_lavoro - pere.gg_rid)
                                               ,cost.gg_lavoro,26 * pere.rap_ore
                                                              ,(cost.gg_lavoro - pere.gg_rid)*
                                                                pere.rap_ore
                                              )
                                  )
                                           )
                               )
  ,'G', inre.tariffa / decode(cost.gg_lavoro,0,1,cost.gg_lavoro)
        * pere.gg_rid
  , 'L', inre.tariffa / pere.gg_lav
    * pere.gg_pre * abs(pere.rap_ore)
  ,'P', inre.tariffa / pere.gg_lav * pere.gg_pre
  ,'I', inre.tariffa / 26 * pere.gg_inp
  ,'O', inre.tariffa / 30 * pere.gg_fis * abs(pere.rap_ore)
  , inre.tariffa / 30 * pere.gg_fis
  ) * decode( voec.tipo, 'T', -1, 1 )
, decode( covo.rapporto
  , 'R', inre.tariffa / decode(cost.gg_lavoro,0,1,cost.gg_lavoro)
    * pere.gg_con * abs(pere.rap_ore)
   , 'C', inre.tariffa / 26  -- decode(pere.gg_rap,cost.gg_lavoro,cost.gg_lavoro,26)
        * abs(pere.rap_ore) *
                         decode( pere.competenza
                                ,'A',
--                                 ((decode(pere.gg_rid,cost.gg_lavoro,26,cost.gg_lavoro) * pere.rap_ore) -
                                 ((26 * pere.rap_ore) -
                                       decode( (cost.gg_lavoro - pere.gg_rid)
                                               ,cost.gg_lavoro,26 * pere.rap_ore
                                                              ,(cost.gg_lavoro - pere.gg_rid)*
                                                                pere.rap_ore
                                             )
                                 )
                                 ,'C',decode(least(pere.al,p_al),p_fin_ela
                                 ,pere.gg_rap
                                 ,((26 * pere.rap_ore) -
                                        decode( (cost.gg_lavoro - pere.gg_rid)
                                               ,cost.gg_lavoro,26 * pere.rap_ore
                                                              ,(cost.gg_lavoro - pere.gg_rid)*
                                                                pere.rap_ore
                                              )
                                  )
                                           )
                               )
  , 'G', inre.tariffa / decode(cost.gg_lavoro,0,1,cost.gg_lavoro)
    * pere.gg_rid
   , null
  ) * decode( voec.tipo, 'T', -1, 1 )
 from contratti_storici  cost
  , contabilita_voce   covo
  , voci_economiche  voec
  , informazioni_retributive_bp inre
  , periodi_retributivi_bp  pere
 where cost.contratto =
  (select contratto
  from qualifiche_giuridiche
  where numero  =  pere.qualifica
  and pere.al  between nvl(dal,to_date(2222222,'j'))
    and nvl(al ,to_date(3333333,'j'))
  )
  and pere.al  between nvl(cost.dal,to_date(2222222,'j'))
    and nvl(cost.al ,to_date(3333333,'j'))
  and covo.voce  = inre.voce||''
  and covo.sub  = inre.sub
  and pere.al  between nvl(covo.dal,to_date(2222222,'j'))
    and nvl(covo.al ,to_date(3333333,'j'))
  and voec.codice  = inre.voce||''
  and voec.tipo  != 'Q'
  and covo.rapporto is not null
  and pere.al  between nvl(inre.dal,to_date(2222222,'j'))
    and nvl(inre.al ,to_date(3333333,'j'))
  and inre.tipo||''  = 'I'
  and inre.ci  = P_ci
  and ( last_day(pere.al) >= P_fin_ela
  or nvl(voec.specifica,' ') not in ( 'NCC', 'CCA')
  or voec.specifica = 'CCA' and P_cong_ind > 2
  )
  and pere.ci  = P_ci
  and pere.competenza in ( 'C', 'A' )
  and pere.periodo  = P_fin_ela
;
  peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  END IF;
  BEGIN  --Inserimento delle Variabili RETRIBUTIVE del mese
  P_stp := 'VOCI_RETRIBUTIVE-03';
insert into calcoli_contabili
( ci, voce, sub
, riferimento
, competenza
, arr
, input
, estrazione
, data
, tar
, qta
, imp
, ipn_c, ipn_s, ipn_p, ipn_l, ipn_e, ipn_t, ipn_a, ipn_ap
, ipn_eap
, sede_del, anno_del, numero_del, delibera  -- modifica del 28/04/2004
, risorsa_intervento, capitolo, articolo, conto
, impegno, anno_impegno, sub_impegno, anno_sub_impegno,codice_siope
)
select P_ci, vare.voce, vare.sub
  , vare.riferimento
  , vare.competenza
  , vare.arr
  , decode( voec.classe
   , 'R', decode( vare.imp_var
    , null, 'C'
     , vare.input
    )
   , vare.input
   )
  , decode( voec.classe
   , 'Q', 'Q'
   , 'C', 'C'||nvl(voec.estrazione,'B')
   , 'R', 'R'||nvl(voec.estrazione,'I')
   , 'AR'
   ) estrazione
  , vare.data
  , decode( voec.classe
   , 'C', vare.tar_var
   , 'Q', vare.tar_var
   , 'R', decode( vare.imp_var
    , null, nvl(vare.tar_var,0)
     , vare.tar_var
    )
   , vare.tar_var)
  , decode( voec.classe
   , 'R', decode( vare.imp_var, null, 0, vare.qta_var )
   , vare.qta_var
   ) * decode( voec.tipo, 'T', -1, 1 )
  , vare.imp_var * decode( voec.tipo, 'T', -1, 1 )
  , decode( voec.classe
   , 'R', nvl(vare.imp_var,0)
   * decode( nvl(vare.arr,'C')
    , 'P', 0
    , decode( covo.fiscale, 'P', 0, 'Y', 0, 1 )
    )
   * decode( voec.tipo, 'T', -1, 1 )
   , null
   )
  , decode( voec.classe, 'R', 0, null )
  , decode( voec.classe
   , 'R', nvl(vare.imp_var,0)
   * decode( nvl(vare.arr,'C')
    , 'P', 1
    , decode( covo.fiscale, 'P', 1, 'Y', 1, 0 )
    )
   * decode( voec.tipo, 'T', -1, 1 )
   , null
   )
  , decode( voec.classe, 'R', 0, null )
  , decode( voec.classe, 'R', 0, null )
  , decode( voec.classe, 'R', 0, null )
  , decode( voec.classe, 'R', 0, null )
  , decode( voec.classe, 'R', 0, null )
  , decode( voec.classe
   , 'R', nvl(vare.tar_var,0)
   * decode( nvl(vare.arr,'C')
    , 'P', 1
    , decode( covo.fiscale, 'P', 1, 'Y', 1, 0 )
    )
   * decode( voec.tipo, 'T', -1, 1 )
   , decode( covo.rapporto
    , 'R', nvl(vare.tar_var, vare.imp_var)
    , 'G', nvl(vare.tar_var, vare.imp_var)
    , null
    )
   )
  , vare.sede_del, vare.anno_del, vare.numero_del, vare.delibera  -- modifica del 28/04/2004
  , vare.risorsa_intervento, vare.capitolo, vare.articolo, vare.conto
  , vare.impegno, vare.anno_impegno, vare.sub_impegno, vare.anno_sub_impegno,vare.codice_siope
 from contabilita_voce covo
  , voci_economiche voec
  , movimenti_contabili vare
 where covo.voce  = vare.voce||''
  and covo.sub  = vare.sub
  and vare.riferimento between nvl(covo.dal,to_date(2222222,'j'))
    and nvl(covo.al ,to_date(3333333,'j'))
  and voec.codice  = vare.voce||''
  and vare.anno  = P_anno
  and vare.mese  = P_mese
  and vare.mensilita  = P_mensilita
  and vare.ci  = P_ci
  and vare.input not in ('M', 'S')
;
  peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  END;
  BEGIN  --Inserimento delle voci INDIVIDUALI del mese
  --( emette le voci Eccezione di Imponibile
  --con INPUT = '*' per considerarle solo ai fini del calcolo
  --e con ESTRAZIONE = 'i' per non trattarle come vere e
  --proprie voci di imponibile )
  --JOIN con Periodi_retributivi_bp per *PREVISIONE*
  P_stp := 'VOCI_RETRIBUTIVE-04';
  FOR CURR IN
  (select max(pere.anno) anno
   , max(pere.mese) mese
   , inre.voce
   , inre.sub
   , inre.tipo
   , max(inre.al) scadenza
   , max(pere.al) al
   , max(inre.tariffa) tariffa
   , max(sign(inre.tariffa)) segno_tar
   , max(inre.sospensione) sospensione
   , max(inre.imp_tot) imp_tot
   , max(inre.rate_tot) rate_tot
   , max(inre.rowid) inre_rowid
   , max(voec.classe) classe
   , max(voec.estrazione) estrazione
   , max(voec.tipo) tipo_voce
 from voci_economiche voec
  , informazioni_retributive_bp inre
  , periodi_retributivi_bp  pere  /*per 12 mesi in *PREVISIONE*/
  , contabilita_voce covo
 where pere.ci  = P_ci
  and pere.periodo  = P_fin_ela
  and pere.competenza  in ('C','A')
  and pere.al  in ( last_day
    ( to_date( to_char(pere.anno)||'/'||
      to_char(pere.mese),'yyyy/mm'))
    , P_al
    )  /*considera un solo periodo per ogni mese in periodi di *PREVISIONE*/
  and inre.ci  = P_ci
  and pere.al  between nvl(inre.dal,to_date(2222222,'j'))
   and last_day
    (least(P_al,nvl(inre.al ,to_date(3333333,'j'))))
  and covo.voce  = inre.voce||''
  and covo.sub  = inre.sub
  and least(pere.al,P_al)
   between nvl(covo.dal,to_date(2222222,'j'))
    and nvl(covo.al ,to_date(3333333,'j'))
  and covo.budget is not null
  and voec.codice  = inre.voce||''
  and ( inre.tipo||'' = 'E' and
  voec.classe  != 'Q' and
  exists
  (select 'x'
  from estrazioni_voce  esvo
  where esvo.voce  = inre.voce
   and esvo.sub   = inre.sub
   and pere.gestione  like esvo.gestione
   and pere.contratto like esvo.contratto
   and pere.trattamento like esvo.trattamento
   and ( esvo.condizione = 'S'
   or esvo.condizione = 'F' and pere.mese = 12 and
       P_tipo = 'N'
      /*mese di PERE in *PREVISIONE*/
   or P_mens_codice like esvo.condizione
   or substr(esvo.condizione,1,1) = 'P' and
   substr(esvo.condizione,2,1) = P_periodo
   or esvo.condizione = 'C' and P_conguaglio = 2
   or esvo.condizione = 'I' and P_conguaglio in (1,2,3)
   or esvo.condizione = 'N' and P_anno != P_anno_ret
   or esvo.condizione = 'M' and P_tipo  = 'N' and
       pere.gg_fis != 0
   or exists
    (select 'x'
    from periodi_retributivi_bp
    where  ci  = P_ci
    and  periodo = P_fin_ela
    and  anno  = pere.anno  /*anno,mese di PERE*/
    and  mese  = pere.mese  /*PREVISIONE*/
   having (  esvo.condizione  = 'R'
    and P_tipo  = 'N'
    and sum(nvl(gg_rat,0)) > 14
    or  esvo.condizione  = 'G'
    and sum(nvl(gg_rid,0)) > 0
/* modifica del 20/01/99 */
         and P_tipo     != 'S'
/* fine modifica del 20/01/99 */
    )
    )
   )
  )
  or inre.tipo||'' = 'E' and
  voec.classe||'' = 'Q' and
    0 != (select sum(gg_rid)
     from periodi_retributivi_bp
    where ci  = P_ci
      and periodo = P_fin_ela
      and anno+0  = pere.anno
      and mese    = pere.mese
      /*anno, mese di PERE *PREVISIONE*/
    )
  or inre.tipo||'' = 'R' and P_tipo = 'N'
  or inre.tipo||'' = 'I' and P_tipo = 'N' and
  voec.tipo  != 'Q' and
  exists
  (select 'x'
   from contabilita_voce
  where rapporto is null
  and voce  = voec.codice
  and pere.al between nvl(dal,to_date(2222222,'j'))
     and nvl(al ,to_date(3333333,'j'))
  )
  )
  group by decode( voec.classe
   , 'V', pere.anno
   , 'R', pere.anno
    , decode( voec.specie
    , 'T', pere.anno
      , null
    )
   )
  , decode( voec.classe
   , 'V', pere.mese
   , 'R', decode(inre.tariffa,null,pere.anno,pere.mese)
    , decode( voec.specie
    , 'T', pere.mese
      , null
    )
   )
  , inre.voce, inre.sub, inre.tipo
  having not exists
  (select 'x'
  from calcoli_contabili
  where voce = inre.voce
   and sub  = inre.sub
   and arr is null
   and ci = P_ci
  )
  ) LOOP
  P_stp := 'VOCI_RETRIBUTIVE-04';
  peccmocp.log_trace(P_trc,P_prn,P_pas,P_prs,P_stp,SQL%ROWCOUNT,P_tim);
  BEGIN  --Inserimento voci
   IF curr.tipo = 'R' THEN  --Voci a RATE
   DECLARE
   D_rate_pag number(4);
   D_imp_pag  number;
   D_residuo  number;
   D_rata_corr number(1);
   D_qta      number(4);
   BEGIN
   D_rata_corr := 0;
   select nvl(sum(p_qta),0), nvl(sum(p_imp),0)
    into D_rate_pag, D_imp_pag
    from progressivi_contabili
    where voce = curr.voce
    and sub  = curr.sub
    and ci = P_ci
    and anno = P_anno
    and mese = P_mese
    and mensilita = P_mensilita
   ;
   select 'x'
     into W_dummy
     from contabilita_voce covo
    where covo.voce  = curr.voce
      and covo.sub  = curr.sub
      and P_al between nvl(covo.dal,to_date(2222222,'j'))
                   and nvl(covo.al ,to_date(3333333,'j'))
      and ( nvl(curr.sospensione,0) = 0
         or (nvl(curr.sospensione,0) <=
            (select sum(gg_rid)
               from periodi_retributivi_bp
              where ci  = P_ci
                and periodo  = P_fin_ela
                and anno+0   = curr.anno
                and mese     = curr.mese
                /*anno, mese per *PREVISIONE*/
            )
            )
         or (nvl(curr.sospensione,0) = 98 and
             1 <=
            (select sum(gg_rid)
               from periodi_retributivi_bp
              where ci    = P_ci
                and periodo  = P_fin_ela
                and anno+0   = curr.anno
                and mese     = curr.mese
                /*anno, mese per *PREVISIONE*/
             )
             )
          )
   ;
   D_residuo := greatest( 0
                        , abs( nvl(curr.imp_tot,0) )
                             - abs(D_imp_pag)
    /*sottrae progressivo *PREVISIONE*/
                             - ( abs(nvl(curr.tariffa,0))
                                * greatest
                                  ( 0, curr.mese - P_mese )
                               )
    /*da importo totale della Rata*/
                        );
      IF D_residuo  = 0 THEN
       null;
      ELSIF
       curr.sospensione = 98 and
       p_conguaglio in (2,3,6,7) THEN
       D_residuo := D_residuo * curr.segno_tar;
       D_qta := abs(curr.rate_tot) - abs(D_rate_pag);
      ELSIF
       curr.sospensione = 98 and
       curr.al = P_fin_ela THEN
       D_residuo := D_residuo * curr.segno_tar;
       D_qta := abs(curr.rate_tot) - abs(D_rate_pag);
      ELSIF
       D_residuo <= abs( nvl(curr.tariffa,0) ) THEN
       D_residuo := D_residuo * curr.segno_tar;
       D_qta := 1;
      ELSIF
       abs(curr.rate_tot) = abs(D_rate_pag) + 1 THEN
       D_residuo := D_residuo * curr.segno_tar;
       D_qta := 1;
      ELSE
       D_residuo := curr.tariffa;
       D_qta := 1;
      END IF;
   IF D_residuo != 0 THEN
    insert into calcoli_contabili
    ( ci, voce, sub
    , riferimento
    , input
    , estrazione
    , data
    , qta
    , imp
    )
    values
    ( P_ci, curr.voce, curr.sub
    , curr.al
    , 'C'
    , 'AR'
    , curr.scadenza  --Data scadenza Rata
    , D_qta * decode( curr.tipo_voce, 'T', -1, 1)
    , D_residuo * decode( curr.tipo_voce, 'T', -1, 1)
    )
    ;
   END IF;
   IF p_ricalcolo = 'Y' THEN
    D_rata_corr := 1;
    RAISE NO_DATA_FOUND;
   END IF;
   EXCEPTION
   WHEN NO_DATA_FOUND THEN
    null;
/*Soppresso Update in *PREVISIONE*
    BEGIN  --ricalcola data Fine
    update informazioni_retributive_bp
     set al = add_months( P_fin_ela
        , abs(curr.rate_tot)
        - abs(D_rate_pag)
        - D_rata_corr
        )
     where rowid = curr.inre_rowid
    ;
    END;
*/
    RAISE;
   END;
   ELSIF
   curr.tipo = 'E' AND --Voci di Eccezione
   curr.classe = 'C' THEN  --a Calcolo
   insert into calcoli_contabili
   ( ci, voce, sub
   , riferimento
   , input
   , estrazione
   , tar
   , qta
   , imp
   )
select P_ci, curr.voce,curr.sub
  , curr.al
  , 'A'
  , curr.classe||nvl(curr.estrazione,'B')
  , decode( tavo.cod_voce_qta||to_char(tavo.quantita)
   , null, null
   , curr.tariffa
   )
  , decode( tavo.cod_voce_qta||to_char(tavo.quantita)
   , null, curr.tariffa
   , null
   ) * decode( curr.tipo_voce, 'T', -1, 1 )
  , null
 from contabilita_voce covo
  , tariffe_voce tavo
 where covo.voce  = curr.voce
  and covo.sub  = curr.sub
  and curr.al between nvl(covo.dal,to_date(2222222,'j'))
   and nvl(covo.al ,to_date(3333333,'j'))
  and tavo.voce  = curr.voce
  and curr.al between nvl(tavo.dal,to_date(2222222,'j'))
   and nvl(tavo.al ,to_date(3333333,'j'))
   ;
   ELSIF
   curr.tipo = 'E' AND --Voci di Eccezione
   curr.classe = 'Q' THEN  --a Quantita`
   insert into calcoli_contabili
   ( ci, voce, sub
   , riferimento
   , input
   , estrazione
   , tar
   , qta
   )
select P_ci, curr.voce,curr.sub
  , curr.al
  , 'A'
  , 'Q'
  , null tar
  , curr.tariffa * decode( curr.tipo_voce, 'T', -1, 1 ) qta
 from contabilita_voce covo
  , tariffe_voce tavo
 where covo.voce  = curr.voce
  and covo.sub  = curr.sub
  and curr.al between nvl(covo.dal,to_date(2222222,'j'))
   and nvl(covo.al ,to_date(3333333,'j'))
  and tavo.voce  = curr.voce
  and curr.al between nvl(tavo.dal,to_date(2222222,'j'))
   and nvl(tavo.al ,to_date(3333333,'j'))
   ;
   ELSIF
   curr.tipo = 'E' AND --Voci di Eccezione
   curr.classe = 'R' THEN  --a Ritenuta
   DECLARE
   D_fiscale  VARCHAR2(1);
   D_val_voce_ipn VARCHAR2(1);
   D_cod_voce_ipn VARCHAR2(10);
   D_sub_voce_ipn VARCHAR2(2);
   D_per_rit_ac  number;
   D_per_rit_ap  number;
   BEGIN  --Preleva dati di Ritenuta
    --con controllo contabilizzazione attiva
   select covo.fiscale
    , rivo.val_voce_ipn
    , rivo.cod_voce_ipn
    , rivo.sub_voce_ipn
    , rivo.per_rit_ac
    , rivo.per_rit_ap
    into D_fiscale
    , D_val_voce_ipn
    , D_cod_voce_ipn
    , D_sub_voce_ipn
    , D_per_rit_ac
    , D_per_rit_ap
    from contabilita_voce covo
    , ritenute_voce  rivo
    where covo.voce  = curr.voce
    and covo.sub  = curr.sub
    and P_al
    between nvl(covo.dal,to_date(2222222,'j'))
     and nvl(covo.al ,to_date(3333333,'j'))
    and rivo.voce  = curr.voce
    and rivo.sub  = curr.sub
    and P_al
    between nvl(rivo.dal,to_date(2222222,'j'))
     and nvl(rivo.al ,to_date(3333333,'j'))
   ;
   IF curr.tariffa is not null THEN
   --Tratta voci di Eccezione a Ritenuta con Tariffa
    insert into calcoli_contabili
    ( ci, voce, sub
    , riferimento
    , input
    , estrazione
    , tar
    , qta
    , imp
    , ipn_c
    , ipn_s
    , ipn_p
    , ipn_l, ipn_e, ipn_t, ipn_a, ipn_ap, ipn_eap
    )
  values( P_ci, curr.voce,curr.sub
  , P_al
  , 'C'
  , 'R'||nvl(curr.estrazione,'I')
  , null
  , null
  , curr.tariffa * decode( curr.tipo_voce, 'T', -1, 1 )
  , curr.tariffa * decode( D_fiscale, 'P', 0, 'Y', 0, 1 )
    * decode( curr.tipo_voce, 'T', -1, 1 )
  , 0
  , curr.tariffa * decode( D_fiscale, 'P', 1, 'Y', 1, 0 )
    * decode( curr.tipo_voce, 'T', -1, 1 )
  , 0, 0, 0, 0, 0, 0
  )
    ;
   ELSE
   --Tratta voci di Eccezione a Ritenuta senza Tariffa
   --prelevando eventuale progressivo imponibile
    IF D_val_voce_ipn = 'P' THEN
    --Estrae valore da Progressivi Contabili
    insert into calcoli_contabili
    ( ci, voce, sub
    , riferimento
    , input
    , estrazione
    , tar
    , qta
    , imp
    , ipn_s
    , ipn_p
    , ipn_l, ipn_e, ipn_t, ipn_a, ipn_ap
    )
select P_ci, curr.voce,curr.sub
  , P_al
  , 'C'
  , 'R'||nvl(curr.estrazione,'I')
  , nvl(sum(prco.p_imp),0)
  , 0 qta
  , null imp
  , 0 ipn_s
  , nvl(sum(prco.p_ipn_p),0)
  , 0 ipn_l, 0 ipn_e, 0 ipn_t, 0 ipn_a, 0 ipn_ap
 from progressivi_contabili prco
 where prco.voce  = D_cod_voce_ipn
  and prco.sub  = D_sub_voce_ipn
  and decode( to_char(prco.riferimento,'yyyy')
   , P_anno, 'C'
   , 'P'
   ) like decode( D_per_rit_ac
    , 0, 'P'
    , decode( D_per_rit_ap
      , 0, 'C'
      , '%'
      )
    )
  and prco.ci  = P_ci
  and prco.anno  = P_anno
  and prco.mese  = P_mese
  and prco.mensilita = P_mensilita
    ;
    ELSE  --Estrae Voce a Ritenuta vuota
    insert into calcoli_contabili
    ( ci, voce, sub
    , riferimento
    , input
    , estrazione
    , tar
    , qta
    , imp
    , ipn_s
    , ipn_p
    , ipn_l, ipn_e, ipn_t, ipn_a, ipn_ap
    )
  values( P_ci, curr.voce,curr.sub
  , P_al
  , 'C'
  , 'R'||nvl(curr.estrazione,'I')
  , 0
  , 0
  , null
  , 0
  , 0
  , 0, 0, 0, 0, 0
  )
    ;
    END IF;
   END IF;
   END;
   ELSE  --tipo 'I' oppure  tipo 'E'e classe = 'I'
   insert into calcoli_contabili
   ( ci, voce, sub
   , riferimento
   , input
   , estrazione
   , tar
   , qta
   , imp
   )
select P_ci, curr.voce,curr.sub
  , curr.al
  , decode( curr.tipo
   , 'I', 'C'
   , '*'  --Voce utile solo per Calcolo
   ) input
  , decode( curr.tipo
   , 'I', 'AR'
   , 'i'  --Flag di richiesta Imponibile
   ) estrazione
  , null tar
  , null qta
  , decode( curr.tipo
   , 'I', curr.tariffa * decode( curr.tipo_voce, 'T', -1, 1 )
   , null
   ) imp
 from contabilita_voce covo
 where covo.voce  = curr.voce
  and covo.sub  = curr.sub
  and P_al  between nvl(covo.dal,to_date(2222222,'j'))
   and nvl(covo.al ,to_date(3333333,'j'))
   ;
  END IF;
  EXCEPTION
  WHEN NO_DATA_FOUND THEN
   null;  --voce non estraibile
  END;
  END LOOP;
  END;
  VOCI_RETR_CON  --Emissione Voci Retributive a Conguaglio
  ( P_ci, P_anno_ret, P_al, P_cong_ind, P_d_cong, P_d_cong_al
  , P_anno, P_mese, P_mensilita, P_fin_ela
  , P_tipo, P_periodo
  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
  );
  peccmocp.VOCI_TOTALE  --Totalizzazione
   --voci Automatiche (non di Presenza e Assenza)
   --e voci di Retribuzione
  (P_ci, P_al, P_fin_ela, P_tipo, 'AR'
  , P_trc, P_prn, P_pas, P_prs, P_stp, P_tim
  );
EXCEPTION
  WHEN FORM_TRIGGER_FAILURE THEN
  RAISE;
  WHEN OTHERS THEN
  peccmocp.err_trace(P_trc,P_prn,P_pas,P_prs,P_stp,0,P_tim);
  RAISE FORM_TRIGGER_FAILURE;
END;
END;
/

